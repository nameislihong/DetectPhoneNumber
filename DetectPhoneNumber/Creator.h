//
//  Creator.h
//  DetectPhoneNumber
//
//  Created by xcode on 13-4-20.
//  Copyright (c) 2013年 xcode. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

typedef void (^arrayBlock)(NSMutableArray *objectArray);

@interface Creator : NSObject
+ (void)initWithLocation:(CLLocationCoordinate2D)location
              onCompleted:(arrayBlock)completed;
@end
