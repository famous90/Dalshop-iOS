//
//  FlagDataController.m
//  flag-ios
//
//  Created by Gyuyoung Hwang on 2014. 2. 11..
//
//

#import "FlagDataController.h"
#import "Flag.h"

@implementation FlagDataController

- (Flag *)objectWithFlagId:(NSNumber *)flagId
{
    NSLog(@"selected %@", flagId);
    for( Flag *object in self.masterData){
        NSLog(@"search %@", object.flagId);
        
        if ([object.flagId integerValue] == [flagId integerValue]) {
//            return object;
            NSLog(@"done");
        }
    }
    
    return nil;
}

- (NSArray *)shopIdListInFlagList
{
    NSMutableSet *noDuplicateSet = [[NSMutableSet alloc] init];
    
    for(NSDictionary *object in self.masterData){
        [noDuplicateSet addObject:[object valueForKey:@"shopId"]];
        NSLog(@"%@", [[object valueForKey:@"shopId"] class]);
    }

    return [noDuplicateSet allObjects];
}

@end
