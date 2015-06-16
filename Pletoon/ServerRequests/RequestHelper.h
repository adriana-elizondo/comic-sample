//
//  RequestHelper.h
//  Pletoon
//
//  Created by Adriana Elizondo on 6/10/15.
//  Copyright (c) 2015 Adriana. All rights reserved.
//
#import <AFNetworking/AFNetworking.h>
#import <Foundation/Foundation.h>

@protocol RequestHelperDelegate <NSObject>
@required
-(void)requestWasSuccessfulWithResponse:(NSData *)response performSelector:(NSString*)selector;
-(void)requestWasUnsuccessfulWithError:(NSError *)error;

@end

@interface RequestsHelper : NSObject
@property (nonatomic,weak)id<RequestHelperDelegate> delegate;
@property AFHTTPRequestOperationManager *manager;

-(void)getRequestWithQueryString:(NSString *)query performSelector:(NSString *)selector;

@end

