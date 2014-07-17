//
//  BeaconUtil.m
//  Dalshop
//
//  Created by Hwang Gyuyoung on 2014. 5. 22..
//
//

#import "BeaconUtil.h"
#import "DataUtil.h"

#import "BeaconDataController.h"

@implementation BeaconUtil

+ (void)handleBeaconListWithData:(NSDictionary *)results withLastUpdateTime:(NSTimeInterval)lastUpdateTime
{
    NSArray *beacons = [results objectForKey:@"items"];
    DLog(@"beacon list count %ld", (unsigned long)[beacons count]);
    
    if ([beacons count]) {
        
        // save beacon data after created last update time
        [DataUtil saveBeaconListWithData:beacons afterLastUpdateTime:lastUpdateTime];
    }
    
    // save last update time with now
    [DataUtil saveLastUpdateTimeWithDate:[NSDate date]];
}

+ (BeaconDataController *)getBeaconListAroundLocation:(CLLocation *)location
{
    double latitude = location.coordinate.latitude;
    double longitude = location.coordinate.longitude;
    
    BeaconDataController *beaconData = [DataUtil getBeaconListWithLatitude:latitude longitude:longitude];
    
    return beaconData;
}

+ (BOOL)isDeviceInRangeOfBeaconCheckInWithBeacon:(CLBeacon *)beacon
{
    if ((beacon.accuracy < [beacon.minor floatValue]) && (beacon.accuracy > 0)) {
        return YES;
    }else return NO;
}
@end
