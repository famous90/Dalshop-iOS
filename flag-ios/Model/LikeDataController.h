//
//  LikeDataController.h
//  Dalshop
//
//  Created by Hwang Gyuyoung on 2014. 6. 11..
//
//

#import "DataController.h"

@interface LikeDataController : DataController

@property (nonatomic, assign) NSInteger type;

- (void)setType:(NSInteger)type;
- (NSArray *)objectIdsInList;

@end
