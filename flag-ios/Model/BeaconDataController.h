//
//  BeaconDataController.h
//  flag-ios
//
//  Created by Gyuyoung Hwang on 2014. 3. 19..
//
//

#import "DataController.h"

@class Beacon;

@interface BeaconDataController : DataController

- (void)initForTest;

//- (Beacon *)beaconInListWithBeaconId:(NSString *)beaconId;
- (NSArray *)scannableBeaconList;
- (Beacon *)didScanBeaconWithBeaconId:(NSString *)beaconId;

@end
