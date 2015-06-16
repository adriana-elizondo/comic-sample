//
//  PLEpisodeViewController.m
//  Pletoon
//
//  Created by Adriana Elizondo on 6/11/15.
//  Copyright (c) 2015 Adriana. All rights reserved.
//
#import "PLEpisodeViewController.h"

@interface PLEpisodeViewController (){
    NSArray *episodes;
    int selectedEpisode;
}

@end

@implementation PLEpisodeViewController
@synthesize comic;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Episodes";
    
    UIBarButtonItem *infoButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"info"] landscapeImagePhone:nil style:UIBarButtonItemStylePlain target:self action:@selector(showComicInfo)];
    self.navigationItem.rightBarButtonItem = infoButton;
}

-(void)viewWillAppear:(BOOL)animated{
    NSSortDescriptor *descriptor = [NSSortDescriptor sortDescriptorWithKey:@"order"
                                                                 ascending:YES];
    
    episodes = [[comic.episodes array] sortedArrayUsingDescriptors:@[descriptor]];
    if (episodes.count == 0) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Show comic info
-(void)showComicInfo{
    [self performSegueWithIdentifier:@"comicInfo" sender:self];
}

#pragma mark - UITableview datasource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return episodes.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *cellIdentifier = @"episodeCell";
    PLEpisodeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    Episode *episode = [episodes objectAtIndex:indexPath.row];
    
    UIImage *coverImage = [UIImage imageWithData:episode.coverPictureImage];
    [cell.episodeImage setImage:coverImage];
    cell.episodeTitle.text = episode.title;
    cell.episodeLikes.text = [NSString stringWithFormat:@"%@",episode.likes];
    cell.episodeComments.text = [NSString stringWithFormat:@"%@",episode.comments];
    
    return cell;
}

#pragma mark - UITableview delegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    selectedEpisode = (int)indexPath.row;
    [self performSegueWithIdentifier:@"readComic" sender:self];
}

#pragma mark - Prepare for segue
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"readComic"]) {
        PLEpisodeDetailViewController *episodeDetail = (PLEpisodeDetailViewController *)segue.destinationViewController;
        Episode *episode = [episodes objectAtIndex:selectedEpisode];
        episodeDetail.images = [episode.images array];
    }else if ([segue.identifier isEqualToString:@"comicInfo"]){
        PLComicInfoViewController *comicInfo = (PLComicInfoViewController *)segue.destinationViewController;
        comicInfo.comic = comic;
    }
}
@end
