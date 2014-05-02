/* This file was generated by the ServiceGenerator.
 * The ServiceGenerator is Copyright (c) 2014 Google Inc.
 */

//
//  GTLServiceFlagengine.m
//

// ----------------------------------------------------------------------------
// NOTE: This file is generated from Google APIs Discovery Service.
// Service:
//   flagengine/v1
// Description:
//   This is an API
// Classes:
//   GTLServiceFlagengine (0 custom class methods, 0 custom properties)

#import "GTLFlagengine.h"

@implementation GTLServiceFlagengine

#if DEBUG
// Method compiled in debug builds just to check that all the needed support
// classes are present at link time.
+ (NSArray *)checkClasses {
  NSArray *classes = [NSArray arrayWithObjects:
                      [GTLQueryFlagengine class],
                      [GTLFlagengineBeacon class],
                      [GTLFlagengineBeaconCollection class],
                      [GTLFlagengineBranchItemMatcher class],
                      [GTLFlagengineFeedbackMessage class],
                      [GTLFlagengineFlag class],
                      [GTLFlagengineFlagCollection class],
                      [GTLFlagengineItem class],
                      [GTLFlagengineItemCollection class],
                      [GTLFlagengineLike class],
                      [GTLFlagengineNotice class],
                      [GTLFlagengineProvider class],
                      [GTLFlagengineProviderForm class],
                      [GTLFlagengineRetainForm class],
                      [GTLFlagengineReward class],
                      [GTLFlagengineRewardCollection class],
                      [GTLFlagengineShop class],
                      [GTLFlagengineShopCollection class],
                      [GTLFlagengineUploadUrl class],
                      [GTLFlagengineUser class],
                      [GTLFlagengineUserForm class],
                      [GTLFlagengineVersion class],
                      nil];
  return classes;
}
#endif  // DEBUG

- (id)init {
  self = [super init];
  if (self) {
    // Version from discovery.
    self.apiVersion = @"v1";

    // From discovery.  Where to send JSON-RPC.
    // Turn off prettyPrint for this service to save bandwidth (especially on
    // mobile). The fetcher logging will pretty print.
    self.rpcURL = [NSURL URLWithString:@"https://genuine-evening-455.appspot.com/_ah/api/rpc?prettyPrint=false"];
  }
  return self;
}

@end
