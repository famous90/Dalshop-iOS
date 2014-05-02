/* This file was generated by the ServiceGenerator.
 * The ServiceGenerator is Copyright (c) 2014 Google Inc.
 */

//
//  GTLFlagengineProvider.h
//

// ----------------------------------------------------------------------------
// NOTE: This file is generated from Google APIs Discovery Service.
// Service:
//   flagengine/v1
// Description:
//   This is an API
// Classes:
//   GTLFlagengineProvider (0 custom class methods, 4 custom properties)

#if GTL_BUILT_AS_FRAMEWORK
  #import "GTL/GTLObject.h"
#else
  #import "GTLObject.h"
#endif

// ----------------------------------------------------------------------------
//
//   GTLFlagengineProvider
//

@interface GTLFlagengineProvider : GTLObject
@property (retain) NSNumber *balance;  // intValue
@property (copy) NSString *email;

// identifier property maps to 'id' in JSON (to avoid Objective C's 'id').
@property (retain) NSNumber *identifier;  // longLongValue

@property (copy) NSString *password;
@end