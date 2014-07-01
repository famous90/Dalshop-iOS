//
//  ItemListViewController.m
//  flag-ios
//
//  Created by Gyuyoung Hwang on 2014. 2. 5..
//
//

#import "AppDelegate.h"
#import "ItemListViewController.h"
#import "QRCodeReaderViewController.h"
#import "ActivityIndicatorView.h"
#import "ItemDetailViewController.h"
#import "SWRevealViewController.h"
#import "TransitionDelegate.h"
#import "CollectRewardViewController.h"

#import "ImageDataController.h"
#import "ItemDataController.h"
#import "Item.h"
#import "Shop.h"
#import "Like.h"
#import "LikeDataController.h"
#import "URLParameters.h"

#import "Util.h"
#import "ViewUtil.h"
#import "DataUtil.h"
#import "SVPullToRefresh.h"

#import "GoogleAnalytics.h"

@interface ItemListViewController ()

@property (nonatomic, strong) TransitionDelegate *transitionDelegate;

@end

@implementation ItemListViewController{
    ItemDataController *allItemData;
    ImageDataController *imageData;
    
    URLParameters *itemListURLParams;
    
    CGFloat itemImageWidth;
    CGFloat itemImageHeight;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.user = [[User alloc] init];
    self.shop = [[Shop alloc] init];
    
    allItemData = [[ItemDataController alloc] init];
    imageData = [[ImageDataController alloc] init];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    [self setContentView];
    [self.collectionView setBackgroundColor:UIColorFromRGB(BASE_COLOR)];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setContent];
    
    self.afterItemScan = NO;
    
    if (self.parentPage == TAB_BAR_VIEW_PAGE) {
        __weak ItemListViewController *weakSelf = self;
        
        // setup pull-to-refresh
        //    [self.collectionView addPullToRefreshWithActionHandler:^{
        //        [weakSelf insertRowAtTop];
        //    }];
        
        // setup infinite scrolling
        [self.collectionView addInfiniteScrollingWithActionHandler:^{
            [weakSelf insertRowAtBottom];
        }];
        
        [self configureCheckInRewardTutorial];

    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self setUser:[DelegateUtil getUser]];
    [ViewUtil setAppDelegatePresentingViewControllerWithViewController:self];
    
    if (self.afterItemScan) {
        [allItemData removeAllData];
        [self setContent];
        self.afterItemScan = NO;
    }
    
    [self.collectionView reloadData];
    
    
    // GA
    [[[GAI sharedInstance] defaultTracker] set:kGAIScreenName value:GAI_SCREEN_NAME_ITEM_LIST_VIEW];
    [[[GAI sharedInstance] defaultTracker] send:[[GAIDictionaryBuilder createAppView] build]];
}

- (void)setContentView
{
    itemImageWidth = 306.0f;
    itemImageHeight = 384.0f;
    
    if (self.parentPage == TAB_BAR_VIEW_PAGE) {
        
        // navigation bar
        self.navigationController.navigationBar.tintColor = UIColorFromRGB(BASE_COLOR);
        
        UIBarButtonItem *menuButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icon_slide_menu"] style:UIBarButtonItemStyleBordered target:self.revealViewController action:@selector(revealToggle:)];
        self.navigationItem.leftBarButtonItem = menuButton;
        menuButton.tintColor = UIColorFromRGB(BASE_COLOR);
        
        UIBarButtonItem *rewardMenuButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icon_slide_menu"] style:UIBarButtonItemStyleBordered target:self.revealViewController action:@selector(rightRevealToggle:)];
        [rewardMenuButton setTintColor:UIColorFromRGB(0xeb6468)];
        self.navigationItem.rightBarButtonItem = rewardMenuButton;
        //        UIBarButtonItem *collectRewardButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"BUTTON_TITLE_FIND_SHOP_FOR_REWARD", @"reward") style:UIBarButtonItemStyleBordered target:self.revealViewController action:@selector(rightRevealToggle:)];
        
        // slide menu
        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
        [self.view addGestureRecognizer:self.revealViewController.tapGestureRecognizer];
        
    }else if (self.parentPage == SALE_INFO_VIEW_PAGE){
        
    }else if (self.parentPage == SLIDE_MENU_PAGE){
        
        // navigation bar
        self.title = @"나의 좋아요";
        
        UIBarButtonItem *menuButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"button_back"] style:UIBarButtonItemStyleBordered target:self action:@selector(cancelButtonTapped:)];
        self.navigationItem.leftBarButtonItem = menuButton;
        
    }else if (self.parentPage == COLLECT_REWARD_SELECT_VIEW_PAGE){
        
        self.title = @"스캔아이템";
        
        UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"button_back"] style:UIBarButtonItemStyleBordered target:self action:@selector(cancelButtonTapped:)];
        self.navigationItem.leftBarButtonItem = backButton;
        backButton.tintColor = UIColorFromRGB(BASE_COLOR);
        
    }else if (self.parentPage == NOTIFICATION_VIEW){
        
        [self setTitle:self.shop.name];
        
        UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"button_back"] style:UIBarButtonItemStyleBordered target:self action:@selector(cancelButtonTapped:)];
        [self.navigationItem setLeftBarButtonItem:backButton];
        [backButton setTintColor:UIColorFromRGB(BASE_COLOR)];
    }
}

- (void)setContent
{
    if (self.parentPage == TAB_BAR_VIEW_PAGE) {
        
        itemListURLParams = [self getURLPathWithRandomItem];
        
    }else if (self.parentPage == SALE_INFO_VIEW_PAGE){
        
        itemListURLParams = [self getURLPathWithSaleInfo];
        
    }else if (self.parentPage == SLIDE_MENU_PAGE){
        
        itemListURLParams = [self getURLPathWithMyLikeItem];
        
    }else if (self.parentPage == COLLECT_REWARD_SELECT_VIEW_PAGE){
        
        itemListURLParams = [self getURLPathForScanItemList];
        
    }else if (self.parentPage == NOTIFICATION_VIEW){
        
        itemListURLParams = [self getURLPathWithSaleInfo];
        
    }
    
    [self performSelectorInBackground:@selector(getItemListWithURLParams:) withObject:itemListURLParams];
}

- (void)viewDidAppear:(BOOL)animated
{
//    [super viewDidAppear:animated];
    [self.collectionView triggerPullToRefresh];
//    [self.collectionView reloadData];
}

#pragma mark -
#pragma mark pull to refresh delegate
- (void)insertRowAtTop
{
    // GA
    [GAUtil sendGADataWithUIAction:@"pull_top_to_refresh" label:@"inside_view" value:nil];

    
    __weak ItemListViewController *weakSelf = self;
    
    int64_t delayInSeconds = 2.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        
        NSLog(@"insert row at top");
        [weakSelf.collectionView.infiniteScrollingView stopAnimating];
    });
    
}

- (void)insertRowAtBottom
{
    // GA
    [GAUtil sendGADataWithUIAction:@"pull_bottom_to_refresh" label:@"inside_view" value:nil];

    
    __weak ItemListViewController *weakSelf = self;
    
    int64_t delayInSeconds = 2.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){

        [weakSelf performSelectorInBackground:@selector(getItemListWithURLParams:) withObject:itemListURLParams];
        [weakSelf.collectionView.infiniteScrollingView stopAnimating];

    });
}


#pragma mark -
#pragma mark - server connect
- (URLParameters *)getURLPathWithSaleInfo
{
    URLParameters *urlParam = [[URLParameters alloc] init];
    [urlParam setMethodName:@"item"];
    [urlParam addParameterWithKey:@"shopId" withParameter:self.shop.shopId];
    [urlParam addParameterWithUserId:self.user.userId];
    
    return urlParam;
}

- (URLParameters *)getURLPathWithRandomItem
{
    NSInteger mark = 0;
    URLParameters *urlParam = [[URLParameters alloc] init];
    
    [urlParam setMethodName:@"item_init"];
    [urlParam addParameterWithKey:@"mark" withParameter:[NSNumber numberWithInteger:mark]];
    [urlParam addParameterWithUserId:self.user.userId];
    
    return urlParam;
}


- (URLParameters *)getURLPathWithMyLikeItem
{
    LikeDataController *likeData = [[LikeDataController alloc] init];
    likeData = [DataUtil getLikeListWithType:LIKE_ITEM];
    
    URLParameters *urlParam = [[URLParameters alloc] init];
    
    [urlParam setMethodName:@"item_list"];
    for(Like *theLike in likeData.masterData){
        [urlParam addParameterWithKey:@"ids" withParameter:theLike.objectId];
    }
    [urlParam addParameterWithUserId:self.user.userId];
    
    return urlParam;
}

- (URLParameters *)getURLPathForScanItemList
{
    URLParameters *urlParam = [[URLParameters alloc] init];
    [urlParam setMethodName:@"item_reward"];
    [urlParam addParameterWithKey:@"mark" withParameter:[NSNumber numberWithInteger:0]];
    [urlParam addParameterWithUserId:self.user.userId];
    
    return urlParam;
}

- (void)getItemListWithURLParams:(URLParameters *)urlParams
{
    [FlagClient getDataResultWithURL:[urlParams getURLForRequest] methodName:[urlParams getMethodName] completion:^(NSDictionary *results){
        
        if (results) {
            
            [self setItemDataWithJsonData:results];
        }
        
        [self.collectionView reloadData];
        
    }];
}

- (void)setItemDataWithJsonData:(NSDictionary *)results
{
    NSArray *items = [results objectForKey:@"items"];
    for(id object in items){
        Item *theItem = [[Item alloc] initWithData:object];
        [allItemData addObjectWithObject:theItem];
        
        if (![theItem.thumbnailUrl isEqual:(id)[NSNull null]]) {
            [self getItemImageWithImagePath:theItem.thumbnailUrl itemId:theItem.itemId];
        }
    }
    
    [self.collectionView reloadData];
}

- (void)getItemImageWithImagePath:(NSString *)imagePath itemId:(NSNumber *)itemId
{
    NSString *urlString = [Util addImageParameterInImagePath:imagePath width:itemImageWidth height:itemImageHeight];

    [FlagClient getImageWithImageURL:urlString imageDataController:imageData objectId:itemId objectType:IMAGE_ITEM view:self.collectionView completion:^(UIImage *image){}];
}

#pragma mark - Collection view data source
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [allItemData countOfList];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"ItemCell";
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    Item *theItem = (Item *)[allItemData objectInListAtIndex:indexPath.row];
    
    UIImage *theImage = (UIImage *)[imageData imageInListWithId:theItem.itemId];
    UIImageView *itemImageView = (UIImageView *)[cell viewWithTag:201];
    UIImageView *itemLikeImageView = (UIImageView *)[cell viewWithTag:202];
    UILabel *itemLikeCountLabel = (UILabel *)[cell viewWithTag:203];
//    UIImageView *itemScanImageView = (UIImageView *)[cell viewWithTag:204];
    UIButton *itemScanButton = (UIButton *)[cell viewWithTag:204];
    UILabel *itemRewardLabel = (UILabel *)[cell viewWithTag:205];
    
    if (theItem.liked) {
        itemLikeImageView.image = [UIImage imageNamed:@"icon_like_selected"];
    }else{
        itemLikeImageView.image = [UIImage imageNamed:@"icon_like_unselected"];
    }
    
    if (theItem.reward == 0) {
        
        [itemScanButton setHidden:YES];
        [itemRewardLabel setHidden:YES];
        
    }else{
        
        NSString *reward = [NSString stringWithFormat:@"%ld달", (long)theItem.reward];
        itemRewardLabel.text = reward;

        if (theItem.rewarded) {
            [itemScanButton setBackgroundImage:[UIImage imageNamed:@"icon_scan_done"] forState:UIControlStateNormal];
        }else{
            [itemScanButton setBackgroundImage:[UIImage imageNamed:@"icon_scan"] forState:UIControlStateNormal];
        }
    }
    [itemScanButton addTarget:self action:@selector(scanButtonTapped:) forControlEvents:UIControlEventTouchUpInside];

    itemImageView.image = theImage;
    itemImageView.layer.borderColor = [UIColor colorWithWhite:0 alpha:0.1].CGColor;
    itemImageView.layer.borderWidth = 0.5f;
    itemLikeCountLabel.text = [NSString stringWithFormat:@"%ld", (long)theItem.likes];


    // Border line
    cell.layer.borderColor = [UIColor colorWithWhite:0 alpha:0.1].CGColor;
    cell.layer.borderWidth = 0.5f;
    
    return cell;
}

#pragma mark - Collection view delegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    // GA
    [GAUtil sendGADataWithUIAction:@"see_item_image" label:@"escape_view" value:nil];

    
    Item *theItem = (Item *)[allItemData objectInListAtIndex:indexPath.row];
    UIImage *theItemImage = [imageData imageInListWithId:theItem.itemId];

    UIStoryboard *storyboard = [ViewUtil getStoryboard];
    ItemDetailViewController *childViewController = (ItemDetailViewController *)[storyboard instantiateViewControllerWithIdentifier:@"ItemDetailView"];
    
    childViewController.user = self.user;
    childViewController.item = theItem;
    childViewController.itemImage = theItemImage;
    childViewController.parentPage = ITEM_LIST_VIEW_PAGE;
    
    childViewController.itemListViewController = self;
    childViewController.selectedItemIndexpathRow = indexPath.row;
    
    [self.navigationController pushViewController:childViewController animated:YES];
}

#pragma mark - IBAction
- (IBAction)scanButtonTapped:(UIButton *)sender
{
    // GA
    [GAUtil sendGADataWithUIAction:@"item_scan_click" label:@"inside_view" value:nil];

    
    CGPoint buttonOrigiInCollectionView = [sender convertPoint:CGPointZero toView:self.collectionView];
    NSIndexPath *indexPath = [self.collectionView indexPathForItemAtPoint:buttonOrigiInCollectionView];
    Item *theItem = (Item *)[allItemData objectInListAtIndex:indexPath.row];
    
    [self showItemScanViewWithItem:theItem];
}

- (IBAction)cancelButtonTapped:(id)sender
{
    // GA
    [GAUtil sendGADataWithUIAction:@"go_back" label:@"escape_view" value:nil];

    
    if (self.parentPage == SLIDE_MENU_PAGE) {
        
        [self dismissViewControllerAnimated:YES completion:nil];
    
    }else if (self.parentPage == COLLECT_REWARD_SELECT_VIEW_PAGE){
    
        NSLog(@"cancel button tapped");
        [self dismissViewControllerAnimated:YES completion:nil];
    
    }else if (self.parentPage == NOTIFICATION_VIEW){
        
        [self dismissViewControllerAnimated:YES completion:nil];
        
    }
}

- (IBAction)cancel:(UIStoryboardSegue *)segue
{
    if ([[segue identifier] isEqualToString:@"ReturnQRCodeReader"]) {
    }
}

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

#pragma mark - Implementation
- (void)showItemScanViewWithItem:(Item *)theItem
{
    // set view
    UIStoryboard *storyborad = [ViewUtil getStoryboard];
    QRCodeReaderViewController *childViewController = (QRCodeReaderViewController *)[storyborad instantiateViewControllerWithIdentifier:@"QRCodeReaderView"];
    
    childViewController.user = self.user;
    childViewController.item = theItem;
    childViewController.itemListViewController = self;
    
    [self.navigationController pushViewController:childViewController animated:YES];
}

- (void)addItemLikesWithIndexpathRow:(NSInteger)row
{
    Item *theItem = [allItemData objectInListAtIndex:row];
    theItem.likes++;
    theItem.liked = YES;
}

- (void)minusItemLikesWithIndexpathRow:(NSInteger)row
{
    Item *theItem = [allItemData objectInListAtIndex:row];
    theItem.likes--;
    theItem.liked = NO;
}

#pragma mark -
#pragma mark notification
- (void)configureCheckInRewardTutorial
{
    if (![DataUtil isUserFirstLaunchApp]) {
        
        [ViewUtil presentTutorialInView:self type:TUTORIAL_REWARD_DESCRIPTION];
        [DataUtil saveUserHistoryAfterAppLaunch];
    }
}

@end
