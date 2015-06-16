//
//  SaveDataHelper.h
//  Pletoon
//
//  Created by Adriana Elizondo on 6/13/15.
//  Copyright (c) 2015 Adriana. All rights reserved.
//
#import "Artist.h"
#import "Categories.h"
#import "Comic.h"
#import "Episode.h"
#import "EpisodeImages.h"
#import "PLComic.h"
#import <MagicalRecord/MagicalRecord.h>
#import <Foundation/Foundation.h>

@protocol SaveHelperDelegate <NSObject>
@required
-(void)updateProgressWithValue:(float)progress forDownload:(NSInteger)
downloadNumber;

-(void)errorSaving:(NSInteger)downloadNumber withMessage:(NSString *)message;
-(void)saveCompletedSuccessfully:(NSInteger)downloadNumber;
-(void)startedSavingToDisk:(NSInteger)downloadNumber;
@end


@interface SaveDataHelper : NSObject
@property (nonatomic,weak)id<SaveHelperDelegate> delegate;

-(void)saveComic:(PLComic *)plComic withOrder:(NSInteger)order andEpisodes:(NSArray *)comicEpisodes;
@end
