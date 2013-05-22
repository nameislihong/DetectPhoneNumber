//
//  Validator.h
//  NSReg
//
//  Created by LiHong 13-3-24.
//  Copyright (c) 2013年 xcode. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserInfoValidator : NSObject

+ (BOOL)isValidMobileNumber:(NSString*)mobileNum;
+ (BOOL)isValidEmail:(NSString *)email;
+ (BOOL)isValidZipCode:(NSString *)zipCode;

@end
