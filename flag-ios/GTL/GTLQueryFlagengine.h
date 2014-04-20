//
//  GTLQueryFlagengine.h
//  flag-ios
//
//  Created by Gyuyoung Hwang on 2014. 4. 15..
//
//

#if GTL_BUILT_AS_FRAMEWORK
#import "GTL/GTLQuery.h"
#else
#import "GTLQuery.h"
#endif

@class GTLFlagengineNotice;
@class GTLFlagengineGuestSession;

@interface GTLQueryFlagengine : GTLQuery

//
// Parameters valid on all methods.
//

// Selector specifying which fields to include in a partial response.
@property (copy) NSString *fields;

//
// Method-specific parameters; see the comments below for more information.
//
@property (copy) NSString *beaconId;
// Remapped to 'descriptionProperty' to avoid NSObject's 'description'.
@property (copy) NSString *descriptionProperty;
@property (assign) long long flagId;
// identifier property maps to 'id' in JSON (to avoid Objective C's 'id').
@property (assign) long long identifier;
@property (retain) NSArray *ids;  // of NSNumber (longLongValue)
@property (copy) NSString *imageUrl;
@property (assign) long long itemId;
@property (assign) double lat;
@property (copy) NSString *logoUrl;
@property (assign) double lon;
@property (copy) NSString *name;
@property (assign) long long parentId;
@property (assign) NSInteger reward;
@property (assign) BOOL rewarded;
@property (assign) long long rewardedForUser;
@property (assign) long long shopId;
@property (assign) NSInteger type;
@property (assign) long long userId;

#pragma mark -
#pragma mark "apps.notices" methods
// These create a GTLQueryFlagengine object.

// Method: flagengine.apps.notices.get
//  Authorization scope(s):
//   kGTLAuthScopeFlagengineUserinfoEmail
// Fetches a GTLFlagengineNotice.
+ (id)queryForAppsNoticesGet;

// Method: flagengine.apps.notices.insert
//  Authorization scope(s):
//   kGTLAuthScopeFlagengineUserinfoEmail
// Fetches a GTLFlagengineNotice.
+ (id)queryForAppsNoticesInsertWithObject:(GTLFlagengineNotice *)object;

#pragma mark -
#pragma mark "users.guest" methods
// These create a GTLQueryFlagengine object.

// Method: flagengine.users.guest
//  Authorization scope(s):
//   kGTLAuthScopeFlagengineUserinfoEmail
// Fetches a GTLFlagengineGuestSession.
+ (id)queryForUserGuestSession;

@end
