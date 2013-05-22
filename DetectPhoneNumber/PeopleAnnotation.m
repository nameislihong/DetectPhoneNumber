//
//  PeopleAnnotation.m
//  DetectPhoneNumber
//
//  Created by xcode on 13-4-21.
//  Copyright (c) 2013年 xcode. All rights reserved.
//

#import "PeopleAnnotation.h"

@implementation PeopleAnnotation


- (CLLocationCoordinate2D)coordinate
{
    return  self.people.location;
}

- (NSString *)title
{
    return [NSString stringWithFormat:@"%@ %@", self.people.sex, self.people.age];
}

- (NSString *)subtitle
{
    return [NSString stringWithFormat:@"%@ %@", self.people.number.operators, self.people.number.phoneNumber];
}
@end
