//
//  AppDelegate.h
//  DetectPhoneNumber
//
//  Created by xcode on 13-4-20.
//  Copyright (c) 2013年 xcode. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Reachability.h"

@class ViewController;

#define REACH ((AppDelegate *)[UIApplication sharedApplication].delegate).reach

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) ViewController *viewController;
@property (strong, nonatomic) Reachability *reach;

@end
