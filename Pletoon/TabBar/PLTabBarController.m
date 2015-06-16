//
//  PLTabBarController.m
//  Pletoon
//
//  Created by Adriana Elizondo on 6/13/15.
//  Copyright (c) 2015 Adriana. All rights reserved.
//

#import "PLTabBarController.h"

@interface PLTabBarController ()

@end
typedef enum
{
    discoverController,
    myComicsController
}tabViewControllers;

@implementation PLTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (![ReachabilityHelper isReachable]) {
        self.selectedIndex = myComicsController;
    }else{
        self.selectedIndex = discoverController;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
