//
//  AppBaseDataController.m
//  Dalshop
//
//  Created by Hwang Gyuyoung on 2014. 7. 8..
//
//

#import "AppBaseDataController.h"

@implementation AppBaseDataController

- (id)init
{
    self = [super init];
    if (self) {
        self.masterData = [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (void)addObjectsWithData:(id)data
{
    NSArray *items = [data objectForKey:@"items"];
    
    for(int i=0;i<[items count];i++){
        
        id object = [items objectAtIndex:i];
        NSInteger objectId = [[object valueForKey:@"id"] integerValue];
        NSString *objectString = [object valueForKey:@"string"];
        
        if (objectId == IOS_KEY_LAUNCH_ALERT_SHOW) {
            
            BOOL isLaunchAlertShowing = [objectString boolValue];
            [self.masterData setValue:[NSNumber numberWithBool:isLaunchAlertShowing] forKey:[NSString stringWithFormat:@"%d", IOS_KEY_LAUNCH_ALERT_SHOW]];
            
        }else if (objectId == IOS_KEY_LAUNCH_ALERT_TITLE){
            
            [self.masterData setValue:objectString forKey:[NSString stringWithFormat:@"%d", IOS_KEY_LAUNCH_ALERT_TITLE]];
            
        }else if (objectId == IOS_KEY_LAUNCH_ALERT_MESSAGE){
            
            [self.masterData setValue:objectString forKey:[NSString stringWithFormat:@"%d", IOS_KEY_LAUNCH_ALERT_MESSAGE]];
            
        }else if (objectId == IOS_KEY_NEWEST_VERSION){
            
            [self.masterData setValue:objectString forKey:[NSString stringWithFormat:@"%d", IOS_KEY_NEWEST_VERSION]];
            
        }
    }
}

- (BOOL)getLaunchAlertShow
{
    BOOL isLaunchAlertShowing = [[self.masterData valueForKey:[NSString stringWithFormat:@"%d", IOS_KEY_LAUNCH_ALERT_SHOW]] boolValue];
    return isLaunchAlertShowing;
}

- (NSString *)getLaunchAlertTitle
{
    NSString *title = [self.masterData valueForKey:[NSString stringWithFormat:@"%d", IOS_KEY_LAUNCH_ALERT_TITLE]];
    return title;
}

- (NSString *)getLaunchAlertMessage
{
    NSString *message = [self.masterData valueForKey:[NSString stringWithFormat:@"%d", IOS_KEY_LAUNCH_ALERT_MESSAGE]];
    return message;
}

- (NSString *)getNewestAppVersion
{
    NSString *version = [self.masterData valueForKey:[NSString stringWithFormat:@"%d", IOS_KEY_NEWEST_VERSION]];
    return version;
}


@end
