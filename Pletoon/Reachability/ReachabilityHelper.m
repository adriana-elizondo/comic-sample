//
//  ReachabilityHelper.m
//  Pletoon
//
//  Created by Adriana Elizondo on 6/14/15.
//  Copyright (c) 2015 Adriana. All rights reserved.
//

#import "ReachabilityHelper.h"

@implementation ReachabilityHelper

+ (id)sharedHelper{
    static ReachabilityHelper *sharedHelper = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedHelper = [[self alloc] init];
    });
    return sharedHelper;
}


- (id)init {
    self = [super init];
    
    if (self) {
        // Initialize Reachability
        self.reachability = [Reachability reachabilityForInternetConnection];
        
        // Start Monitoring
        [self.reachability startNotifier];
    }
    
    return self;
}

+ (BOOL)isReachable {
    BOOL isConnected = [[ReachabilityHelper sharedHelper].reachability currentReachabilityStatus] == NotReachable;
    return !isConnected;
}

@end
