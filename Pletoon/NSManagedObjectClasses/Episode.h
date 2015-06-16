//
//  Episode.h
//  
//
//  Created by Adriana Elizondo on 6/12/15.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Comic, EpisodeImages;

@interface Episode : NSManagedObject

@property (nonatomic, retain) NSNumber * episodeId;
@property (nonatomic, retain) NSNumber * order;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSData * coverPictureImage;
@property (nonatomic, retain) NSNumber * likes;
@property (nonatomic, retain) NSNumber * comments;
@property (nonatomic, retain) NSOrderedSet *images;
@property (nonatomic, retain) Comic *comic;

@end
