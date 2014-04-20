//
//  URLParameters.h
//  flag-ios
//
//  Created by Gyuyoung Hwang on 2014. 4. 7..
//
//

#import <Foundation/Foundation.h>

@interface URLParameters : NSObject

@property (nonatomic, strong) NSString *methodName;
@property (nonatomic, strong) NSMutableArray *parameters;

- (id)init;

- (void)setMethodName:(NSString *)methodName;
- (void)addParameterWithKey:(NSString *)key withParameter:(id)param;
- (void)addParameterWithUserId:(NSNumber *)userId;

- (NSString *)keyNameAtIndex:(NSInteger)index;
- (id)parameterAtIndex:(NSInteger)index;

- (NSURL *)getURLForRequest;

@end
