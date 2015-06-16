//
//  Comic.h
//  
//
//  Created by Adriana Elizondo on 6/12/15.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Artist, Categories, Episode;

@interface Comic : NSManagedObject

@property (nonatomic, retain) NSNumber * comicId;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * comicDescription;
@property (nonatomic, retain) NSNumber * isHighlighted;
@property (nonatomic, retain) NSNumber * isCompletelyDownloaded;
@property (nonatomic, retain) NSNumber * order;
@property (nonatomic, retain) NSNumber * rating;
@property (nonatomic, retain) NSString * principalCategory;
@property (nonatomic, retain) NSString * language;
@property (nonatomic, retain) NSData * coverImage;
@property (nonatomic, retain) NSData * coverNewImage;
@property (nonatomic, retain) NSData * squareImage;
@property (nonatomic, retain) NSData * highlightedImage;
@property (nonatomic, retain) NSOrderedSet *episodes;
@property (nonatomic, retain) Artist *artist;
@property (nonatomic, retain) NSOrderedSet *categories;
@end
