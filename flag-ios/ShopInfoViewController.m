//
//  ShopInfoViewController.m
//  flag-ios
//
//  Created by Gyuyoung Hwang on 2014. 2. 6..
//
//

#import "AppDelegate.h"
#import "ShopInfoViewController.h"
#import "MallShopViewController.h"
#import "SaleInfoViewController.h"

#import "User.h"

#import "ViewUtil.h"

#import "GoogleAnalytics.h"

@interface ShopInfoViewController ()

@property (nonatomic, weak) AppDelegate *appDelegate;

@end

@implementation ShopInfoViewController{
    BOOL shopInfoFirstTapped;
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
    
    shopInfoFirstTapped = NO;
}

#pragma mark - 
#pragma mark - IBAction
- (IBAction)shopInfoViewTapped:(id)sender
{
    // GAI event tracker
    if (!shopInfoFirstTapped) {
        [[[GAI sharedInstance] defaultTracker] send:[[GAIDictionaryBuilder createTimingWithCategory:@"ui_delay" interval:[NSNumber numberWithDouble:[[NSDate date] timeIntervalSinceDate:self.appDelegate.timeCriteria]] name:@"go_to_shop" label:nil] build]];
        shopInfoFirstTapped = YES;
    }
    [[[GAI sharedInstance] defaultTracker] send:[[GAIDictionaryBuilder createEventWithCategory:@"ui_action" action:@"go_to_shop" label:@"escape_view" value:nil] build]];
    
    
    // change view
    BOOL isMall = NO;
    UIStoryboard *storyborad = [ViewUtil getStoryboard];
    
    if (isMall) {
        
        UINavigationController *navController = (UINavigationController *)[storyborad instantiateViewControllerWithIdentifier:@"MallShopViewNav"];
        MallShopViewController *childViewController = (MallShopViewController *)[navController topViewController];
        
        childViewController.user = self.user;
        childViewController.parentPage = SHOP_INFO_VIEW_PAGE;
        childViewController.shopId = [self.shopId mutableCopy];
        childViewController.shopName = [self.shopName mutableCopy];
        childViewController.title = self.shopName;
        
    }else{
        
//        navController = (UINavigationController *)[storyborad instantiateViewControllerWithIdentifier:@"SaleInfoViewNav"];
//        navController = [[UINavigationController alloc] init];
//        SaleInfoViewController *childViewController = (SaleInfoViewController *)[navController topViewController];
        SaleInfoViewController *childViewController = (SaleInfoViewController *)[storyborad instantiateViewControllerWithIdentifier:@"SaleInfoView"];
        
        childViewController.user = self.user;
        childViewController.shopId = self.shopId;
        childViewController.parentPage = SHOP_INFO_VIEW_PAGE;
        childViewController.title = self.shopName;
     
        [self.navigationController pushViewController:childViewController animated:YES];
    }
}

// GAI touch tracking
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [[event allTouches] anyObject];
    CGPoint touchLocation = [touch locationInView:touch.view];
    CGFloat relativeTouchPositionX = touchLocation.x/[ViewUtil getIOSDeviceScreenHeight];
    CGFloat relativeTouchPositionY = ([ViewUtil getIOSDeviceScreenHeight] - self.view.frame.size.height + touchLocation.y)/[ViewUtil getIOSDeviceScreenHeight];
    
    [[[GAI sharedInstance] defaultTracker] send:[[GAIDictionaryBuilder createEventWithCategory:@"ui_touch" action:GAI_SCREEN_NAME_SHOP_INFO_VIEW label:[NSString stringWithFormat:@"%f,%f", relativeTouchPositionX, relativeTouchPositionY] value:nil] build]];
}

@end
