//
//  GTLQueryFlagengine.m
//  flag-ios
//
//  Created by Gyuyoung Hwang on 2014. 4. 15..
//
//

#import "GTLQueryFlagengine.h"

#import "GTLFlagengineNotice.h"
#import "GTLFlagengineGuestSession.h"

@implementation GTLQueryFlagengine

@dynamic beaconId, descriptionProperty, fields, flagId, identifier, ids,
imageUrl, itemId, lat, logoUrl, lon, name, parentId, reward, rewarded,
rewardedForUser, shopId, type, userId;

+ (NSDictionary *)parameterNameMap {
    NSDictionary *map =
    [NSDictionary dictionaryWithObjectsAndKeys:
     @"description", @"descriptionProperty",
     @"id", @"identifier",
     nil];
    return map;
}

+ (NSDictionary *)arrayPropertyToClassMap {
    NSDictionary *map =
    [NSDictionary dictionaryWithObject:[NSNumber class]
                                forKey:@"ids"];
    return map;
}   

#pragma mark -
#pragma mark "apps.notices" methods
// These create a GTLQueryFlagengine object.

+ (id)queryForAppsNoticesGet {
    NSString *methodName = @"flagengine.apps.notices.get";
    GTLQueryFlagengine *query = [self queryWithMethodName:methodName];
    query.expectedObjectClass = [GTLFlagengineNotice class];
    return query;
}

+ (id)queryForAppsNoticesInsertWithObject:(GTLFlagengineNotice *)object {
    if (object == nil) {
        GTL_DEBUG_ASSERT(object != nil, @"%@ got a nil object", NSStringFromSelector(_cmd));
        return nil;
    }
    NSString *methodName = @"flagengine.apps.notices.insert";
    GTLQueryFlagengine *query = [self queryWithMethodName:methodName];
    query.bodyObject = object;
    query.expectedObjectClass = [GTLFlagengineNotice class];
    return query;
}

#pragma mark - 
#pragma mark "users.guest" methods
// These create a GTLQueryFlagengine object.

+ (id)queryForUserGuestSession
{
    NSString *methodName = @"flagengine.users.guest";
    GTLQueryFlagengine *query = [self queryWithMethodName:methodName];
    query.expectedObjectClass = [GTLFlagengineGuestSession class];
    return query;
}

@end
