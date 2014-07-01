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
#import "TransitionDelegate.h"
#import "CollectRewardViewController.h"

#import "Flag.h"
#import "FlagDataController.h"
#import "Shop.h"
#import "URLParameters.h"

#import "Util.h"
#import "ViewUtil.h"
#import "DataUtil.h"

#import "FlagClient.h"
#import "GoogleAnalytics.h"

@interface FlagViewController ()

@property (nonatomic, weak) AppDelegate *delegate;
@property (nonatomic, strong) TransitionDelegate *transitionDelegate;

@end

@implementation FlagViewController{
    FlagDataController *flagData;
    Shop *selectedShop;
    UIImage *shopImage;
    BOOL isSlide;

    CGFloat navigationBarHeight;
    CGFloat tabBarHeight;
    CGFloat mapPadding;
    
    NSDate *createdViewAt;
}

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

    [self setUser:[DelegateUtil getUser]];
    [ViewUtil setAppDelegatePresentingViewControllerWithViewController:self];

    createdViewAt = [NSDate date];
    [[GAI sharedInstance].defaultTracker set:kGAIScreenName value:GAI_SCREEN_NAME_FLAG_VIEW];
    [[GAI sharedInstance].defaultTracker send:[[GAIDictionaryBuilder createAppView] build]];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self configureNavigationBar];
    
    isSlide = [self didSlideOutMapView];
}

- (void)configureNavigationBar
{
    navigationBarHeight = self.navigationController.navigationBar.frame.origin.y + self.navigationController.navigationBar.frame.size.height;
    tabBarHeight = 0.0f;
    mapPadding = 5.0f;
    
    if (self.parentPage == TAB_BAR_VIEW_PAGE) {
     
        UIBarButtonItem *menuButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icon_slide_menu"] style:UIBarButtonItemStyleBordered target:self.revealViewController action:@selector(revealToggle:)];
        self.navigationItem.leftBarButtonItem = menuButton;
        
//        self.transitionDelegate = [[TransitionDelegate alloc] init];
//        UIBarButtonItem *collectRewardButton = [[UIBarButtonItem alloc] initWithTitle:@"달따기" style:UIBarButtonItemStyleBordered target:self action:@selector(presentCollectRewardView:)];
//        self.navigationItem.rightBarButtonItem = collectRewardButton;
        UIBarButtonItem *rewardMenuButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icon_slide_menu"] style:UIBarButtonItemStyleBordered target:self.revealViewController action:@selector(rightRevealToggle:)];
        [rewardMenuButton setTintColor:UIColorFromRGB(0xeb6468)];
        self.navigationItem.rightBarButtonItem = rewardMenuButton;
        
    }else if (self.parentPage == COLLECT_REWARD_SELECT_VIEW_PAGE){
        
        self.title = @"체크인 상점";
        self.navigationController.navigationBar.tintColor = UIColorFromRGB(BASE_COLOR);
        
        
        UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"button_back"] style:UIBarButtonItemStyleBordered target:self action:@selector(cancelButtonTapped:)];
        self.navigationItem.leftBarButtonItem = cancelButton;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - 
#pragma mark - server connection
- (void)getShopInfoWithFlag:(Flag *)flag
{
    shopImage = nil;
    
    URLParameters *urlParam = [[URLParameters alloc] init];
    [urlParam setMethodName:@"shop"];
    [urlParam addParameterWithKey:@"id" withParameter:flag.shopId];
    [urlParam addParameterWithUserId:self.user.userId];
    NSURL *url = [urlParam getURLForRequest];
    NSString *methodName = [urlParam getMethodName];
    
    [FlagClient getDataResultWithURL:url methodName:methodName completion:^(NSDictionary *results){
       
        if (results) {
            [self setShopWithJsonData:results];
        }
        
    }];
}

- (void)setShopWithJsonData:(NSDictionary *)results
{
    selectedShop = [[Shop alloc] initWithData:results];
    
    [self.shopInfoViewController setShop:selectedShop];
    [self.shopInfoViewController configureShopScanRewardInfo];
    [self.shopInfoViewController configureShopSaleInfo];
    
    if (selectedShop.logoUrl) {
        
        if ([DataUtil isImageCachedWithObjectId:selectedShop.shopId imageUrl:selectedShop.logoUrl inListType:IMAGE_SHOP_LOGO]) {

            shopImage = [DataUtil getImageWithObjectId:selectedShop.shopId inListType:IMAGE_SHOP_LOGO];
            [self.shopInfoViewController.shopImageView setImage:shopImage];

        }else{
            
            [FlagClient getImageWithImageURL:selectedShop.logoUrl imageDataController:nil objectId:selectedShop.shopId objectType:IMAGE_SHOP_LOGO view:self.view completion:^(UIImage *image){
            
                shopImage = image;
                [DataUtil insertImageWithImage:image imageUrl:selectedShop.logoUrl objectId:selectedShop.shopId inListType:IMAGE_SHOP_LOGO];
                [self.shopInfoViewController.shopImageView setImage:shopImage];
            }];
        }
    }
}

#pragma mark - 
#pragma mark IBAction
//- (IBAction)presentCollectRewardView:(id)sender
//{
//    // GA
//    [GAUtil sendGADataWithUIAction:@"go_to_reward_collection" label:@"escape_view" value:nil];
//    
//    
//    UIStoryboard *storyboard = [ViewUtil getStoryboard];
//    CollectRewardViewController *childViewController = (CollectRewardViewController *)[storyboard instantiateViewControllerWithIdentifier:@"CollectRewardView"];
//    childViewController.user = self.user;
//    
//    childViewController.view.backgroundColor = [UIColor colorWithWhite:0 alpha:0.7];
//    [childViewController setTransitioningDelegate:self.transitionDelegate];
//    childViewController.modalPresentationStyle = UIModalPresentationCustom;
//    
//    [self presentViewController:childViewController animated:YES completion:nil];
//}

- (IBAction)cancelButtonTapped:(id)sender
{
    // GA
    [GAUtil sendGADataWithUIAction:@"go_back" label:@"escape_view" value:nil];
    
    
    [self dismissViewControllerAnimated:YES completion:nil];
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
        
        self.shopInfoViewController = (ShopInfoViewController *)[segue destinationViewController];
        
    }
}

- (void)prepareForMapEmbeddingSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    self.mapViewController = segue.destinationViewController;
    self.mapViewController.delegate = self;
    self.mapViewController.user = self.user;
    self.mapViewController.objectIdForFlag = self.objectIdForFlag;
    self.mapViewController.parentPage = self.parentPage;
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
    
    [self.shopInfoViewController setUser:self.user];
    [self.shopInfoViewController setShop:selectedShop];
    [self.shopInfoViewController.shopNameLabel setText:[Util changeStringFirstSpaceToLineBreak:selectedFlag.shopName]];
    [self.shopInfoViewController.shopRewardLabel setText:[NSString stringWithFormat:@"%ld달", (long)selectedShop.reward]];
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


#pragma mark - IBAction

//- (void)showMyPage
//{
//    UIStoryboard *storyboard = [ViewUtil getStoryboard];
//    MyPageViewController *childViewController = (MyPageViewController *)[storyboard instantiateViewControllerWithIdentifier:@"MyPageView"];
//    
//    childViewController.user = self.user;
//    
//    [self.navigationController pushViewController:childViewController animated:YES];
//}
//
//- (void)showJoinPage
//{
//    UIStoryboard *storyboard = [ViewUtil getStoryboard];
//    
//    JoinViewController *childViewController = (JoinViewController *)[storyboard instantiateViewControllerWithIdentifier:@"JoinView"];
//    
//    childViewController.user = self.user;
//    childViewController.parentPage = TAB_BAR_VIEW_PAGE;
//    
//    [self presentViewController:childViewController animated:YES completion:nil];
//}

- (IBAction)showShopListButtonTapped:(id)sender
{
    [self showShopList];
}

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

//- (IBAction)showMyPageTapped:(id)sender {
//    [self showMyPage];
//}
@end
