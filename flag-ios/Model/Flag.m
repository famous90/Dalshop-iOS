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
        _lastScanTime = [NSDate dateWithTimeIntervalSince1970:0];
    }
    
    return self;
}

- (id)initWithCoreData:(id)data
{
    self = [super init];
    if (self) {
        [self setCreatedAtWithDate:[data valueForKey:@"createdAt"]];
        _flagId = [data valueForKey:@"flagId"];
        _lat = [data valueForKey:@"latitude"];
        _lon = [data valueForKey:@"longitude"];
        _shopId = [data valueForKey:@"shopId"];
        _shopName = [data valueForKey:@"shopName"];
        _shopType = [[data valueForKey:@"shopType"] integerValue];
        if ([data valueForKey:@"lastScanTime"]) {
            _lastScanTime = [data valueForKey:@"lastScanTime"];
        }else{
            _lastScanTime = [NSDate dateWithTimeIntervalSince1970:0];
        }
    }
    return self;
}

- (NSDate *)getCreatedAtByNSDate
{
    NSDate *createdAt = [NSDate dateWithTimeIntervalSince1970:self.createdAt];
    return createdAt;
}

- (void)setCreatedAtWithDate:(NSDate *)date
{
    NSTimeInterval time = [date timeIntervalSince1970];
    _createdAt = time;
}

- (BOOL)canFlagBeCheckedIn
{
    NSDate *now = [NSDate date];
    NSDate *coolTimeCriteria = [now dateByAddingTimeInterval:-(BEACON_COOL_TIME)];
    
    if ([self.lastScanTime compare:coolTimeCriteria] == NSOrderedAscending) {
        return YES;
    }else{
        return NO;
    }
}

- (NSInteger)getFlagCheckInStatus
{
    if ([self canFlagBeCheckedIn]) {
        return BASE;
    }else{
        return REWARDED;
    }
}

@end
