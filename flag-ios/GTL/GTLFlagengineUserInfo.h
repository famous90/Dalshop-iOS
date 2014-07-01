/* This file was generated by the ServiceGenerator.
 * The ServiceGenerator is Copyright (c) 2014 Google Inc.
 */

//
//  GTLFlagengineUserInfo.h
//

// ----------------------------------------------------------------------------
// NOTE: This file is generated from Google APIs Discovery Service.
// Service:
//   flagengine/v1
// Description:
//   This is an API
// Classes:
//   GTLFlagengineUserInfo (0 custom class methods, 7 custom properties)

#if GTL_BUILT_AS_FRAMEWORK
  #import "GTL/GTLObject.h"
#else
  #import "GTLObject.h"
#endif

// ----------------------------------------------------------------------------
//
//   GTLFlagengineUserInfo
//

@interface GTLFlagengineUserInfo : GTLObject
@property (retain) NSNumber *birth;  // longLongValue
@property (retain) NSNumber *empty;  // boolValue
@property (retain) NSNumber *job;  // intValue
@property (copy) NSString *phone;
@property (retain) NSNumber *sex;  // intValue
@property (retain) NSNumber *userId;  // longLongValue
@property (copy) NSString *verificationCode;
@end
