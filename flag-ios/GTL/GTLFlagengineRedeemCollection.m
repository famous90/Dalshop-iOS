/* This file was generated by the ServiceGenerator.
 * The ServiceGenerator is Copyright (c) 2014 Google Inc.
 */

//
//  GTLFlagengineRedeemCollection.m
//

// ----------------------------------------------------------------------------
// NOTE: This file is generated from Google APIs Discovery Service.
// Service:
//   flagengine/v1
// Description:
//   This is an API
// Classes:
//   GTLFlagengineRedeemCollection (0 custom class methods, 2 custom properties)

#import "GTLFlagengineRedeemCollection.h"

#import "GTLFlagengineRedeem.h"

// ----------------------------------------------------------------------------
//
//   GTLFlagengineRedeemCollection
//

@implementation GTLFlagengineRedeemCollection
@dynamic redeems, statusCode;

+ (NSDictionary *)arrayPropertyToClassMap {
  NSDictionary *map =
    [NSDictionary dictionaryWithObject:[GTLFlagengineRedeem class]
                                forKey:@"redeems"];
  return map;
}

@end
