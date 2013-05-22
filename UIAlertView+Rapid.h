//
//  UIAlertView+Rapid.h
//  DetectPhoneNumber
//
//  Created by xcode on 13-4-23.
//  Copyright (c) 2013年 xcode. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIAlertView (Rapid)

+ (void)showWithMessage:(NSString *)msg;
+ (void)showWithMessage:(NSString *)msg
               delegate:(id<UIAlertViewDelegate>)delegate
           secondButton:(NSString *)buttonName;

@end
