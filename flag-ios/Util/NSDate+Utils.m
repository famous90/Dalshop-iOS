//
//  NSDate+Utils.m
//  flag-ios
//
//  Created by Gyuyoung Hwang on 2014. 2. 22..
//
//

#import "NSDate+Utils.h"

@implementation NSDate(Utils)

+ (NSString *)dateAtTime:(NSTimeInterval)timeInterval withFormat:(NSInteger)format
{
    NSCalendar *sysCalendar = [NSCalendar currentCalendar];
    NSDate *date = [[NSDate alloc] initWithTimeIntervalSince1970:timeInterval];
    NSDateComponents *breakDown = [sysCalendar components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit fromDate:date];
    NSInteger year = [breakDown year];
    NSInteger month = [breakDown month];
    NSInteger day = [breakDown day];
    NSString *dateString;
    
    switch (format) {
        case DATE_FORMAT_YYYYMMDD:
            dateString = [NSString stringWithFormat:@"%04ld.%02ld.%02ld", (long)year, (long)month, (long)day];
            break;
            
        default:
            dateString = nil;
            break;
    }
    
    return dateString;
}

@end

@implementation NSDate_Utils

@end
