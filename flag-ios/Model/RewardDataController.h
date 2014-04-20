//
//  RewardDataController.h
//  flag-ios
//
//  Created by Gyuyoung Hwang on 2014. 2. 22..
//
//

#import "DataController.h"

@class Reward;

@interface RewardDataController : DataController

- (void)initForTest;
- (NSUInteger)countOfOnedayRewardAtIndex:(NSInteger)index;
- (NSString *)dateStringAtIndex:(NSInteger)index;
- (Reward *)objectAtIndex:(NSInteger)index rewardIndex:(NSInteger)rewardIndex;

@end
