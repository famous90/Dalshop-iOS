//
//  RewardHistoryViewController.h
//  flag-ios
//
//  Created by Gyuyoung Hwang on 2014. 2. 22..
//
//

#import <UIKit/UIKit.h>

@class User;

@interface RewardHistoryViewController : UITableViewController

@property (nonatomic, strong) User *user;
@property (nonatomic, assign) NSInteger parentPage;

@end
