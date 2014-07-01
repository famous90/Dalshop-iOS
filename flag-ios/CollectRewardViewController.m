//
//  CollectRewardViewController.m
//  Dalshop
//
//  Created by Hwang Gyuyoung on 2014. 5. 27..
//
//

#import "CollectRewardViewController.h"
#import "ItemListViewController.h"
#import "FlagViewController.h"

#import "ViewUtil.h"

#import "GoogleAnalytics.h"

@interface CollectRewardViewController ()

@end

@implementation CollectRewardViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self configureViewContent];
}

- (void)configureViewContent
{
    CGFloat spacing = 10.0f;
    
    // CHECK IN SHOP BUTTON
    UIImage *checkInIconImage = [UIImage imageNamed:@"icon_checkIn_round"];
    
    [self.collectCheckInRewardButton.titleLabel setNumberOfLines:2];
    [self.collectCheckInRewardButton setTitle:@"달이 뜨는 가게\nCHECK-IN" forState:UIControlStateNormal];
    [self.collectCheckInRewardButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.collectCheckInRewardButton setImage:checkInIconImage forState:UIControlStateNormal];
    
    CGSize checkInImageSize = self.collectCheckInRewardButton.imageView.frame.size;
    self.collectCheckInRewardButton.titleEdgeInsets = UIEdgeInsetsMake(0, -checkInImageSize.width, -checkInImageSize.height - spacing, 0);
    
    CGSize checkInTitleSize = self.collectCheckInRewardButton.titleLabel.frame.size;
    self.collectCheckInRewardButton.imageEdgeInsets = UIEdgeInsetsMake(-checkInTitleSize.height - spacing, 0, 0, -checkInTitleSize.width);
    
    
    // SCAN ITEM BUTTON
    UIImage *scanIconImage = [UIImage imageNamed:@"icon_scan_round"];
    UIImage *scanDisableIconImage = [UIImage imageNamed:@"icon_scan_disable_round"];
    
    [self.collectScanRewardButton.titleLabel setNumberOfLines:2];
    
    [self.collectScanRewardButton setTitle:@"ITEM SCAN\n달 적립 지점" forState:UIControlStateNormal];
    [self.collectScanRewardButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.collectScanRewardButton setImage:scanIconImage forState:UIControlStateNormal];
    
    [self.collectScanRewardButton setTitle:@"서비스 준비 중" forState:UIControlStateDisabled];
    [self.collectScanRewardButton setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
    [self.collectScanRewardButton setImage:scanDisableIconImage forState:UIControlStateDisabled];
    
    CGSize scanImageSize = self.collectScanRewardButton.imageView.frame.size;
    self.collectScanRewardButton.titleEdgeInsets = UIEdgeInsetsMake(0, -scanImageSize.width, -scanImageSize.height - spacing, 0);
    
    CGSize scanTitleSize = self.collectScanRewardButton.titleLabel.frame.size;
    self.collectScanRewardButton.imageEdgeInsets = UIEdgeInsetsMake(-scanTitleSize.height - spacing, 0, 0, -scanTitleSize.width);
    
    [self.collectScanRewardButton setEnabled:NO];
   
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self setUser:[DelegateUtil getUser]];
    [ViewUtil setAppDelegatePresentingViewControllerWithViewController:self];
    
    // GA
    [[[GAI sharedInstance] defaultTracker] set:kGAIScreenName value:GAI_SCREEN_NAME_SELECT_REWARD_TYPE_VIEW];
    [[[GAI sharedInstance] defaultTracker] send:[[GAIDictionaryBuilder createAppView] build]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - 
#pragma mark IBAction

- (IBAction)collectCheckInRewardButtonTapped:(id)sender
{
    // GA
    [GAUtil sendGADataWithUIAction:@"go_to_check_in_reward_map" label:@"escape_view" value:nil];

    
    [self presentCheckInShopListView];
}

- (IBAction)collectScanRewardButtonTapped:(id)sender
{
    // GA
    [GAUtil sendGADataWithUIAction:@"go_to_scan_item_map" label:@"escape_view" value:nil];

    
    [self presentScanItemListView];
}

- (IBAction)cancelButtonTapped:(id)sender
{
    // GA
    [GAUtil sendGADataWithUIAction:@"go_back" label:@"escape_view" value:nil];

    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)backgroundTapped:(id)sender
{
    // GA
    [GAUtil sendGADataWithUIAction:@"go_back" label:@"escape_view" value:nil];

    
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark -
#pragma mark Implementation
- (void)presentCheckInShopListView
{
    UIStoryboard *storyboard = [ViewUtil getStoryboard];
    UINavigationController *navController = (UINavigationController *)[storyboard instantiateViewControllerWithIdentifier:@"FlagViewNav"];
    FlagViewController *childViewController = (FlagViewController *)[navController topViewController];
    childViewController.user = self.user;
    childViewController.parentPage = COLLECT_REWARD_SELECT_VIEW_PAGE;
    
    UIViewController *parentViewController = self.presentingViewController;
    [self dismissViewControllerAnimated:YES completion:^{
        [parentViewController presentViewController:navController animated:YES completion:nil];
    }];
}

- (void)presentScanItemListView
{
    UIStoryboard *storyboard = [ViewUtil getStoryboard];
    UINavigationController *navController = (UINavigationController *)[storyboard instantiateViewControllerWithIdentifier:@"ItemListViewNav"];
    ItemListViewController *childViewController = (ItemListViewController *)[navController topViewController];
    childViewController.user = self.user;
    childViewController.parentPage = COLLECT_REWARD_SELECT_VIEW_PAGE;
    
    UIViewController *parentViewController = self.presentingViewController;
    [self dismissViewControllerAnimated:YES completion:^{
        [parentViewController presentViewController:navController animated:YES completion:nil];
    }];
}
@end
