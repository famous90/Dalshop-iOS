//
//  ItemDataController.h
//  flag-ios
//
//  Created by Gyuyoung Hwang on 2014. 2. 6..
//
//

#import "DataController.h"

@interface ItemDataController : DataController

- (BOOL)didRewardItemWithItemId:(NSNumber *)itemId;
- (NSArray *)getItemListFromList;
- (NSArray *)getScanListFromList;

@end
