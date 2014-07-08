//
//  AppDelegate.h
//  flag-ios
//
//  Created by Gyuyoung Hwang on 2014. 2. 3..
//
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <CoreBluetooth/CoreBluetooth.h>

#import "TransitionDelegate.h"

@class User;
@class AppBaseDataController;

@interface AppDelegate : UIResponder <UIApplicationDelegate, UIAlertViewDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, strong) CLLocation *savedLocation;
@property (nonatomic, strong) User *user;
@property (nonatomic, strong) UIViewController *presentingViewController;
@property (nonatomic, strong) TransitionDelegate *transitionDelegate;
@property (nonatomic, strong) AppBaseDataController *appBaseData;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@end
