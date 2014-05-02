//
//  FlagViewController.m
//  flag-ios
//
//  Created by Gyuyoung Hwang on 2014. 2. 7..
//
//
#define ASK_JOIN_ALERT  10

#import "AppDelegate.h"
#import "FlagViewController.h"
#import "MapViewController.h"
#import "ShopInfoViewController.h"
#import "MyPageViewController.h"
#import "ShopListViewController.h"
#import "SWRevealViewController.h"
#import "JoinViewController.h"

#import "Flag.h"
#import "FlagDataController.h"
#import "Shop.h"
#import "URLParameters.h"

#import "Util.h"
#import "ViewUtil.h"

#import "FlagClient.h"
#import "GoogleAnalytics.h"

@interface FlagViewController ()

@property (nonatomic, weak) AppDelegate *delegate;

@end

@implementation FlagViewController{
    FlagDataController *flagData;
    Shop *selectedShop;
    UIImage *shopImage;
    BOOL isSlide;
    
    BOOL flagListFirstTapped;
    BOOL myPageFirstTapped;
}

CGFloat navigationBarHeight = 64.0f;
CGFloat tabBarHeight = 0.0f;
CGFloat mapPadding = 5.0f;

- (void)awakeFromNib
{
    [super awakeFromNib];
    flagData = [[FlagDataController alloc] init];
    
    // make user mock up
    self.user = [[User alloc] init];
    self.user.userId = [NSNumber numberWithInteger:0];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    [self.view setBackgroundColor:UIColorFromRGB(BASE_COLOR)];
    [self setMapView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.delegate.timeCriteria = [NSDate date];
    [[GAI sharedInstance].defaultTracker set:kGAIScreenName value:GAI_SCREEN_NAME_FLAG_VIEW];
    [[GAI sharedInstance].defaultTracker send:[[GAIDictionaryBuilder createAppView] build]];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.menuButton.target = self.revealViewController;
    self.menuButton.action = @selector(revealToggle:);
//    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    
    flagListFirstTapped = NO;
    myPageFirstTapped = NO;
    
    isSlide = [self didSlideOutMapView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - 
#pragma mark - server connection
- (void)getShopInfoWithFlag:(Flag *)flag
{
    NSDate *loadBeforeTime = [NSDate date];
    
    shopImage = nil;
    
    URLParameters *urlParam = [[URLParameters alloc] init];
    [urlParam setMethodName:@"shop"];
    [urlParam addParameterWithKey:@"id" withParameter:flag.shopId];
    [urlParam addParameterWithUserId:self.user.userId];
    NSURL *url = [urlParam getURLForRequest];
    
    [[[NSOperationQueue alloc] init] addOperationWithBlock:^{
        
        NSDictionary *results = [FlagClient getURLResultWithURL:url];
        
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            
            [self setShopWithJsonData:results];
            
            // GAI User Timing
            [[[GAI sharedInstance] defaultTracker] send:[[GAIDictionaryBuilder createTimingWithCategory:@"data_load" interval:[NSNumber numberWithDouble:[[NSDate date] timeIntervalSinceDate:loadBeforeTime]] name:@"get_shop" label:nil] build]];
        }];
    }];
}

- (void)setShopWithJsonData:(NSDictionary *)results
{
    selectedShop = [[Shop alloc] initWithData:results];
    
    if (selectedShop.logoUrl) {
        shopImage = [FlagClient getImageWithImagePath:selectedShop.logoUrl];
        self.shopInfoViewController.shopImageView.image = shopImage;
    }
}

#pragma mark - Implementaion

- (void)setMapView
{
    self.mapView.frame = CGRectMake(mapPadding, mapPadding + navigationBarHeight, self.view.frame.size.width - mapPadding*2, self.view.frame.size.height - navigationBarHeight - tabBarHeight - mapPadding*2);
    self.shopInfoView.frame = CGRectMake(mapPadding, self.view.frame.size.height, self.view.frame.size.width - mapPadding*2, self.shopInfoView.frame.size.height);
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"ShowMap"]) {
        [self prepareForMapEmbeddingSegue:segue sender:sender];
    }
    
    if ([[segue identifier] isEqualToString:@"ShowShopInfo"]) {
//        ShopInfoViewController *containerViewController = (ShopInfoViewController *)[segue destinationViewController];
        self.shopInfoViewController = (ShopInfoViewController *)[segue destinationViewController];
    }
}

- (void)prepareForMapEmbeddingSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    self.mapViewController = segue.destinationViewController;
    self.mapViewController.delegate = self;
    self.mapViewController.user = self.user;
}

- (BOOL)didSlideMapView
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:.5];
    
    CGRect frame = _shopInfoView.frame;
    frame.origin.y = self.view.frame.size.height - frame.size.height - tabBarHeight - mapPadding;
    _shopInfoView.frame = frame;
    
    [UIView commitAnimations];
    
    return YES;
}

- (BOOL)didSlideOutMapView
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:.5];
    
    CGRect frame = _shopInfoView.frame;
    frame.origin.y = self.view.frame.size.height;
    _shopInfoView.frame = frame;
    
    [UIView commitAnimations];
    
    return NO;
}

#pragma mark - map view delegate

- (void)mapViewController:(MapViewController *)mapViewController didSelectMarker:(GMSMarker *)marker
{
    Flag *selectedFlag = (Flag *)marker.userData;
    
    [self getShopInfoWithFlag:selectedFlag];
    
    self.shopInfoViewController.user = self.user;
    self.shopInfoViewController.shopId = [selectedFlag.shopId copy];
    self.shopInfoViewController.shopName = [selectedFlag.shopName copy];
    [self.shopInfoViewController.shopNameLabel setText:[Util changeStringFirstSpaceToLineBreak:selectedFlag.shopName]];
    [self.shopInfoViewController.shopRewardLabel setText:[NSString stringWithFormat:@"%ld달", (long)selectedShop.reward]];
//    [self.shopInfoViewController.shopSalePercentageLabel setText:[NSString stringWithFormat:@"%d%%SALE", selectedShop.sale]];
    self.shopInfoViewController.shopImageView.image = shopImage;
    
    isSlide = [self didSlideMapView];
}

- (void)mapViewController:(MapViewController *)mapViewController unSelectMarker:(GMSMarker *)marker
{
//    [self.view sendSubviewToBack:self.shopInfoView];
    selectedShop = nil;
    shopImage = nil;
    isSlide = [self didSlideOutMapView];
}

- (void)flagListOnMap:(FlagDataController *)flagDataController
{
    flagData.masterData = [flagDataController.masterData mutableCopy];
}

//- (void)setCurrentLocation:(CLLocation *)currentLocation
//{
////    self.currentLocation = currentLocation;
//}

#pragma mark - IBAction

- (void)showMyPage
{
    UIStoryboard *storyboard = [ViewUtil getStoryboard];
    MyPageViewController *childViewController = (MyPageViewController *)[storyboard instantiateViewControllerWithIdentifier:@"MyPageView"];
    
//    navController.navigationBar.tintColor = UIColorFromRGB(BASE_COLOR);
    childViewController.user = self.user;
    
//    [self presentViewController:navController animated:YES completion:nil];
    [self.navigationController pushViewController:childViewController animated:YES];
}

- (void)showJoinPage
{
    UIStoryboard *storyboard = [ViewUtil getStoryboard];
//    UINavigationController *navController = [[UINavigationController alloc] init];
//    JoinViewController *childViewController = (JoinViewController *)[navController topViewController];
    
    JoinViewController *childViewController = (JoinViewController *)[storyboard instantiateViewControllerWithIdentifier:@"JoinView"];
    
    childViewController.user = self.user;
    childViewController.parentPage = TAB_BAR_VIEW_PAGE;
    
    [self presentViewController:childViewController animated:YES completion:nil];
//    [self.navigationController pushViewController:childViewController animated:YES];
}

//- (IBAction)showShopListButtonTapped:(id)sender
//{
//    // GAI event
//    if (!flagListFirstTapped) {
//        [[[GAI sharedInstance] defaultTracker] send:[[GAIDictionaryBuilder createTimingWithCategory:@"ui_delay" interval:[NSNumber numberWithDouble:[[NSDate date] timeIntervalSinceDate:self.delegate.timeCriteria]] name:@"go_to_flag_list" label:nil] build]];
//        flagListFirstTapped = YES;
//    }
//    [[[GAI sharedInstance] defaultTracker] send:[[GAIDictionaryBuilder createEventWithCategory:@"ui_action" action:@"go_to_flag_list" label:@"escape_view" value:nil] build]];
//    
//    [self showShopList];
//}

- (void)showShopList
{
    UIStoryboard *storyboard = [ViewUtil getStoryboard];
    UINavigationController *navController = (UINavigationController *)[storyboard instantiateViewControllerWithIdentifier:@"ShopListViewNav"];
    ShopListViewController *childViewController = (ShopListViewController *)[navController topViewController];
    
    navController.navigationBar.tintColor = UIColorFromRGB(BASE_COLOR);
    [childViewController setUser:self.user];
    [childViewController setTitle:@"상점리스트"];
    
    [self presentViewController:navController animated:YES completion:nil];
}

- (IBAction)findCurrentPositionButtonTapped:(id)sender
{
    [self.mapViewController showCurrentLocation];
}

- (IBAction)showMyPageTapped:(id)sender {
    [self showMyPage];
}

#pragma mark - 
#pragma mark alert delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == ASK_JOIN_ALERT) {
        if (buttonIndex == 0) {
            
        }else if(buttonIndex == 1){
            [self showJoinPage];
        }
    }
}
@end
