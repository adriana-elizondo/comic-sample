//
//  EpisodeImages.h
//  
//
//  Created by Adriana Elizondo on 6/12/15.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Episode;

@interface EpisodeImages : NSManagedObject

@property (nonatomic, retain) NSNumber * order;
@property (nonatomic, retain) NSData * image;
@property (nonatomic, retain) Episode *episode;

@end
