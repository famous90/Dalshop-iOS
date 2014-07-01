//
//  Item.h
//  flag-ios
//
//  Created by Gyuyoung Hwang on 2014. 2. 6..
//
//

#import <Foundation/Foundation.h>

@interface Item : NSObject

@property (nonatomic, strong) NSNumber *itemId;
@property (nonatomic, strong) NSNumber *shopId;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *thumbnailUrl;
@property (nonatomic, strong) NSString *description;
@property (nonatomic, assign) NSInteger sale;
@property (nonatomic, strong) NSString *oldPrice;
@property (nonatomic, strong) NSString *price;
@property (nonatomic, strong) NSString *barcodeId;
@property (nonatomic, assign) NSInteger reward;
@property (nonatomic, assign) BOOL rewarded;
@property (nonatomic, assign) BOOL rewardable;
@property (nonatomic, assign) NSInteger likes;
@property (nonatomic, assign) BOOL liked;
@property (nonatomic, assign) BOOL sex;
@property (nonatomic, assign) NSInteger type;

- (id)initWithData:(id)data;
- (BOOL)isEqualToCodeString:(NSString *)codeString;
- (void)didRewardItem;

@end
