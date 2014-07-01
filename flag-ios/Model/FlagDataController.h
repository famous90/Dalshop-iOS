//
//  FlagDataController.h
//  flag-ios
//
//  Created by Gyuyoung Hwang on 2014. 2. 11..
//
//

#import "DataController.h"

@class Flag;

@interface FlagDataController : DataController

- (Flag *)objectWithFlagId:(NSNumber *)flagId;
- (NSArray *)shopIdListInFlagList;
- (Flag *)objectWithShopId:(NSNumber *)shopId;
- (NSArray *)sortFlagsByDistanceFromCurrentLocation;

@end
