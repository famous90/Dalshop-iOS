/* This file was generated by the ServiceGenerator.
 * The ServiceGenerator is Copyright (c) 2014 Google Inc.
 */

//
//  GTLFlagengineUserForm.m
//

// ----------------------------------------------------------------------------
// NOTE: This file is generated from Google APIs Discovery Service.
// Service:
//   flagengine/v1
// Description:
//   This is an API
// Classes:
//   GTLFlagengineUserForm (0 custom class methods, 4 custom properties)

#import "GTLFlagengineUserForm.h"

// ----------------------------------------------------------------------------
//
//   GTLFlagengineUserForm
//

@implementation GTLFlagengineUserForm
@dynamic email, identifier, password, statusCode;

+ (NSDictionary *)propertyToJSONKeyMap {
  NSDictionary *map =
    [NSDictionary dictionaryWithObject:@"id"
                                forKey:@"identifier"];
  return map;
}

@end
