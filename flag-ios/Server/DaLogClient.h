//
//  DaLogClient.h
//  Dalshop
//
//  Created by Hwang Gyuyoung on 2014. 7. 10..
//
//

#import <Foundation/Foundation.h>

@interface DaLogClient : NSObject

+ (void)sendDaLogWithCategory:(NSInteger)category target:(NSInteger)target value:(NSInteger)value;

@end
