//
//  Beacon.m
//  flag-ios
//
//  Created by Gyuyoung Hwang on 2014. 3. 19..
//
//

#import "Beacon.h"

@implementation Beacon

- (id)initWithData:(id)data
{
    self = [super init];
    if (self) {
        _beaconId = [data valueForKey:@"id"];
        _shopId = [data valueForKey:@"shopId"];
        _shopName = [data valueForKey:@"name"];
        _latitude = [data valueForKey:@"lat"];
        _longitude = [data valueForKey:@"lon"];
        _flagId = [data valueForKey:@"flagId"];
        _createdAt = [data valueForKey:@"createdAt"];
        _lastScanTime = [[NSDate alloc] init];
    }
    return self;
}

- (id)initWithManagedObject:(NSManagedObject *)object
{
    self = [super init];
    if (self) {
        _beaconId = [object valueForKey:@"beaconId"];
        _shopId = [object valueForKey:@"shopId"];
        _shopName = [object valueForKey:@"shopName"];
        _latitude = [object valueForKey:@"latitude"];
        _longitude = [object valueForKey:@"longitude"];
        _lastScanTime = [object valueForKey:@"lastScanTime"];
    }
    
    return self;
}

@end
