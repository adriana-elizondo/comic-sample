//
//  ReachabilityHelper.h
//  Pletoon
//
//  Created by Adriana Elizondo on 6/14/15.
//  Copyright (c) 2015 Adriana. All rights reserved.
//
#import "Reachability.h"
#import <Foundation/Foundation.h>

@interface ReachabilityHelper : NSObject
@property (strong, nonatomic) Reachability *reachability;

+ (ReachabilityHelper *)sharedHelper;

+ (BOOL)isReachable;
@end
