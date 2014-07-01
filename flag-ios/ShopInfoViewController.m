//
//  ShopInfoViewController.m
//  flag-ios
//
//  Created by Gyuyoung Hwang on 2014. 2. 6..
//
//

#import "AppDelegate.h"
#import "ShopInfoViewController.h"
#import "SaleInfoViewController.h"

#import "User.h"
#import "Shop.h"

#import "ViewUtil.h"

#import "GoogleAnalytics.h"

@interface ShopInfoViewController ()

@property (nonatomic, weak) AppDelegate *appDelegate;

@end

@implementation ShopInfoViewController{
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.user = [[User alloc] init];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    CALayer *topBorder = [CALayer layer];
    topBorder.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width, 0.5f);
    topBorder.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.1f].CGColor;
    
    [self.view.layer addSublayer:topBorder];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self setUser:[DelegateUtil getUser]];
}

#pragma mark -
#pragma mark Implementation
- (void)configureShopScanRewardInfo
{
    [self.scanRewardImageView setHidden:!self.shop.reward];
}

- (void)configureShopSaleInfo
{
    [self.shopSaleImageView setHidden:!self.shop.onSale];
}

#pragma mark - 
#pragma mark - IBAction
- (IBAction)shopInfoViewTapped:(id)sender
{
    // GA
    [GAUtil sendGADataWithUIAction:@"go_to_shop" label:@"escape_view" value:nil];
    
    
    // change view
    UIStoryboard *storyborad = [ViewUtil getStoryboard];
    
    SaleInfoViewController *childViewController = (SaleInfoViewController *)[storyborad instantiateViewControllerWithIdentifier:@"SaleInfoView"];
    
    childViewController.user = self.user;
    childViewController.shopId = self.shop.shopId;
    childViewController.parentPage = SHOP_INFO_VIEW_PAGE;
    childViewController.title = self.shop.name;
 
    [self.navigationController pushViewController:childViewController animated:YES];
}

@end
