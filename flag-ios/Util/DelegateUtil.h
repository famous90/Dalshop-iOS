//
//  DelegateUtil.h
//  Dalshop
//
//  Created by Hwang Gyuyoung on 2014. 6. 11..
//
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@class User;

@interface DelegateUtil : NSObject


// LOCATION
+ (CLLocation *)getCurrentLocation;


// USER
+ (User *)getUser;
+ (void)updateUserWithUser:(User *)user;


// App Base Data
+ (NSString *)getNewestVersion;
   
@end
