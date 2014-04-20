//
//  AppDelegate.m
//  flag-ios
//
//  Created by Gyuyoung Hwang on 2014. 2. 3..
//
//

#import "AppDelegate.h"
#import "FlagViewController.h"
#import "SWRevealViewController.h"
#import <GoogleMaps/GoogleMaps.h>

#import "User.h"
#import "BeaconDataController.h"
#import "Beacon.h"
#import "URLParameters.h"

#import "ViewUtil.h"
#import "MapUtil.h"

#import "FlagClient.h"
#import "GTLFlagengine.h"

/******* Set your tracking ID here *******/
static NSString *const kGaTrackingId = @"UA-45882688-3";
static NSString *const kTrackingPreferenceKey = @"allowTracking";
static BOOL const kGaDryRun = YES;
static int const kGaDispatchPeriod = 30;

@interface AppDelegate ()<CLLocationManagerDelegate>

- (void)initializeGoogleAnalytics;
- (void)initializeBeaconDetector;

@end

@implementation AppDelegate{
    CLLocationManager *locationManager;
    CLLocation *savedLocation;
    
    CLBeaconRegion *beaconRegion;
    BeaconDataController *beaconDataWithGPS;
    BeaconDataController *beaconData;
}

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Beacon Detect
    [self initializeBeaconDetector];
    

    // NAV BAR
    [[UINavigationBar appearance] setBarTintColor:UIColorFromRGB(0xffffff)];
    [[UINavigationBar appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:UIColorFromRGB(BASE_COLOR), NSForegroundColorAttributeName, [UIFont fontWithName:@"Helvetica_Bold" size:18], NSFontAttributeName, nil]];

    
    // Google Map
    [GMSServices provideAPIKey:@"AIzaSyCOrp3cZWnafY1RGJHcIR_qY7BScyUxwds"];
    
    
    // Google Analytics
    [self initializeGoogleAnalytics];
    
    
    // Check detect app launching for the first time
    [self checkUserSession];
    
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    NSLog(@"resign active");
    
//    [locationManager stopMonitoringSignificantLocationChanges];
//    [locationManager startUpdatingLocation];
    [self startMonitoringBeaconInBackground];
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    NSLog(@"background");
    
//    [locationManager startMonitoringSignificantLocationChanges];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    NSLog(@"foreground");
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    NSLog(@"become active");
    
    [GAI sharedInstance].optOut = ![[NSUserDefaults standardUserDefaults] boolForKey:kTrackingPreferenceKey];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    NSLog(@"terminate");
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}

#pragma mark -
#pragma mark server connection

//- (void)setUserWithJsonData:(NSDictionary *)results
//{
//    User *user = [[User alloc] initWithData:results];
//    
//    NSManagedObjectContext *context = [self managedObjectContext];
//    
//    NSManagedObject *guestUser;
//    guestUser = [NSEntityDescription insertNewObjectForEntityForName:@"UserInfo" inManagedObjectContext:context];
//    [guestUser setValue:user.userId forKeyPath:@"userId"];
//    [guestUser setValue:@"" forKeyPath:@"email"];
//    [guestUser setValue:[NSNumber numberWithBool:NO] forKeyPath:@"registered"];
//    
//    NSError *error;
//    [context save:&error];
//}

#pragma mark -
#pragma mark Core Data stack
- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

// Returns the managed object context for the application.
// If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _managedObjectContext;
}

// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"flag_ios" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it.
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"flag_ios.sqlite"];
    
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
         
         Typical reasons for an error here include:
         * The persistent store is not accessible;
         * The schema for the persistent store is incompatible with current managed object model.
         Check the error message to determine what the actual problem was.
         
         
         If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
         
         If you encounter schema incompatibility errors during development, you can reduce their frequency by:
         * Simply deleting the existing store:
         [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
         
         * Performing automatic lightweight migration by passing the following dictionary as the options parameter:
         @{NSMigratePersistentStoresAutomaticallyOption:@YES, NSInferMappingModelAutomaticallyOption:@YES}
         
         Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
         
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }    
    
    return _persistentStoreCoordinator;
}


#pragma mark - Check Guest Session
- (void)checkUserSession
{
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"haveLaunched"]) {
        
        UIAlertView *alert = [[UIAlertView alloc ]initWithTitle:@"show" message:@"not first launch" delegate:nil cancelButtonTitle:@"okay" otherButtonTitles:nil, nil];
        [alert show];
        
        [self getUserInfoFromCoreData];

    }else{

        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"haveLaunched"];
        [[NSUserDefaults standardUserDefaults] synchronize];

        UIAlertView *alert = [[UIAlertView alloc ]initWithTitle:@"show" message:@"first launch" delegate:nil cancelButtonTitle:@"okay" otherButtonTitles:nil, nil];
        [alert show];

        [self getGuestSession];

    }
}

- (void)getGuestSession
{
    GTLServiceFlagengine *service = [FlagClient flagengineService];
    
    GTLQueryFlagengine *query = [GTLQueryFlagengine queryForUserGuestSession];
    
    NSLog(@"start execute");
    [service executeQuery:query completionHandler:^(GTLServiceTicket *ticket, GTLFlagengineGuestSession *object, NSError *error){
        NSLog(@"result object \n %@", object);
        
        User *user = [[User alloc] init];
        user.userId = [object identifier];
        user.reward = [[object reward] integerValue];
        
        [self saveGuestSessionInCoreData:user];
        [self initializeRootViewControllerWithUser:user];
    }];
}

- (void)saveGuestSessionInCoreData:(User *)theUser
{
    NSManagedObjectContext *context = [self managedObjectContext];
    
    NSManagedObject *object = [NSEntityDescription insertNewObjectForEntityForName:@"UserInfo" inManagedObjectContext:context];
    [object setValue:theUser.userId forKey:@"userId"];
    [object setValue:NO forKey:@"registered"];
    
    NSError *error;
    [context save:&error];
}

- (void)getUserInfoFromCoreData
{
    NSManagedObjectContext *context = [self managedObjectContext];
    
    NSEntityDescription *entityDesc = [NSEntityDescription entityForName:@"UserInfo" inManagedObjectContext:context];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDesc];
    
    NSMutableArray *userInfoCoreData = [[context executeFetchRequest:request error:nil] mutableCopy];
    
    // user data loaded
    if ([userInfoCoreData count]) {
        NSManagedObject *userInfo = [userInfoCoreData objectAtIndex:0];
        
        User *user = [[User alloc] initWithCoreData:userInfo];
        [self initializeRootViewControllerWithUser:user];
        
    }else{
        [self getGuestSession];
    }
}

- (void)initializeRootViewControllerWithUser:(User *)theUser
{
    UIStoryboard *storyboard = [ViewUtil getStoryboard];
    SWRevealViewController *rootViewController = (SWRevealViewController *)[storyboard instantiateViewControllerWithIdentifier:@"RevealView"];
    rootViewController.user = theUser;
    [self.window setRootViewController:rootViewController];
}


#pragma mark -
#pragma mark Google Analytics

- (void)initializeGoogleAnalytics
{
    [[GAI sharedInstance] setDispatchInterval:kGaDispatchPeriod];
    [[GAI sharedInstance] setDryRun:kGaDryRun];
    [[GAI sharedInstance] setTrackUncaughtExceptions:YES];
    self.tracker = [[GAI sharedInstance] trackerWithTrackingId:kGaTrackingId];
    self.timeCriteria = [NSDate date];
}

#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

#pragma mark - beacon data load
- (void)getBeaconListAfterLastUpdateTime:(NSTimeInterval)time
{
    NSString *url = BASE_URL;
    NSString *methodName = @"lastUpdateTime";
    
    url = [NSString stringWithFormat:@"%@/%@?time=%@", url, methodName, [NSString stringWithFormat:@"%.0f", time*1000]];
    
    NSData *jsonDataString = [[NSString stringWithContentsOfURL:[NSURL URLWithString:url] encoding:NSUTF8StringEncoding error:Nil] dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error = nil;
    NSDictionary *results = [NSJSONSerialization JSONObjectWithData:jsonDataString options:NSJSONReadingMutableContainers error:&error];
    NSLog(@"data response result : %@", results);
    
    NSArray *beacons = [results objectForKey:@"beacons"];
    NSArray *deletedBeacons = [results objectForKey:@"deletedBeacons"];
    
    if ([beacons count]) {
        
        BeaconDataController *newBeaconData = [[BeaconDataController alloc] init];
        
        for(NSDictionary *object in beacons){
            Beacon *theBeacon = [[Beacon alloc] initWithData:object];
            [newBeaconData addObjectWithObject:theBeacon];
        }
        
        [self addBeaconsInCoredataWithBeacons:newBeaconData];
    }
    
    if ([deletedBeacons count]) {
        
        NSMutableArray *deletedBeaconData = [[NSMutableArray alloc] init];
        
        for(NSDictionary *object in deletedBeacons){
            NSNumber *deletedBeaconId = [object valueForKey:@"beaconId"];
            [deletedBeaconData addObject:deletedBeaconId];
        }
        
        [self deleteBeaconsIdCoredataWithBeaconIds:deletedBeaconData];
    }
}

- (void)addBeaconsInCoredataWithBeacons:(BeaconDataController *)beacons
{
    // add to coredata
    NSManagedObjectContext *context = [self managedObjectContext];
    
    for(Beacon *beacon in beacons.masterData){
        
        NSManagedObject *newBeacon;
        newBeacon = [NSEntityDescription insertNewObjectForEntityForName:@"BeaconList" inManagedObjectContext:context];
        [newBeacon setValue:beacon.beaconId forKey:@"beaconId"];
        [newBeacon setValue:beacon.shopId forKey:@"shopId"];
        [newBeacon setValue:beacon.shopName forKey:@"shopName"];
        [newBeacon setValue:beacon.latitude forKey:@"latitude"];
        [newBeacon setValue:beacon.longitude forKey:@"longitude"];
        [newBeacon setValue:beacon.lastScanTime forKeyPath:@"lastScanTime"];
        
    }
    
    NSError *error;
    [context save:&error];
    NSLog(@"Beacon Saved");
}

- (void)deleteBeaconsIdCoredataWithBeaconIds:(NSMutableArray *)beaconIds
{
    // delete in coredata
    NSManagedObjectContext *context = [self managedObjectContext];
    
    NSEntityDescription *entityDesc = [NSEntityDescription entityForName:@"BeaconList" inManagedObjectContext:context];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDesc];
    
    NSMutableArray *pred = [NSMutableArray array];
    for(NSString *beaconId in beaconIds){
        [pred addObject:[NSPredicate predicateWithFormat:@"beaconId LIKE[c] %@", beaconId]];
    }
    NSPredicate *compoundPred = [NSCompoundPredicate andPredicateWithSubpredicates:pred];
    [request setPredicate:compoundPred];
    
    NSError *error;
    NSArray *objects = [context executeFetchRequest:request error:&error];
    
    for(NSManagedObject *object in objects){
        [context deleteObject:object];
    }
}

- (BeaconDataController *)getBeaconListAtLocation:(CLLocation *)location
{
    NSManagedObjectContext *context = [self managedObjectContext];
    double locationLatitude = location.coordinate.latitude;
    double locationLongitude = location.coordinate.longitude;
    
    NSEntityDescription *entityDesc = [NSEntityDescription entityForName:@"BeaconList" inManagedObjectContext:context];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDesc];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(%f <= latitude) AND (latitude <= %f) AND (%f <= longitude) AND (longitude <= %f)", (locationLatitude - BEACON_DETECT_RADIUS_GEODETIC), (locationLatitude + BEACON_DETECT_RADIUS_GEODETIC), (locationLongitude - BEACON_DETECT_RADIUS_GEODETIC), (locationLongitude + BEACON_DETECT_RADIUS_GEODETIC)];
    [request setPredicate:predicate];
    
    NSError *error;
    NSArray *objects = [context executeFetchRequest:request error:&error];
    BeaconDataController *beaconDataController = [[BeaconDataController alloc] init];
    
    for(NSManagedObject *object in objects){
        Beacon *theBeacon = [[Beacon alloc] initWithManagedObject:object];
        [beaconDataController addObjectWithObject:theBeacon];
    }
    
    return beaconDataController;
}

#pragma mark - beacon detect method

- (void)initializeBeaconCoreDataForTest
{
    BeaconDataController *beaconList = [[BeaconDataController alloc] init];
    [beaconList initForTest];
    
    NSManagedObjectContext *context = [self managedObjectContext];
    
    for(Beacon *beacon in beaconList.masterData){
        
        NSManagedObject *newBeacon;
        newBeacon = [NSEntityDescription insertNewObjectForEntityForName:@"BeaconList" inManagedObjectContext:context];
        [newBeacon setValue:beacon.beaconId forKey:@"beaconId"];
        [newBeacon setValue:beacon.shopId forKey:@"shopId"];
        [newBeacon setValue:beacon.shopName forKey:@"shopName"];
        [newBeacon setValue:beacon.latitude forKey:@"latitude"];
        [newBeacon setValue:beacon.longitude forKey:@"longitude"];
        [newBeacon setValue:beacon.lastScanTime forKeyPath:@"lastScanTime"];
        
    }
    
    NSError *error;
    [context save:&error];
    NSLog(@"Beacon Saved");
}

- (void)initializeBeaconDetector{
    
//    [self initializeBeaconCoreDataForTest];
    
    // initalize location manager
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;

    [locationManager startUpdatingLocation];
}

- (void)startBeaconDetectNearby
{
    // scan start
    for(Beacon *theBeacon in beaconData.masterData){
        
        NSLog(@"start to detect beacon %@ last detected time is %@", theBeacon.beaconId, theBeacon.lastScanTime);
        beaconRegion = [[CLBeaconRegion alloc] initWithProximityUUID:[[NSUUID alloc] initWithUUIDString:theBeacon.beaconId] identifier:theBeacon.shopName];
        beaconRegion.notifyEntryStateOnDisplay = YES;
        
        [locationManager startRangingBeaconsInRegion:beaconRegion];
    }
}

- (void)startMonitoringBeaconInBackground
{
    //Check if our iOS version supports multitasking I.E iOS 4
    if ([[UIDevice currentDevice] respondsToSelector:@selector(isMultitaskingSupported)]) {
        
        //Check if device supports mulitasking
        if ([[UIDevice currentDevice] isMultitaskingSupported]) {
            
            //Get the shared application instance
            UIApplication *application = [UIApplication sharedApplication];
            
            //Create a task object
            __block UIBackgroundTaskIdentifier background_task;
            
            background_task = [application beginBackgroundTaskWithExpirationHandler: ^ {
                
                //Tell the system that we are done with the tasks
                [application endBackgroundTask: background_task];
                
                //Set the task to be invalid
                background_task = UIBackgroundTaskInvalid;
                
                //System will be shutting down the app at any point in time now
            }];
            
            //Background tasks require you to use asyncrous tasks
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                
                //Perform your tasks that your application requires
                NSLog(@"\n\nRunning in the background!\n\n");
                
//                [self initializeBeaconDetector];
//                beaconRegion = [[CLBeaconRegion alloc] initWithProximityUUID:[[NSUUID alloc] initWithUUIDString:@"696818FB-86BC-4CCE-9155-010F50D2458D"] identifier: @"Hello"];
//                beaconRegion.notifyEntryStateOnDisplay = YES;
//                [_locationManager startMonitoringForRegion:beaconRegion];
//                [_locationManager stopRangingBeaconsInRegion:beaconRegion];
//                locationManager = [[CLLocationManager alloc] init];
//                locationManager.delegate = self;
//                locationManager.desiredAccuracy = kCLLocationAccuracyBest;
//                [locationManager startRangingBeaconsInRegion:beaconRegion];
//                [locationManager startUpdatingLocation];
                
//                [application endBackgroundTask: background_task]; //End the task so the system knows that you are done with what you need to perform
//                background_task = UIBackgroundTaskInvalid; //Invalidate the background_task
                
            });
        }
    }

}

#pragma mark - location manager

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"fail to update location with error %@", [error localizedDescription]);
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    NSLog(@"found location");
    CLLocation *currentLocation = [locations lastObject];
    
    if (!savedLocation) {
        savedLocation = [[CLLocation alloc] initWithLatitude:0 longitude:0];
    }
    
    if ([MapUtil currentLocation:currentLocation getOutOfPreviousLocation:savedLocation withBoundRadius:BEACON_DETECT_RADIUS_DISTANCE]) {
        
        NSLog(@"location updated");
        
        savedLocation = currentLocation;
        
        // set beacon data controller
        beaconData = [[BeaconDataController alloc] init];
        [beaconData removeAllData];
        beaconDataWithGPS = [self getBeaconListAtLocation:currentLocation];
        [beaconData addMasterDataWithArray:[beaconDataWithGPS scannableBeaconList]];
        
        [self startBeaconDetectNearby];
    }
}

- (void)locationManager:(CLLocationManager *)manager didDetermineState:(CLRegionState)state forRegion:(CLRegion *)region
{
    if (state == CLRegionStateInside) {
        NSLog(@"location manager did determine state INSIDE for %@", region.identifier);
    }else if (state == CLRegionStateOutside){
        NSLog(@"location manager did determine state OUTSIDE for %@", region.identifier);
    }else{
        NSLog(@"location manager did determine state OTHER for %@", region.identifier);
    }
}

- (void)locationManager:(CLLocationManager *)manager didRangeBeacons:(NSArray *)beacons inRegion:(CLBeaconRegion *)region
{
    NSLog(@"did range beacon");
    
    if ([beacons count]) {
        
        NSLog(@"found something");
        
        [locationManager stopUpdatingLocation];
        
        for(CLBeacon *beacon in beacons){
            
            NSLog(@"find beacon %@ rssi %ld, accuracy %f", beacon, (long)beacon.rssi, beacon.accuracy);
            
            Beacon *foundBeacon = [beaconData didScanBeaconWithBeaconId:beacon.proximityUUID.UUIDString];
            
            if (foundBeacon) {
                
                UILocalNotification *localNotification = [[UILocalNotification alloc] init];
                if (localNotification) {
                    localNotification.fireDate = [[NSDate date] dateByAddingTimeInterval:.3];
                    localNotification.timeZone = [NSTimeZone defaultTimeZone];
                    localNotification.repeatInterval = 0;
                    localNotification.alertBody = [NSString stringWithFormat:@"find beacon %@ r %ld t,a %f", foundBeacon.shopName, (long) beacon.rssi, beacon.accuracy];
                    [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
                }
            }
        }
        
        [locationManager stopRangingBeaconsInRegion:region];
        [locationManager startUpdatingLocation];
    }
    
    // Stop beacon detect
    // Reset beacon data
    // Restart beacon detect
//    [locationManager stopRangingBeaconsInRegion:region];
//    [self startBeaconDetectNearby];
}

#pragma mark - local notification
- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
    UIApplicationState state = [application applicationState];
    
    if (state == UIApplicationStateActive) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Beacon Detected" message:notification.alertBody delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        
    }else if (state == UIApplicationStateBackground){
        
        NSLog(@"beacon detected in background");
        
    }else if (state == UIApplicationStateInactive){
        
        NSLog(@"beacon detected in inactive");
        
    }
}

@end
