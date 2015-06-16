//
//  PLComic.h
//  Pletoon
//
//  Created by Adriana Elizondo on 6/10/15.
//  Copyright (c) 2015 Adriana. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PLComic : NSObject

@property int comicId;
@property float rating;
@property float downloadProgress;
@property BOOL isHighlighted;
@property BOOL isDownloading;
@property BOOL isSaving;
@property NSDictionary *artist;
@property NSArray *categories;
@property NSString *comicTitle;
@property NSString *comicDescription;
@property NSString *language;
@property NSString *highlitedImageUrl;
@property NSString *squareImageUrl;
@property NSString *highlightedImageUrl;
@property NSString *principalCategory;

@end
