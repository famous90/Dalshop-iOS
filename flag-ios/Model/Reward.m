//
//  Reward.m
//  flag-ios
//
//  Created by Gyuyoung Hwang on 2014. 2. 22..
//
//

#import "Reward.h"

@implementation Reward

- (id)initWithData:(id)data
{
    self = [super init];
    if (self) {
        _rewardId = [data valueForKey:@"id"];
        _userId = [data valueForKey:@"userId"];
        _targetId = [data valueForKey:@"targetId"];
        _targetName = [data valueForKey:@"targetName"];
        _type = [[data valueForKey:@"type"] integerValue];
        _reward = [[data valueForKey:@"reward"] integerValue];
        _createdAt = [[data valueForKey:@"createdAt"] floatValue]/1000;
    }
    return self;
}

@end
