//
//  Redeem.h
//  flag-ios
//
//  Created by Gyuyoung Hwang on 2014. 3. 3..
//
//

#import <Foundation/Foundation.h>

@interface Redeem : NSObject

@property (nonatomic, strong) NSNumber *userId;
@property (nonatomic, strong) NSNumber *targetId;
@property (nonatomic, strong) NSString *targetName;
@property (nonatomic, assign) NSInteger redeem;
@property (nonatomic, assign) NSTimeInterval createdAt;

@end
