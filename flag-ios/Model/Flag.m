//
//  Flag.m
//  flag-ios
//
//  Created by Gyuyoung Hwang on 2014. 2. 5..
//
//

#import "Flag.h"

@implementation Flag

- (id)initWithData:(id)data
{
    self = [super init];
    
    if (self) {
        _createdAt = [[data valueForKey:@"createdAt"] floatValue]/1000;
        _flagId = [data valueForKey:@"id"];
        _lat = [data valueForKey:@"lat"];
        _lon = [data valueForKey:@"lon"];
        _shopId = [data valueForKey:@"shopId"];
        _shopName = [data valueForKey:@"shopName"];
        _shopType = [[data valueForKey:@"shopType"] integerValue];
    }
    
    return self;
}

@end
