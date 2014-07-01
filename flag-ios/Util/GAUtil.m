//
//  GAUtil.m
//  Dalshop
//
//  Created by Hwang Gyuyoung on 2014. 6. 23..
//
//

#import "GAUtil.h"

@implementation GAUtil

+ (void)sendGADataWithUIAction:(NSString *)actionName label:(NSString *)label value:(NSNumber *)value
{
    [[[GAI sharedInstance] defaultTracker] send:[[GAIDictionaryBuilder createEventWithCategory:@"ui_action" action:actionName label:label value:value] build]];
}

+ (void)sendGADataLoadTimeWithInterval:(NSTimeInterval)time actionName:(NSString *)actionName label:(NSString *)label
{
    [[[GAI sharedInstance] defaultTracker] send:[[GAIDictionaryBuilder createTimingWithCategory:@"data_load" interval:[NSNumber numberWithDouble:time] name:actionName label:label] build]];
}

+ (void)sendGADataWithCategory:(NSString *)category actionName:(NSString *)actionName label:(NSString *)label value:(NSNumber *)value
{
    [[[GAI sharedInstance] defaultTracker] send:[[GAIDictionaryBuilder createEventWithCategory:category action:actionName label:label value:value] build]];
}

@end
