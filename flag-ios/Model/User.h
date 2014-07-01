//
//  User.h
//  flag-ios
//
//  Created by Gyuyoung Hwang on 2014. 2. 6..
//
//

#import <Foundation/Foundation.h>

@class GTLFlagengineUser;

@interface User : NSObject

@property (nonatomic, strong) NSNumber *userId;
@property (nonatomic, strong) NSString *email;
@property (nonatomic, assign) NSInteger reward;
@property (nonatomic, assign) BOOL registered;
@property (nonatomic, assign) BOOL phoneCertificated;
@property (nonatomic, assign) BOOL additionalProfiled;

- (id)initWithData:(id)data;
- (id)initWithLoginData:(GTLFlagengineUser *)user;
- (id)initWithCoreData:(id)data;

@end
