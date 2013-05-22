//
//  LHHUDView.m
//  GroupPurchase
//
//  Created by xcode on 13-3-12.
//  Copyright (c) 2013年 LiHong. All rights reserved.
//

#import "LHHUDView.h"

#define Margin (10)
#define HUDWidth (LH_SCREEN_WIDTH - 2 * Margin)

@implementation LHHUDView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.8];
        
        CGRect f = frame;
        f.origin = CGPointZero;
        
        self.textLabel = [[UILabel alloc] initWithFrame:f];
        self.textLabel.backgroundColor = [UIColor clearColor];
        self.textLabel.textColor = [UIColor whiteColor];
        self.textLabel.textAlignment = NSTextAlignmentCenter;
        self.textLabel.font = [UIFont systemFontOfSize:15];
        self.textLabel.numberOfLines = 0;
        self.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
        [self addSubview:self.textLabel];
        
        double delayInSeconds = 8.0;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [self removeSelf];
        });
    }
    return self;
}

- (void)removeSelf
{
    [self removeFromSuperview];
}

+ (void)showHudInView:(UIView *)superView text:(NSString *)text
{
    CGSize size = [text sizeWithFont:[UIFont systemFontOfSize:15] forWidth:HUDWidth lineBreakMode:NSLineBreakByWordWrapping];
    
    CGRect frame = superView.frame;
    CGRect f = CGRectMake(Margin, frame.size.height - size.height-5, HUDWidth, size.height);
    
    LHHUDView *hud = [[LHHUDView alloc] initWithFrame:f];
    hud.textLabel.text = text;
    [superView addSubview:hud];
}

@end
