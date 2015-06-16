//
//  PLCategoryTableViewCell.h
//  Pletoon
//
//  Created by Adriana Elizondo on 6/15/15.
//  Copyright (c) 2015 Adriana. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PLCategoryTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *categoryImage;
@property (weak, nonatomic) IBOutlet UILabel *categoryName;

@end
