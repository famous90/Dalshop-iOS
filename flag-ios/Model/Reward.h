//
//  Reward.h
//  flag-ios
//
//  Created by Gyuyoung Hwang on 2014. 2. 22..
//
//

#import <Foundation/Foundation.h>

@interface Reward : NSObject

@property (nonatomic, strong) NSNumber *rewardId;
@property (nonatomic, strong) NSNumber *userId;
@property (nonatomic, strong) NSNumber *targetId;
@property (nonatomic, strong) NSString *targetName;
@property (nonatomic, assign) NSInteger type;
@property (nonatomic, assign) NSInteger reward;
@property (nonatomic, assign) NSTimeInterval createdAt;

- (id)initWithData:(id)data;

@end
