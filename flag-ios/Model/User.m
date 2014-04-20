//
//  User.m
//  flag-ios
//
//  Created by Gyuyoung Hwang on 2014. 2. 6..
//
//

#import "User.h"

@implementation User

- (id)initWithData:(id)data
{
    self = [super init];
    if (self) {
        _userId = [data valueForKey:@"id"];
        _reward = [[data valueForKey:@"reward"] integerValue];
    }
    return self;
}

- (id)initWithCoreData:(id)data
{
    self = [super init];
    if (self) {
        _userId = [NSNumber numberWithLongLong:[[data valueForKey:@"userId"] longLongValue]];
        _registered = [[data valueForKey:@"registered"] boolValue];
    }
    return self;
}

@end
