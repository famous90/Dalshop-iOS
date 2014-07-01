//
//  ShopInfoViewController.h
//  flag-ios
//
//  Created by Gyuyoung Hwang on 2014. 2. 6..
//
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@class User;
@class Shop;

@interface ShopInfoViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *shopNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *shopRewardLabel;
@property (weak, nonatomic) IBOutlet UILabel *shopSalePercentageLabel;
@property (weak, nonatomic) IBOutlet UIImageView *shopImageView;
@property (weak, nonatomic) IBOutlet UIImageView *scanRewardImageView;
@property (weak, nonatomic) IBOutlet UIImageView *shopSaleImageView;

@property (nonatomic, strong) User *user;
@property (nonatomic, strong) Shop *shop;
//@property (nonatomic, strong) NSNumber *shopId;
//@property (nonatomic, strong) NSString *shopName;


- (void)configureShopScanRewardInfo;
- (void)configureShopSaleInfo;
- (IBAction)shopInfoViewTapped:(id)sender;

@end
