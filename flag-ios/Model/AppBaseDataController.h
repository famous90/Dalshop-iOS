//
//  AppBaseDataController.h
//  Dalshop
//
//  Created by Hwang Gyuyoung on 2014. 7. 8..
//
//

#import <Foundation/Foundation.h>

@interface AppBaseDataController : NSObject

@property (nonatomic, strong) NSMutableDictionary *masterData;

- (id)init;
- (void)addObjectsWithData:(id)data;

- (BOOL)getLaunchAlertShow;
- (NSString *)getLaunchAlertTitle;
- (NSString *)getLaunchAlertMessage;
- (NSString *)getNewestAppVersion;

@end
