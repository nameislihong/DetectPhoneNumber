//
//  PayProtocolViewController.m
//  GuiJinPay
//
//  Created by xcode on 13-3-29.
//  Copyright (c) 2013年 xcode. All rights reserved.
//

#import "PayProtocolViewController.h"

@interface PayProtocolViewController ()

@property (weak, nonatomic) IBOutlet UITextView *textView;

@end

@implementation PayProtocolViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"用户协议";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
        
    NSString *path = [[NSBundle mainBundle] pathForResource:@"UserAgreement" ofType:@"txt"];
    NSStringEncoding encode = NSUTF8StringEncoding;
    self.textView.text = [NSString stringWithContentsOfFile:path usedEncoding:&encode error:nil];
}

- (void)viewDidUnload
{
    [self setTextView:nil];
    [super viewDidUnload];
}
@end
