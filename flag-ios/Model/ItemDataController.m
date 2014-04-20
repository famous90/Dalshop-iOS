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

@end
