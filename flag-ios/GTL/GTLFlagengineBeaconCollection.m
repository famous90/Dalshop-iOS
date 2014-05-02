/* This file was generated by the ServiceGenerator.
 * The ServiceGenerator is Copyright (c) 2014 Google Inc.
 */

//
//  GTLFlagengineBeaconCollection.m
//

// ----------------------------------------------------------------------------
// NOTE: This file is generated from Google APIs Discovery Service.
// Service:
//   flagengine/v1
// Description:
//   This is an API
// Classes:
//   GTLFlagengineBeaconCollection (0 custom class methods, 1 custom properties)

#import "GTLFlagengineBeaconCollection.h"

#import "GTLFlagengineBeacon.h"

// ----------------------------------------------------------------------------
//
//   GTLFlagengineBeaconCollection
//

@implementation GTLFlagengineBeaconCollection
@dynamic items;

+ (NSDictionary *)arrayPropertyToClassMap {
  NSDictionary *map =
    [NSDictionary dictionaryWithObject:[GTLFlagengineBeacon class]
                                forKey:@"items"];
  return map;
}

@end