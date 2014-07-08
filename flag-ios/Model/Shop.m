//
//  Shop.m
//  flag-ios
//
//  Created by Gyuyoung Hwang on 2014. 2. 5..
//
//

#import "Shop.h"

#import "DataUtil.h"

@implementation Shop

- (id)initWithData:(id)data
{
    self = [super init];
    if (self) {
        _shopId = [data valueForKey:@"id"];
        _parentId = [data valueForKey:@"parentId"];
        _providerId = [data valueForKey:@"providerId"];
        _name = [data valueForKey:@"name"];
        _logoUrl = [data valueForKey:@"logoUrl"];
        _imageUrl = [data valueForKey:@"imageUrl"];
        _description = [data valueForKey:@"description"];
        _type = [[data valueForKey:@"type"] integerValue];
        _reward = [[data valueForKey:@"reward"] longValue];
        _rewarded= [DataUtil isObjectRewarded:self.shopId type:REWARD_CHECKIN];
        _liked = [DataUtil isObjectLiked:self.shopId type:LIKE_SHOP];
        _likes = [[data valueForKey:@"likes"] longValue];
        _onSale = [[data valueForKey:@"onSale"] boolValue];
    }

    return self;
}

- (BOOL)isShopLiked
{
    return _liked;
}

- (void)likeShop
{
    _liked = YES;
    _likes++;
}

- (void)canceLikeShop
{
    _liked = NO;
    _likes--;
}

- (NSInteger)getCheckInStateType
{
    if (_reward == 0) {
        return REWARD_STATE_DISABLED;
    }else{
        if (_rewarded) {
            return REWARD_STATE_DONE;
        }else return REWARD_STATE_BEFORE;
    }
}

@end
