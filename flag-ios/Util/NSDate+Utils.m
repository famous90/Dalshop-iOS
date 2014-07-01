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

+ (NSTimeInterval)generateTimeIntervalFromYear:(NSInteger)year
{
    NSDate *now = [NSDate date];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *componets = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:now];
    [componets setYear:year];
    
    NSDate *date = [calendar dateFromComponents:componets];
    NSTimeInterval yearTimeInterval = [date timeIntervalSince1970];
    
    return yearTimeInterval;
}

+ (NSInteger)breakDownTimeInterval:(NSTimeInterval)time toCalendarComponent:(NSCalendarUnit)calendarUnit
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDate *date = [[NSDate alloc] initWithTimeIntervalSince1970:time];
    NSDateComponents *component = [calendar components:calendarUnit fromDate:date];
    NSInteger value = 0;
    
    switch (calendarUnit) {
        case NSMinuteCalendarUnit:{
            value = [component minute];
            break;
        }
        case NSHourCalendarUnit:{
            value = [component hour];
            break;
        }
        case NSDayCalendarUnit:{
            value = [component day];
            break;
        }
        case NSWeekCalendarUnit:{
            value = [component weekday];
            break;
        }
        case NSMonthCalendarUnit:{
            value = [component month];
            break;
        }
        case NSYearCalendarUnit:{
            value = [component year];
            break;
        }
            
        default:{
            break;
        }
    }
    
    return value;
}

@end

@implementation NSDate_Utils

@end
