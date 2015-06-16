//
//  PLEpisodeDetailViewController.h
//  Pletoon
//
//  Created by Adriana Elizondo on 6/11/15.
//  Copyright (c) 2015 Adriana. All rights reserved.
//
#import "EpisodeImages.h"
#import "PLEpisodeContentViewController.h"
#import <UIKit/UIKit.h>

@interface PLEpisodeDetailViewController : UIViewController<UIPageViewControllerDataSource, UIPageViewControllerDelegate>
@property NSArray *images;
@property UIPageViewController *pageViewController;
@end
