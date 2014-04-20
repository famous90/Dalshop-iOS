//
//  GTLFlagengineGuestSession.h
//  flag-ios
//
//  Created by Gyuyoung Hwang on 2014. 4. 16..
//
//

#if GTL_BUILT_AS_FRAMEWORK
    #import "GTL/GTLObject.h"
#else
    #import "GTLObject.h"
#endif

// -------------------------------------------------
//
//  GTLFlagengineGuestSession
//

@interface GTLFlagengineGuestSession : GTLObject

@property (retain) NSNumber *identifier; // longLongValue

@property (retain) NSNumber *reward;    // intValue

@end
