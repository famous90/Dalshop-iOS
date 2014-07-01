//
//  FlagDataController.m
//  flag-ios
//
//  Created by Gyuyoung Hwang on 2014. 2. 11..
//
//

#import "FlagDataController.h"
#import "Flag.h"

#import "AppDelegate.h"

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

- (Flag *)objectWithShopId:(NSNumber *)shopId
{
    for( Flag *theFlag in self.masterData){
        if ([theFlag.shopId integerValue] == [shopId integerValue]) {
            return theFlag;
        }
    }
    return nil;
}

- (NSArray *)shopIdListInFlagList
{
    NSMutableSet *noDuplicateSet = [[NSMutableSet alloc] init];
    
    for(NSDictionary *object in self.masterData){
        [noDuplicateSet addObject:[object valueForKey:@"shopId"]];
    }
    
    return [noDuplicateSet allObjects];
}

- (NSArray *)sortFlagsByDistanceFromCurrentLocation
{
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    CLLocation *location = delegate.savedLocation;
    
    NSArray *orderedFlags = [self.masterData sortedArrayUsingComparator:^(id a, id b){
       
        Flag *flagA = (Flag *)a;
        Flag *flagB = (Flag *)b;
        
        CLLocation *locationA = [[CLLocation alloc] initWithLatitude:[flagA.lat floatValue] longitude:[flagA.lon floatValue]];
        CLLocation *locationB = [[CLLocation alloc] initWithLatitude:[flagB.lat floatValue] longitude:[flagB.lon floatValue]];
        
        CLLocationDistance distanceA = [locationA distanceFromLocation:location];
        CLLocationDistance distanceB = [locationB distanceFromLocation:location];
        
        if (distanceA < distanceB) {
            return NSOrderedAscending;
        }else if (distanceA > distanceB){
            return NSOrderedDescending;
        }else return NSOrderedSame;
        
    }];
    
//    for(Flag *theFlag in orderedFlags){
//        NSLog(@"ordered flag %@ name %@", theFlag.flagId, theFlag.shopName);
//    }
    
    return orderedFlags;
}

@end
