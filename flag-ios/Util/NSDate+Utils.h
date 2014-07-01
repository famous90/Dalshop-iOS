//
//  NSDate+Utils.h
//  flag-ios
//
//  Created by Gyuyoung Hwang on 2014. 2. 22..
//
//

#import <Foundation/Foundation.h>

@interface NSDate(Utils)

+ (NSString *)dateAtTime:(NSTimeInterval)timeInterval withFormat:(NSInteger)format;
+ (NSTimeInterval)generateTimeIntervalFromYear:(NSInteger)year;
+ (NSInteger)breakDownTimeInterval:(NSTimeInterval)time toCalendarComponent:(NSCalendarUnit)calendarUnit;

@end

@interface NSDate_Utils : NSObject

@end
