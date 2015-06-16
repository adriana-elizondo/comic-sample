//
//  PLEpisodeTableViewCell.h
//  Pletoon
//
//  Created by Adriana Elizondo on 6/10/15.
//  Copyright (c) 2015 Adriana. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PLEpisodeTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *episodeImage;
@property (weak, nonatomic) IBOutlet UILabel *episodeTitle;
@property (weak, nonatomic) IBOutlet UILabel *episodeLikes;
@property (weak, nonatomic) IBOutlet UILabel *episodeComments;

@end
