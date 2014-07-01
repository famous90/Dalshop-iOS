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
@class FlagDataController;

@interface ShopListViewController : UITableViewController

@property (nonatomic, strong) User *user;
//@property (nonatomic, strong) FlagDataController *flagData;
@property (nonatomic, assign) NSInteger parentPage;
//@property (nonatomic, weak) CLLocation *currentLocation;

- (IBAction)cancel:(id)sender;

@end
