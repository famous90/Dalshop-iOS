//
//  SaleInfoViewController.h
//  flag-ios
//
//  Created by Gyuyoung Hwang on 2014. 3. 4..
//
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@class User;
@class Shop;
@class Flag;

@interface SaleInfoViewController : UITableViewController

@property (nonatomic, strong) User *user;
@property (nonatomic, strong) Shop *shop;
@property (nonatomic, strong) Flag *flag;
@property (nonatomic, assign) NSInteger parentPage;
@property (nonatomic, strong) NSNumber *shopId;

- (IBAction)cancelButtonTapped:(id)sender;

@end
