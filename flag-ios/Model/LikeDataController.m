//
//  LikeDataController.m
//  Dalshop
//
//  Created by Hwang Gyuyoung on 2014. 6. 11..
//
//

#import "LikeDataController.h"

@implementation LikeDataController

- (void)setType:(NSInteger)type
{
    _type = type;
}

- (NSArray *)objectIdsInList
{
    NSString *idName;
    if (self.type == LIKE_ITEM) {
        idName = @"itemId";
    }else if (self.type == LIKE_SHOP){
        idName = @"shopId";
    }
    
    NSMutableSet *noDuplicateSet = [[NSMutableSet alloc] init];
    
    for(NSDictionary *object in self.masterData){
        [noDuplicateSet addObject:[object valueForKey:idName]];
    }
    
    return [noDuplicateSet allObjects];
}

@end
