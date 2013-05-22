//
//  PhoneNumber.h
//  DetectPhoneNumber
//
//  Created by xcode on 13-4-20.
//  Copyright (c) 2013年 xcode. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PhoneNumber : NSObject
@property (strong, nonatomic) NSString *phoneNumber;
@property (strong, nonatomic) NSString *operators;    // 运营商
@end
