//
//  ShopListViewController.h
//  flag-ios
//
//  Created by Gyuyoung Hwang on 2014. 2. 6..
//
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@class User;

@interface ShopListViewController : UITableViewController

@property (nonatomic, strong) User *user;
@property (nonatomic, assign) NSInteger parentPage;

- (IBAction)cancel:(id)sender;

@end
