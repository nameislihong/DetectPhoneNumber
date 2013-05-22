//
//  Creator.m
//  DetectPhoneNumber
//
//  Created by xcode on 13-4-20.
//  Copyright (c) 2013年 xcode. All rights reserved.
//

#import "Creator.h"
#import "People.h"
#import "PhoneNumber.h"

static NSArray *numbersPrefixArray;

@implementation Creator

+ (void)initialize
{
    /* 手机号 
     * 移动：134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     * 联通：130,131,132,152,155,156,185,186
     * 电信：133,1349,153,180,189
     */
    numbersPrefixArray =
    @[
        @[@135, @136, @137, @138, @139, @150, @157, @158, @159, @182, @187, @188],
        @[@130, @131, @132, @152, @155, @156, @158, @186],
        @[@133, @153, @180, @189]
     ];
}

+ (void)initWithLocation:(CLLocationCoordinate2D)location
             onCompleted:(arrayBlock)completed
{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        srand(time(NULL));
        NSMutableArray *array = [NSMutableArray new];
        int count = rand() % 100 + 50;

        for(int i = 0; i != count; i++)
            [array addObject:[Creator people:location]];
                
        dispatch_async(dispatch_get_main_queue(), ^{
            completed(array);
        });
    });
}

+ (People *)people:(CLLocationCoordinate2D)location
{
    People *p = [People new];
    p.age = [NSString stringWithFormat:@"%d岁", rand()%14 + 18];
    p.sex = rand() % 5 ? @"女" : @"男";
    p.number = [Creator phoneNumber];
    p.location = [Creator newLoacation:location];
    return p;
}

#define REGION 20000

+ (CLLocationCoordinate2D)newLoacation:(CLLocationCoordinate2D)location
{
    NSString *latStr, *lonStr;
    latStr = [NSString stringWithFormat:@"%f", location.latitude];
    lonStr = [NSString stringWithFormat:@"%f", location.longitude];
    
    NSArray *latStrComponent = [latStr componentsSeparatedByString:@"."];
    NSArray *lonStrComponent = [lonStr componentsSeparatedByString:@"."];
    NSString *latStrSecondPart = latStrComponent[1];
    NSString *lonStrSecondPart = lonStrComponent[1];
    
    NSInteger latValue;
    if(rand() % 2)
        latValue = rand() % REGION + latStrSecondPart.integerValue;
    else
        latValue = latStrSecondPart.integerValue - rand() % REGION;
    
    NSInteger lonValue;
    if(rand() % 2)
        lonValue = rand() % REGION + lonStrSecondPart.integerValue;
    else
        lonValue = lonStrSecondPart.integerValue - rand() % REGION;
    
    latStr = [NSString stringWithFormat:@"%@.%d", latStrComponent[0], latValue];
    lonStr = [NSString stringWithFormat:@"%@.%d", lonStrComponent[0], lonValue];
    
    CLLocationCoordinate2D newLocation = {latStr.floatValue, lonStr.floatValue};
    return newLocation;
}

+ (PhoneNumber *)phoneNumber
{
    NSInteger i = rand() % 3;
    NSArray *array = numbersPrefixArray[i];
    
    NSString *prefix = array[rand() % array.count];
    
    PhoneNumber *number = [PhoneNumber new];
    number.phoneNumber = [NSString stringWithFormat:@"%@%@", prefix, [Creator randomString8]];
    if(i == 0)
        number.operators = @"中国移动";
    else if (i == 1)
        number.operators = @"中国联通";
    else
        number.operators = @"中国电信";
    
    return number;
}

+ (NSString *)randomString8
{
    char chars_pool[] = {'0','1','2','3','4','5','6','7','8','9'};
    char chars[9];
    
    for(int i = 0; i < 8; i++){
        chars[i] = chars_pool[rand() % sizeof(chars_pool)];
    }
    chars[8] = '\0';
    return [NSString stringWithUTF8String:chars];
}

@end
