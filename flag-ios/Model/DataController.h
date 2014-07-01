//
//  DataController.h
//  flag-ios
//
//  Created by Gyuyoung Hwang on 2014. 2. 6..
//
//

#import <Foundation/Foundation.h>

@interface DataController : NSObject

@property (nonatomic, strong) NSMutableArray *masterData;

- (id)init;
- (id)initWithArray:(NSArray *)dataArray;

- (NSUInteger)countOfList;
- (id)objectInListAtIndex:(NSUInteger)index;
- (void)addObjectWithObject:(id)object;
- (void)removeAllData;
- (void)addMasterDataWithArray:(NSArray *)dataArray;

@end
