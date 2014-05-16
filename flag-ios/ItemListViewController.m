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

#import "ImageDataController.h"
#import "ItemDataController.h"
#import "Item.h"
#import "Shop.h"
#import "URLParameters.h"

#import "Util.h"
#import "ViewUtil.h"
#import "SVPullToRefresh.h"

#import "GoogleAnalytics.h"

@interface ItemListViewController ()
@end

@implementation ItemListViewController{
    ItemDataController *allItemData;
    ImageDataController *imageData;
    
    NSURL *itemListUrl;
}

CGFloat itemImageWidth = 306.0f;
CGFloat itemImageHeight = 384.0f;

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

    [self.collectionView setBackgroundColor:UIColorFromRGB(BASE_COLOR)];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setContentView];
    [self setContent];
    
    __weak ItemListViewController *weakSelf = self;
    
    // setup pull-to-refresh
//    [self.collectionView addPullToRefreshWithActionHandler:^{
//        [weakSelf insertRowAtTop];
//    }];
    
    // setup infinite scrolling
    [self.collectionView addInfiniteScrollingWithActionHandler:^{
        [weakSelf insertRowAtBottom];
    }];
}

- (void)setContentView
{
    if (self.parentPage == TAB_BAR_VIEW_PAGE) {
        
        // navigation bar
        UIBarButtonItem *menuButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icon_slide_menu"] style:UIBarButtonItemStyleBordered target:self.revealViewController action:@selector(revealToggle:)];
        self.navigationItem.leftBarButtonItem = menuButton;
        menuButton.tintColor = UIColorFromRGB(BASE_COLOR);
        
        
        // slide menu
        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
        
    }else if (self.parentPage == SALE_INFO_VIEW_PAGE){
        
    }else if (self.parentPage == SLIDE_MENU_PAGE){
        
        // navigation bar
        self.title = @"나의 좋아요";
        
        UIBarButtonItem *menuButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"button_back"] style:UIBarButtonItemStyleBordered target:self action:@selector(cancelButtonTapped:)];
        self.navigationItem.leftBarButtonItem = menuButton;
        
    }
}

- (void)setContent
{
    if (self.parentPage == TAB_BAR_VIEW_PAGE) {
        
        itemListUrl = [self getURLPathWithRandomItem];
        
    }else if (self.parentPage == SALE_INFO_VIEW_PAGE){
        
        itemListUrl = [self getURLPathWithSaleInfo];
        
    }else if (self.parentPage == SLIDE_MENU_PAGE){
        
        itemListUrl = [self getURLPathWithMyLikeItem];
        
    }
    
    [self performSelectorInBackground:@selector(getItemListWithURL:) withObject:itemListUrl];
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
    __weak ItemListViewController *weakSelf = self;
    
    int64_t delayInSeconds = 2.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){

        [weakSelf performSelectorInBackground:@selector(getItemListWithURL:) withObject:itemListUrl];
        [weakSelf.collectionView.infiniteScrollingView stopAnimating];

    });
}


#pragma mark -
#pragma mark - server connect
- (NSURL *)getURLPathWithSaleInfo
{
    URLParameters *urlParam = [[URLParameters alloc] init];
    [urlParam setMethodName:@"item"];
    [urlParam addParameterWithKey:@"shopId" withParameter:self.shop.shopId];
    [urlParam addParameterWithUserId:self.user.userId];
    NSURL *url = [urlParam getURLForRequest];
    
    return url;
}

- (NSURL *)getURLPathWithRandomItem
{
    NSInteger mark = 0;
    URLParameters *urlParam = [[URLParameters alloc] init];
    
    [urlParam setMethodName:@"item_init"];
    [urlParam addParameterWithKey:@"mark" withParameter:[NSNumber numberWithInteger:mark]];
    [urlParam addParameterWithUserId:self.user.userId];
    NSURL *url = [urlParam getURLForRequest];
    
    return url;
}


- (NSURL *)getURLPathWithMyLikeItem
{
    URLParameters *urlParam = [[URLParameters alloc] init];
    
    [urlParam setMethodName:@"item_user"];
    [urlParam addParameterWithUserId:self.user.userId];
    NSURL *url = [urlParam getURLForRequest];
    
    return url;
}

- (void)getItemListWithURL:(NSURL *)url
{
    // Activity Indicator
//    ActivityIndicatorView *aiView = [ActivityIndicatorView startActivityIndicatorInParentView:self.view];
    
    NSDate *loadBeforeTime = [NSDate date];
    
    [[[NSOperationQueue alloc] init] addOperationWithBlock:^{
        
        NSDictionary *results = [FlagClient getURLResultWithURL:url];
        
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            
            [self setItemDataWithJsonData:results];
            
            // GAI Data Load Time
            [[[GAI sharedInstance] defaultTracker] send:[[GAIDictionaryBuilder createTimingWithCategory:@"data_load" interval:[NSNumber numberWithDouble:[[NSDate date] timeIntervalSinceDate:loadBeforeTime]] name:@"item_list" label:nil] build]];

            [self.collectionView reloadData];
//            [aiView stopActivityIndicator];
            
        }];
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

    [FlagClient setImageFromUrl:urlString imageDataController:imageData itemId:itemId view:self.collectionView completion:^(void){
        
    }];
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
//        UIFont *textFont = [UIFont fontWithName:@"System Bold" size:13];
//        CGRect rewardStringFrame = [reward boundingRectWithSize:CGSizeMake(100, 40) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:textFont} context:nil];
//        CGRect rewardLabelFrame = CGRectMake(cell.frame.size.width - 13 - rewardStringFrame.size.width, itemRewardLabel.frame.origin.y, rewardStringFrame.size.width, itemRewardLabel.frame.size.height);
//        itemRewardLabel.frame = rewardLabelFrame;
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
    
    
    // Shadow
//    CALayer *layer = cell.layer;
//    layer.shadowOffset = CGSizeMake(0.5f, 0.5f);
//    layer.shadowColor = [[UIColor blackColor] CGColor];
//    layer.shadowRadius = 2.0f;
//    layer.shadowOpacity = 0.3f;
//    layer.shadowPath = [[UIBezierPath bezierPathWithRect:layer.bounds] CGPath];
    
    return cell;
}

#pragma mark - Collection view delegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    Item *theItem = (Item *)[allItemData objectInListAtIndex:indexPath.row];
    UIImage *theItemImage = [imageData imageInListWithId:theItem.itemId];

    UIStoryboard *storyboard = [ViewUtil getStoryboard];
    ItemDetailViewController *childViewController = (ItemDetailViewController *)[storyboard instantiateViewControllerWithIdentifier:@"ItemDetailView"];
    
    childViewController.user = self.user;
    childViewController.item = theItem;
    childViewController.itemImage = theItemImage;
    
    // GAI event
    [[[GAI sharedInstance] defaultTracker] send:[[GAIDictionaryBuilder createEventWithCategory:@"ui_action" action:@"see_item_image" label:@"inside_view" value:nil] build]];
    
    [self.navigationController pushViewController:childViewController animated:YES];
}

#pragma mark - IBAction
- (IBAction)scanButtonTapped:(UIButton *)sender
{
    CGPoint buttonOrigiInCollectionView = [sender convertPoint:CGPointZero toView:self.collectionView];
    NSIndexPath *indexPath = [self.collectionView indexPathForItemAtPoint:buttonOrigiInCollectionView];
    Item *theItem = (Item *)[allItemData objectInListAtIndex:indexPath.row];
    
    [self showItemScanViewWithItem:theItem];
}

- (IBAction)cancelButtonTapped:(id)sender
{
    if (self.parentPage == SLIDE_MENU_PAGE) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (IBAction)cancel:(UIStoryboardSegue *)segue
{
    if ([[segue identifier] isEqualToString:@"ReturnQRCodeReader"]) {
    }
}

#pragma mark - Implementation
- (void)changeItemRewardToRewardedWithItemId:(NSNumber *)itemId
{
    [allItemData didRewardItemWithItemId:itemId];
}

- (void)showItemScanViewWithItem:(Item *)theItem
{
    // GAI event
    [[[GAI sharedInstance] defaultTracker] send:[[GAIDictionaryBuilder createEventWithCategory:@"ui_action" action:@"scan_item" label:@"inside_view" value:nil] build]];
    
    // set view
    UIStoryboard *storyborad = [ViewUtil getStoryboard];
    QRCodeReaderViewController *childViewController = (QRCodeReaderViewController *)[storyborad instantiateViewControllerWithIdentifier:@"QRCodeReaderView"];
    
    childViewController.theItem = theItem;
    childViewController.itemListViewController = self;
    
    [self.navigationController pushViewController:childViewController animated:YES];
}

@end
