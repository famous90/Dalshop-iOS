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

- (id)objectInlistWithObjectId:(NSNumber *)objectId
{
    for(NSDictionary *object in self.masterData){
        if ([[object valueForKey:@"shopId"] isEqual:objectId]) {
            return object;
        }
    }
    
    return nil;
}

- (NSArray *)getHQShopIds
{
    NSMutableSet *noDuplicateSet = [[NSMutableSet alloc] init];
    
    for(NSDictionary *object in self.masterData){
        [noDuplicateSet addObject:[object valueForKey:@"parentId"]];
    }
    
    return [noDuplicateSet allObjects];
}


@end
