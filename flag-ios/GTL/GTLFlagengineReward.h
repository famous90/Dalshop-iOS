/* This file was generated by the ServiceGenerator.
 * The ServiceGenerator is Copyright (c) 2014 Google Inc.
 */

//
//  GTLFlagengineReward.h
//

// ----------------------------------------------------------------------------
// NOTE: This file is generated from Google APIs Discovery Service.
// Service:
//   flagengine/v1
// Description:
//   This is an API
// Classes:
//   GTLFlagengineReward (0 custom class methods, 8 custom properties)

#if GTL_BUILT_AS_FRAMEWORK
  #import "GTL/GTLObject.h"
#else
  #import "GTLObject.h"
#endif

// ----------------------------------------------------------------------------
//
//   GTLFlagengineReward
//

@interface GTLFlagengineReward : GTLObject
@property (retain) NSNumber *createdAt;  // longLongValue

// identifier property maps to 'id' in JSON (to avoid Objective C's 'id').
@property (copy) NSString *identifier;

@property (retain) NSNumber *reward;  // intValue
@property (retain) NSNumber *statusCode;  // intValue
@property (retain) NSNumber *targetId;  // longLongValue
@property (copy) NSString *targetName;
@property (retain) NSNumber *type;  // intValue
@property (retain) NSNumber *userId;  // longLongValue
@end
