//
//  PLBaseViewController.h
//  Pletoon
//
//  Created by Adriana Elizondo on 6/10/15.
//  Copyright (c) 2015 Adriana. All rights reserved.
//
#import "RequestHelper.h"
#import <UIKit/UIKit.h>
#import <SVProgressHUD/SVProgressHUD.h>

@interface PLBaseViewController : UIViewController<RequestHelperDelegate>

@property RequestsHelper *requestHelper;
@end
