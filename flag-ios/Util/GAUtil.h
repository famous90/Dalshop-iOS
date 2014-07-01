//
//  GAUtil.h
//  Dalshop
//
//  Created by Hwang Gyuyoung on 2014. 6. 23..
//
//

#import <Foundation/Foundation.h>
#import "GoogleAnalytics.h"

@interface GAUtil : NSObject

+ (void)sendGADataWithUIAction:(NSString *)actionName label:(NSString *)label value:(NSNumber *)value;
+ (void)sendGADataLoadTimeWithInterval:(NSTimeInterval)time actionName:(NSString *)actionName label:(NSString *)label;
+ (void)sendGADataWithCategory:(NSString *)category actionName:(NSString *)actionName label:(NSString *)label value:(NSNumber *)value;

@end
