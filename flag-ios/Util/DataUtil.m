//
//  DataUtil.m
//  Dalshop
//
//  Created by Hwang Gyuyoung on 2014. 5. 22..
//
//

#import "DataUtil.h"

#import "AppDelegate.h"

#import "User.h"
#import "Like.h"
#import "LikeDataController.h"
#import "Flag.h"
#import "FlagDataController.h"
#import "ItemDataController.h"
#import "ShopDataController.h"
#import "Beacon.h"
#import "BeaconDataController.h"
#import "URLParameters.h"

#import "FlagClient.h"
#import "GTLFlagengine.h"

@implementation DataUtil

// USER
+ (void)getUserFormServerAtCompletionHandler:(void (^)(User *user))completionHandler
{
    NSDate *startDate = [NSDate date];
    
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    User *theUser = delegate.user;
    
    GTLServiceFlagengine *service = [FlagClient flagengineService];
    GTLFlagengineUserForm *userForm = [GTLFlagengineUserForm alloc];
    [userForm setIdentifier:theUser.userId];
    
    GTLQueryFlagengine *query = [GTLQueryFlagengine queryForUsersGetWithObject:userForm];
    
    [service executeQuery:query completionHandler:^(GTLServiceTicket *ticket, GTLFlagengineUserForm *theUserForm, NSError *error){
        
        NSLog(@"did load user form");
        if (error == nil) {
            
            [GAUtil sendGADataLoadTimeWithInterval:[[NSDate date] timeIntervalSinceDate:startDate] actionName:@"get_user_form" label:nil];
            User *theUser = [[User alloc] init];
            [theUser setUserId:theUser.userId];
            [theUser setReward:theUser.reward];
            
            [self saveUserInfoToDelegateUserWithUser:theUser];
            completionHandler(theUser);
        }
        
    }];
}


// USER INFO
+ (User *)getUserInfo
{
    NSMutableArray *managedObjects = [self getManagedObjectsWithEntityName:@"UserInfo"];
    
    if ([managedObjects count]) {
        
        NSManagedObject *managedObject = [managedObjects lastObject];
        
        User *user = [[User alloc] initWithCoreData:managedObject];
        
        return user;
        
    }else return nil;
}

+ (void)saveGuestSessionWithUser:(User *)user
{
    NSManagedObjectContext *context = [self managedObjectContext];
    NSManagedObject *object = [NSEntityDescription insertNewObjectForEntityForName:@"UserInfo" inManagedObjectContext:context];
    [object setValue:user.userId forKey:@"userId"];
    [object setValue:[NSNumber numberWithBool:NO] forKey:@"registered"];
    
    NSError *error;
    if (![context save:&error]) {
        NSLog(@"Can't save! %@ %@", error, [error localizedDescription]);
    }
}

+ (void)saveUserFormForRegisterWithEmail:(NSString *)email
{
    NSManagedObjectContext *context = [self managedObjectContext];
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"UserInfo"];
    NSMutableArray *managedObjects = [[context executeFetchRequest:request error:nil] mutableCopy];
    NSManagedObject *object = [managedObjects lastObject];
    
    if (object) {
        [object setValue:email forKey:@"email"];
        [object setValue:[NSNumber numberWithBool:YES] forKey:@"registered"];
    }
    
    NSError *error = nil;
    if (![context save:&error]) {
        NSLog(@"Can't save! %@ %@", error, [error description]);
    }
}

+ (void)savePhoneCertificationSeccess
{
    NSManagedObjectContext *context = [self managedObjectContext];
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"UserInfo"];
    NSMutableArray *managedObjects = [[context executeFetchRequest:request error:nil] mutableCopy];
    NSManagedObject *object = [managedObjects lastObject];
    
    if (object) {
        [object setValue:[NSNumber numberWithBool:YES] forKey:@"phoneCertificated"];
    }
    
    NSError *error = nil;
    if (![context save:&error]) {
        NSLog(@"Can't save! %@ %@", error, [error description]);
    }
}

+ (void)saveUserAdditionalInfoEntered
{
    NSManagedObjectContext *context = [self managedObjectContext];
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"UserInfo"];
    NSMutableArray *managedObjects = [[context executeFetchRequest:request error:nil] mutableCopy];
    NSManagedObject *object = [managedObjects lastObject];
    
    if (object) {
        [object setValue:[NSNumber numberWithBool:YES] forKey:@"additionalProfiled"];
    }
    
    NSError *error = nil;
    if (![context save:&error]) {
        NSLog(@"Can't save! %@ %@", error, [error description]);
    }
}

+ (void)getUserInfoFromServerWithCompletionHandler:(void (^)(User *))completion
{
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    User *user = delegate.user;
    
    URLParameters *urlParam = [[URLParameters alloc] init];
    [urlParam setMethodName:@"user_info"];
    [urlParam addParameterWithUserId:user.userId];
    
    NSURL *url = [urlParam getURLForRequest];
    NSString *methodName = [urlParam getMethodName];
    
    [FlagClient getDataResultWithURL:url methodName:methodName completion:^(NSDictionary *result){
        
        User *theUser = [[User alloc] initWithData:result];
        [self saveUserInfoToDelegateUserWithUser:theUser];
        completion(theUser);
        
    }];
}

+ (void)saveUserInfoToDelegateUserWithUser:(User *)user
{
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [delegate.user setReward:user.reward];
}

+ (void)deleteUserInfo
{
    [self deleteAllDataWithEntityName:@"UserInfo"];
}


// USER ACTION HISTORY
+ (BOOL)getUserActionHistoryForRewardShopWatched
{
    NSMutableArray *managedObjects = [self getManagedObjectsWithEntityName:@"UserActionHistory"];
    
    if ([managedObjects count]) {
        
        NSManagedObject *managedObject = [managedObjects lastObject];
        
        BOOL rewardShopWatched = [[managedObject valueForKey:@"rewardShopWatched"] boolValue];
        
        return rewardShopWatched;
    }
    return NO;
}

+ (BOOL)isUserFirstLaunchApp
{
    NSMutableArray *managedObjects = [self getManagedObjectsWithEntityName:@"UserActionHistory"];
    
    if ([managedObjects count]) {
        
        NSManagedObject *managedObject = [managedObjects lastObject];
        
        BOOL rewardShopCheckedIn = [[managedObject valueForKey:@"rewardShopCheckedIn"] boolValue];
        
        return rewardShopCheckedIn;
    }
    return YES;
}

+ (void)saveUserHistoryForRewardShopWatched
{
    NSManagedObjectContext *context = [self managedObjectContext];
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"UserActionHistory"];
    NSMutableArray *managedObjects = [[context executeFetchRequest:request error:nil] mutableCopy];
    NSManagedObject *object = [managedObjects lastObject];
    
    if (object) {
        [object setValue:[NSNumber numberWithBool:YES] forKey:@"rewardShopWatched"];
    }
    
    NSError *error = nil;
    if (![context save:&error]) {
        NSLog(@"Can't save! %@ %@", error, [error description]);
    }
}

+ (void)saveUserHistoryAfterAppLaunch
{
    NSManagedObjectContext *context = [self managedObjectContext];
    NSManagedObject *object = [NSEntityDescription insertNewObjectForEntityForName:@"UserActionHistory" inManagedObjectContext:context];
    
    if (object) {
        [object setValue:[NSNumber numberWithBool:YES] forKey:@"rewardShopCheckedIn"];
    }
    
    NSError *error = nil;
    if (![context save:&error]) {
        NSLog(@"Can't save! %@ %@", error, [error description]);
    }
}



// LAST UPDATE TIME
+ (NSDate *)getLastUpdateTime
{
    NSMutableArray *managedObjects = [self getManagedObjectsWithEntityName:@"BeaconLastUpdateTime"];
    
    if ([managedObjects count]) {
        NSManagedObject *object = [managedObjects lastObject];
        NSDate *lastUpdateTime = [object valueForKey:@"lastUpdateTime"];
        NSLog(@"last update time %@", lastUpdateTime);
        
        return lastUpdateTime;
    }else return nil;
}

+ (void)saveLastUpdateTimeWithDate:(NSDate *)date
{
    [self deleteAllDataWithEntityName:@"BeaconLastUpdateTime"];
    
    NSManagedObjectContext *context = [self managedObjectContext];
    NSManagedObject *newUpdateTimeObject = [NSEntityDescription insertNewObjectForEntityForName:@"BeaconLastUpdateTime" inManagedObjectContext:context];
    [newUpdateTimeObject setValue:date forKey:@"lastUpdateTime"];
    
    NSError *error = nil;
    if (![context save:&error]) {
        NSLog(@"Can't save! %@ %@", error, [error localizedDescription]);
    }
}


// FLAG LIST
+ (void)updateFlagListWithData:(NSDictionary *)results afterLastUpdateTime:(NSTimeInterval)lastUpdateTime
{
    NSArray *flags = [results objectForKey:@"flags"];
    NSLog(@"updated new flag list %ld", (long)[flags count]);
    
    if ([flags count]) {
        
        // save flag list data after created last update time
        [self saveFlagListWithData:flags afterLastUpdateTime:lastUpdateTime];
    }
    
    // save last update time with now
    [self saveLastUpdateTimeWithDate:[NSDate date]];
}

+ (void)saveFlagListWithData:(NSArray *)data afterLastUpdateTime:(NSTimeInterval)lastUpdateTime
{
    FlagDataController *willSaveFlagData = [[FlagDataController alloc] init];
    
    for(id object in data){
        
        Flag *theFlag = [[Flag alloc] initWithData:object];
        
        if (theFlag.createdAt > lastUpdateTime) {
            [willSaveFlagData addObjectWithObject:theFlag];
        }
    }
    
    [self saveFlagListWithDataController:willSaveFlagData];
}

+ (void)saveFlagListWithDataController:(FlagDataController *)flagData
{
    NSManagedObjectContext *context = [self managedObjectContext];
    
    for(Flag *theFlag in flagData.masterData){
        
        NSManagedObject *newFlag = [NSEntityDescription insertNewObjectForEntityForName:@"FlagList" inManagedObjectContext:context];
        
        [newFlag setValue:[NSNumber numberWithLongLong:[theFlag.flagId longLongValue]] forKey:@"flagId"];
        [newFlag setValue:theFlag.lat forKey:@"latitude"];
        [newFlag setValue:theFlag.lon forKey:@"longitude"];
        [newFlag setValue:[theFlag getCreatedAtByNSDate] forKey:@"createdAt"];
        [newFlag setValue:[NSNumber numberWithLongLong:[theFlag.shopId longLongValue]] forKey:@"shopId"];
        [newFlag setValue:theFlag.shopName forKey:@"shopName"];
        [newFlag setValue:[NSNumber numberWithInteger:theFlag.shopType] forKey:@"shopType"];
        [newFlag setValue:[NSDate dateWithTimeIntervalSince1970:0] forKey:@"lastScanTime"];
    }
    
    NSError *error = nil;
    if (![context save:&error]) {
        NSLog(@"Can't save %@ %@", error, [error localizedDescription]);
    }
}

+ (FlagDataController *)getFlagListAroundLatitude:(CGFloat)latitude longitude:(CGFloat)longitude
{
    FlagDataController *flagData = [[FlagDataController alloc] init];
    
    NSPredicate *predicateWithLocation = [NSPredicate predicateWithFormat:@"(%f <= latitude) AND (latitude <= %f) AND (%f <= longitude) AND (longitude <= %f)", (latitude - BEACON_DETECT_RADIUS_GEOMETIC), (latitude + BEACON_DETECT_RADIUS_GEOMETIC), (longitude - BEACON_DETECT_RADIUS_GEOMETIC), (longitude + BEACON_DETECT_RADIUS_GEOMETIC)];
    NSMutableArray *managedObjects = [self getManagedObjectWithEntityName:@"FlagList" withPredicate:predicateWithLocation];
    
    for(NSManagedObject *object in managedObjects){
        Flag *theFlag = [[Flag alloc] initWithCoreData:object];
        [flagData addObjectWithObject:theFlag];
    }
    
    return flagData;
}

+ (Flag *)getFlagWithFlagId:(NSNumber *)flagId
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"flagId == %d", [flagId longLongValue]];
    NSMutableArray *managedObjects = [self getManagedObjectWithEntityName:@"FlagList" withPredicate:predicate];
    
    if ([managedObjects count]) {
        
        NSManagedObject *object = [managedObjects lastObject];
        Flag *theFlag = [[Flag alloc] initWithCoreData:object];

        return theFlag;
        
    }else return nil;
}

+ (BOOL)canFlagBeCheckedInWithFlagId:(NSNumber *)flagId
{
    Flag *theFlag = [self getFlagWithFlagId:flagId];
    
    if (theFlag && [theFlag canFlagBeCheckedIn]) {
        return YES;
    }else return NO;
}

+ (void)didCheckInFlagWithFlagId:(NSNumber *)flagId
{
    NSLog(@"did check in shop");
    
    NSManagedObjectContext *context = [self managedObjectContext];
    NSEntityDescription *entityDesc = [NSEntityDescription entityForName:@"FlagList" inManagedObjectContext:context];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"flagId == %d", [flagId longLongValue]];
    
    [request setEntity:entityDesc];
    [request setPredicate:predicate];
    
    NSError *error = nil;
    NSMutableArray *managedObject = [self getManagedObjectWithEntityName:@"FlagList" withPredicate:predicate];
    
    if ([managedObject count]) {
        NSManagedObject *object = [managedObject lastObject];
        [object setValue:[NSDate date] forKey:@"lastScanTime"];
    }
    
    if (![context save:&error]) {
        NSLog(@"Can't save! %@ %@", error, [error localizedDescription]);
    }
}

+ (FlagDataController *)getFlagListAroundLocation:(CLLocation *)location rangeRadius:(CGFloat)radius
{
    FlagDataController *flagData = [[FlagDataController alloc] init];
    CGFloat latitude = location.coordinate.latitude;
    CGFloat longitude = location.coordinate.longitude;
    
    NSPredicate *predicateWithLocation = [NSPredicate predicateWithFormat:@"(%f <= latitude) AND (latitude <= %f) AND (%f <= longitude) AND (longitude <= %f)", (latitude - radius), (latitude + radius), (longitude - radius), (longitude + radius)];
    NSMutableArray *managedObjects = [self getManagedObjectWithEntityName:@"FlagList" withPredicate:predicateWithLocation];
    
    for(NSManagedObject *object in managedObjects){
        Flag *theFlag = [[Flag alloc] initWithCoreData:object];
        [flagData addObjectWithObject:theFlag];
    }
    
    return flagData;
}


// LIKE LIST
+ (NSString *)getLikeEntityNameWithType:(NSInteger)type
{
    NSString *entityName;
    if (type == LIKE_ITEM) {
        entityName = @"LikeItemList";
    }else if (type == LIKE_SHOP){
        entityName = @"LikeShopList";
    }
    
    return entityName;
}

+ (NSString *)getLikeObjectIdNameWithType:(NSInteger)type
{
    NSString *idName;
    if (type == LIKE_ITEM) {
        idName = @"itemId";
    }else if (type == LIKE_SHOP){
        idName = @"shopId";
    }
    
    return idName;
}

+ (NSPredicate *)predicateFormatWithLikeObjectId:(NSNumber *)objectId type:(NSInteger)type
{
    NSPredicate *predicate;
    if (type == LIKE_ITEM) {
        predicate = [NSPredicate predicateWithFormat:@"itemId == %@", objectId];
    }else if (type == LIKE_SHOP){
        predicate = [NSPredicate predicateWithFormat:@"shopId == %@", objectId];
    }
    
    return predicate;
}

+ (LikeDataController *)getLikeListWithType:(NSInteger)type
{
    NSString *entityName = [self getLikeEntityNameWithType:type];
    
    LikeDataController *likeData = [[LikeDataController alloc] init];
    [likeData setType:type];
    
    NSMutableArray *managedObjects = [self getManagedObjectsWithEntityName:entityName];
    for(NSManagedObject *object in managedObjects){
        Like *likeObject = [[Like alloc] initWithCoreData:object type:type];
        [likeData addObjectWithObject:likeObject];
    }
    
    return likeData;
}

+ (BOOL)isObjectLiked:(NSNumber *)objectId type:(NSInteger)type
{
    NSString *entityName = [self getLikeEntityNameWithType:type];
    
    NSPredicate *predicate = [self predicateFormatWithLikeObjectId:objectId type:type];
    NSMutableArray *managedObjects = [self getManagedObjectWithEntityName:entityName withPredicate:predicate];
    
    if ([managedObjects count]) {
        return YES;
    }else return NO;
}

+ (LikeDataController *)getLikeListForObjectIds:(NSArray *)objectIds type:(NSInteger)type
{
    NSString *entityName = [self getLikeEntityNameWithType:type];
    NSPredicate *predicate;
    if (type == LIKE_ITEM) {
        predicate = [NSPredicate predicateWithFormat:@"(itemId == %@)" argumentArray:objectIds];
    }else if (type == LIKE_SHOP){
        predicate = [NSPredicate predicateWithFormat:@"(shopId == %@)" argumentArray:objectIds];
    }
    
    LikeDataController *likeData = [[LikeDataController alloc] init];
    [likeData setType:type];
    
    NSMutableArray *managedObjects = [self getManagedObjectWithEntityName:entityName withPredicate:predicate];
    for(NSManagedObject *object in managedObjects){
        Like *likeObject = [[Like alloc] initWithCoreData:object type:type];
        [likeData addObjectWithObject:likeObject];
    }
    
    return likeData;
}

+ (LikeDataController *)getLikeListForShopList:(ShopDataController *)shopData
{
    NSArray *shopIds = [shopData getHQShopIds];
    LikeDataController *likeData = [self getLikeListForObjectIds:shopIds type:LIKE_SHOP];
    return likeData;
}

+ (LikeDataController *)getLikeListForItemList:(ItemDataController *)itemData
{
    NSArray *itemIds = [itemData getItemIds];
    LikeDataController *likeData = [self getLikeListForObjectIds:itemIds type:LIKE_ITEM];
    return likeData;
}

+ (void)saveLikeObjectWithObjectId:(NSNumber *)objectId type:(NSInteger)type
{
    NSManagedObjectContext *context = [self managedObjectContext];
    NSString *entityName = [self getLikeEntityNameWithType:type];
    NSString *idName = [self getLikeObjectIdNameWithType:type];
    NSManagedObject *newLikeObject = [NSEntityDescription insertNewObjectForEntityForName:entityName inManagedObjectContext:context];
    
    [newLikeObject setValue:[NSNumber numberWithLongLong:[objectId longLongValue]] forKey:idName];
    [newLikeObject setValue:[NSDate date] forKey:@"createdAt"];
    [newLikeObject setValue:[NSDate date] forKey:@"updatedAt"];

    NSError *error = nil;
    if (![context save:&error]) {
        NSLog(@"Can't save %@ %@", error, [error localizedDescription]);
    }
}

+ (void)deleteLikeObjectWithObjectId:(NSNumber *)objectId type:(NSInteger)type
{
    NSManagedObjectContext *context = [self managedObjectContext];
    NSString *entityName = [self getLikeEntityNameWithType:type];
    NSPredicate *predicate = [self predicateFormatWithLikeObjectId:objectId type:type];
    NSMutableArray *managedObject = [self getManagedObjectWithEntityName:entityName withPredicate:predicate];
    
    if ([managedObject count]) {
        NSManagedObject *object = [managedObject objectAtIndex:0];
        [context deleteObject:object];
    }
    
    NSError *error = nil;
    if (![context save:&error]) {
        NSLog(@"Can't save %@ %@", error, [error localizedDescription]);
    }
}


// REWARD LIST
+ (NSString *)getRewardEntityNameWithType:(NSInteger)type
{
    NSString *entityName;
    if (type == REWARD_SCAN) {
        entityName = @"RewardedItemList";
    }else if (type == REWARD_CHECKIN){
        entityName = @"RewardedShopList";
    }
    
    return entityName;
}

+ (void)saveRewardObjectWithObjectId:(NSNumber *)objectId type:(NSInteger)type
{
    NSManagedObjectContext *context = [self managedObjectContext];
    NSString *entityName = [self getRewardEntityNameWithType:type];
    NSManagedObject *rewardObject = [NSEntityDescription insertNewObjectForEntityForName:entityName inManagedObjectContext:context];
    
    [rewardObject setValue:[NSNumber numberWithLongLong:[objectId longLongValue]] forKey:@"objectId"];
    [rewardObject setValue:[NSDate date] forKey:@"rewardedAt"];
    
    NSError *error = nil;
    if (![context save:&error]) {
        NSLog(@"Can't save %@ %@", error, [error localizedDescription]);
    }
}

+ (BOOL)isObjectRewarded:(NSNumber *)objectId type:(NSInteger)type
{
    NSString *entityName = [self getRewardEntityNameWithType:type];
    
    NSPredicate *predicate = [self predicateFormatWithLikeObjectId:objectId type:type];
    NSMutableArray *managedObjects = [self getManagedObjectWithEntityName:entityName withPredicate:predicate];
    
    if ([managedObjects count]) {
        return YES;
    }else return NO;
}

+ (void)deleteRewardObjectWithObjectId:(NSNumber *)objectId type:(NSInteger)type
{
    NSManagedObjectContext *context = [self managedObjectContext];
    NSString *entityName = [self getRewardEntityNameWithType:type];
    NSPredicate *predicate = [self predicateFormatWithLikeObjectId:objectId type:type];
    NSMutableArray *managedObject = [self getManagedObjectWithEntityName:entityName withPredicate:predicate];
    
    if ([managedObject count]) {
        NSManagedObject *object = [managedObject objectAtIndex:0];
        [context deleteObject:object];
    }
    
    NSError *error = nil;
    if (![context save:&error]) {
        NSLog(@"Can't save %@ %@", error, [error localizedDescription]);
    }
}


// IMAGE LIST
+ (NSString *)getImageListEntityNameWithType:(NSInteger)type
{
    NSString *entityName;
    
    if (type == IMAGE_SHOP_LOGO || type == IMAGE_SHOP_EVENT ) {
        entityName = @"ImageListForShop";
    }
    
    return entityName;
}

+ (void)insertImageWithImage:(UIImage *)image imageUrl:(NSString *)imageUrl objectId:(NSNumber *)objectId inListType:(NSInteger)type
{
    if ([self isOldImageCachedWithObjectId:objectId inListType:type]) {
        
        [self updateImageWithImage:image imageUrl:imageUrl objectId:objectId inListType:type];
        
    }else{
     
        NSManagedObjectContext *context = [self managedObjectContext];
        NSString *entityName = [self getImageListEntityNameWithType:type];
        NSManagedObject *object = [NSEntityDescription insertNewObjectForEntityForName:entityName inManagedObjectContext:context];
        NSData *imageData = [NSData dataWithData:UIImagePNGRepresentation(image)];
        
        [object setValue:[NSNumber numberWithLongLong:[objectId longLongValue]] forKeyPath:@"objectId"];
        [object setValue:imageData forKeyPath:@"image"];
        [object setValue:imageUrl forKeyPath:@"imageURL"];
        [object setValue:[NSNumber numberWithLong:(long)type] forKeyPath:@"type"];
        [object setValue:[NSDate date] forKeyPath:@"updatedAt"];
        
        NSError *error = nil;
        if (![context save:&error]) {
            NSLog(@"Can't save %@ %@", error, [error localizedDescription]);
        }
    }
}

+ (void)updateImageWithImage:(UIImage *)image imageUrl:(NSString *)imageUrl objectId:(NSNumber *)objectId inListType:(NSInteger)type
{
    NSManagedObjectContext *context = [self managedObjectContext];
    NSString *entityName = [self getImageListEntityNameWithType:type];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(objectId == %@) AND (type == %d)", objectId, type];
    NSMutableArray *managedObject = [self getManagedObjectWithEntityName:entityName withPredicate:predicate];
    
    if ([managedObject count]) {
        NSManagedObject *object = [managedObject lastObject];
        NSData *imageData = [NSData dataWithData:UIImagePNGRepresentation(image)];

        [object setValue:imageData forKeyPath:@"image"];
        [object setValue:[NSDate date] forKeyPath:@"updatedAt"];
    }
    
    NSError *error = nil;
    if (![context save:&error]) {
        NSLog(@"Can't save %@ %@", error, [error localizedDescription]);
    }
}

+ (BOOL)isImageCachedWithObjectId:(NSNumber *)objectId imageUrl:(NSString *)imageUrl inListType:(NSInteger)type
{
    NSString *entityName = [self getImageListEntityNameWithType:type];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(objectId == %@) AND (imageURL LIKE %@) AND (type == %d)", objectId, imageUrl, type];
    NSMutableArray *managedObjects = [self getManagedObjectWithEntityName:entityName withPredicate:predicate];
    
    if ([managedObjects count]) {
        return YES;
    }else return NO;
}

+ (BOOL)isOldImageCachedWithObjectId:(NSNumber *)objectId inListType:(NSInteger)type
{
    NSString *entityName = [self getImageListEntityNameWithType:type];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(objectId == %@) AND (type == %d)", objectId, type];
    NSMutableArray *managedObjects = [self getManagedObjectWithEntityName:entityName withPredicate:predicate];
    
    if ([managedObjects count]) {
        return YES;
    }else return NO;
}

+ (UIImage *)getImageWithObjectId:(NSNumber *)objectId inListType:(NSInteger)type
{
    NSString *entityName = [self getImageListEntityNameWithType:type];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(objectId == %@) AND (type == %d)", objectId, type];
    NSMutableArray *managedObjects = [self getManagedObjectWithEntityName:entityName withPredicate:predicate];
    
    if ([managedObjects count]) {
        
        NSManagedObject *object = [managedObjects lastObject];
        UIImage *image = [UIImage imageWithData:[object valueForKey:@"image"]];
        return image;
        
    }return nil;
}



// BEACON LIST
+ (void)saveBeaconListWithData:(NSArray *)data afterLastUpdateTime:(NSTimeInterval)lastUpdateTime
{
    BeaconDataController *willSaveBeaconData = [[BeaconDataController alloc] init];
    
    for(NSDictionary *object in data){
    
        Beacon *theBeacon = [[Beacon alloc] initWithData:object];
        
        // new beacon set created after last update time
        if ([theBeacon.createdAt floatValue]/1000 > lastUpdateTime) {
            [willSaveBeaconData addObjectWithObject:theBeacon];
        }
    }
    
    // save beacon in core data
    [self saveBeaconListWithDataController:willSaveBeaconData];
}

+ (void)saveBeaconListWithDataController:(BeaconDataController *)beaconData
{
    NSManagedObjectContext *context = [self managedObjectContext];

    for(Beacon *theBeacon in beaconData.masterData){

        NSManagedObject *newBeacon = [NSEntityDescription insertNewObjectForEntityForName:@"BeaconList" inManagedObjectContext:context];

        [newBeacon setValue:theBeacon.beaconId forKey:@"beaconId"];
        [newBeacon setValue:[NSNumber numberWithLongLong:[theBeacon.shopId longLongValue]] forKey:@"shopId"];
        [newBeacon setValue:theBeacon.shopName forKey:@"shopName"];
        [newBeacon setValue:theBeacon.latitude forKey:@"latitude"];
        [newBeacon setValue:theBeacon.longitude forKey:@"longitude"];
        [newBeacon setValue:theBeacon.lastScanTime forKey:@"lastScanTime"];

    }

    NSError *error = nil;
    if (![context save:&error]) {
        NSLog(@"Can't save! %@ %@", error, [error localizedDescription]);
    }
}

+ (BeaconDataController *)getBeaconListWithLatitude:(double)latitude longitude:(double)longitude
{
    BeaconDataController *beaconData = [[BeaconDataController alloc] init];
    
    NSPredicate *predicateWithLocation = [NSPredicate predicateWithFormat:@"(%f <= latitude) AND (latitude <= %f) AND (%f <= longitude) AND (longitude <= %f)", (latitude - BEACON_DETECT_RADIUS_GEOMETIC), (latitude + BEACON_DETECT_RADIUS_GEOMETIC), (longitude - BEACON_DETECT_RADIUS_GEOMETIC), (longitude + BEACON_DETECT_RADIUS_GEOMETIC)];
    
    NSDate *now = [NSDate date];
    NSDate *timeBaseLine = [now dateByAddingTimeInterval:-(BEACON_COOL_TIME)];
    NSLog(@"now %@ %@", now, timeBaseLine);
    NSPredicate *predicateWithLastScanTime = [NSPredicate predicateWithFormat:@"lastScanTime <= %@", timeBaseLine];
    
    NSPredicate *compoundPredicate = [NSCompoundPredicate andPredicateWithSubpredicates:@[predicateWithLocation, predicateWithLastScanTime]];
    
    NSMutableArray *managedObjects = [self getManagedObjectWithEntityName:@"BeaconList" withPredicate:compoundPredicate];
    
    for(NSManagedObject *object in managedObjects){
        Beacon *theBeacon = [[Beacon alloc] initWithManagedObject:object];
        [beaconData addObjectWithObject:theBeacon];
    }
    
    return beaconData;
}


#pragma mark -
#pragma mark managed objects
+ (NSMutableArray *)getManagedObjectsWithEntityName:(NSString *)entityName
{
    NSManagedObjectContext *context = [self managedObjectContext];
    NSEntityDescription *entityDesc = [NSEntityDescription entityForName:entityName inManagedObjectContext:context];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDesc];
    
    NSMutableArray *managedObjects = [[context executeFetchRequest:request error:nil] mutableCopy];
    return managedObjects;
}

+ (NSMutableArray *)getManagedObjectWithEntityName:(NSString *)entityName withPredicate:(NSPredicate *)predicate
{
    NSManagedObjectContext *context = [self managedObjectContext];
    NSEntityDescription *entityDesc = [NSEntityDescription entityForName:entityName inManagedObjectContext:context];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    
    [request setEntity:entityDesc];
    [request setPredicate:predicate];
    
    NSError *error = nil;
    NSMutableArray *managedObjects = [[context executeFetchRequest:request error:&error] mutableCopy];
    return managedObjects;
}

+ (void)deleteAllDataWithEntityName:(NSString *)entityName
{
    NSManagedObjectContext *context = [self managedObjectContext];
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:[NSEntityDescription entityForName:entityName inManagedObjectContext:context]];
    [request setIncludesPropertyValues:NO];
    
    NSError *error = nil;
    NSArray *managedObjects = [context executeFetchRequest:request error:&error];
    
    for(NSManagedObject *object in managedObjects){
        [context deleteObject:object];
    }
    NSError *saveError = nil;
    [context save:&saveError];
}


#pragma mark -
#pragma mark managed object context
+ (NSManagedObjectContext *)managedObjectContext
{
    NSManagedObjectContext *context = nil;
    id delegate = [[UIApplication sharedApplication] delegate];
    if ([delegate performSelector:@selector(managedObjectContext)]) {
        context = [delegate managedObjectContext];
    }
    return context;
}

@end
