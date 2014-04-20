//
//  GTLFlagengineGuestSession.m
//  flag-ios
//
//  Created by Gyuyoung Hwang on 2014. 4. 16..
//
//

#import "GTLFlagengineGuestSession.h"

// -------------------------------------------------
//
//  GTLFlagengineGuestSession
//

@implementation GTLFlagengineGuestSession
@dynamic identifier, reward;

+ (NSDictionary *)propertyToJSONKeyMap {
    NSDictionary *map =
    [NSDictionary dictionaryWithObject:@"id"
                                forKey:@"identifier"];
    return map;
}

@end
