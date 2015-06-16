//
//  PLComicTableViewCell.h
//  Pletoon
//
//  Created by Adriana Elizondo on 6/15/15.
//  Copyright (c) 2015 Adriana. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PLComicTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *comicImage;
@property (weak, nonatomic) IBOutlet UILabel *comicTitle;
@property (weak, nonatomic) IBOutlet UILabel *comicDescription;
@property (weak, nonatomic) IBOutlet UIImageView *downloadedImageView;
@property (weak, nonatomic) IBOutlet UIImageView *languageFlag;
@property (weak, nonatomic) IBOutlet UIProgressView *progressView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@end
