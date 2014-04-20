//
//  GTLFlagengineConstants.h
//  flag-ios
//
//  Created by Gyuyoung Hwang on 2014. 4. 15..
//
//

#import <Foundation/Foundation.h>

#if GTL_BUILT_AS_FRAMEWORK
#import "GTL/GTLDefines.h"
#else
#import "GTLDefines.h"
#endif

// Authorization scope
// View your email address
GTL_EXTERN NSString * const kGTLAuthScopeFlagengineUserinfoEmail;  // "https://www.googleapis.com/auth/userinfo.email"
