//
//  Like.m
//  Dalshop
//
//  Created by Hwang Gyuyoung on 2014. 6. 11..
//
//

#import "Like.h"

@implementation Like

- (id)initWithCoreData:(id)data type:(NSInteger)type
{
    self = [super init];
    if (self) {
        
        if (type == LIKE_ITEM) {
            _objectId = [data valueForKey:@"itemId"];
        }else if (type == LIKE_SHOP){
            _objectId = [data valueForKey:@"shopId"];
        }
        _createdAt = [data valueForKey:@"createdAt"];
        _updatedAt = [data valueForKey:@"updatedAt"];
    }
    return self;
}

@end
