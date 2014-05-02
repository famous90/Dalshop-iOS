//
//  Item.m
//  flag-ios
//
//  Created by Gyuyoung Hwang on 2014. 2. 6..
//
//

#import "Item.h"

@implementation Item

- (id)initWithData:(id)data
{
    self = [super init];
    if (self) {
        _itemId = [data valueForKey:@"id"];
        _shopId = [data valueForKey:@"shopId"];
        _name = [data valueForKey:@"name"];
        _thumbnailUrl = [data valueForKey:@"thumbnailUrl"];
//        _imageUrl = [data valueForKey:@"imageUrl"];
        _description = [data valueForKey:@"description"];
        _sale = [[data valueForKey:@"sale"] integerValue];
        _oldPrice = [data valueForKey:@"oldPrice"];
        _price = [data valueForKey:@"price"];
        _barcodeId = [data valueForKey:@"barcodeId"];
        _reward = [[data valueForKey:@"reward"] integerValue];
        _rewarded = [[data valueForKey:@"rewarded"] boolValue];
        _rewardable = [[data valueForKey:@"rewardable"] boolValue];
        _likes = [[data valueForKey:@"likes"] integerValue];
        _liked = [[data valueForKey:@"liked"] boolValue];
    }
    return self;
}

- (BOOL)isEqualToCodeString:(NSString *)barcodeId
{
    if ([self.barcodeId isEqualToString:barcodeId]) {
        return YES;
    }else return NO;
}

- (void)didRewardItem
{
    _rewarded = YES;
}

@end
