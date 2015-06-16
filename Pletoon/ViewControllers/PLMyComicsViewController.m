//
//  PLMyComicsViewController.m
//  Pletoon
//
//  Created by Adriana Elizondo on 6/13/15.
//  Copyright (c) 2015 Adriana. All rights reserved.
//

#import "PLMyComicsViewController.h"

@interface PLMyComicsViewController (){
    NSMutableArray *comics;
    NSInteger selectedIndex;
    NSInteger comicToDelete;
}

@end

@implementation PLMyComicsViewController

- (void)viewDidLoad {
    self.title = @"My Comics";
    [super viewDidLoad];
}

-(void)viewWillAppear:(BOOL)animated{
    
    [self.activityIndicator startAnimating];
    
    //Initialize
    selectedIndex = 0;
    comicToDelete = 0;
    
    //Load comics from disk
    [self loadComics];
    
    //Check for possible corrupted downloads
    [self deleteIncomplete];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Load data
-(void)loadComics{
    //Fetched comics from disk
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"isCompletelyDownloaded == %@", @(1)];
    comics = [[NSMutableArray alloc] initWithArray:[Comic MR_findAllWithPredicate:predicate]];
    
    [self.activityIndicator stopAnimating];
    self.activityIndicator.hidden = YES;
    if (comics.count == 0) {
        self.loadingComics.text = @"Ooops, you haven't downloaded any comic yet!";
    }else{
        self.loadingComics.hidden = YES;
    }
    
    [self.myComicsCollectionView reloadData];
}

#pragma mark - UICollectionview datasource

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return comics.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    NSString *cellIdentifier = @"comicCell";
    PLComicCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    
    Comic *comic = [comics objectAtIndex:indexPath.row];
    
    cell.comicTitle.text = [NSString stringWithFormat:@"%@", comic.title];
    cell.comicImage.contentMode = UIViewContentModeScaleAspectFill;
    cell.comicImage.clipsToBounds = YES;
    
    //Display flag according to language
    if ([comic.language isEqualToString:@"id"]) {
        [cell.languageFlag setImage:[UIImage imageNamed:@"indonesia"]];
    }else if ([comic.language isEqualToString:@"en"]){
        [cell.languageFlag setImage:[UIImage imageNamed:@"usa"]];
    }
    
    //Display cover image
    UIImage *image;
    if (comic.isHighlighted && comic.highlightedImage != nil) {
        image = [UIImage imageWithData:comic.highlightedImage];
    }else{
        image = [UIImage imageWithData:comic.squareImage];
    }
    
    [cell.comicImage setImage:image];
    
    //Add black border to cell
    cell.layer.borderWidth = 1.0f;
    cell.layer.borderColor=[UIColor blackColor].CGColor;
    
    //Add delete gesture
    cell.tag = indexPath.row;
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(deleteComic:)];
    [cell addGestureRecognizer:longPress];
    
    return cell;
    
}

#pragma mark - Delete comic
-(void)deleteComic:(UILongPressGestureRecognizer *)sender{
    if (sender.state == UIGestureRecognizerStateBegan){
        comicToDelete = sender.view.tag;
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Are you sure you want to delete me? ):" delegate:self cancelButtonTitle:@"Yes" otherButtonTitles:@"No", nil];
        alert.delegate = self;
        [alert show];
    }
}

#pragma mark - UIAlertview delegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    switch (buttonIndex) {
        case 0:
            [self deleteMe];
            break;
        case 1:
            break;
            
        default:
            break;
    }
}
-(void)deleteMe{
    Comic *comic = [comics objectAtIndex:comicToDelete];
    [comic MR_deleteEntity];
    [SVProgressHUD show];
    [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreWithCompletion:^(BOOL contextDidSave, NSError *error) {
        if (contextDidSave) {
            [SVProgressHUD dismiss];
            [self loadComics];
        }
    }];
}


#pragma mark - UICollectionview size
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    int margin = 15;
    CGFloat size = (self.view.frame.size.width / 2.3) - margin;
    return CGSizeMake(size, size);
}

#pragma mark collection view cell paddings
- (UIEdgeInsets)collectionView:(UICollectionView*)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(5, 15, 0, 15); // top, left, bottom, right
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    
    return 5.0;
}

#pragma mark - UICollectionview delegate

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    selectedIndex = (int)indexPath.row;
    [self performSegueWithIdentifier:@"comicDetail" sender:self];
    
}

#pragma mark - Delete possible incomplete comics
-(void)deleteIncomplete{
    NSPredicate *deletePredicate = [NSPredicate predicateWithFormat:@"isCompletelyDownloaded == %@", @(0)];
    NSArray *incompleteComics = [Comic MR_findAllWithPredicate:deletePredicate];
    if (incompleteComics.count > 0) {
        [Comic MR_deleteAllMatchingPredicate:deletePredicate];
        
        [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreWithCompletion:^(BOOL contextDidSave, NSError *error) {
            NSLog(@"deleted incomplete comics");
        }];
    }
}

#pragma mark - Prepare for segue
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"comicDetail"]) {
        PLEpisodeViewController *episodes = (PLEpisodeViewController *)segue.destinationViewController;
        Comic *comic = [comics objectAtIndex:selectedIndex];
        episodes.comic = comic;
    }
}

@end
