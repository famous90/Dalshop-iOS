//
//  RewardDataController.m
//  flag-ios
//
//  Created by Gyuyoung Hwang on 2014. 2. 22..
//
//

#import "RewardDataController.h"
#import "Reward.h"

#import "NSDate+Utils.h"

@interface RewardDataController()

//- (NSInteger)rewardDateExistInListWithDate:(NSString *)dateString;

@end
@implementation RewardDataController

- (void)initForTest
{
    Reward *reward1 = [[Reward alloc] init];
    Reward *reward2 = [[Reward alloc] init];
    Reward *reward3 = [[Reward alloc] init];
    Reward *reward4 = [[Reward alloc] init];
    Reward *reward5 = [[Reward alloc] init];
    Reward *reward6 = [[Reward alloc] init];
    
    reward1.createdAt = [[NSDate date] timeIntervalSince1970] - 7200;
    reward1.targetId = [NSNumber numberWithInt:1];
    reward1.targetName = @"GORGIO ARMANI";
    reward1.type = 1;
    reward1.reward = 1000;
    
    reward2.createdAt = [[NSDate date] timeIntervalSince1970] - 518400;
    reward2.targetId = [NSNumber numberWithInt:2];
    reward2.targetName = @"Celvin Klain";
    reward2.type = 2;
    reward2.reward = 2000;
    
    reward3.createdAt = [[NSDate date] timeIntervalSince1970] - 172800;
    reward3.targetId = [NSNumber numberWithInt:3];
    reward3.targetName = @"UNIQLO";
    reward3.type = 1;
    reward3.reward = 3500;
    
    reward4.createdAt = [[NSDate date] timeIntervalSince1970] - 3600;
    reward4.targetId = [NSNumber numberWithInt:1];
    reward4.targetName = @"GORGIO ARMANI";
    reward4.type = 2;
    reward4.reward = 500;
    
    reward5.createdAt = [[NSDate date] timeIntervalSince1970] - 7200;
    reward5.targetId = [NSNumber numberWithInt:1];
    reward5.targetName = @"GORGIO ARMANI";
    reward5.type = 1;
    reward5.reward = 12000;
    
    reward6.createdAt = [[NSDate date] timeIntervalSince1970] - 172800;
    reward6.targetId = [NSNumber numberWithInt:3];
    reward6.targetName = @"UNIQLO";
    reward6.type = 2;
    reward6.reward = 500;
    
    [self addObjectWithObject:reward1];
    [self addObjectWithObject:reward2];
    [self addObjectWithObject:reward3];
    [self addObjectWithObject:reward4];
    [self addObjectWithObject:reward5];
    [self addObjectWithObject:reward6];
    
    NSLog(@"%@", reward1.targetName);
    NSLog(@"%@", reward2.targetName);
    NSLog(@"%@", reward3.targetName);
    NSLog(@"%@", reward4.targetName);
    NSLog(@"%@", reward5.targetName);
    NSLog(@"%@", reward6.targetName);
    NSLog(@"%@", self.masterData);
}

- (void)addObjectWithObject:(id)object
{
    NSString *dateString = [NSDate dateAtTime:[(Reward *)object createdAt] withFormat:DATE_FORMAT_YYYYMMDD];
    NSInteger objectIndex = [self rewardDateExistInListWithDate:dateString];
    // reward date does not exist
    if (objectIndex == [self.masterData count]) {
        
        NSMutableArray *onedayRewardArray = [[NSMutableArray alloc] initWithObjects:dateString, nil];
        [onedayRewardArray addObject:object];
        [self.masterData addObject:onedayRewardArray];
        
        // reward date exist
    }else{
        
        [[self objectInListAtIndex:objectIndex] addObject:object];
    }
}

- (NSInteger)rewardDateExistInListWithDate:(NSString *)dateString
{
    for(int i=0; i<[self countOfList]; i++){
        if ([[[self objectInListAtIndex:i] objectAtIndex:0] isEqualToString:dateString]) {
            return i;
        }
    }
    return [self.masterData count];
}

- (NSUInteger)countOfOnedayRewardAtIndex:(NSInteger)index
{
    if (index < [self.masterData count]) {
        return [[self.masterData objectAtIndex:index] count];
    }else return 0;
}

- (NSString *)dateStringAtIndex:(NSInteger)index
{
    return [[self.masterData objectAtIndex:index] objectAtIndex:0];
}

- (Reward *)objectAtIndex:(NSInteger)index rewardIndex:(NSInteger)rewardIndex
{
    if ((rewardIndex != 0) && (rewardIndex < [self countOfOnedayRewardAtIndex:index])) {
        return [[self.masterData objectAtIndex:index] objectAtIndex:rewardIndex];
    }else return nil;
}
@end
