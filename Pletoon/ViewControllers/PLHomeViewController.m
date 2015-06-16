//
//  PLHomeViewController.m
//  Pletoon
//
//  Created by Adriana Elizondo on 6/10/15.
//  Copyright (c) 2015 Adriana. All rights reserved.
//
#import "PLHomeViewController.h"

@interface PLHomeViewController (){
    int selectedIndex;
    int concurrentDownloads;
    NSMutableArray *comics;
    NSMutableArray *downloadStack;
    SaveDataHelper *saveHelper;
}

@end

@implementation PLHomeViewController
@synthesize requestHelper;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Discover";
    
    selectedIndex = 0;
    
    [self.activityIndicator startAnimating];
    
    //Initialize save helper class
    saveHelper = [[SaveDataHelper alloc] init];
    saveHelper.delegate = self;
    
    //Initialize the request helper that enables connection to server.
    requestHelper = [[RequestsHelper alloc] init];
    requestHelper.delegate = self;
    
    //Initialize downlaod stack
    downloadStack = [[NSMutableArray alloc] init];
    
    self.comicsTableView.tableFooterView = [[UIView alloc] init];
    
    //Check if theres a conenction to internet
    BOOL isReachable = [ReachabilityHelper isReachable];
    if(!isReachable)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Please connect to the internet to download comics." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
        [self.activityIndicator stopAnimating];
        self.loadingLabel.text = @"No Connection";
    }
    else{
        //Get all comics from server
        [requestHelper getRequestWithQueryString:@"comics" performSelector:@"getAllComics:"];
    }
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Comics from service
-(void)getAllComics:(NSData *)data{
    NSError *error;
    NSDictionary *comicDictionary = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    
    //Check if comic data was received successfully
    if (error) {
        [SVProgressHUD showErrorWithStatus:@"Error processing data"];
        return;
    }
    
    NSArray *allComics = [[NSArray alloc] initWithArray:[comicDictionary objectForKey:@"comics"]];
    if (allComics.count == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"There are no comics available" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    
    //Parse and display comic data.
    comics = [[NSMutableArray alloc] init];
    [allComics enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        PLComic *comic = [[PLComic alloc] init];
        comic.comicId = [[obj objectForKey:@"id"] intValue];
        comic.comicTitle = [obj objectForKey:@"title"];
        comic.comicDescription = [obj objectForKey:@"description"];
        comic.isHighlighted = [[obj objectForKey:@"highlighted"] boolValue];
        comic.rating = [[obj objectForKey:@"rate"] floatValue];
        comic.squareImageUrl = [obj objectForKey:@"square_image"];
        comic.language = [obj objectForKey:@"language"];
        
        if (![[obj objectForKey:@"highlighted_img_image"] isEqual:[NSNull null]]) {
            comic.highlightedImageUrl = [obj objectForKey:@"highlighted_img_image"];

        }
        comic.artist = [obj objectForKey:@"artist"];
        comic.categories = [obj objectForKey:@"categories"];
        comic.principalCategory = [[obj objectForKey:@"principal_category"] objectForKey:@"title"];
        
        [comics addObject:comic];
    }];
    
    [self.activityIndicator stopAnimating];
    self.activityIndicator.hidden = YES;
    self.loadingLabel.hidden = YES;
    
    //Reload data
    NSIndexSet *indexSet = [NSIndexSet indexSetWithIndex:0];
    [self.comicsTableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
    
}

//If download was interrupted by connection error
-(void)connectionError:(NSError *)error{
    if (downloadStack.count > 0) {
        [self errorSaving:[[downloadStack lastObject] integerValue] withMessage:@"Download Error"];
    }
}

//Get all comics from server
#pragma mark - Refresh comics
- (IBAction)refreshComics:(id)sender {
    [self.activityIndicator startAnimating];
    self.loadingLabel.text = @"Loading comics...";
    [requestHelper getRequestWithQueryString:@"comics" performSelector:@"getAllComics:"];
    
}


#pragma mark - UITableview datasource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return comics.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *cellIdentifier = @"comicCell";
    PLComicTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    PLComic *comic = [comics objectAtIndex:indexPath.row];
    Comic *diskComic = [Comic MR_findFirstByAttribute:@"comicId" withValue:@(comic.comicId)];
    
    //Is comic already saved
    if (diskComic != nil && diskComic.isCompletelyDownloaded) {
        [cell.downloadedImageView setImage:[UIImage imageNamed:@"checkmark"]];
    }else{
        [cell.downloadedImageView setImage:[UIImage imageNamed:nil]];
    }
    
    //Display info
    cell.comicTitle.text = comic.comicTitle;
    cell.comicDescription.text = comic.comicDescription;
    cell.comicImage.contentMode = UIViewContentModeScaleAspectFill;
    cell.comicImage.clipsToBounds = YES;
    
    //Display flag according to language
    if ([comic.language isEqualToString:@"id"]) {
        [cell.languageFlag setImage:[UIImage imageNamed:@"indonesia"]];
    }else if ([comic.language isEqualToString:@"en"]){
        [cell.languageFlag setImage:[UIImage imageNamed:@"usa"]];
    }
    
    NSURL *imageUrl;
    if (comic.isHighlighted && comic.highlightedImageUrl != nil) {
        imageUrl = [NSURL URLWithString:comic.highlightedImageUrl];
    }else{
        imageUrl = [NSURL URLWithString:comic.squareImageUrl];
    }
    
    [cell.comicImage hnk_setImageFromURL:imageUrl placeholder:[UIImage imageNamed:@"blueimage"]];
    
    //Comic is being downloaded
    cell.activityIndicator.hidden = !comic.isDownloading;
    if (comic.isDownloading) {
        [cell.activityIndicator startAnimating];
    }
    
    //Comic is being saved to disk
    cell.progressView.hidden = !comic.isSaving;
    cell.progressView.progress = comic.downloadProgress;
    CGAffineTransform transform = CGAffineTransformMakeScale(1.0f, 3.0f);
    cell.progressView.transform = transform;

    return cell;
    
}

#pragma mark - UITableview cell size
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    return 90;
}


#pragma mark - UITableview delegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    PLComic *selectedComic = [comics objectAtIndex:indexPath.row];
    Comic *diskComic = [Comic MR_findFirstByAttribute:@"comicId" withValue:@(selectedComic.comicId)];
    selectedIndex = (int)indexPath.row;
    
    //If comic is already in disk show episodes
    if (diskComic.isCompletelyDownloaded && !selectedComic.isSaving) {
        [self performSegueWithIdentifier:@"comicDetail" sender:self];
        
    }else if(selectedComic.isDownloading || selectedComic.isSaving){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Please wait while your comic is downloaded." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
        return;
        
    }else{
        //Check if connection to internet is available before starting download
        if (![ReachabilityHelper isReachable]) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"You have to be online to download this comic." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alert show];
            return;
        }
        
        //Only allow 1 concurrent download
        if (concurrentDownloads == 1) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"You can only have 1 download at a time!" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alert show];
            return;
        }
        concurrentDownloads++;
        selectedComic.isDownloading = YES;
        [comics replaceObjectAtIndex:selectedIndex withObject:selectedComic];
        [downloadStack addObject:@(indexPath.row)];
        
        PLComicTableViewCell *cell = (PLComicTableViewCell *)[self.comicsTableView cellForRowAtIndexPath:indexPath];
        cell.activityIndicator.hidden = NO;
        [cell.activityIndicator startAnimating];
        
        //Get episode data from web service
        [requestHelper getRequestWithQueryString:[NSString stringWithFormat:@"comic/%i", selectedComic.comicId] performSelector:@"getComicEpisodes:"];
    }
}

#pragma mark - Episodes from service
-(void)getComicEpisodes:(NSData *)data{
    NSError *error;
    NSDictionary *responseDict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    
    if (error) {
        [SVProgressHUD showErrorWithStatus:@"Error processing data"];
        return;
    }
    
    NSDictionary *comicDict = [responseDict objectForKey:@"comic"];
    NSArray *allEpisodes = [[NSArray alloc] initWithArray:[comicDict objectForKey:@"published_episodes"]];
    
    PLComic *selectedComic = [comics objectAtIndex:selectedIndex];
    
    //Save comic in disk using helper
    [saveHelper saveComic:selectedComic withOrder:[[downloadStack lastObject] integerValue] andEpisodes:allEpisodes];

}

#pragma mark - Save helper delegate
//Comic data is downloaded and is being saved to Core Data
-(void)startedSavingToDisk:(NSInteger)downloadNumber{
    PLComic *comic = [comics objectAtIndex:downloadNumber];
    comic.isSaving = YES;
    comic.isDownloading = NO;
    [comics replaceObjectAtIndex:downloadNumber withObject:comic];
    
    NSIndexPath *indexpath = [NSIndexPath indexPathForRow:downloadNumber inSection:0];
    PLComicTableViewCell *cell = (PLComicTableViewCell *)[self.comicsTableView cellForRowAtIndexPath:indexpath];
    dispatch_async(dispatch_get_main_queue(), ^{
        cell.activityIndicator.hidden = YES;
        [cell.activityIndicator stopAnimating];
        cell.progressView.hidden = NO;
    });

}

-(void)updateProgressWithValue:(float)progress forDownload:(NSInteger)downloadNumber{
    NSLog(@"progress %f for view %ld", progress, (long)downloadNumber);
    //Comic is being saved
    PLComic *comic = [comics objectAtIndex:downloadNumber];
    comic.downloadProgress = progress;
    [comics replaceObjectAtIndex:downloadNumber withObject:comic];
    
    NSIndexPath *indexpath = [NSIndexPath indexPathForRow:downloadNumber inSection:0];
    PLComicTableViewCell *cell = (PLComicTableViewCell *)[self.comicsTableView cellForRowAtIndexPath:indexpath];
    dispatch_async(dispatch_get_main_queue(), ^{
        cell.progressView.progress = progress;
    });
}

-(void)saveCompletedSuccessfully:(NSInteger)downloadNumber{
    NSIndexPath *indexpath = [NSIndexPath indexPathForRow:downloadNumber inSection:0];
    PLComic *comic = [comics objectAtIndex:downloadNumber];
    comic.isSaving = NO;
    comic.isDownloading = NO;
    [comics replaceObjectAtIndex:indexpath.row withObject:comic];
    
    PLComicTableViewCell *cell = (PLComicTableViewCell *)[self.comicsTableView cellForRowAtIndexPath:indexpath];
    concurrentDownloads --;
    
    //Update UI
    dispatch_async(dispatch_get_main_queue(), ^{
        cell.progressView.hidden = YES;
        [self.comicsTableView reloadRowsAtIndexPaths:@[indexpath] withRowAnimation:UITableViewRowAnimationAutomatic];
    });
}

-(void)errorSaving:(NSInteger)downloadNumber withMessage:(NSString *)message{
    NSIndexPath *indexpath = [NSIndexPath indexPathForRow:downloadNumber inSection:0];
    PLComic *comic = [comics objectAtIndex:downloadNumber];
    comic.isSaving = NO;
    comic.isDownloading = NO;
    [comics replaceObjectAtIndex:downloadNumber withObject:comic];
    
    PLComicTableViewCell *cell = (PLComicTableViewCell *)[self.comicsTableView cellForRowAtIndexPath:indexpath];
    if (concurrentDownloads != 0) {
        concurrentDownloads --;
    }
    
    //Update UI
    dispatch_async(dispatch_get_main_queue(), ^{
        [SVProgressHUD showErrorWithStatus:message];
        [cell.activityIndicator stopAnimating];
        [self.comicsTableView reloadRowsAtIndexPaths:@[indexpath] withRowAnimation:UITableViewRowAnimationAutomatic];
    });
}

#pragma mark - Prepare for segue
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"comicDetail"]) {
        PLEpisodeViewController *episodes = (PLEpisodeViewController *)segue.destinationViewController;
        
        PLComic *comic = [comics objectAtIndex:selectedIndex];
        Comic *comicFromDisk = [Comic MR_findFirstByAttribute:@"comicId" withValue:@(comic.comicId)];
        episodes.comic = comicFromDisk;
    }
}
@end
