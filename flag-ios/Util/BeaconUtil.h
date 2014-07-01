//
//  BeaconUtil.h
//  Dalshop
//
//  Created by Hwang Gyuyoung on 2014. 5. 22..
//
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>


@interface BeaconUtil : NSObject

//+ (void)handleBeaconListWithData:(NSDictionary *)results withLastUpdateTime:(NSTimeInterval)lastUpdateTime;
//+ (BeaconDataController *)getBeaconListAroundLocation:(CLLocation * )location;
+ (BOOL)isDeviceInRangeOfBeaconCheckInWithBeacon:(CLBeacon *)beacon;

@end
