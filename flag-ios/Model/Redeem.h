//
//  Redeem.h
//  flag-ios
//
//  Created by Gyuyoung Hwang on 2014. 3. 3..
//
//

#import <Foundation/Foundation.h>

@interface Redeem : NSObject

@property (nonatomic, strong) NSNumber *redeemId;
@property (nonatomic, strong) NSString *imageUrl;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, assign) NSInteger price;
@property (nonatomic, strong) NSString *vendor;

- (id)initWithData:(id)data;

@end
