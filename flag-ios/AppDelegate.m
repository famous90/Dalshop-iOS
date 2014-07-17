//
//  AppDelegate.m
//  flag-ios
//
//  Created by Gyuyoung Hwang on 2014. 2. 3..
//
//

#import <GoogleMaps/GoogleMaps.h>
#import <KakaoOpenSDK/KakaoOpenSDK.h>

#import "AppDelegate.h"
#import "FlagViewController.h"
#import "SWRevealViewController.h"

#import "User.h"
#import "Shop.h"
#import "Flag.h"
#import "FlagDataController.h"
#import "BeaconDataController.h"
#import "Beacon.h"
#import "URLParameters.h"
#import "AppBaseDataController.h"

#import "Util.h"
#import "ViewUtil.h"
#import "MapUtil.h"
#import "DataUtil.h"
#import "BeaconUtil.h"
#import "UIDevice-Reachability.h"

#import "FlagClient.h"
#import "GTLFlagengine.h"
#import "GoogleAnalytics.h"

/******* Set your tracking ID here *******/
static NSString *const kGaTrackingId = @"UA-45882688-3";
static BOOL const kGaTrackingOptOut = NO;
static NSString *const kTrackingPreferenceKey = @"allowTracking";

//#ifdef DEBUG
//static BOOL const kGaDryRun = YES;
//#else
//static BOOL const kGaDryRun = NO;
//#endif

static int const kGaDispatchPeriod = 20;

@interface AppDelegate ()<CLLocationManagerDelegate>

- (void)initializeGoogleAnalytics;

@end

@implementation AppDelegate{
    CLLocationManager *locationManager;
//    CLLocation *savedLocation;
    
    CLBeaconRegion *beaconRegion;
    BeaconDataController *beaconDataWithGPS;
    BeaconDataController *beaconData;
}

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // check device network
    if (![self checkDeviceNetworkState]) {
        return NO;
    }
    
    
    // app base data
    [self initializeAppBaseDataCompletion:^(){}];
    
    
    // device token
    [self initializeRemoteNotification];
    
    
    // Google Analytics
    [self initializeGoogleAnalytics];
    
    
    self.transitionDelegate = [[TransitionDelegate alloc] init];
    // update flag list
    [self updateFlagTimeStamp];
    
    
    // location manager
    [self initializeLocationManager];
    
    
    // set beacon data controller
    [self startDetectingBeacon];
    

    // set base appearance
    [self configureApprearance];

    
    // Google Map
    [GMSServices provideAPIKey:GOOGLE_MAP_API_KEY];
    
    
    // is launched by Notification
    if ([self checkLaunchApplicationByNotificationWithOptions:launchOptions]) {
        return YES;
    }
    
    
    // Check detect app launching for the first time
    [self checkUserSessionAndOpenViewType:TAB_BAR_VIEW_PAGE withObject:nil];
    
    return NO;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    NSLog(@"resign active");
    
//    [locationManager stopMonitoringSignificantLocationChanges];
//    [locationManager startUpdatingLocation];
    [self startMonitoringInBackground];
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
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    NSLog(@"terminate");
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}

- (void)configureApprearance
{
    // NAV BAR
    [[UINavigationBar appearance] setBarTintColor:UIColorFromRGB(0xffffff)];
    [[UINavigationBar appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:UIColorFromRGB(BASE_COLOR), NSForegroundColorAttributeName, [UIFont fontWithName:@"Helvetica_Bold" size:18], NSFontAttributeName, nil]];
    
    
    // PAGE CONTROL
    UIPageControl *pageControl = [UIPageControl appearance];
    pageControl.pageIndicatorTintColor = [UIColor lightGrayColor];
    pageControl.currentPageIndicatorTintColor = UIColorFromRGB(BASE_COLOR);
}

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
            DLog(@"Unresolved error %@, %@", error, [error userInfo]);
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
    NSDictionary *migrateOptions = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption, [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption, nil];
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"flag_ios.sqlite"];
    
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:migrateOptions error:&error]) {
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
        DLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }    
    
    return _persistentStoreCoordinator;
}


#pragma mark -
#pragma mark App Base Data Delegate
- (BOOL)initializeAppBaseDataCompletion:(void (^)())completion
{
    self.appBaseData = [[AppBaseDataController alloc] init];
    
    URLParameters *urlParam = [self getURLForAppBaseData];
    
    [FlagClient getDataResultWithURL:[urlParam getURLForRequest] methodName:[urlParam getMethodName] completion:^(NSDictionary *result){
        
        [self.appBaseData addObjectsWithData:result];
        
        if ([self.appBaseData getLaunchAlertShow]) {
            
            [self showAppLaunchUnexpectedAlert];
            
        }else{
            // pass
        }
        
    }];
    
    return [self.appBaseData getLaunchAlertShow];
}

- (URLParameters *)getURLForAppBaseData
{
    URLParameters *urlParam = [[URLParameters alloc] init];
    [urlParam setMethodName:@"idstring"];
    
    return urlParam;
}

- (void)showAppLaunchUnexpectedAlert
{
    NSString *alertTitle = [self.appBaseData getLaunchAlertTitle];
    NSString *alertMessage = [self.appBaseData getLaunchAlertMessage];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:alertTitle message:alertMessage delegate:self cancelButtonTitle:nil otherButtonTitles:NSLocalizedString(@"I got it", @"I got it"), nil];
    [alert setTag:ALERT_UNEXPECTED_MESSAGE];
    [alert show];
}


#pragma mark -
#pragma mark Reachability
- (BOOL)checkDeviceNetworkState
{
    UIDevice *device = [UIDevice currentDevice];
    BOOL isNetworkAvailable = [device networkAvailable];
    
    if (!isNetworkAvailable) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Network error", @"Network error") message:NSLocalizedString(@"app is impossible to network", @"app is impossible to network") delegate:self cancelButtonTitle:nil otherButtonTitles:NSLocalizedString(@"End App", @"End App"), nil];
        [alert setTag:ALERT_NETWORK_CHECK];
        [alert show];
    }
    
    return isNetworkAvailable;
}



#pragma mark -
#pragma mark Check Guest Session
- (void)checkUserSessionAndOpenViewType:(NSInteger)viewType withObject:(id)object
{
    if ([self isFirstLaunchApplication]) {
        [self getGuestSessionAndOpenViewType:viewType withObject:object];
    }else{
        [self getUserInfoFromCoreDataAndOpenViewType:viewType withObject:object];
    }
}

- (BOOL)isFirstLaunchApplication
{
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"haveLaunched"]) {
        
        return NO;
        
    }else{
        
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"haveLaunched"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        return YES;
        
    }
}

- (void)getGuestSessionAndOpenViewType:(NSInteger)viewType withObject:(id)object
{
    NSDate *startDate = [NSDate date];
    
    GTLServiceFlagengine *service = [FlagClient flagengineService];
    
    GTLQueryFlagengine *query = [GTLQueryFlagengine queryForUsersGuest];
    
    [service executeQuery:query completionHandler:^(GTLServiceTicket *ticket, GTLFlagengineUser *object, NSError *error){
        DLog(@"start guest session result object %@", object);
        
        if (error == nil) {
            // GA
            [GAUtil sendGADataLoadTimeWithInterval:[[NSDate date] timeIntervalSinceDate:startDate] actionName:@"get_guest_session" label:nil];
            
            
            // DALOG
            [DaLogClient sendDaLogWithCategory:CATEGORY_FIRST_USER target:VIEW_LOADING value:0];
            
            
            User *user = [[User alloc] init];
            user.userId = [object identifier];
            user.reward = [[object reward] integerValue];
            self.user = user;
            
            [DataUtil saveGuestSessionWithUser:user];
            [self initializeViewControllerForViewType:viewType withObject:object user:user];
        }
    }];
}

- (void)getUserInfoFromCoreDataAndOpenViewType:(NSInteger)viewType withObject:(id)object
{
    self.user = [DataUtil getUserInfo];

    if (self.user) {
        [self getUserRewardWithUser:self.user andOpenViewWithViewType:viewType withObject:object];
    }else{
        [self getGuestSessionAndOpenViewType:viewType withObject:object];
    }
}

- (void)getUserRewardWithUser:(User *)user andOpenViewWithViewType:(NSInteger)viewType withObject:(id)object
{
    [DataUtil getUserFormServerAtCompletionHandler:^(User *theUser){
       
        self.user.reward = theUser.reward;
        [self initializeViewControllerForViewType:viewType withObject:object user:self.user];
        
    }];
}

- (void)initializeViewControllerForViewType:(NSInteger)viewType withObject:(id)object user:(User *)user
{
    if (viewType == TAB_BAR_VIEW_PAGE) {
        [ViewUtil initializeRootViewControllerWithUser:self.user window:self.window];
    }else if (viewType == SALE_INFO_VIEW_PAGE){
        [ViewUtil initializeSaleInfoViewControllerWithUser:self.user shopId:object window:self.window];
    }else if (viewType == ITEM_DETAIL_VIEW_PAGE){
        [ViewUtil initializeItemDetailViewControllerWithUser:self.user itemId:object window:self.window];
    }
}


#pragma mark -
#pragma mark Google Analytics

- (void)initializeGoogleAnalytics
{
//    [[GAI sharedInstance] setDryRun:kGaDryRun];
    [[[GAI sharedInstance] logger] setLogLevel:kGAILogLevelVerbose];
    [[GAI sharedInstance] setTrackUncaughtExceptions:YES];
    
    [[GAI sharedInstance] setDispatchInterval:kGaDispatchPeriod];
    
    id<GAITracker> tracker = [[GAI sharedInstance] trackerWithTrackingId:kGaTrackingId];
    
    NSString *version = [[NSBundle mainBundle] objectForInfoDictionaryKey:(NSString *)kCFBundleVersionKey];
    [tracker set:kGAIAppVersion value:version];
    
    [[GAI sharedInstance] setOptOut:kGaTrackingOptOut];
}


#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}


#pragma mark - 
#pragma mark Flag data
- (void)updateFlagTimeStamp
{
    NSDate *lastUpdateTime = [DataUtil getLastUpdateTime];
    NSTimeInterval lastUpdateTimeWithTimeInterval;
    
    if (lastUpdateTime) {
        lastUpdateTimeWithTimeInterval = [lastUpdateTime timeIntervalSince1970];
    }else{
        lastUpdateTimeWithTimeInterval = 0;
    }
    
    [self getFlagListAfterLastUpdateTime:lastUpdateTimeWithTimeInterval];
}

- (void)getFlagListAfterLastUpdateTime:(NSTimeInterval)time
{
    URLParameters *urlParams = [self urlToUpdateFlagListWithLastUpdateTime:time];
    NSURL *url = [urlParams getURLForRequest];
    NSString *methodName = [urlParams getMethodName];
    
    [FlagClient getDataResultWithURL:url methodName:methodName completion:^(NSDictionary *results){
        
        if (results) {
            
            if ([results objectForKey:@"error"]) {
                DLog(@"update flag list error %@", [results objectForKey:@"error"]);
            }else{
                [DataUtil updateFlagListWithData:results afterLastUpdateTime:time];
            }
        }
    }];
}

- (URLParameters *)urlToUpdateFlagListWithLastUpdateTime:(NSTimeInterval)time
{
    NSNumber *timeStampForJava = [NSNumber numberWithLongLong:(time * 1000)];
    URLParameters *urlParam = [[URLParameters alloc] init];
    [urlParam setMethodName:@"flag_list_all"];
    [urlParam addParameterWithKey:@"tag" withParameter:timeStampForJava];
    
    return urlParam;
}

- (void)detectFlagListAroundLocation:(CLLocation *)location
{
    if (self.user) {
        FlagDataController *flagDataNearby = [[FlagDataController alloc] init];
        
        flagDataNearby = [DataUtil getFlagListAroundLatitude:location.coordinate.latitude longitude:location.coordinate.longitude];
        
        if ([flagDataNearby countOfList]) {
            
            NSArray *shopIds = [flagDataNearby shopIdListInFlagList];
            URLParameters *urlParam = [self urlToGetRecommandShopListWithShopIds:shopIds];
            NSURL *url = [urlParam getURLForRequest];
            NSString *methodName = [urlParam getMethodName];
            
            [FlagClient getDataResultWithURL:url methodName:methodName completion:^(NSDictionary *result){
                
                if (result) {
                    DLog(@"recommand shop near user");
                    [self recommandShopsNearUserWithData:result];
                }
            }];
            
        }else DLog(@"no flag list nearby");
    }
}

- (URLParameters *)urlToGetRecommandShopListWithShopIds:(NSArray *)shopIds
{
    URLParameters *urlParam = [[URLParameters alloc] init];
    [urlParam setMethodName:@"shop_recommend_near"];
    for(NSNumber *shopId in shopIds){
        [urlParam addParameterWithKey:@"ids" withParameter:shopId];
    }
    [urlParam addParameterWithUserId:self.user.userId];
    
    return urlParam;
}

- (void)recommandShopsNearUserWithData:(NSDictionary *)result
{
    Shop *theShop = [[Shop alloc] initWithData:result];
    
    NSString *shopName;
    if (theShop.name) {
        shopName = theShop.name;
    }else{
        shopName = NSLocalizedString(@"Shop", @"Shop");
    }
    
    NSString *message = [NSString stringWithFormat:@"%@%@", shopName, NSLocalizedString(@"is near here", @"is near here")];
    NSDictionary *userInfo = [[NSDictionary alloc] initWithObjectsAndKeys:theShop.shopId, @"shopId", theShop.name, @"shopName", [NSNumber numberWithInteger:NOTIFICATION_BY_GPS], @"type", nil];
    
    [Util showLocalNotificationWithUserInfo:userInfo atDate:[NSDate date] message:message];
}


#pragma mark -
#pragma mark Beacon detect
- (void)startDetectingBeacon
{
    NSUUID *beaconUUID = [[NSUUID alloc] initWithUUIDString:BEACON_UUID];
    beaconRegion = [[CLBeaconRegion alloc] initWithProximityUUID:beaconUUID identifier:BEACON_IDENTIFIER];
    beaconRegion.notifyEntryStateOnDisplay = YES;
    
    [locationManager startRangingBeaconsInRegion:beaconRegion];
}

- (URLParameters *)urlToGetShopWithShopId:(NSNumber *)shopId
{
    URLParameters *urlParam = [[URLParameters alloc] init];
    [urlParam setMethodName:@"shop"];
    [urlParam addParameterWithKey:@"id" withParameter:shopId];
    [urlParam addParameterWithUserId:self.user.userId];
    
    return urlParam;
}

- (void)checkInShopWithShopId:(NSNumber *)shopId inFlagId:(NSNumber *)flagId
{
    URLParameters *urlParam = [self urlToGetShopWithShopId:shopId];
    NSURL *url = [urlParam getURLForRequest];
    NSString *methodName = [urlParam getMethodName];
    
    [FlagClient getDataResultWithURL:url methodName:methodName completion:^(NSDictionary *result){
       
        if (result) {
            
            DLog(@"result %@", result);
            Shop *theShop = [[Shop alloc] initWithData:result];
            
            [self popUpForCheckInRewardWithShop:theShop];
            [self requestCheckInRewardWithShop:theShop];
            [DataUtil didCheckInFlagWithFlagId:flagId];
            [DataUtil saveRewardObjectWithObjectId:theShop.shopId type:REWARD_CHECKIN];
        }
    }];
}

- (void)popUpForCheckInRewardWithShop:(Shop *)theShop
{
    NSString *message = [NSString stringWithFormat:NSLocalizedString(@"You are in check-in shop. Have a shopping and get DAL", @"You are in check-in shop. Have a shopping and get DAL")];
    NSDictionary *userInfo = [[NSDictionary alloc] initWithObjectsAndKeys:theShop.shopId, @"shopId", theShop.name, @"shopName", [NSNumber numberWithInteger:theShop.reward], @"reward", [NSNumber numberWithInteger:NOTIFICATION_BY_BEACON], @"type", nil];
    [Util showLocalNotificationWithUserInfo:userInfo atDate:[NSDate date] message:message];
}

- (void)requestCheckInRewardWithShop:(Shop *)shop
{
    NSDate *startDate = [NSDate date];
    
    GTLService *service = [FlagClient flagengineService];
    GTLFlagengineReward *reward = [GTLFlagengineReward alloc];
    [reward setUserId:self.user.userId];
    [reward setTargetId:shop.shopId];
    [reward setTargetName:shop.name];
    [reward setReward:[NSNumber numberWithInteger:shop.reward]];
    [reward setType:[NSNumber numberWithInteger:REWARD_REQUEST_CHECKIN]];
    GTLQueryFlagengine *query = [GTLQueryFlagengine queryForRewardsInsertWithObject:reward];
    
    [service executeQuery:query completionHandler:^(GTLServiceTicket *ticket, GTLFlagengineReward *reward, NSError *error){
        DLog(@"reward result %@", reward);
        
        // GA
        [GAUtil sendGADataLoadTimeWithInterval:[[NSDate date] timeIntervalSinceDate:startDate] actionName:@"reward_check_in" label:nil];
        
        
        // DALOG
        [DaLogClient sendDaLogWithCategory:CATEGORY_CHECK_IN target:[shop.shopId integerValue] value:0];
    }];
}

- (void)startMonitoringInBackground
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
                DLog(@"\n\nRunning in the background!\n\n");
                
//                [application endBackgroundTask: background_task]; //End the task so the system knows that you are done with what you need to perform
//                background_task = UIBackgroundTaskInvalid; //Invalidate the background_task
                
            });
        }
    }

}

#pragma mark - 
#pragma mark alert delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == ALERT_NETWORK_CHECK) {
        exit(0);
    }else if (alertView.tag == ALERT_UNEXPECTED_MESSAGE){
        
    }
}


#pragma mark -
#pragma mark location manager
- (void)initializeLocationManager
{
    // initalize location manager
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    
    [locationManager startUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    DLog(@"fail to update location with error %@", [error localizedDescription]);
    [locationManager stopUpdatingLocation];
    [NSTimer scheduledTimerWithTimeInterval:LOCATION_UPDATE_DELAY_TIME target:locationManager selector:@selector(startUpdatingLocation) userInfo:nil repeats:NO];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    DLog(@"location updated");
    [locationManager stopUpdatingLocation];
    CLLocation *currentLocation = [locations lastObject];
    
    if (!self.savedLocation) {
        self.savedLocation = [[CLLocation alloc] initWithLatitude:0 longitude:0];
    }
    
    if ([MapUtil currentLocation:currentLocation getOutOfPreviousLocation:self.savedLocation withBoundRadius:LOCATION_UPDATE_RADIUS_DISTANCE]) {
        
#ifdef DEBUG
        NSString *message = [NSString stringWithFormat:@"location updated (%f, %f)", currentLocation.coordinate.latitude, currentLocation.coordinate.longitude];
        NSDictionary *userInfo = [[NSDictionary alloc] initWithObjectsAndKeys:[NSNumber numberWithInteger:NOTIFICATION_FOR_TEST], @"type", nil];
        [Util showLocalNotificationWithUserInfo:userInfo atDate:[NSDate date] message:message];
#else
#endif
        
        self.savedLocation = currentLocation;
        
        [self detectFlagListAroundLocation:self.savedLocation];
    }

    [NSTimer scheduledTimerWithTimeInterval:LOCATION_UPDATE_DELAY_TIME target:locationManager selector:@selector(startUpdatingLocation) userInfo:nil repeats:NO];
    
//    [locationManager startUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager didDetermineState:(CLRegionState)state forRegion:(CLRegion *)region
{
    if (state == CLRegionStateInside) {
        DLog(@"location manager did determine state INSIDE for %@", region.identifier);
    }else if (state == CLRegionStateOutside){
        DLog(@"location manager did determine state OUTSIDE for %@", region.identifier);
    }else{
        DLog(@"location manager did determine state OTHER for %@", region.identifier);
    }
}

- (void)locationManager:(CLLocationManager *)manager didRangeBeacons:(NSArray *)beacons inRegion:(CLBeaconRegion *)region
{
    DLog(@"did range beacon");
    
    if ([beacons count]) {
        
        for(CLBeacon *theBeacon in beacons){
          
            Flag *flag = [DataUtil getFlagWithFlagId:theBeacon.major];
            DLog(@"beacon find with flag %@ %@ %@ %f %d", flag.flagId, flag.shopId, flag.shopName, theBeacon.accuracy, [BeaconUtil isDeviceInRangeOfBeaconCheckInWithBeacon:theBeacon]);
        
            // check in
            if ([flag canFlagBeCheckedIn] && [BeaconUtil isDeviceInRangeOfBeaconCheckInWithBeacon:theBeacon]) {
                [self checkInShopWithShopId:flag.shopId inFlagId:flag.flagId];
            }
            
        };
    }
}

#pragma mark -
#pragma mark local notification
- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
    UIApplicationState state = [application applicationState];
    NSDictionary *userInfo = notification.userInfo;
    NSInteger notiType = [[userInfo valueForKey:@"type"] integerValue];
    
    NSNumber *shopId = [userInfo valueForKey:@"shopId"];
    NSString *shopName = [userInfo valueForKey:@"shopName"];
    NSNumber *reward = [userInfo valueForKey:@"reward"];
    
    if (notiType == NOTIFICATION_BY_BEACON) {
        
        // GA
        [GAUtil sendGADataWithCategory:@"bg_trigger" actionName:@"push_beacon" label:nil value:nil];
        
        
        if (self.presentingViewController) {
            
            [ViewUtil presentRewardPopUpViewInView:self.presentingViewController shopId:shopId shopName:shopName reward:reward];
            
        }else{
            [ViewUtil presentRewardPopUpViewInView:self.window.rootViewController shopId:shopId shopName:shopName reward:reward];
        }

        if (state == UIApplicationStateActive) {
            DLog(@"beacon detected in active");
        }else if (state == UIApplicationStateBackground){
            DLog(@"beacon detected in background");
        }else if (state == UIApplicationStateInactive){
            DLog(@"beacon detected in inactive");
        }
        
        return;
    }
    
    if (notiType == NOTIFICATION_BY_GPS) {
        
        // GA
        [GAUtil sendGADataWithCategory:@"bg_trigger" actionName:@"push_gps" label:nil value:nil];
        
        
        // DALOG
        [DaLogClient sendDaLogWithCategory:CATEGORY_LOCAL_PUSH target:[shopId integerValue] value:0];
        
        
        if (state == UIApplicationStateBackground || state == UIApplicationStateInactive) {
            if (self.presentingViewController) {
                [ViewUtil presentItemListViewNavInView:self.presentingViewController withUser:self.user shopId:shopId shopName:shopName withParentPageNumber:NOTIFICATION_VIEW];
            }else{
                [ViewUtil presentItemListViewNavInView:self.window.rootViewController withUser:self.user shopId:shopId shopName:shopName withParentPageNumber:NOTIFICATION_VIEW];
            }            
        }

        return;
    }
    
}

- (BOOL)checkLaunchApplicationByNotificationWithOptions:(NSDictionary *)launchOptions
{
    UILocalNotification *localNotif = [launchOptions objectForKey:UIApplicationLaunchOptionsLocalNotificationKey];
    
    if (localNotif) {
        NSDictionary *userInfo = localNotif.userInfo;
        NSInteger notiType = [[userInfo valueForKey:@"type"] integerValue];
        
        if (notiType == NOTIFICATION_BY_BEACON) {
            
            //GA
            [GAUtil sendGADataWithCategory:@"bg_action" actionName:@"accept_push_beacon" label:nil value:nil];
            
            NSNumber *shopId = [userInfo valueForKey:@"shopId"];
            [self checkUserSessionAndOpenViewType:SALE_INFO_VIEW_PAGE withObject:shopId];
        }
        
        if (notiType == NOTIFICATION_BY_GPS) {
            
            //GA
            [GAUtil sendGADataWithCategory:@"bg_action" actionName:@"accept_push_gps" label:nil value:nil];
            
            NSNumber *shopId = [userInfo valueForKey:@"shopId"];
            [self checkUserSessionAndOpenViewType:SALE_INFO_VIEW_PAGE withObject:shopId];
        }
        
        return YES;
    }return NO;
}


#pragma mark -
#pragma mark remote notification
- (void)initializeRemoteNotification
{
    UIRemoteNotificationType types = (UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound);
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:types];
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    NSString *token = [self hexStringFromData:deviceToken];
    DLog(@"content---%@", token);
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"deviceTokenNotification" object:self];
}

// Returns an NSString object that contains a hexadecimal representation of the
// receiver’s contents.
- (NSString *)hexStringFromData:(NSData *)data {
    NSUInteger dataLength = [data length];
    NSMutableString *stringBuffer =
    [NSMutableString stringWithCapacity:dataLength * 2];
    const unsigned char *dataBuffer = [data bytes];
    for (int i=0; i<dataLength; i++) {
        [stringBuffer appendFormat:@"%02lx", (unsigned long)dataBuffer[i]];
    }
    
    return stringBuffer;
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    DLog(@"error %@", error);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    DLog(@"alert %@", userInfo);
    
    NSString *message = userInfo[@"hiddenMessage"];
    
    // message is in the format of "<regId>:query:<clientSubId>" based on the backend
    NSArray *tokens = [message componentsSeparatedByString:@":"];
    
    // Tokens are not expected, do nothing
    if ([tokens count] != 3) {
        DLog(@"Message doesn't conform to the subId format at the backend %@", message);
        return;
    }
    
    // Token type isn't "query", do nothing
    if (![[tokens objectAtIndex:1] isEqual:@"query"]) {
        DLog(@"Message id not in type QUERY %@", message);
        return;
    }
    
    // Handle this push notification based on this topicID
//    NSString *topicID = [tokens objectAtIndex:2];
}


#pragma mark - 
#pragma mark url link
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    
    // Kakao Talk Link
    if ([KOSession isKakaoLinkCallback:url]) {
        
        NSMutableDictionary *paramDic = [Util dictionaryWithURLParameter:url];
        DLog(@"kakaoLink callback! query string : %@", paramDic);
        NSString *method = [paramDic valueForKey:@"method"];
        NSNumber *shopId = [paramDic valueForKey:@"shopId"];
        NSNumber *itemId = [paramDic valueForKey:@"itemId"];
        
        // GA
        [GAUtil sendGADataWithCategory:@"kakao_action" actionName:@"accept_kakao_invite" label:method value:nil];
        
        
        if ([method isEqualToString:@"main"]) {
            [self checkUserSessionAndOpenViewType:TAB_BAR_VIEW_PAGE withObject:nil];
        }else if ([method isEqualToString:@"shop"]){
            [self checkUserSessionAndOpenViewType:SALE_INFO_VIEW_PAGE withObject:shopId];
        }else if ([method isEqualToString:@"item"]){
            [self checkUserSessionAndOpenViewType:ITEM_DETAIL_VIEW_PAGE withObject:itemId];
        }else return NO;
        
        return YES;
    }else return NO;
}

@end
