/* This file was generated by the ServiceGenerator.
 * The ServiceGenerator is Copyright (c) 2014 Google Inc.
 */

//
//  GTLFlagengineRewardCollection.m
//

// ----------------------------------------------------------------------------
// NOTE: This file is generated from Google APIs Discovery Service.
// Service:
//   flagengine/v1
// Description:
//   This is an API
// Classes:
//   GTLFlagengineRewardCollection (0 custom class methods, 1 custom properties)

#import "GTLFlagengineRewardCollection.h"

#import "GTLFlagengineReward.h"

// ----------------------------------------------------------------------------
//
//   GTLFlagengineRewardCollection
//

@implementation GTLFlagengineRewardCollection
@dynamic rewards;

+ (NSDictionary *)arrayPropertyToClassMap {
  NSDictionary *map =
    [NSDictionary dictionaryWithObject:[GTLFlagengineReward class]
                                forKey:@"rewards"];
  return map;
}

@end
