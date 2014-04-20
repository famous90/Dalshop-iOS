//
//  GTLServiceFlagengine.m
//  flag-ios
//
//  Created by Gyuyoung Hwang on 2014. 4. 15..
//
//

#import "GTLFlagengine.h"

@implementation GTLServiceFlagengine

#if DEBUG
// Method compiled in debuLg builds just to check that all the needed support
// classes are present at link time.
+ (NSArray *)checkClasses {
    NSArray *classes = [NSArray arrayWithObjects:
                        [GTLQueryFlagengine class],
                        [GTLFlagengineNotice class],
                        [GTLFlagengineGuestSession class],
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
