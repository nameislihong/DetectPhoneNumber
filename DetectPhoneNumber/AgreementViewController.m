 //
//  AgreementViewController.m
//  DetectPhoneNumber
//
//  Created by xcode on 13-5-2.
//  Copyright (c) 2013年 xcode. All rights reserved.
//

#import "AgreementViewController.h"
#import "BButton.h"
#import "UIAlertView+Rapid.h"

@interface AgreementViewController ()
@property (weak, nonatomic) IBOutlet BButton *closeButton;
@property (weak, nonatomic) IBOutlet UITextView *textView;

@property (assign, nonatomic) BOOL isAgree;
@property (strong, nonatomic) NSTimer *timer;
@end

@implementation AgreementViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
  
    self.isAgree = NO;
    self.closeButton.enabled = NO;
    
    [self.closeButton setType:BButtonTypeDefault];
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"UserAgreement" ofType:@"txt"];
    NSStringEncoding encode = NSUTF8StringEncoding;
    self.textView.text = [NSString stringWithContentsOfFile:path usedEncoding:&encode error:nil];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(countDown) userInfo:nil repeats:YES];
}


- (void)countDown
{
    static NSInteger sec = 60;
    [self.closeButton setTitle:[NSString stringWithFormat:@"%d秒", sec--] forState:UIControlStateDisabled];
    if(sec == 0){
        self.closeButton.enabled = YES;
        [self.closeButton setTitle:@"关闭" forState:UIControlStateNormal];
        [self.closeButton setType:BButtonTypeSuccess];
        [self.timer invalidate];
    }
}

- (IBAction)agree:(UIButton *)sender {
    sender.selected = !sender.selected;
    self.isAgree = !self.isAgree;
}

- (IBAction)close:(id)sender {
    if(self.isAgree == NO){
        [UIAlertView showWithMessage:@"请认真阅读并同意协议"];
        return;
    }
    
    [self dismissModalViewControllerAnimated:YES];
}

- (void)viewDidUnload {
    [self setCloseButton:nil];
    [self setTextView:nil];
    [super viewDidUnload];
}
@end
