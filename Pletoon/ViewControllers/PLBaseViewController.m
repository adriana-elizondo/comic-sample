//
//  PLBaseViewController.m
//  Pletoon
//
//  Created by Adriana Elizondo on 6/10/15.
//  Copyright (c) 2015 Adriana. All rights reserved.
//

#import "PLBaseViewController.h"

@interface PLBaseViewController ()

@end

@implementation PLBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Request helper delegate

-(void)requestWasSuccessfulWithResponse:(NSData *)response performSelector:(NSString *)selector{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    [self performSelector:NSSelectorFromString(selector) withObject:response afterDelay:0.0];
}

-(void)requestWasUnsuccessfulWithError:(NSError *)error{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    [self performSelector:@selector(connectionError:)withObject:error afterDelay:0.0];
}

@end
