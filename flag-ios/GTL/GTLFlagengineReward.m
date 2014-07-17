/* This file was generated by the ServiceGenerator.
 * The ServiceGenerator is Copyright (c) 2014 Google Inc.
 */

//
//  GTLFlagengineReward.m
//

// ----------------------------------------------------------------------------
// NOTE: This file is generated from Google APIs Discovery Service.
// Service:
//   flagengine/v1
// Description:
//   This is an API
// Classes:
//   GTLFlagengineReward (0 custom class methods, 8 custom properties)

#import "GTLFlagengineReward.h"

// ----------------------------------------------------------------------------
//
//   GTLFlagengineReward
//

@implementation GTLFlagengineReward
@dynamic createdAt, identifier, reward, statusCode, targetId, targetName, type,
         userId;

+ (NSDictionary *)propertyToJSONKeyMap {
  NSDictionary *map =
    [NSDictionary dictionaryWithObject:@"id"
                                forKey:@"identifier"];
  return map;
}

@end
