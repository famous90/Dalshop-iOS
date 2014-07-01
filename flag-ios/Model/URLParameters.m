//
//  URLParameters.m
//  flag-ios
//
//  Created by Gyuyoung Hwang on 2014. 4. 7..
//
//

#import "URLParameters.h"

@implementation URLParameters

- (id)init
{
    self = [super init];
    if (self) {
        self.parameters = [[NSMutableArray alloc] init];
    }
    return self;
}

- (NSString *)getMethodName
{
    return self.methodName;
}

- (void)setMethodName:(NSString *)methodName
{
    _methodName = methodName;
}

- (void)addParameterWithKey:(NSString *)key withParameter:(id)param
{
    NSDictionary *paramDictionary = [[NSDictionary alloc] initWithObjectsAndKeys:key, @"keyName", param, @"parameter", nil];
    [self.parameters addObject:paramDictionary];
}

- (void)addParameterWithUserId:(NSNumber *)userId
{
    [self addParameterWithKey:@"userId" withParameter:[userId stringValue]];
}

- (NSString *)keyNameAtIndex:(NSInteger)index
{
    NSDictionary *paramDictionary = [self.parameters objectAtIndex:index];
    return [paramDictionary valueForKey:@"keyName"];
}

- (id)parameterAtIndex:(NSInteger)index
{
    NSDictionary *paramDictionary = [self.parameters objectAtIndex:index];
    return [paramDictionary valueForKey:@"parameter"];
}

- (NSURL *)getURLForRequest
{
    NSString *url = BASE_URL;
    
    url = [url stringByAppendingFormat:@"/%@", self.methodName];
    
    if ([self.parameters count] > 0) {
        
        url = [url stringByAppendingString:@"?"];
        
        for (int i=0; i<[self.parameters count]; i++) {
            if (i != 0) {
                url = [url stringByAppendingString:@"&"];
            }
            url = [url stringByAppendingFormat:@"%@=%@", [self keyNameAtIndex:i], [self parameterAtIndex:i]];
        }
    }
    
    return [NSURL URLWithString:url];
}

@end
