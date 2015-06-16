//
//  PLComicInfoViewController.h
//  Pletoon
//
//  Created by Adriana Elizondo on 6/13/15.
//  Copyright (c) 2015 Adriana. All rights reserved.
//
#import "Artist.h"
#import "Categories.h"
#import "Comic.h"
#import "PLCategoryTableViewCell.h"
#import "PLTabBarController.h"
#import <MagicalRecord/MagicalRecord.h>
#import <SVProgressHUD/SVProgressHUD.h>
#import <UIKit/UIKit.h>

@interface PLComicInfoViewController : UIViewController<UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UIImageView *comicImage;
@property (weak, nonatomic) IBOutlet UILabel *comicTitle;
@property (weak, nonatomic) IBOutlet UILabel *comicDescription;
@property (weak, nonatomic) IBOutlet UILabel *rating;
@property (weak, nonatomic) IBOutlet UILabel *principalCategory;
@property (weak, nonatomic) IBOutlet UIImageView *artistAvatar;
@property (weak, nonatomic) IBOutlet UILabel *artistName;
@property (weak, nonatomic) IBOutlet UILabel *artistEmail;
@property (weak, nonatomic) IBOutlet UITableView *categoriesTableView;

@property Comic *comic;

@end
