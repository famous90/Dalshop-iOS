/* This file was generated by the ServiceGenerator.
 * The ServiceGenerator is Copyright (c) 2014 Google Inc.
 */

//
//  GTLFlagengineFeedbackMessage.m
//

// ----------------------------------------------------------------------------
// NOTE: This file is generated from Google APIs Discovery Service.
// Service:
//   flagengine/v1
// Description:
//   This is an API
// Classes:
//   GTLFlagengineFeedbackMessage (0 custom class methods, 5 custom properties)

#import "GTLFlagengineFeedbackMessage.h"

// ----------------------------------------------------------------------------
//
//   GTLFlagengineFeedbackMessage
//

@implementation GTLFlagengineFeedbackMessage
@dynamic createdAt, email, identifier, message, userId;

+ (NSDictionary *)propertyToJSONKeyMap {
  NSDictionary *map =
    [NSDictionary dictionaryWithObject:@"id"
                                forKey:@"identifier"];
  return map;
}

@end
