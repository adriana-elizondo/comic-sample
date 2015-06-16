//
//  PLMyComicsViewController.h
//  Pletoon
//
//  Created by Adriana Elizondo on 6/13/15.
//  Copyright (c) 2015 Adriana. All rights reserved.
//
#import "Comic.h"
#import "PLComicCollectionViewCell.h"
#import "PLEpisodeViewController.h"
#import <MagicalRecord/MagicalRecord.h>
#import <UIKit/UIKit.h>

@interface PLMyComicsViewController : UIViewController<UICollectionViewDataSource, UICollectionViewDelegate, UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *myComicsCollectionView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (weak, nonatomic) IBOutlet UILabel *loadingComics;

@end
