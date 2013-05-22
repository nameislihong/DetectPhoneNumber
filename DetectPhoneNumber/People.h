//
//  People.h
//  DetectPhoneNumber
//
//  Created by xcode on 13-4-20.
//  Copyright (c) 2013年 xcode. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "PhoneNumber.h"

@interface People : NSObject
@property (strong, nonatomic) NSString *sex;
@property (strong, nonatomic) NSString *age;
@property (strong, nonatomic) PhoneNumber *number;
@property (assign, nonatomic) CLLocationCoordinate2D location;
@end
