//
//  PLComicCollectionViewCell.h
//  Pletoon
//
//  Created by Adriana Elizondo on 6/10/15.
//  Copyright (c) 2015 Adriana. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PLComicCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *comicImage;
@property (weak, nonatomic) IBOutlet UILabel *comicTitle;
@property (weak, nonatomic) IBOutlet UIImageView *languageFlag;
@end
