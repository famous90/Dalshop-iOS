/* This file was generated by the ServiceGenerator.
 * The ServiceGenerator is Copyright (c) 2014 Google Inc.
 */

//
//  GTLQueryFlagengine.m
//

// ----------------------------------------------------------------------------
// NOTE: This file is generated from Google APIs Discovery Service.
// Service:
//   flagengine/v1
// Description:
//   This is an API
// Classes:
//   GTLQueryFlagengine (68 custom class methods, 39 custom properties)

#import "GTLQueryFlagengine.h"

#import "GTLFlagengineBranchItemMatcher.h"
#import "GTLFlagengineFeedbackMessage.h"
#import "GTLFlagengineFlag.h"
#import "GTLFlagengineFlagCollection.h"
#import "GTLFlagengineIdString.h"
#import "GTLFlagengineIdStringCollection.h"
#import "GTLFlagengineItem.h"
#import "GTLFlagengineItemCollection.h"
#import "GTLFlagengineItemViewPair.h"
#import "GTLFlagengineLike.h"
#import "GTLFlagengineLog.h"
#import "GTLFlagengineLogCollection.h"
#import "GTLFlagengineNotice.h"
#import "GTLFlagenginePP.h"
#import "GTLFlagengineProvider.h"
#import "GTLFlagengineProviderForm.h"
#import "GTLFlagengineRedeem.h"
#import "GTLFlagengineRedeemCollection.h"
#import "GTLFlagengineRetainForm.h"
#import "GTLFlagengineReward.h"
#import "GTLFlagengineRewardCollection.h"
#import "GTLFlagengineShop.h"
#import "GTLFlagengineShopCollection.h"
#import "GTLFlagengineTOU.h"
#import "GTLFlagengineUploadUrl.h"
#import "GTLFlagengineUser.h"
#import "GTLFlagengineUserForm.h"
#import "GTLFlagengineUserInfo.h"
#import "GTLFlagengineVersion.h"

@implementation GTLQueryFlagengine

@dynamic barcodeId, birth, descriptionProperty, empty, end, fields, flagId,
         identifier, ids, imageUrl, itemId, job, lat, liked, likes, logoUrl,
         lon, mark, name, oldPrice, onSale, parentId, phone, price, providerId,
         range, reward, rewardable, rewarded, sale, sex, shopId, start,
         statusCode, tag, thumbnailUrl, type, userId, verificationCode;

+ (NSDictionary *)parameterNameMap {
  NSDictionary *map =
    [NSDictionary dictionaryWithObjectsAndKeys:
      @"description", @"descriptionProperty",
      @"id", @"identifier",
      nil];
  return map;
}

+ (NSDictionary *)arrayPropertyToClassMap {
  NSDictionary *map =
    [NSDictionary dictionaryWithObject:[NSNumber class]
                                forKey:@"ids"];
  return map;
}

#pragma mark -
#pragma mark "apps.feedbacks" methods
// These create a GTLQueryFlagengine object.

+ (id)queryForAppsFeedbacksInsertWithObject:(GTLFlagengineFeedbackMessage *)object {
  if (object == nil) {
    GTL_DEBUG_ASSERT(object != nil, @"%@ got a nil object", NSStringFromSelector(_cmd));
    return nil;
  }
  NSString *methodName = @"flagengine.apps.feedbacks.insert";
  GTLQueryFlagengine *query = [self queryWithMethodName:methodName];
  query.bodyObject = object;
  return query;
}

#pragma mark -
#pragma mark "apps.idstrings" methods
// These create a GTLQueryFlagengine object.

+ (id)queryForAppsIdstringsDelete {
  NSString *methodName = @"flagengine.apps.idstrings.delete";
  GTLQueryFlagengine *query = [self queryWithMethodName:methodName];
  return query;
}

+ (id)queryForAppsIdstringsGet {
  NSString *methodName = @"flagengine.apps.idstrings.get";
  GTLQueryFlagengine *query = [self queryWithMethodName:methodName];
  query.expectedObjectClass = [GTLFlagengineIdStringCollection class];
  return query;
}

+ (id)queryForAppsIdstringsInsertWithObject:(GTLFlagengineIdString *)object {
  if (object == nil) {
    GTL_DEBUG_ASSERT(object != nil, @"%@ got a nil object", NSStringFromSelector(_cmd));
    return nil;
  }
  NSString *methodName = @"flagengine.apps.idstrings.insert";
  GTLQueryFlagengine *query = [self queryWithMethodName:methodName];
  query.bodyObject = object;
  query.expectedObjectClass = [GTLFlagengineIdString class];
  return query;
}

#pragma mark -
#pragma mark "apps.notices" methods
// These create a GTLQueryFlagengine object.

+ (id)queryForAppsNoticesGet {
  NSString *methodName = @"flagengine.apps.notices.get";
  GTLQueryFlagengine *query = [self queryWithMethodName:methodName];
  query.expectedObjectClass = [GTLFlagengineNotice class];
  return query;
}

+ (id)queryForAppsNoticesInsertWithObject:(GTLFlagengineNotice *)object {
  if (object == nil) {
    GTL_DEBUG_ASSERT(object != nil, @"%@ got a nil object", NSStringFromSelector(_cmd));
    return nil;
  }
  NSString *methodName = @"flagengine.apps.notices.insert";
  GTLQueryFlagengine *query = [self queryWithMethodName:methodName];
  query.bodyObject = object;
  query.expectedObjectClass = [GTLFlagengineNotice class];
  return query;
}

#pragma mark -
#pragma mark "apps.pps" methods
// These create a GTLQueryFlagengine object.

+ (id)queryForAppsPpsGet {
  NSString *methodName = @"flagengine.apps.pps.get";
  GTLQueryFlagengine *query = [self queryWithMethodName:methodName];
  query.expectedObjectClass = [GTLFlagenginePP class];
  return query;
}

+ (id)queryForAppsPpsInsertWithObject:(GTLFlagenginePP *)object {
  if (object == nil) {
    GTL_DEBUG_ASSERT(object != nil, @"%@ got a nil object", NSStringFromSelector(_cmd));
    return nil;
  }
  NSString *methodName = @"flagengine.apps.pps.insert";
  GTLQueryFlagengine *query = [self queryWithMethodName:methodName];
  query.bodyObject = object;
  query.expectedObjectClass = [GTLFlagenginePP class];
  return query;
}

#pragma mark -
#pragma mark "apps.tous" methods
// These create a GTLQueryFlagengine object.

+ (id)queryForAppsTousGet {
  NSString *methodName = @"flagengine.apps.tous.get";
  GTLQueryFlagengine *query = [self queryWithMethodName:methodName];
  query.expectedObjectClass = [GTLFlagengineTOU class];
  return query;
}

+ (id)queryForAppsTousInsertWithObject:(GTLFlagengineTOU *)object {
  if (object == nil) {
    GTL_DEBUG_ASSERT(object != nil, @"%@ got a nil object", NSStringFromSelector(_cmd));
    return nil;
  }
  NSString *methodName = @"flagengine.apps.tous.insert";
  GTLQueryFlagengine *query = [self queryWithMethodName:methodName];
  query.bodyObject = object;
  query.expectedObjectClass = [GTLFlagengineTOU class];
  return query;
}

#pragma mark -
#pragma mark "apps.versions" methods
// These create a GTLQueryFlagengine object.

+ (id)queryForAppsVersionsGet {
  NSString *methodName = @"flagengine.apps.versions.get";
  GTLQueryFlagengine *query = [self queryWithMethodName:methodName];
  query.expectedObjectClass = [GTLFlagengineVersion class];
  return query;
}

+ (id)queryForAppsVersionsInsertWithObject:(GTLFlagengineVersion *)object {
  if (object == nil) {
    GTL_DEBUG_ASSERT(object != nil, @"%@ got a nil object", NSStringFromSelector(_cmd));
    return nil;
  }
  NSString *methodName = @"flagengine.apps.versions.insert";
  GTLQueryFlagengine *query = [self queryWithMethodName:methodName];
  query.bodyObject = object;
  query.expectedObjectClass = [GTLFlagengineVersion class];
  return query;
}

#pragma mark -
#pragma mark "flags" methods
// These create a GTLQueryFlagengine object.

+ (id)queryForFlagsDeleteWithFlagId:(long long)flagId {
  NSString *methodName = @"flagengine.flags.delete";
  GTLQueryFlagengine *query = [self queryWithMethodName:methodName];
  query.flagId = flagId;
  return query;
}

+ (id)queryForFlagsInsertWithObject:(GTLFlagengineFlag *)object {
  if (object == nil) {
    GTL_DEBUG_ASSERT(object != nil, @"%@ got a nil object", NSStringFromSelector(_cmd));
    return nil;
  }
  NSString *methodName = @"flagengine.flags.insert";
  GTLQueryFlagengine *query = [self queryWithMethodName:methodName];
  query.bodyObject = object;
  query.expectedObjectClass = [GTLFlagengineFlag class];
  return query;
}

#pragma mark -
#pragma mark "flags.list" methods
// These create a GTLQueryFlagengine object.

+ (id)queryForFlagsListAll {
  NSString *methodName = @"flagengine.flags.list.all";
  GTLQueryFlagengine *query = [self queryWithMethodName:methodName];
  query.expectedObjectClass = [GTLFlagengineFlagCollection class];
  return query;
}

+ (id)queryForFlagsListByitem {
  NSString *methodName = @"flagengine.flags.list.byitem";
  GTLQueryFlagengine *query = [self queryWithMethodName:methodName];
  query.expectedObjectClass = [GTLFlagengineFlagCollection class];
  return query;
}

#pragma mark -
#pragma mark "flags.list.byitem" methods
// These create a GTLQueryFlagengine object.

+ (id)queryForFlagsListByitemReward {
  NSString *methodName = @"flagengine.flags.list.byitem.reward";
  GTLQueryFlagengine *query = [self queryWithMethodName:methodName];
  query.expectedObjectClass = [GTLFlagengineFlagCollection class];
  return query;
}

#pragma mark -
#pragma mark "flags.list" methods
// These create a GTLQueryFlagengine object.

+ (id)queryForFlagsListByreward {
  NSString *methodName = @"flagengine.flags.list.byreward";
  GTLQueryFlagengine *query = [self queryWithMethodName:methodName];
  query.expectedObjectClass = [GTLFlagengineFlagCollection class];
  return query;
}

+ (id)queryForFlagsListByshop {
  NSString *methodName = @"flagengine.flags.list.byshop";
  GTLQueryFlagengine *query = [self queryWithMethodName:methodName];
  query.expectedObjectClass = [GTLFlagengineFlagCollection class];
  return query;
}

+ (id)queryForFlagsListNear {
  NSString *methodName = @"flagengine.flags.list.near";
  GTLQueryFlagengine *query = [self queryWithMethodName:methodName];
  query.expectedObjectClass = [GTLFlagengineFlagCollection class];
  return query;
}

+ (id)queryForFlagsListRange {
  NSString *methodName = @"flagengine.flags.list.range";
  GTLQueryFlagengine *query = [self queryWithMethodName:methodName];
  query.expectedObjectClass = [GTLFlagengineFlagCollection class];
  return query;
}

#pragma mark -
#pragma mark "images.uploadUrl" methods
// These create a GTLQueryFlagengine object.

+ (id)queryForImagesUploadUrlGet {
  NSString *methodName = @"flagengine.images.uploadUrl.get";
  GTLQueryFlagengine *query = [self queryWithMethodName:methodName];
  query.expectedObjectClass = [GTLFlagengineUploadUrl class];
  return query;
}

#pragma mark -
#pragma mark "items.branch" methods
// These create a GTLQueryFlagengine object.

+ (id)queryForItemsBranchExposeWithObject:(GTLFlagengineBranchItemMatcher *)object {
  if (object == nil) {
    GTL_DEBUG_ASSERT(object != nil, @"%@ got a nil object", NSStringFromSelector(_cmd));
    return nil;
  }
  NSString *methodName = @"flagengine.items.branch.expose";
  GTLQueryFlagengine *query = [self queryWithMethodName:methodName];
  query.bodyObject = object;
  query.expectedObjectClass = [GTLFlagengineBranchItemMatcher class];
  return query;
}

+ (id)queryForItemsBranchHide {
  NSString *methodName = @"flagengine.items.branch.hide";
  GTLQueryFlagengine *query = [self queryWithMethodName:methodName];
  return query;
}

+ (id)queryForItemsBranchRewardWithObject:(GTLFlagengineBranchItemMatcher *)object {
  if (object == nil) {
    GTL_DEBUG_ASSERT(object != nil, @"%@ got a nil object", NSStringFromSelector(_cmd));
    return nil;
  }
  NSString *methodName = @"flagengine.items.branch.reward";
  GTLQueryFlagengine *query = [self queryWithMethodName:methodName];
  query.bodyObject = object;
  query.expectedObjectClass = [GTLFlagengineBranchItemMatcher class];
  return query;
}

#pragma mark -
#pragma mark "items" methods
// These create a GTLQueryFlagengine object.

+ (id)queryForItemsDelete {
  NSString *methodName = @"flagengine.items.delete";
  GTLQueryFlagengine *query = [self queryWithMethodName:methodName];
  return query;
}

+ (id)queryForItemsGet {
  NSString *methodName = @"flagengine.items.get";
  GTLQueryFlagengine *query = [self queryWithMethodName:methodName];
  query.expectedObjectClass = [GTLFlagengineItem class];
  return query;
}

+ (id)queryForItemsInit {
  NSString *methodName = @"flagengine.items.init";
  GTLQueryFlagengine *query = [self queryWithMethodName:methodName];
  query.expectedObjectClass = [GTLFlagengineItemCollection class];
  return query;
}

+ (id)queryForItemsInsertWithObject:(GTLFlagengineItem *)object {
  if (object == nil) {
    GTL_DEBUG_ASSERT(object != nil, @"%@ got a nil object", NSStringFromSelector(_cmd));
    return nil;
  }
  NSString *methodName = @"flagengine.items.insert";
  GTLQueryFlagengine *query = [self queryWithMethodName:methodName];
  query.bodyObject = object;
  query.expectedObjectClass = [GTLFlagengineItem class];
  return query;
}

+ (id)queryForItemsList {
  NSString *methodName = @"flagengine.items.list";
  GTLQueryFlagengine *query = [self queryWithMethodName:methodName];
  query.expectedObjectClass = [GTLFlagengineItemCollection class];
  return query;
}

#pragma mark -
#pragma mark "items.list" methods
// These create a GTLQueryFlagengine object.

+ (id)queryForItemsListIds {
  NSString *methodName = @"flagengine.items.list.ids";
  GTLQueryFlagengine *query = [self queryWithMethodName:methodName];
  query.expectedObjectClass = [GTLFlagengineItemCollection class];
  return query;
}

+ (id)queryForItemsListItem {
  NSString *methodName = @"flagengine.items.list.item";
  GTLQueryFlagengine *query = [self queryWithMethodName:methodName];
  query.expectedObjectClass = [GTLFlagengineItemCollection class];
  return query;
}

+ (id)queryForItemsListManager {
  NSString *methodName = @"flagengine.items.list.manager";
  GTLQueryFlagengine *query = [self queryWithMethodName:methodName];
  query.expectedObjectClass = [GTLFlagengineItemCollection class];
  return query;
}

+ (id)queryForItemsListReward {
  NSString *methodName = @"flagengine.items.list.reward";
  GTLQueryFlagengine *query = [self queryWithMethodName:methodName];
  query.expectedObjectClass = [GTLFlagengineItemCollection class];
  return query;
}

+ (id)queryForItemsListUser {
  NSString *methodName = @"flagengine.items.list.user";
  GTLQueryFlagengine *query = [self queryWithMethodName:methodName];
  query.expectedObjectClass = [GTLFlagengineItemCollection class];
  return query;
}

#pragma mark -
#pragma mark "items" methods
// These create a GTLQueryFlagengine object.

+ (id)queryForItemsPatch {
  NSString *methodName = @"flagengine.items.patch";
  GTLQueryFlagengine *query = [self queryWithMethodName:methodName];
  query.expectedObjectClass = [GTLFlagengineItem class];
  return query;
}

+ (id)queryForItemsUpdateWithObject:(GTLFlagengineItem *)object {
  if (object == nil) {
    GTL_DEBUG_ASSERT(object != nil, @"%@ got a nil object", NSStringFromSelector(_cmd));
    return nil;
  }
  NSString *methodName = @"flagengine.items.update";
  GTLQueryFlagengine *query = [self queryWithMethodName:methodName];
  query.bodyObject = object;
  query.expectedObjectClass = [GTLFlagengineItem class];
  return query;
}

#pragma mark -
#pragma mark "likes" methods
// These create a GTLQueryFlagengine object.

+ (id)queryForLikesDelete {
  NSString *methodName = @"flagengine.likes.delete";
  GTLQueryFlagengine *query = [self queryWithMethodName:methodName];
  return query;
}

+ (id)queryForLikesInsertWithObject:(GTLFlagengineLike *)object {
  if (object == nil) {
    GTL_DEBUG_ASSERT(object != nil, @"%@ got a nil object", NSStringFromSelector(_cmd));
    return nil;
  }
  NSString *methodName = @"flagengine.likes.insert";
  GTLQueryFlagengine *query = [self queryWithMethodName:methodName];
  query.bodyObject = object;
  query.expectedObjectClass = [GTLFlagengineLike class];
  return query;
}

#pragma mark -
#pragma mark "logs" methods
// These create a GTLQueryFlagengine object.

+ (id)queryForLogsGet {
  NSString *methodName = @"flagengine.logs.get";
  GTLQueryFlagengine *query = [self queryWithMethodName:methodName];
  query.expectedObjectClass = [GTLFlagengineLogCollection class];
  return query;
}

+ (id)queryForLogsInsertWithObject:(GTLFlagengineLog *)object {
  if (object == nil) {
    GTL_DEBUG_ASSERT(object != nil, @"%@ got a nil object", NSStringFromSelector(_cmd));
    return nil;
  }
  NSString *methodName = @"flagengine.logs.insert";
  GTLQueryFlagengine *query = [self queryWithMethodName:methodName];
  query.bodyObject = object;
  query.expectedObjectClass = [GTLFlagengineLog class];
  return query;
}

#pragma mark -
#pragma mark "logs.insert" methods
// These create a GTLQueryFlagengine object.

+ (id)queryForLogsInsertIvpairWithObject:(GTLFlagengineItemViewPair *)object {
  if (object == nil) {
    GTL_DEBUG_ASSERT(object != nil, @"%@ got a nil object", NSStringFromSelector(_cmd));
    return nil;
  }
  NSString *methodName = @"flagengine.logs.insert.ivpair";
  GTLQueryFlagengine *query = [self queryWithMethodName:methodName];
  query.bodyObject = object;
  query.expectedObjectClass = [GTLFlagengineItemViewPair class];
  return query;
}

#pragma mark -
#pragma mark "providers" methods
// These create a GTLQueryFlagengine object.

+ (id)queryForProvidersGetWithObject:(GTLFlagengineProviderForm *)object {
  if (object == nil) {
    GTL_DEBUG_ASSERT(object != nil, @"%@ got a nil object", NSStringFromSelector(_cmd));
    return nil;
  }
  NSString *methodName = @"flagengine.providers.get";
  GTLQueryFlagengine *query = [self queryWithMethodName:methodName];
  query.bodyObject = object;
  query.expectedObjectClass = [GTLFlagengineProvider class];
  return query;
}

+ (id)queryForProvidersInsertWithObject:(GTLFlagengineProviderForm *)object {
  if (object == nil) {
    GTL_DEBUG_ASSERT(object != nil, @"%@ got a nil object", NSStringFromSelector(_cmd));
    return nil;
  }
  NSString *methodName = @"flagengine.providers.insert";
  GTLQueryFlagengine *query = [self queryWithMethodName:methodName];
  query.bodyObject = object;
  query.expectedObjectClass = [GTLFlagengineProvider class];
  return query;
}

#pragma mark -
#pragma mark "redeems" methods
// These create a GTLQueryFlagengine object.

+ (id)queryForRedeemsInsertWithObject:(GTLFlagengineRedeem *)object {
  if (object == nil) {
    GTL_DEBUG_ASSERT(object != nil, @"%@ got a nil object", NSStringFromSelector(_cmd));
    return nil;
  }
  NSString *methodName = @"flagengine.redeems.insert";
  GTLQueryFlagengine *query = [self queryWithMethodName:methodName];
  query.bodyObject = object;
  query.expectedObjectClass = [GTLFlagengineRedeem class];
  return query;
}

+ (id)queryForRedeemsList {
  NSString *methodName = @"flagengine.redeems.list";
  GTLQueryFlagengine *query = [self queryWithMethodName:methodName];
  query.expectedObjectClass = [GTLFlagengineRedeemCollection class];
  return query;
}

#pragma mark -
#pragma mark "rewards" methods
// These create a GTLQueryFlagengine object.

+ (id)queryForRewardsInsertWithObject:(GTLFlagengineReward *)object {
  if (object == nil) {
    GTL_DEBUG_ASSERT(object != nil, @"%@ got a nil object", NSStringFromSelector(_cmd));
    return nil;
  }
  NSString *methodName = @"flagengine.rewards.insert";
  GTLQueryFlagengine *query = [self queryWithMethodName:methodName];
  query.bodyObject = object;
  query.expectedObjectClass = [GTLFlagengineUser class];
  return query;
}

+ (id)queryForRewardsList {
  NSString *methodName = @"flagengine.rewards.list";
  GTLQueryFlagengine *query = [self queryWithMethodName:methodName];
  query.expectedObjectClass = [GTLFlagengineRewardCollection class];
  return query;
}

#pragma mark -
#pragma mark "shops" methods
// These create a GTLQueryFlagengine object.

+ (id)queryForShopsDeleteWithShopId:(long long)shopId {
  NSString *methodName = @"flagengine.shops.delete";
  GTLQueryFlagengine *query = [self queryWithMethodName:methodName];
  query.shopId = shopId;
  return query;
}

+ (id)queryForShopsGet {
  NSString *methodName = @"flagengine.shops.get";
  GTLQueryFlagengine *query = [self queryWithMethodName:methodName];
  query.expectedObjectClass = [GTLFlagengineShop class];
  return query;
}

+ (id)queryForShopsInit {
  NSString *methodName = @"flagengine.shops.init";
  GTLQueryFlagengine *query = [self queryWithMethodName:methodName];
  query.expectedObjectClass = [GTLFlagengineShopCollection class];
  return query;
}

+ (id)queryForShopsInsertWithObject:(GTLFlagengineShop *)object {
  if (object == nil) {
    GTL_DEBUG_ASSERT(object != nil, @"%@ got a nil object", NSStringFromSelector(_cmd));
    return nil;
  }
  NSString *methodName = @"flagengine.shops.insert";
  GTLQueryFlagengine *query = [self queryWithMethodName:methodName];
  query.bodyObject = object;
  query.expectedObjectClass = [GTLFlagengineShop class];
  return query;
}

+ (id)queryForShopsList {
  NSString *methodName = @"flagengine.shops.list";
  GTLQueryFlagengine *query = [self queryWithMethodName:methodName];
  query.expectedObjectClass = [GTLFlagengineShopCollection class];
  return query;
}

#pragma mark -
#pragma mark "shops.list" methods
// These create a GTLQueryFlagengine object.

+ (id)queryForShopsListProvider {
  NSString *methodName = @"flagengine.shops.list.provider";
  GTLQueryFlagengine *query = [self queryWithMethodName:methodName];
  query.expectedObjectClass = [GTLFlagengineShopCollection class];
  return query;
}

+ (id)queryForShopsListReward {
  NSString *methodName = @"flagengine.shops.list.reward";
  GTLQueryFlagengine *query = [self queryWithMethodName:methodName];
  query.expectedObjectClass = [GTLFlagengineShopCollection class];
  return query;
}

#pragma mark -
#pragma mark "shops" methods
// These create a GTLQueryFlagengine object.

+ (id)queryForShopsPatch {
  NSString *methodName = @"flagengine.shops.patch";
  GTLQueryFlagengine *query = [self queryWithMethodName:methodName];
  query.expectedObjectClass = [GTLFlagengineShop class];
  return query;
}

#pragma mark -
#pragma mark "shops.recommend" methods
// These create a GTLQueryFlagengine object.

+ (id)queryForShopsRecommendNear {
  NSString *methodName = @"flagengine.shops.recommend.near";
  GTLQueryFlagengine *query = [self queryWithMethodName:methodName];
  query.expectedObjectClass = [GTLFlagengineShop class];
  return query;
}

#pragma mark -
#pragma mark "shops" methods
// These create a GTLQueryFlagengine object.

+ (id)queryForShopsStart {
  NSString *methodName = @"flagengine.shops.start";
  GTLQueryFlagengine *query = [self queryWithMethodName:methodName];
  query.expectedObjectClass = [GTLFlagengineShopCollection class];
  return query;
}

+ (id)queryForShopsUpdateWithObject:(GTLFlagengineShop *)object {
  if (object == nil) {
    GTL_DEBUG_ASSERT(object != nil, @"%@ got a nil object", NSStringFromSelector(_cmd));
    return nil;
  }
  NSString *methodName = @"flagengine.shops.update";
  GTLQueryFlagengine *query = [self queryWithMethodName:methodName];
  query.bodyObject = object;
  query.expectedObjectClass = [GTLFlagengineShop class];
  return query;
}

#pragma mark -
#pragma mark "userinfos" methods
// These create a GTLQueryFlagengine object.

+ (id)queryForUserinfosGet {
  NSString *methodName = @"flagengine.userinfos.get";
  GTLQueryFlagengine *query = [self queryWithMethodName:methodName];
  query.expectedObjectClass = [GTLFlagengineUserInfo class];
  return query;
}

#pragma mark -
#pragma mark "userInfos" methods
// These create a GTLQueryFlagengine object.

+ (id)queryForUserInfosPatch {
  NSString *methodName = @"flagengine.userInfos.patch";
  GTLQueryFlagengine *query = [self queryWithMethodName:methodName];
  query.expectedObjectClass = [GTLFlagengineUserInfo class];
  return query;
}

#pragma mark -
#pragma mark "userinfos.phone" methods
// These create a GTLQueryFlagengine object.

+ (id)queryForUserinfosPhoneInsertWithObject:(GTLFlagengineUserInfo *)object {
  if (object == nil) {
    GTL_DEBUG_ASSERT(object != nil, @"%@ got a nil object", NSStringFromSelector(_cmd));
    return nil;
  }
  NSString *methodName = @"flagengine.userinfos.phone.insert";
  GTLQueryFlagengine *query = [self queryWithMethodName:methodName];
  query.bodyObject = object;
  query.expectedObjectClass = [GTLFlagengineUserInfo class];
  return query;
}

+ (id)queryForUserinfosPhoneTestWithObject:(GTLFlagengineUserInfo *)object {
  if (object == nil) {
    GTL_DEBUG_ASSERT(object != nil, @"%@ got a nil object", NSStringFromSelector(_cmd));
    return nil;
  }
  NSString *methodName = @"flagengine.userinfos.phone.test";
  GTLQueryFlagengine *query = [self queryWithMethodName:methodName];
  query.bodyObject = object;
  query.expectedObjectClass = [GTLFlagengineUserInfo class];
  return query;
}

#pragma mark -
#pragma mark "userInfos" methods
// These create a GTLQueryFlagengine object.

+ (id)queryForUserInfosUpdateWithObject:(GTLFlagengineUserInfo *)object {
  if (object == nil) {
    GTL_DEBUG_ASSERT(object != nil, @"%@ got a nil object", NSStringFromSelector(_cmd));
    return nil;
  }
  NSString *methodName = @"flagengine.userInfos.update";
  GTLQueryFlagengine *query = [self queryWithMethodName:methodName];
  query.bodyObject = object;
  query.expectedObjectClass = [GTLFlagengineUserInfo class];
  return query;
}

#pragma mark -
#pragma mark "users" methods
// These create a GTLQueryFlagengine object.

+ (id)queryForUsersGetWithObject:(GTLFlagengineUserForm *)object {
  if (object == nil) {
    GTL_DEBUG_ASSERT(object != nil, @"%@ got a nil object", NSStringFromSelector(_cmd));
    return nil;
  }
  NSString *methodName = @"flagengine.users.get";
  GTLQueryFlagengine *query = [self queryWithMethodName:methodName];
  query.bodyObject = object;
  query.expectedObjectClass = [GTLFlagengineUser class];
  return query;
}

+ (id)queryForUsersGuest {
  NSString *methodName = @"flagengine.users.guest";
  GTLQueryFlagengine *query = [self queryWithMethodName:methodName];
  query.expectedObjectClass = [GTLFlagengineUser class];
  return query;
}

+ (id)queryForUsersInsertWithObject:(GTLFlagengineUserForm *)object {
  if (object == nil) {
    GTL_DEBUG_ASSERT(object != nil, @"%@ got a nil object", NSStringFromSelector(_cmd));
    return nil;
  }
  NSString *methodName = @"flagengine.users.insert";
  GTLQueryFlagengine *query = [self queryWithMethodName:methodName];
  query.bodyObject = object;
  query.expectedObjectClass = [GTLFlagengineUser class];
  return query;
}

+ (id)queryForUsersRetainWithObject:(GTLFlagengineRetainForm *)object {
  if (object == nil) {
    GTL_DEBUG_ASSERT(object != nil, @"%@ got a nil object", NSStringFromSelector(_cmd));
    return nil;
  }
  NSString *methodName = @"flagengine.users.retain";
  GTLQueryFlagengine *query = [self queryWithMethodName:methodName];
  query.bodyObject = object;
  query.expectedObjectClass = [GTLFlagengineUser class];
  return query;
}

@end
