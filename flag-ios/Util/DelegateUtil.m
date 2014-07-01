//
//  DelegateUtil.m
//  Dalshop
//
//  Created by Hwang Gyuyoung on 2014. 6. 11..
//
//

#import "DelegateUtil.h"

#import "AppDelegate.h"

#import "User.h"

@implementation DelegateUtil

+ (AppDelegate *)getAppDelegate
{
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    return delegate;
}


// LOCATION
+ (CLLocation *)getCurrentLocation
{
    AppDelegate *delegate = [self getAppDelegate];
    CLLocation *currentLocation = delegate.savedLocation;
    
    if (!currentLocation) {
        currentLocation = [[CLLocation alloc] initWithLatitude:BASE_LATITUDE longitude:BASE_LONGITUDE];
    }

    return currentLocation;
}


// USER
+ (User *)getUser
{
    AppDelegate *delegate = [self getAppDelegate];
    User *theUser = delegate.user;
    return theUser;
}

+ (void)updateUserWithUser:(User *)user
{
    AppDelegate *delegate = [self getAppDelegate];
    [delegate setUser:user];
}


@end
