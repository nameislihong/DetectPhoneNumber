//
//  UIAlertView+Rapid.m
//  DetectPhoneNumber
//
//  Created by xcode on 13-4-23.
//  Copyright (c) 2013年 xcode. All rights reserved.
//

#import "UIAlertView+Rapid.h"

@implementation UIAlertView (Rapid)

+ (void)showWithMessage:(NSString *)msg
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:msg
                                                       delegate:nil
                                              cancelButtonTitle:@"关闭"
                                              otherButtonTitles:nil];
    alertView.tag = 200;
    [alertView show];
}

+ (void)showWithMessage:(NSString *)msg
               delegate:(id<UIAlertViewDelegate>)delegate
           secondButton:(NSString *)buttonName
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:msg
                                                       delegate:delegate
                                              cancelButtonTitle:@"关闭"
                                              otherButtonTitles:buttonName, nil];
    alertView.tag = 100;
    [alertView show];
}

@end
