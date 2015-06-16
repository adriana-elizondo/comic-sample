//
//  PLHomeViewController.h
//  Pletoon
//
//  Created by Adriana Elizondo on 6/10/15.
//  Copyright (c) 2015 Adriana. All rights reserved.
//
#import "Comic.h"
#import "PLComic.h"
#import "PLBaseViewController.h"
#import "PLComicTableViewCell.h"
#import "PLEpisodeViewController.h"
#import "PLHomeViewController.h"
#import "ReachabilityHelper.h"
#import "SaveDataHelper.h"
#import <Haneke/Haneke.h>
#import <MagicalRecord/MagicalRecord.h>
#import <SystemConfiguration/SystemConfiguration.h>
#import <UIKit/UIKit.h>

@interface PLHomeViewController : PLBaseViewController<SaveHelperDelegate, UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *comicsTableView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (weak, nonatomic) IBOutlet UILabel *loadingLabel;

@end
