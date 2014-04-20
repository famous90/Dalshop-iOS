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

@interface ShopInfoViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *shopNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *shopRewardLabel;
@property (weak, nonatomic) IBOutlet UILabel *shopSalePercentageLabel;
@property (weak, nonatomic) IBOutlet UIImageView *shopImageView;

@property (nonatomic, strong) User *user;
@property (nonatomic, strong) NSNumber *shopId;
@property (nonatomic, strong) NSString *shopName;

- (IBAction)shopInfoViewTapped:(id)sender;
@end
