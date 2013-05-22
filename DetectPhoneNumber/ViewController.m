//
//  ViewController.m
//  DetectPhoneNumber
//
//  Created by xcode on 13-4-20.
//  Copyright (c) 2013年 xcode. All rights reserved.
//

#import "ViewController.h"
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "Creator.h"
#import "People.h"
#import "PeopleAnnotationView.h"
#import "PeopleAnnotation.h"
#import "TSMessage.h"
#import "PopoverView.h"
#import "BButton.h"
#import "UIAlertView+Rapid.h"
#import "Validate/UserInfoValidator.h"
#import "AppDelegate.h"
#import "MBHUDView.h"
#import "PayProtocolViewController.h"
#import "LHHUDView.h"
#import <QuartzCore/QuartzCore.h>
#import "AgreementViewController.h"

@interface ViewController ()<CLLocationManagerDelegate, MKMapViewDelegate, UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *topContainerView;
@property (weak, nonatomic) IBOutlet UIView *topContainerBackgroundView;
@property (weak, nonatomic) IBOutlet UILabel *sexLabel;
@property (weak, nonatomic) IBOutlet UITextField *ageTextField;
@property (weak, nonatomic) IBOutlet UITextField *telphoneTextField;
@property (weak, nonatomic) IBOutlet BButton *sharePositionButton;

@property (weak, nonatomic) IBOutlet UIView *bottomContainerView;
@property (weak, nonatomic) IBOutlet UIView *bottomContainerBackgroundView;
@property (weak, nonatomic) IBOutlet BButton *telphoneButton;
@property (weak, nonatomic) IBOutlet BButton *smsButton;
@property (weak, nonatomic) IBOutlet UIImageView *sexImageView;
@property (weak, nonatomic) IBOutlet UILabel *ageLabel;
@property (weak, nonatomic) IBOutlet UILabel *telphoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, nonatomic) CLLocationManager *locationManager;

@property (strong, nonatomic) NSMutableArray *mapViewAnnotaions;
@property (strong, nonatomic) UIImage *boyAnnotaionImage, *girlAnnotaionImage;

@property (strong, nonatomic) CLLocation *currentLocation;
@property (strong, nonatomic) People *currentPeople;

@property (assign, nonatomic) BOOL isAgreeProtocol;
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"附近号友";
    self.isAgreeProtocol = NO;
    self.mapViewAnnotaions = [NSMutableArray new];
    
    UIEdgeInsets edge = UIEdgeInsetsMake(5, 5, 20, 16);
    self.boyAnnotaionImage = [[UIImage imageNamed:@"boy_annotaion@2x.png"] resizableImageWithCapInsets:edge];
    self.girlAnnotaionImage = [[UIImage imageNamed:@"girl_annotaion@2x.png"] resizableImageWithCapInsets:edge];
    
    [self.sharePositionButton setType:BButtonTypeDefault];
    [self.telphoneButton setType:BButtonTypeSuccess];
    [self.smsButton setType:BButtonTypeDefault];
    
    UIButton *itemButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [itemButton setImage:[UIImage imageNamed:@"topbar_share_ifno"] forState:UIControlStateNormal];
    itemButton.frame = CGRectMake(0, 0, 48, 30);
    [itemButton addTarget:self action:@selector(showTopView) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:itemButton];
    
    BOOL isFirstUseing = [[NSUserDefaults standardUserDefaults] boolForKey:@"isFirst"];
    if(isFirstUseing == NO){
        AgreementViewController *AVC = [[AgreementViewController alloc] initWithNibName:@"AgreementViewController" bundle:nil];
        [self presentModalViewController:AVC animated:YES];
        
        [self performSelector:@selector(showWelcomeInfo) withObject:nil afterDelay:92];
    }
    
    if([CLLocationManager locationServicesEnabled]){
        self.locationManager = [[CLLocationManager alloc] init];
        self.locationManager.delegate = self;
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        self.locationManager.distanceFilter = kCLLocationAccuracyThreeKilometers;
        [self.locationManager startUpdatingLocation];
        
        [MBHUDView hudWithBody:@"正在定位" type:MBAlertViewHUDTypeActivityIndicator hidesAfter:18000 show:YES];
        
    }else{
        [UIAlertView showWithMessage:@"我们需要使用您的位置信息才能为您提供服务，请在[设置-隐私-定位服务]中开启。"];
    }
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    CGRect frame = self.view.frame;
    frame.origin.y = frame.size.height;
    self.bottomContainerView.frame = frame;
    
    frame = self.topContainerView.frame;
    frame.origin.y -= frame.size.height;
    self.topContainerView.frame = frame;
    
}

- (void)viewDidUnload {
    [self setMapViewAnnotaions:nil];
    [self setMapView:nil];
    [self setBottomContainerView:nil];
    [self setBottomContainerBackgroundView:nil];
    [self setTelphoneButton:nil];
    [self setSmsButton:nil];
    [self setSexImageView:nil];
    [self setSexLabel:nil];
    [self setAgeLabel:nil];
    [self setTelphoneLabel:nil];
    [self setDistanceLabel:nil];
    [self setSharePositionButton:nil];
    [self setTopContainerView:nil];
    [self setTopContainerBackgroundView:nil];
    [self setAgeTextField:nil];
    [self setTelphoneTextField:nil];
    [super viewDidUnload];
}

#pragma mark - Action

- (void)showTopView
{
    CGRect frame = self.topContainerView.frame;
    frame.origin.y = 0;
    
    [UIView animateWithDuration:0.3 animations:^{
        self.topContainerView.frame = frame;
    }];
}

- (IBAction)tapOnTopView:(id)sender
{
    [self.view endEditing:YES];
    
    CGRect frame = self.topContainerView.frame;
    frame.origin.y -= frame.size.height;
    
    [UIView animateWithDuration:0.3 animations:^{
        self.topContainerView.frame = frame;
    }];
}

- (IBAction)tapOnBottomContainerView:(UITapGestureRecognizer *)sender
{
    CGRect frame = self.bottomContainerView.frame;
    frame.origin.y = frame.size.height;
    [UIView animateWithDuration:0.3 animations:^{
        self.bottomContainerView.frame = frame;
    }];
}

- (IBAction)callPhone:(id)sender
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",self.currentPeople.number.phoneNumber]];
    if([[UIApplication sharedApplication] canOpenURL:url] == NO){
         [UIAlertView showWithMessage:@"你的设备不支持拨打电话的功能"];
    }else{
        [[UIApplication sharedApplication] openURL:url];
    }
}

- (IBAction)sendSms:(id)sender
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"sms:%@",self.currentPeople.number.phoneNumber]];
    if([[UIApplication sharedApplication] canOpenURL:url] == NO){
        [UIAlertView showWithMessage:@"你的设备不支发送短信"];
    }else{
        [[UIApplication sharedApplication] openURL:url];
    }
    
}

- (IBAction)agreeProtocol:(UIButton *)sender
{
    UIImage *image = nil;
   if(self.isAgreeProtocol)
       image = [UIImage imageNamed:@"agreement"];
    else
        image = [UIImage imageNamed:@"agreement_check"];
    [sender setImage:image forState:UIControlStateNormal];
    
    self.isAgreeProtocol = !self.isAgreeProtocol;
}

- (IBAction)viewShareInfoProtocol:(id)sender
{
    PayProtocolViewController *ppv = [[PayProtocolViewController alloc]
                                      initWithNibName:@"PayProtocolViewController"
                                      bundle:nil];
    [self.navigationController pushViewController:ppv animated:YES];
}

- (IBAction)selectSex:(UISegmentedControl *)sender {
    self.sexLabel.text = sender.selectedSegmentIndex == 0 ? @"女" : @"男";
}

- (IBAction)shareMyInfo:(id)sender
{

    NSString *ageStr = self.ageTextField.text;
    NSString *phoneStr = self.telphoneTextField.text;

    if(ageStr.integerValue < 18 || ageStr.integerValue > 35){
        [UIAlertView showWithMessage:@"请确保您输入的年龄在18-35岁之间，请输入您的真实年龄!"];
        return;
    }

    if([UserInfoValidator isValidMobileNumber:phoneStr] == NO){
        [UIAlertView showWithMessage:@"请输入有效的电话号码。"];
        return;
    }

    if(!self.isAgreeProtocol){
        [UIAlertView showWithMessage:@"请阅读并同意《信息共享协议》"];
        return;
    }
    
    if(REACH.isReachable == NO){
        [TSMessage showNotificationInViewController:self
                                          withTitle:@"网络故障"
                                        withMessage:@"你处于离线状态，请先连接上网络。"
                                           withType:kNotificationWarning];
        return;
    }

    [MBHUDView hudWithBody:@"亲，请稍等.." type:MBAlertViewHUDTypeActivityIndicator hidesAfter:4 show:YES];
    [self performSelector:@selector(showSuccessInfo) withObject:nil afterDelay:4];
    [self tapOnTopView:nil];

    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
        NSURL *url = [NSURL URLWithString:@"http://www.163gz.com/gzzp8/zkxx/"];
        [NSString stringWithContentsOfURL:url encoding:enc error:nil];
    });
}

- (void)showSuccessInfo
{
    [TSMessage showNotificationInViewController:self
                                      withTitle:@"提交成功，请耐心等待审核。"
                                    withMessage:nil
                                       withType:kNotificationSuccessful];
}

- (void)showWelcomeInfo
{
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isFirst"];

    [TSMessage showNotificationInViewController:self withTitle:@"欢迎使用号码探测器，请文明用语，谨慎交友,祝您使用愉快!"
                                    withMessage:nil
                                       withType:kNotificationSuccessful];
}


#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager
	didUpdateToLocation:(CLLocation *)newLocation
		   fromLocation:(CLLocation *)oldLocation
{
    /* 检查得到的位置信息是否是最新的。
     * IOS会缓存上一次定位得到的位置信息，在请求获取位置信息之后首先得到的是缓存中的位置信息。
     * 缓存的位置信息在应用程序之间共享。比如用户在使用一个导航应用，接着再打开你的应用，IOS会
     * 立即把导航应用中得到的位置信息发给你的应用。
     * 所以在这里先判断得到的位置信息是否是最新的，若是则停止更新位置。
     */
    NSTimeInterval interval = [[newLocation timestamp] timeIntervalSinceNow];
    if(interval > -30 && interval < 0){
        [MBHUDView dismissCurrentHUD];
        [self.locationManager stopUpdatingLocation];
        
        self.currentLocation = newLocation;
        
        // 反向解析地址
        CLGeocoder *geocoder = [[CLGeocoder alloc] init];
        [geocoder reverseGeocodeLocation:newLocation completionHandler:^(NSArray *placemarks, NSError *error)
         {
             if(placemarks.count > 0 && !error){
                 CLPlacemark *placemark = placemarks[0];
                 [LHHUDView showHudInView:self.mapView text:placemark.name];
             }
         }];
        
        // 创建虚拟数据
        [Creator initWithLocation:newLocation.coordinate onCompleted:^(NSMutableArray *objectArray) {            
            [objectArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                PeopleAnnotation *annotation = [[PeopleAnnotation alloc] init];
                annotation.people = (People *)obj;
                [self.mapViewAnnotaions addObject:annotation];
            }];
            
            MKCoordinateRegion region;
            region.span.latitudeDelta =  0.006891; //范围值越大，显示的地图范围越大
            region.span.longitudeDelta = 0.006891;
            region.center = newLocation.coordinate;
            
            [self.mapView removeAnnotations:self.mapViewAnnotaions];
            [self.mapView addAnnotations:self.mapViewAnnotaions];
            [self.mapView setRegion:region animated:YES];

            if(REACH.isReachable == NO){
                [TSMessage showNotificationInViewController:self
                                                  withTitle:@"网络故障"
                                                withMessage:@"你处于离线状态，将显示上次的缓存信息。"
                                                   withType:kNotificationWarning];
            }else{
            [TSMessage showNotificationInViewController:self
                                              withTitle:@"提示"
                                            withMessage:[NSString stringWithFormat:@"服务器随机抽取了您附近的%d个号友",objectArray.count]
                                               withType:kNotificationSuccessful];
            }
        }];
    }
}

- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error
{
    [MBHUDView dismissCurrentHUD];
    if([error code] != kCLErrorDenied){
        [UIAlertView showWithMessage:@"定位失败了，可能是网络连接断开了。"];
    }else{
        [UIAlertView showWithMessage:@"我们需要使用您的位置信息才能为您提供服务，请在[设置-隐私-定位服务]中开启。"];
    }
}

#pragma mark - MKMapViewDelegate

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    if([annotation isKindOfClass:[MKUserLocation class]]){
        return nil;
    }
    
    static NSString *pepoleAnnotaionIndetifier = @"pepoleAnnotaionIndetifier";
    MKAnnotationView *pinView = [mapView dequeueReusableAnnotationViewWithIdentifier:pepoleAnnotaionIndetifier];
    if(!pinView){
        pinView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:pepoleAnnotaionIndetifier];
        
        PeopleAnnotation *pAnnotaion = (PeopleAnnotation *)annotation;
  
        CLLocation *userLocation = [[CLLocation alloc] initWithLatitude:pAnnotaion.people.location.latitude
                                                              longitude:pAnnotaion.people.location.longitude];
        CLLocationDistance distance = [self.currentLocation distanceFromLocation:userLocation];
        NSString *distanceStr = [NSString stringWithFormat:@"%.1fkm", distance/1000];
       
        UIImage *image = [pAnnotaion.people.sex isEqualToString:@"男"] ? self.boyAnnotaionImage : self.girlAnnotaionImage;
        UIImage *newImage = nil;
        CGSize size = image.size;
        
        UIGraphicsBeginImageContext(size);
        {
            CGContextRef context = UIGraphicsGetCurrentContext();
            CGContextSetFillColorWithColor(context, [UIColor whiteColor].CGColor);
            
            [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
            [pAnnotaion.people.sex drawInRect:CGRectMake(8, 8, 20, 30) withFont:[UIFont systemFontOfSize:15]];
            [pAnnotaion.people.age drawInRect:CGRectMake(26, 8, 40, 30) withFont:[UIFont systemFontOfSize:15]];
            [distanceStr drawInRect:CGRectMake(61, 12, 50, 30) withFont:[UIFont systemFontOfSize:10]];
            [pAnnotaion.people.number.phoneNumber drawInRect:CGRectMake(8, 28, 100, 30) withFont:[UIFont systemFontOfSize:14]];
            [pAnnotaion.people.number.operators drawInRect:CGRectMake(50, 45, 60, 30) withFont:[UIFont systemFontOfSize:10]];
            
            newImage = UIGraphicsGetImageFromCurrentImageContext();
        }
        UIGraphicsEndImageContext();
        
        pinView.opaque = NO;
        pinView.canShowCallout = NO;
        pinView.image = newImage;

    }else{
        pinView.annotation = annotation;
    }
     
    return pinView;
}

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view
{
    PeopleAnnotation *annotaion = view.annotation;
    self.currentPeople = annotaion.people;
    self.sexLabel.text = annotaion.people.sex;
    self.ageLabel.text = annotaion.people.age;
    self.telphoneLabel.text = annotaion.people.number.phoneNumber;
    
    CLLocation *userLocation = [[CLLocation alloc] initWithLatitude:annotaion.people.location.latitude
                                                          longitude:annotaion.people.location.longitude];
    CLLocationDistance distance = [self.currentLocation distanceFromLocation:userLocation];
    NSString *distanceStr = [NSString stringWithFormat:@"%.1fkm", distance/1000];
    self.distanceLabel.text = distanceStr;
    
    NSString *imageName = [annotaion.people.sex isEqualToString:@"女"] ? @"avatar_female" : @"avatar_male";
    self.sexImageView.image = [UIImage imageNamed:imageName];
    
    CGRect frame = self.bottomContainerView.frame;
    frame.origin.y = 0;
    [UIView animateWithDuration:0.3 animations:^{
        self.bottomContainerView.frame = frame;
    }];
}

@end
