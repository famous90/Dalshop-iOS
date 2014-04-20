//
//  User.h
//  flag-ios
//
//  Created by Gyuyoung Hwang on 2014. 2. 6..
//
//

#import <Foundation/Foundation.h>

@interface User : NSObject

@property (nonatomic, strong) NSNumber *userId;
@property (nonatomic, strong) NSString *email;
@property (nonatomic, assign) NSInteger reward;
@property (nonatomic, assign) BOOL registered;

- (id)initWithData:(id)data;
- (id)initWithCoreData:(id)data;

@end
