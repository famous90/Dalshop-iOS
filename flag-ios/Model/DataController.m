//
//  DataController.m
//  flag-ios
//
//  Created by Gyuyoung Hwang on 2014. 2. 6..
//
//

#import "DataController.h"

@implementation DataController

- (id)init
{
    self = [super init];
    if (self) {
        self.masterData = [[NSMutableArray alloc] init];
    }
    return self;
}

//- (void)setMasterData:(NSMutableArray *)masterData
//{
//    if (self.masterData != masterData) {
//        self.masterData = [masterData mutableCopy];
//    }
//}

- (NSUInteger)countOfList
{
    return [self.masterData count];
}

- (id)objectInListAtIndex:(NSUInteger)index
{
    return [self.masterData objectAtIndex:index];
}

- (void)addObjectWithObject:(id)object
{
    [self.masterData addObject:object];
}

- (void)removeAllData
{
    [self.masterData removeAllObjects];
}

- (void)addMasterDataWithArray:(NSArray *)dataArray
{
    [self.masterData addObjectsFromArray:dataArray];
}

@end
