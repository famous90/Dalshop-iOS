//
//  User.m
//  flag-ios
//
//  Created by Gyuyoung Hwang on 2014. 2. 6..
//
//

#import "User.h"

#import "GTLFlagengineUser.h"

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

- (id)initWithLoginData:(GTLFlagengineUser *)user
{
    self = [super init];
    if (self) {
        _userId = user.identifier;
        _reward = [user.reward integerValue];
        _email = user.email;
        _registered = YES;
    }
    return self;
}

- (id)initWithCoreData:(id)data
{
    self = [super init];
    if (self) {
        _userId = [NSNumber numberWithLongLong:[[data valueForKey:@"userId"] longLongValue]];
        _email = [data valueForKey:@"email"];
        _registered = [[data valueForKey:@"registered"] boolValue];
        _phoneCertificated = [[data valueForKey:@"phoneCertificated"] boolValue];
        _additionalProfiled = [[data valueForKey:@"additionalProfiled"] boolValue];
    }
    return self;
}

@end
