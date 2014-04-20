//
//  AppDelegate.h
//  flag-ios
//
//  Created by Gyuyoung Hwang on 2014. 2. 3..
//
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

#import "GAI.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) id<GAITracker> tracker;
@property (strong, nonatomic) NSDate *timeCriteria;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@end
