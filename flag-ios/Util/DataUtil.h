//
//  DataUtil.h
//  Dalshop
//
//  Created by Hwang Gyuyoung on 2014. 5. 22..
//
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@class BeaconDataController;
@class FlagDataController;
@class LikeDataController;
@class ItemDataController;
@class ShopDataController;
@class User;
@class Flag;

@interface DataUtil : NSObject

// USER
+ (void)getUserFormServerAtCompletionHandler:(void (^)(User *user))completionHandler;


// USER INFO
+ (User *)getUserInfo;
+ (void)saveGuestSessionWithUser:(User *)user;
+ (void)saveUserFormForRegisterWithEmail:(NSString *)email;
+ (void)updateUserIdWithUserId:(NSNumber *)userId;
+ (void)updateRegisteredWithUserRegistered:(BOOL)registered;
+ (void)savePhoneCertificationSeccess;
+ (void)saveUserAdditionalInfoEntered;
+ (void)getUserInfoFromServerWithCompletionHandler:(void (^)(User *user))completion;
+ (void)saveUserInfoToDelegateUserWithUser:(User *)user;
+ (void)deleteUserInfo;


// USER HISTORY
+ (BOOL)getUserActionHistoryForRewardShopWatched;
+ (BOOL)isUserFirstLaunchApp;
+ (void)saveUserHistoryForRewardShopWatched;
+ (void)saveUserHistoryAfterAppLaunch;



// LAST UPDATE TIME
+ (NSDate *)getLastUpdateTime;
+ (void)saveLastUpdateTimeWithDate:(NSDate *)date;


// FLAG LIST
+ (void)updateFlagListWithData:(NSDictionary *)results afterLastUpdateTime:(NSTimeInterval)lastUpdateTime;
+ (void)saveFlagListWithData:(NSArray *)data afterLastUpdateTime:(NSTimeInterval)lastUpdateTime;
+ (FlagDataController *)getFlagListAroundLatitude:(CGFloat)latitude longitude:(CGFloat)longitude;
+ (Flag *)getFlagWithFlagId:(NSNumber *)flagId;
+ (BOOL)canFlagBeCheckedInWithFlagId:(NSNumber *)flagId;
+ (void)didCheckInFlagWithFlagId:(NSNumber *)flagId;
+ (FlagDataController *)getFlagListAroundLocation:(CLLocation *)location rangeRadius:(CGFloat)radius;


// LIKE LIST
+ (LikeDataController *)getLikeListWithType:(NSInteger)type;
+ (BOOL)isObjectLiked:(NSNumber *)objectId type:(NSInteger)type;
+ (LikeDataController *)getLikeListForShopList:(ShopDataController *)shopData;
+ (LikeDataController *)getLikeListForItemList:(ItemDataController *)itemData;
+ (void)saveLikeObjectWithObjectId:(NSNumber *)objectId type:(NSInteger)type;
+ (void)deleteLikeObjectWithObjectId:(NSNumber *)objectId type:(NSInteger)type;


// REWARD LIST
+ (void)saveRewardObjectWithObjectId:(NSNumber *)objectId type:(NSInteger)type;
+ (BOOL)isObjectRewarded:(NSNumber *)objectId type:(NSInteger)type;
+ (void)deleteRewardObjectWithObjectId:(NSNumber *)objectId type:(NSInteger)type;


// IMAGE LIST
+ (void)insertImageWithImage:(UIImage *)image imageUrl:(NSString *)imageUrl objectId:(NSNumber *)objectId inListType:(NSInteger)type;
+ (void)updateImageWithImage:(UIImage *)image imageUrl:(NSString *)imageUrl objectId:(NSNumber *)objectId inListType:(NSInteger)type;
+ (BOOL)isImageCachedWithObjectId:(NSNumber *)objectId imageUrl:(NSString *)imageUrl inListType:(NSInteger)type;
+ (UIImage *)getImageWithObjectId:(NSNumber *)objectId inListType:(NSInteger)type;


// BEACON LIST
+ (void)saveBeaconListWithData:(NSArray *)data afterLastUpdateTime:(NSTimeInterval)lastUpdateTime;
+ (BeaconDataController *)getBeaconListWithLatitude:(double)latitude longitude:(double)longitude;

@end
