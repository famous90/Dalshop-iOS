//
//  ShopDataController.m
//  flag-ios
//
//  Created by Gyuyoung Hwang on 2014. 2. 6..
//
//

#import "ShopDataController.h"
#import "Shop.h"

@implementation ShopDataController

- (void)initForTest
{
    Shop *shop1 = [[Shop alloc] init];
    Shop *shop2 = [[Shop alloc] init];
    
    shop1.shopId = [NSNumber numberWithInt:1];
    shop1.name = @"UNICLO";
    shop1.type = 1;
    shop1.description = @"clothes clothes clothes clothes clothes clothes";
    shop1.reward = 1500;
    shop1.rewarded = NO;

    shop2.shopId = [NSNumber numberWithInt:2];
    shop2.name = @"NIKE";
    shop2.type = 2;
    shop2.description = @"sports sports sports sports sports sports Sale off";
    shop2.reward = 5300;
    shop2.rewarded = YES;
    
    [self.masterData addObject:shop1];
    [self.masterData addObject:shop2];
}

- (id)objectInlistWithObjectId:(NSNumber *)objectId
{
    for(NSDictionary *object in self.masterData){
        if ([[object valueForKey:@"shopId"] isEqual:objectId]) {
            return object;
        }
    }
    
    return nil;
}

@end
