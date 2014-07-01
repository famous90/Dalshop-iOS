//
//  Redeem.m
//  flag-ios
//
//  Created by Gyuyoung Hwang on 2014. 3. 3..
//
//

#import "Redeem.h"

@implementation Redeem

- (id)initWithData:(id)data
{
    self = [super init];
    if (self) {
        
        self.redeemId = [data valueForKey:@"redeemId"];
        self.imageUrl = [data valueForKey:@"imageUrl"];
        self.name = [data valueForKey:@"name"];
        self.price = [[data valueForKey:@"price"] integerValue];
        self.vendor = [data valueForKey:@"vendor"];
        
    }
    return self;
}

@end
