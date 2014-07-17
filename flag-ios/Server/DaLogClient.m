//
//  DaLogClient.m
//  Dalshop
//
//  Created by Hwang Gyuyoung on 2014. 7. 10..
//
//

#import "DaLogClient.h"

#import "URLParameters.h"
#import "User.h"

#import "FlagClient.h"
#import "GTLFlagengine.h"

@implementation DaLogClient

+ (void)sendDaLogWithCategory:(NSInteger)category target:(NSInteger)target value:(NSInteger)value
{
    NSDate *date = [NSDate date];
    NSTimeInterval now = [date timeIntervalSince1970];
    long timeStamp = now * 1000;
    
    User *user = [DelegateUtil getUser];
    
    GTLServiceFlagengine *service = [FlagClient flagengineService];
    GTLFlagengineLog *daLog = [GTLFlagengineLog alloc];
    [daLog setSubject:user.userId];
    [daLog setCategory:[NSNumber numberWithInteger:category]];
    [daLog setTarget:[NSNumber numberWithInteger:target]];
    [daLog setCreatedAt:[NSNumber numberWithLong:timeStamp]];
    [daLog setValue:[NSNumber numberWithInteger:value]];
    
    GTLQueryFlagengine *query = [GTLQueryFlagengine queryForLogsInsertWithObject:daLog];
    [service executeQuery:query completionHandler:^(GTLServiceTicket *ticket, GTLFlagengineLog *resultLog, NSError *error){
        
        if (error == nil) {
            if ([resultLog.statusCode integerValue] == HTTP_STATUS_OK) {
                
            }
        }
    }];
}

@end
