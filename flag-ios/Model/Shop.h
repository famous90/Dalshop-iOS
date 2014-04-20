//
//  Shop.h
//  flag-ios
//
//  Created by Gyuyoung Hwang on 2014. 2. 5..
//
//

#import <Foundation/Foundation.h>

@interface Shop : NSObject

@property (nonatomic, strong) NSNumber *shopId;
@property (nonatomic, strong) NSNumber *parentId;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *logoUrl;
@property (nonatomic, strong) NSString *imageUrl;
@property (nonatomic, strong) NSString *description;
@property (nonatomic, assign) NSInteger type;
@property (nonatomic, assign) NSInteger reward;
@property (nonatomic, assign) BOOL rewarded;

- (id)initWithData:(id)data;

@end
