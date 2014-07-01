//
//  ItemDataController.m
//  flag-ios
//
//  Created by Gyuyoung Hwang on 2014. 2. 6..
//
//

#import "ItemDataController.h"
#import "Item.h"

@implementation ItemDataController

- (BOOL)didRewardItemWithItemId:(NSNumber *)itemId
{
    for(Item *theItem in self.masterData){
        if ([theItem.itemId isEqualToNumber:itemId]) {
            [theItem didRewardItem];
            return YES;
        }
    }
    return NO;
}

- (NSArray *)getItemListFromList
{
    NSPredicate *resultPredicate = [NSPredicate predicateWithFormat:@"reward == %d", 0];
    NSArray *dataSet = [[NSArray alloc] initWithArray:self.masterData];
    return [dataSet filteredArrayUsingPredicate:resultPredicate];
}

- (NSArray *)getScanListFromList
{
    NSPredicate *resultPredicate = [NSPredicate predicateWithFormat:@"reward != %d", 0];
    NSArray *dataSet = [[NSArray alloc] initWithArray:self.masterData];
    return [dataSet filteredArrayUsingPredicate:resultPredicate];
}

- (void)sortItemListAlongScanItem
{
    NSSortDescriptor *scanSorter = [[NSSortDescriptor alloc] initWithKey:@"rewardable" ascending:NO];
    [self.masterData sortUsingDescriptors:[NSArray arrayWithObject:scanSorter]];
}

- (NSArray *)getItemIds
{
    NSMutableSet *noDuplicateSet = [[NSMutableSet alloc] init];
    
    for(NSDictionary *object in self.masterData){
        [noDuplicateSet addObject:[object valueForKey:@"itemId"]];
    }
    
    return [noDuplicateSet allObjects];
}

@end
