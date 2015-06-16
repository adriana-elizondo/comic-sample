//
//  RequestHelper.m
//  Pletoon
//
//  Created by Adriana Elizondo on 6/10/15.
//  Copyright (c) 2015 Adriana. All rights reserved.
//
#import "Constants.h"
#import "RequestHelper.h"

@implementation RequestsHelper
@synthesize manager;

-(void)getRequestWithQueryString:(NSString *)query performSelector:(NSString *)selector{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    manager = [AFHTTPRequestOperationManager manager];
    [manager setRequestSerializer:[AFHTTPRequestSerializer serializer]];
    [manager setResponseSerializer:[AFHTTPResponseSerializer serializer]];
    NSString *url =[NSString stringWithFormat:@"%@%@",kBaseURL,query];
    NSLog(@"url %@", url);
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, NSData *responseObject){
        [self.delegate requestWasSuccessfulWithResponse:responseObject performSelector:selector];
    }failure:^(AFHTTPRequestOperation *operation, NSError *error){
        [self.delegate requestWasUnsuccessfulWithError:error];
    }];
}

@end
