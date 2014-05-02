/* This file was generated by the ServiceGenerator.
 * The ServiceGenerator is Copyright (c) 2014 Google Inc.
 */

//
//  GTLFlagengineLike.m
//

// ----------------------------------------------------------------------------
// NOTE: This file is generated from Google APIs Discovery Service.
// Service:
//   flagengine/v1
// Description:
//   This is an API
// Classes:
//   GTLFlagengineLike (0 custom class methods, 4 custom properties)

#import "GTLFlagengineLike.h"

// ----------------------------------------------------------------------------
//
//   GTLFlagengineLike
//

@implementation GTLFlagengineLike
@dynamic identifier, targetId, type, userId;

+ (NSDictionary *)propertyToJSONKeyMap {
  NSDictionary *map =
    [NSDictionary dictionaryWithObject:@"id"
                                forKey:@"identifier"];
  return map;
}

@end