//
//  PLEpisodeViewController.h
//  Pletoon
//
//  Created by Adriana Elizondo on 6/11/15.
//  Copyright (c) 2015 Adriana. All rights reserved.
//
#import "Comic.h"
#import "Episode.h"
#import "PLComicInfoViewController.h"
#import "PLEpisodeDetailViewController.h"
#import "PLEpisodeTableViewCell.h"
#import "PLEpisodeViewController.h"
#import <Haneke/Haneke.h>
#import <UIKit/UIKit.h>
#import <SVProgressHUD/SVProgressHUD.h>

@interface PLEpisodeViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *episodeTableView;
@property Comic *comic;

@end
