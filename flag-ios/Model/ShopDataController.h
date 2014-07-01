//
//  ShopDataController.h
//  flag-ios
//
//  Created by Gyuyoung Hwang on 2014. 2. 6..
//
//

#import "DataController.h"

@interface ShopDataController : DataController

- (id)objectInlistWithObjectId:(NSNumber *)objectId;
- (NSArray *)getHQShopIds;

@end
