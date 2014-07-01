//
//  RedeemDataController.m
//  Dalshop
//
//  Created by Hwang Gyuyoung on 2014. 5. 30..
//
//

#import "RedeemDataController.h"

#import "Redeem.h"

@implementation RedeemDataController

- (void)initForTest
{
    Redeem *redeem = [[Redeem alloc] init];
    redeem.redeemId = [NSNumber numberWithInteger:1];
    redeem.name = @"아이폰짝퉁";
    redeem.price = 100000;
    redeem.vendor = @"중국산 한국제품";
    redeem.imageUrl = @"https://genuine-evening-455.appspot.com/serve?blob-key=AMIfv94MYPq8WbgIiHbDJDbQ7Tr--8iEo5ksQeH9p8X01pAPyiaUOe6PQ4_uz1TI1xFYe7E7LXIrwY0ApjW77xgSquGy7E8DQV7lJQPT9IpiXfZAEPNmMOPgj3XkY_NIWkhyhqwfgZYAaOYeFw7U6lQMRoPolNT6zzy6M39pZ1vJOfdyo9RB1b8";
    
    [self addObjectWithObject:redeem];
    [self addObjectWithObject:redeem];
    [self addObjectWithObject:redeem];
    [self addObjectWithObject:redeem];
    [self addObjectWithObject:redeem];
    [self addObjectWithObject:redeem];
    [self addObjectWithObject:redeem];
    [self addObjectWithObject:redeem];
    [self addObjectWithObject:redeem];
    [self addObjectWithObject:redeem];
    [self addObjectWithObject:redeem];

}

@end
