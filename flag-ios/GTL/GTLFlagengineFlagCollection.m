/* This file was generated by the ServiceGenerator.
 * The ServiceGenerator is Copyright (c) 2014 Google Inc.
 */

//
//  GTLFlagengineFlagCollection.m
//

// ----------------------------------------------------------------------------
// NOTE: This file is generated from Google APIs Discovery Service.
// Service:
//   flagengine/v1
// Description:
//   This is an API
// Classes:
//   GTLFlagengineFlagCollection (0 custom class methods, 1 custom properties)

#import "GTLFlagengineFlagCollection.h"

#import "GTLFlagengineFlag.h"

// ----------------------------------------------------------------------------
//
//   GTLFlagengineFlagCollection
//

@implementation GTLFlagengineFlagCollection
@dynamic flags;

+ (NSDictionary *)arrayPropertyToClassMap {
  NSDictionary *map =
    [NSDictionary dictionaryWithObject:[GTLFlagengineFlag class]
                                forKey:@"flags"];
  return map;
}

@end