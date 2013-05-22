//
//  LHHUDView.h
//  GroupPurchase
//
//  Created by xcode on 13-3-12.
//  Copyright (c) 2013年 LiHong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LHHUDView : UIView

@property(nonatomic, strong) UILabel *textLabel;

+ (void)showHudInView:(UIView *)superView text:(NSString *)text;

@end
