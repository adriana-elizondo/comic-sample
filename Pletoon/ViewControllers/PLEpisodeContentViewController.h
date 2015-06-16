//
//  PLEpisodeContentViewController.h
//  Pletoon
//
//  Created by Adriana Elizondo on 6/11/15.
//  Copyright (c) 2015 Adriana. All rights reserved.
//
#import <Haneke/Haneke.h>
#import <JTSImageViewController/JTSImageViewController.h>
#import <UIKit/UIKit.h>

@interface PLEpisodeContentViewController : UIViewController
@property NSUInteger pageIndex;
@property NSData *episodeImage;

@property (weak, nonatomic) IBOutlet UIImageView *episodeImageView;


@end
