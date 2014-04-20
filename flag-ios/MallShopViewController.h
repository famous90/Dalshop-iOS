//
//  MallShopViewController.h
//  flag-ios
//
//  Created by Gyuyoung Hwang on 2014. 2. 6..
//
//

#import <UIKit/UIKit.h>

@class User;

@interface MallShopViewController : UITableViewController

@property (nonatomic, strong) User *user;
@property (nonatomic, assign) NSInteger parentPage;
@property (nonatomic, strong) NSNumber *shopId;
@property (nonatomic, strong) NSString *shopName;

- (IBAction)cancel:(id)sender;

@end
