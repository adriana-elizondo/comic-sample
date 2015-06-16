//
//  Categories.h
//  
//
//  Created by Adriana Elizondo on 6/12/15.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Comic;

@interface Categories : NSManagedObject

@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * backgroundColor;
@property (nonatomic, retain) Comic *comic;

@end
