/* This file was generated by the ServiceGenerator.
 * The ServiceGenerator is Copyright (c) 2014 Google Inc.
 */

//
//  GTLFlagengineRedeem.h
//

// ----------------------------------------------------------------------------
// NOTE: This file is generated from Google APIs Discovery Service.
// Service:
//   flagengine/v1
// Description:
//   This is an API
// Classes:
//   GTLFlagengineRedeem (0 custom class methods, 6 custom properties)

#if GTL_BUILT_AS_FRAMEWORK
  #import "GTL/GTLObject.h"
#else
  #import "GTLObject.h"
#endif

// ----------------------------------------------------------------------------
//
//   GTLFlagengineRedeem
//

@interface GTLFlagengineRedeem : GTLObject

// identifier property maps to 'id' in JSON (to avoid Objective C's 'id').
@property (retain) NSNumber *identifier;  // longLongValue

@property (copy) NSString *imageUrl;
@property (copy) NSString *name;
@property (retain) NSNumber *price;  // intValue
@property (retain) NSNumber *statusCode;  // intValue
@property (copy) NSString *vendor;
@end
