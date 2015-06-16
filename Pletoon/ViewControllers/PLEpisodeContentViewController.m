//
//  PLEpisodeContentViewController.m
//  Pletoon
//
//  Created by Adriana Elizondo on 6/11/15.
//  Copyright (c) 2015 Adriana. All rights reserved.
//
#import "PLEpisodeContentViewController.h"

@interface PLEpisodeContentViewController ()

@end

@implementation PLEpisodeContentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    //Add gesture to enlarge image
    UITapGestureRecognizer *showImage = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showImage)];
    [self.view addGestureRecognizer:showImage];

}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    
    //Set image for episode
    self.episodeImageView.contentMode = UIViewContentModeScaleAspectFit;
    UIImage *image = [UIImage imageWithData:self.episodeImage];
    [self.episodeImageView setImage:image];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Set episode image
-(void)showImage{
    self.episodeImageView.contentMode = UIViewContentModeScaleAspectFit;
    UIImage *image = [UIImage imageWithData:self.episodeImage];
    // Create image info
    JTSImageInfo *imageInfo = [[JTSImageInfo alloc] init];
    imageInfo.image = image;
    imageInfo.referenceRect = self.episodeImageView.frame;
    imageInfo.referenceView = self.episodeImageView;
    
    // Setup view controller
    JTSImageViewController *imageViewer = [[JTSImageViewController alloc]
                                           initWithImageInfo:imageInfo
                                           mode:JTSImageViewControllerMode_Image
                                           backgroundStyle:JTSImageViewControllerBackgroundOption_Blurred];
    
    // Present the view controller.
    [imageViewer showFromViewController:self transition:JTSImageViewControllerTransition_FromOffscreen];
}

@end
