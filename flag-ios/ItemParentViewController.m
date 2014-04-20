//
//  ItemParentViewController.m
//  flag-ios
//
//  Created by Gyuyoung Hwang on 2014. 3. 7..
//
//
#define SEGMENT_CONTROL_HEIGHT  44

#import "AppDelegate.h"
#import "ItemParentViewController.h"
#import "ItemListViewController.h"

#import "User.h"
#import "Shop.h"

#import "ViewUtil.h"

#import "GoogleAnalytics.h"

@interface ItemParentViewController ()

@end

@implementation ItemParentViewController

- (void)awakeFromNib
{
//    [super awakeFromNib];
    self.user = [[User alloc] init];
    self.shop = [[Shop alloc] init];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    [self setSubviewFrame];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[GAI sharedInstance].defaultTracker set:kGAIScreenName value:GAI_SCREEN_NAME_ITEM_LIST_VIEW];
    [[GAI sharedInstance].defaultTracker send:[[GAIDictionaryBuilder createAppView] build]];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

#pragma mark -
#pragma mark - Implementation

- (void)setSubviewFrame
{
    // segmented control
    UIImage *segmentedControlBackgroundImage = [UIImage imageNamed:@"segment_background"];
    UIImage *segmentedControlHighlightImage = [UIImage imageNamed:@"segment_background_highlighted"];
    UIImage *segmentedControlDividerImage = [UIImage imageNamed:@"000000"];
//    UIImage *segmentedControlUnselectedBackgroundImage = [UIImage imageNamed:@"segment_unselected"];
    [self.itemListTypeSegment setBackgroundImage:segmentedControlBackgroundImage forState:UIControlStateSelected barMetrics:UIBarMetricsDefault];
    [self.itemListTypeSegment setBackgroundImage:segmentedControlBackgroundImage forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    [self.itemListTypeSegment setBackgroundImage:segmentedControlHighlightImage forState:UIControlStateHighlighted barMetrics:UIBarMetricsDefault];
    [self.itemListTypeSegment setDividerImage:segmentedControlDividerImage forLeftSegmentState:UIControlStateNormal rightSegmentState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    [self.itemListTypeSegment setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:UIColorFromRGB(0x22ada7), NSForegroundColorAttributeName, [UIFont boldSystemFontOfSize:20], NSFontAttributeName, nil] forState:UIControlStateSelected];
    [self.itemListTypeSegment setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:UIColorFromRGB(0x666666), NSForegroundColorAttributeName, [UIFont systemFontOfSize:15], NSFontAttributeName, nil] forState:UIControlStateNormal];
    
    // container view
    CGFloat viewHeight = [ViewUtil getIOSDeviceScreenHeight];
    CGRect itemListViewFrame = self.itemListView.frame;
    itemListViewFrame.origin = CGPointMake(0, 104);
//    CGPointMake(0, self.itemListTypeSegment.frame.origin.y + self.itemListTypeSegment.frame.size.height);
    itemListViewFrame.size = CGSizeMake(self.view.frame.size.width, viewHeight - itemListViewFrame.origin.y);
    self.itemListView.frame = itemListViewFrame;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"ShowItemList"]) {
//        ItemListViewController *childViewController = (ItemListViewController *)[segue destinationViewController];
        self.itemListViewController = (ItemListViewController *)[segue destinationViewController];
        
        self.itemListViewController.user = self.user;
        self.itemListViewController.shop = self.shop;
//        if (self.itemListTypeSegment.selectedSegmentIndex == 0) {
//            self.itemListViewController.pageType = ITEM_LIST_VIEW_PAGE;
//        }else{
//            self.itemListViewController.pageType = SCAN_LIST_VIEW_PAGE;
//        }
    }
}

#pragma mark - IBAction
- (IBAction)itemListTypeSegmentTapped:(id)sender
{
    if (self.itemListTypeSegment.selectedSegmentIndex == 1) {
        
//        self.itemListViewController.pageType = SCAN_LIST_VIEW_PAGE;
        [self.itemListViewController.collectionView reloadData];
//        [self.itemListViewController ]
        
    }else if(self.itemListTypeSegment.selectedSegmentIndex == 0){
        
//        self.itemListViewController.pageType = ITEM_LIST_VIEW_PAGE;
        [self.itemListViewController.collectionView reloadData];
        
    }
}

- (IBAction)cancel:(UIStoryboardSegue *)segue
{
    if ([[segue identifier] isEqualToString:@"CancelQRCodeReader"]) {
    }
}
@end
