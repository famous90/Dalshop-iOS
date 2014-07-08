//
//  Item.m
//  flag-ios
//
//  Created by Gyuyoung Hwang on 2014. 2. 6..
//
//

#import "Item.h"

#import "Util.h"
#import "DataUtil.h"

@implementation Item

- (id)initWithData:(id)data
{
    self = [super init];
    if (self) {
        _itemId = [data valueForKey:@"id"];
        _shopId = [data valueForKey:@"shopId"];
        _name = [data valueForKey:@"name"];
        _thumbnailUrl = [data valueForKey:@"thumbnailUrl"];
        _description = [data valueForKey:@"description"];
        _sale = [[data valueForKey:@"sale"] integerValue];
        _oldPrice = [data valueForKey:@"oldPrice"];
        _price = [data valueForKey:@"price"];
        _barcodeId = [data valueForKey:@"barcodeId"];
        _reward = [[data valueForKey:@"reward"] integerValue];
        _rewarded = [DataUtil isObjectRewarded:self.itemId type:REWARD_SCAN];
        _rewardable = [[data valueForKey:@"rewardable"] boolValue];
        _likes = [[data valueForKey:@"likes"] integerValue];
        _liked = [DataUtil isObjectLiked:self.itemId type:LIKE_ITEM];
        _sex = [[data valueForKey:@"sex"] boolValue];
        _type = [[data valueForKey:@"type"] integerValue];
    }
    return self;
}

- (BOOL)isEqualToCodeString:(NSString *)barcodeId
{
    return [Util isContainedSubString:self.barcodeId inString:barcodeId];
}

- (void)didRewardItem
{
    _rewarded = YES;
}

- (BOOL)isItemLiked
{
    return _liked;
}

- (void)likeItem
{
    _liked = YES;
    _likes++;
}

- (void)cancelLikeItem
{
    _liked = NO;
    _likes--;
}

- (BOOL)hasOldPrice
{
    if (_oldPrice) {
        return YES;
    }else return NO;
}

- (NSInteger)getRewardState
{
    if (_rewardable) {
        if (_rewarded) {
            return REWARD_STATE_DONE;
        }else return REWARD_STATE_BEFORE;
    }else return REWARD_STATE_DISABLED;
}

@end
