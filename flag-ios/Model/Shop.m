//
//  Shop.m
//  flag-ios
//
//  Created by Gyuyoung Hwang on 2014. 2. 5..
//
//

#import "Shop.h"

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
        _rewarded= [[data valueForKey:@"rewarded"] boolValue];
        _liked = [[data valueForKey:@"liked"] boolValue];
        _likes = [[data valueForKey:@"likes"] longValue];
    }
    return self;
}

@end
