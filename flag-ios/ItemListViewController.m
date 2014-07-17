//
//  ItemListViewController.m
//  flag-ios
//
//  Created by Gyuyoung Hwang on 2014. 2. 5..
//
//

#define SHOP_INFO_SECTION           0
#define SHOP_EVENT_IMAGE_ROW    0
#define SHOP_DESCRIPTION_ROW    1

#define ITEM_LIST_SECTION           1

#define ITEM_DETAIL_SECTION         0
#define ITEM_DETAIL_IMAGE_ROW       0
#define ITEM_DETAIL_DESCRIPTION_ROW 1

#define CELL_TYPE_SHOP_INFO     1
#define CELL_TYPE_ITEM_LIST     2
#define CELL_TYPE_ITEM_DETAIL   3

#define IMAGE_LOAD_TYPE_ITEM_DETAIL 1
#define IMAGE_LOAD_TYPE_ITEM_LIST   2
#define IMAGE_LOAD_TYPE_SHOP_EVENT  3

#import "AppDelegate.h"
#import "ItemListViewController.h"
#import "QRCodeReaderViewController.h"
#import "ActivityIndicatorView.h"
#import "ItemDetailViewController.h"
#import "SWRevealViewController.h"
#import "TransitionDelegate.h"
#import "CollectRewardViewController.h"
#import "FlagViewController.h"

#import "ImageDataController.h"
#import "ItemDataController.h"
#import "Item.h"
#import "Shop.h"
#import "Like.h"
#import "LikeDataController.h"
#import "URLParameters.h"

#import "Util.h"
#import "SNSUtil.h"
#import "ViewUtil.h"
#import "DataUtil.h"
#import "SVPullToRefresh.h"

#import "GoogleAnalytics.h"
#import "FlagClient.h"
#import "GTLFlagengine.h"

@interface ItemListViewController ()

@end

@implementation ItemListViewController{
    NSMutableArray *collectionViewCell;
    
    ItemDataController *allItemData;
    ImageDataController *imageData;
    
    URLParameters *itemListURLParams;
    
    CGFloat itemImageWidth;
    CGFloat itemImageHeight;
    
    CGFloat shopEventImageWidth;
    CGFloat shopEventImageHeight;
    CGFloat shopDescriptionExpandButtonHeight;
    CGFloat shopDescriptionTextMargin;
    CGFloat shopDescriptionTextPadding;
    CGFloat shopDescriptionSectionMaxHeight;
    UIFont *shopDescriptionFont;
    
    CGFloat itemDetailTextPadding;
    CGFloat itemDetailTextMargin;
    CGFloat itemDetailPricePartHeight;
    UIFont *itemDetailNameFont;
    UIFont *itemDetailDescriptionFont;
    UIFont *itemDetailOldPriceFont;
    UIFont *itemDetailCurrentPriceFont;
    
    BOOL isShopInfoCellExpanded;
    
    NSMutableDictionary *kakaoTalkLinkObjects;
    
    NSInteger itemListMark;
    
    NSInteger view_type;
    
    UIView *cellResultMessageView;
    NSInteger resultMessageType;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.user = [[User alloc] init];
    self.shop = [[Shop alloc] init];
    
    collectionViewCell = [[NSMutableArray alloc] init];
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
    
    [self initializeParameters];
    [self initializeContent];
    
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
    
    // Analytics
    [[GAI sharedInstance].defaultTracker set:kGAIScreenName value:GAI_SCREEN_NAME_ITEM_LIST_VIEW];
    [[GAI sharedInstance].defaultTracker send:[[GAIDictionaryBuilder createAppView] build]];
}

- (void)initializeParameters
{
    itemImageWidth = 306.0f;
    itemImageHeight = 384.0f;
    
    shopEventImageWidth = 310.0f;
    shopEventImageHeight = 176.0f;
    shopDescriptionExpandButtonHeight = 14.0f;
    shopDescriptionTextMargin = 5.0f;
    shopDescriptionTextPadding = 12.5f;
    shopDescriptionSectionMaxHeight = 100.0f;
    shopDescriptionFont = [UIFont systemFontOfSize:13];
    
    itemDetailTextPadding = 12.5f;
    itemDetailTextMargin = 5.0f;
    if ([self.item hasOldPrice]) {
        itemDetailPricePartHeight = 42.0f;
    }else itemDetailPricePartHeight = 20.0f;
    
    itemDetailNameFont = [UIFont boldSystemFontOfSize:17];
    itemDetailDescriptionFont = [UIFont systemFontOfSize:14];
    itemDetailOldPriceFont = [UIFont systemFontOfSize:14];
    itemDetailCurrentPriceFont = [UIFont boldSystemFontOfSize:16];
    
    kakaoTalkLinkObjects = [[NSMutableDictionary alloc] init];
    
    isShopInfoCellExpanded = NO;
    
    itemListMark = 0;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self setUser:[DelegateUtil getUser]];
    [ViewUtil setAppDelegatePresentingViewControllerWithViewController:self];
    
    if (self.afterItemScan) {
        [allItemData removeAllData];
        [self initializeContent];
        self.afterItemScan = NO;
    }
    
    [self.collectionView reloadData];
}

- (void)setContentView
{
    if (self.parentPage == TAB_BAR_VIEW_PAGE) {
        
        view_type = VIEW_ITEM_LIST;
        
        // navigation bar
        self.navigationController.navigationBar.tintColor = UIColorFromRGB(BASE_COLOR);
        
        UIBarButtonItem *menuButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icon_slide_menu"] style:UIBarButtonItemStyleBordered target:self.revealViewController action:@selector(revealToggle:)];
        self.navigationItem.leftBarButtonItem = menuButton;
        menuButton.tintColor = UIColorFromRGB(BASE_COLOR);
        
        UIBarButtonItem *rewardMenuButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icon_slide_menu"] style:UIBarButtonItemStyleBordered target:self.revealViewController action:@selector(rightRevealToggle:)];
        [rewardMenuButton setTintColor:UIColorFromRGB(0xf2b518)];
        self.navigationItem.rightBarButtonItem = rewardMenuButton;
        //        UIBarButtonItem *collectRewardButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"BUTTON_TITLE_FIND_SHOP_FOR_REWARD", @"reward") style:UIBarButtonItemStyleBordered target:self.revealViewController action:@selector(rightRevealToggle:)];
        
        // slide menu
        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
        [self.view addGestureRecognizer:self.revealViewController.tapGestureRecognizer];
        
    }else if (self.parentPage == SALE_INFO_VIEW_PAGE || self.parentPage == SHOP_LIST_VIEW_PAGE){
        
        view_type = VIEW_ITEM_LIST;
        
        [self setTitle:self.shop.name];
        
    }else if (self.parentPage == SLIDE_MENU_PAGE){
        
        view_type = VIEW_ITEM_LIST_MY_LIKES;
        
        // navigation bar
        [self setTitle:NSLocalizedString(@"My Likes", @"My Likes")];
        
        UIBarButtonItem *menuButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"button_back"] style:UIBarButtonItemStyleBordered target:self action:@selector(cancelButtonTapped:)];
        self.navigationItem.leftBarButtonItem = menuButton;
        
    }else if (self.parentPage == COLLECT_REWARD_SELECT_VIEW_PAGE){
        
        view_type = VIEW_ITEM_LIST_REWARD;
        
        [self setTitle:NSLocalizedString(@"Scan Item", @"Scan Item")];
        
        UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"button_back"] style:UIBarButtonItemStyleBordered target:self action:@selector(cancelButtonTapped:)];
        self.navigationItem.leftBarButtonItem = backButton;
        backButton.tintColor = UIColorFromRGB(BASE_COLOR);
        
    }else if (self.parentPage == NOTIFICATION_VIEW){
        
        view_type = VIEW_ITEM_LIST;
        
        [self setTitle:self.shop.name];
        
        UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"button_back"] style:UIBarButtonItemStyleBordered target:self action:@selector(cancelButtonTapped:)];
        [self.navigationItem setLeftBarButtonItem:backButton];
        [backButton setTintColor:UIColorFromRGB(BASE_COLOR)];
        
    }else if (self.parentPage == ITEM_LIST_VIEW_PAGE){
        
        view_type = VIEW_ITEM_LIST_DETAIL;
        
        [self setTitle:NSLocalizedString(@"Item Detail", @"Item Detail")];
    }
    
    // Analytics
    [DaLogClient sendDaLogWithCategory:CATEGORY_VIEW_APPEAR target:view_type value:0];
}

- (void)initializeContent
{
    NSDictionary *shop_section_dic = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:CELL_TYPE_SHOP_INFO], @"type", nil];
    NSDictionary *item_list_section_dic = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:CELL_TYPE_ITEM_LIST], @"type", nil];
    NSDictionary *item_detail_section_dic = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:CELL_TYPE_ITEM_DETAIL], @"type", nil];
    [collectionViewCell addObject:item_list_section_dic];
    
    [cellResultMessageView removeFromSuperview];
    cellResultMessageView = [ViewUtil getCellResultMessageInView:self.collectionView messageType:CELL_RESULT_DATA_LOADING];
    [cellResultMessageView setHidden:NO];
    
    if (self.parentPage == TAB_BAR_VIEW_PAGE) {
        
        itemListURLParams = [self getURLPathWithRandomItem];
        
    }else if (self.parentPage == SHOP_LIST_VIEW_PAGE){
        
        itemListURLParams = [self getURLPathWithSaleInfo];
        [collectionViewCell insertObject:shop_section_dic atIndex:SHOP_INFO_SECTION];
        
    }else if (self.parentPage == SLIDE_MENU_PAGE){
        
        itemListURLParams = [self getURLPathWithMyLikeItem];
        
    }else if (self.parentPage == COLLECT_REWARD_SELECT_VIEW_PAGE){
        
        itemListURLParams = [self getURLPathForScanItemList];
        
    }else if (self.parentPage == NOTIFICATION_VIEW){
        
        itemListURLParams = [self getURLPathWithSaleInfo];
        
    }else if (self.parentPage == ITEM_LIST_VIEW_PAGE){
        
        [collectionViewCell insertObject:item_detail_section_dic atIndex:ITEM_DETAIL_SECTION];
        itemListURLParams = [self getURLForRelatedItemList];
        [self getImageWithImagePath:self.item.thumbnailUrl objectId:self.item.itemId type:IMAGE_LOAD_TYPE_ITEM_DETAIL];
        
    }else if (self.parentPage == SALE_INFO_VIEW_PAGE){
        
        itemListURLParams = [self getURLPathWithSaleInfo];
        [collectionViewCell insertObject:shop_section_dic atIndex:SHOP_INFO_SECTION];
        [self getImageWithImagePath:self.shop.imageUrl objectId:self.shop.shopId type:IMAGE_LOAD_TYPE_SHOP_EVENT];
        
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
        
        DLog(@"insert row at top");
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

        URLParameters *urlParam = [self getURLPathWithRandomItem];
        [weakSelf performSelectorInBackground:@selector(getItemListWithURLParams:) withObject:urlParam];
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
    URLParameters *urlParam = [[URLParameters alloc] init];
    
    [urlParam setMethodName:@"item_init"];
    [urlParam addParameterWithKey:@"mark" withParameter:[NSNumber numberWithInteger:itemListMark++]];
    DLog(@"mark %ld", (long)itemListMark);
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
    [urlParam addParameterWithKey:@"mark" withParameter:[NSNumber numberWithInteger:itemListMark++]];
    [urlParam addParameterWithUserId:self.user.userId];
    
    return urlParam;
}

- (URLParameters *)getURLForRelatedItemList
{
    URLParameters *urlParam = [[URLParameters alloc] init];
    [urlParam setMethodName:@"item_item"];
    [urlParam addParameterWithKey:@"itemId" withParameter:self.item.itemId];
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
            [self getImageWithImagePath:theItem.thumbnailUrl objectId:theItem.itemId type:IMAGE_LOAD_TYPE_ITEM_LIST];
        }
    }
    
    [cellResultMessageView removeFromSuperview];
    if ([allItemData countOfList] == 0) {
        cellResultMessageView = [ViewUtil getCellResultMessageInView:self.collectionView messageType:CELL_RESULT_NO_RESULT];
        [cellResultMessageView setHidden:NO];
    }
    
    [self.collectionView reloadData];
}

- (void)getImageWithImagePath:(NSString *)imagePath objectId:(NSNumber *)objectId type:(NSInteger)type
{
    if (type == IMAGE_LOAD_TYPE_SHOP_EVENT) {
        
        if ([DataUtil isImageCachedWithObjectId:objectId imageUrl:imagePath inListType:IMAGE_SHOP_EVENT]) {
            
            UIImage *eventImage = [DataUtil getImageWithObjectId:objectId inListType:IMAGE_SHOP_EVENT];
            self.shopEventImage = eventImage;
            [self.collectionView reloadData];
            
        }else{
            
            [FlagClient getImageWithImageURL:imagePath imageDataController:nil objectId:objectId objectType:IMAGE_SHOP_EVENT view:self.collectionView completion:^(UIImage *image){
                
                [DataUtil insertImageWithImage:image imageUrl:imagePath objectId:objectId inListType:IMAGE_SHOP_EVENT];
                [self.collectionView reloadData];
                
            }];
        }
        
    }else if ((type == IMAGE_LOAD_TYPE_ITEM_DETAIL) || (type == IMAGE_LOAD_TYPE_ITEM_LIST)){

        NSString *urlString = [Util addImageParameterInImagePath:imagePath width:itemImageWidth height:itemImageHeight];
        
        [FlagClient getImageWithImageURL:urlString imageDataController:imageData objectId:objectId objectType:IMAGE_ITEM view:self.collectionView completion:^(UIImage *image){
            
            if ((self.parentPage == ITEM_LIST_VIEW_PAGE) && (type == IMAGE_LOAD_TYPE_ITEM_DETAIL)) {
                
                [self setItemImage:image];
                [self.collectionView reloadData];
                
            }
        }];

    }
}


#pragma mark -
#pragma mark Collection view data source
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return [collectionViewCell count];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSNumber *cellType = [[collectionViewCell objectAtIndex:section] valueForKey:@"type"];
    
    if (([cellType intValue] == CELL_TYPE_SHOP_INFO) && (section == SHOP_INFO_SECTION)) {
        
//        if (isShopInfoCellExpanded) {
//            return 2;
//        }else return 1;
        return 1;
        
    }else if (([cellType intValue] == CELL_TYPE_ITEM_DETAIL) && (section == ITEM_DETAIL_SECTION)){
        
        return 2;
        
    }else{
        
        return [allItemData countOfList];
        
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *cell_dic = [collectionViewCell objectAtIndex:indexPath.section];
    NSNumber *cellType = [cell_dic valueForKey:@"type"];
    
    if (([cellType intValue] == CELL_TYPE_SHOP_INFO) && (indexPath.section == SHOP_INFO_SECTION)) {
        
        if (indexPath.row == SHOP_EVENT_IMAGE_ROW) {
    
            static NSString *CellIdentifier = @"ShopInfoCell";
            UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
            
            UIImageView *shopEventImageView = (UIImageView *)[cell viewWithTag:210];
            [shopEventImageView setImage:self.shopEventImage];
            
            UIButton *shopShareButton = (UIButton *)[cell viewWithTag:214];
            CGRect shopShareButtonFrame = CGRectMake(cell.frame.size.width - shopShareButton.frame.size.width, 0, shopShareButton.frame.size.width, shopShareButton.frame.size.height);
            [shopShareButton setFrame:shopShareButtonFrame];
            [shopShareButton setImage:[UIImage imageNamed:@"icon_share_green_round"] forState:UIControlStateNormal];
            [shopShareButton addTarget:self action:@selector(shareShopButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
            
            UILabel *description = (UILabel *)[cell viewWithTag:212];
            CGRect descriptionFrame = [self.shop.description boundingRectWithSize:CGSizeMake(collectionView.frame.size.width - shopDescriptionTextMargin - shopDescriptionTextPadding, shopDescriptionSectionMaxHeight) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: shopDescriptionFont} context:nil];
            CGFloat descriptionHeight;
            if (descriptionFrame.size.height > shopDescriptionSectionMaxHeight) {
                descriptionHeight = shopDescriptionSectionMaxHeight;
            }else {
                descriptionHeight = descriptionFrame.size.height;
            }
            [description setFrame:CGRectMake(shopDescriptionTextPadding, shopEventImageHeight + shopDescriptionTextPadding, descriptionFrame.size.width, descriptionHeight)];
            [description setText:self.shop.description];
            [description setTextColor:UIColorFromRGB(BASE_COLOR)];
            [description setFont:shopDescriptionFont];
            [description setBackgroundColor:[UIColor whiteColor]];
            
            UIImageView *descriptionBgImageView = (UIImageView *)[cell viewWithTag:215];
            CGRect bgFrame = CGRectMake(0, shopEventImageHeight, cell.frame.size.width, descriptionHeight + shopDescriptionTextPadding*2);
            [descriptionBgImageView setFrame:bgFrame];
            [descriptionBgImageView setBackgroundColor:[UIColor whiteColor]];
            
            UIButton *cellExpandButton = (UIButton *)[cell viewWithTag:213];
            [cellExpandButton setHidden:isShopInfoCellExpanded];
            CGRect expandButtonFrame = CGRectMake(cellExpandButton.frame.origin.x, shopEventImageHeight, cellExpandButton.frame.size.width, cellExpandButton.frame.size.height);
            [cellExpandButton setFrame:expandButtonFrame];
            [cellExpandButton addTarget:self action:@selector(expandCellButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
            [cellExpandButton setImage:[UIImage imageNamed:@"icon_triangle_down"] forState:UIControlStateNormal];
            [cellExpandButton setTitle:NSLocalizedString(@"Event Detail", @"Event Detail") forState:UIControlStateNormal];
            [cellExpandButton setBackgroundColor:UIColorFromRGB(0x246a7a)];
            [cellExpandButton setImageEdgeInsets:UIEdgeInsetsMake(2, 2, 2, 2)];
            [cellExpandButton setTintColor:[UIColor whiteColor]];
            
            UIButton *cellFoldButton = (UIButton *)[cell viewWithTag:216];
            [cellFoldButton setHidden:!isShopInfoCellExpanded];
            [cellFoldButton setFrame:CGRectMake(0, [ViewUtil getOriginYBottomToFrame:descriptionBgImageView.frame], cellFoldButton.frame.size.width, cellFoldButton.frame.size.height)];
            [cellFoldButton addTarget:self action:@selector(expandCellButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
            [cellFoldButton setBackgroundColor:UIColorFromRGB(0x246a7a)];
            [cellFoldButton setImageEdgeInsets:UIEdgeInsetsMake(2, 2, 2, 2)];
            [cellFoldButton setImage:[UIImage imageNamed:@"icon_triangle_up"] forState:UIControlStateNormal];
            [cellFoldButton setTitle:NSLocalizedString(@"Unfold Detail Event", @"Unfold Detail Event") forState:UIControlStateNormal];
            [cellFoldButton setTintColor:[UIColor whiteColor]];
            
            [cell setBackgroundColor:[UIColor grayColor]];
            
            return cell;
            
        }else if (indexPath.row == SHOP_DESCRIPTION_ROW){
        
            static NSString *CellIdentifier = @"ShopDescriptionCell";
            UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
            
            
            UILabel *description = (UILabel *)[cell viewWithTag:212];
            CGRect descriptionFrame = [self.shop.description boundingRectWithSize:CGSizeMake(collectionView.frame.size.width - shopDescriptionTextMargin - shopDescriptionTextPadding, shopDescriptionSectionMaxHeight) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: shopDescriptionFont} context:nil];
            CGFloat descriptionHeight;
            if (descriptionFrame.size.height > shopDescriptionSectionMaxHeight) {
                descriptionHeight = shopDescriptionSectionMaxHeight;
            }else {
                descriptionHeight = descriptionFrame.size.height;
            }
            [description setFrame:CGRectMake(shopDescriptionTextPadding, shopDescriptionTextPadding, descriptionFrame.size.width, descriptionHeight)];
            [description setText:self.shop.description];
            [description setTextColor:UIColorFromRGB(BASE_COLOR)];
            [description setFont:shopDescriptionFont];
            [description setBackgroundColor:[UIColor whiteColor]];
            
            
            UIButton *cellExpandButton = (UIButton *)[cell viewWithTag:213];
            [cellExpandButton setFrame:CGRectMake(0, description.frame.size.height + description.frame.origin.y + shopDescriptionTextPadding, cellExpandButton.frame.size.width, cellExpandButton.frame.size.height)];
            [cell bringSubviewToFront:cellExpandButton];
            [cellExpandButton addTarget:self action:@selector(expandCellButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
            [cellExpandButton setBackgroundColor:[UIColor colorWithWhite:0.2 alpha:0.8]];
            [cellExpandButton setImageEdgeInsets:UIEdgeInsetsMake(2, 2, 2, 2)];
            [cellExpandButton setImage:[UIImage imageNamed:@"icon_triangle_up"] forState:UIControlStateNormal];
            [cellExpandButton setTitle:@" 접기" forState:UIControlStateNormal];
            [cellExpandButton setTintColor:[UIColor whiteColor]];
            
            
            UIImageView *descriptionBgImageView = (UIImageView *)[cell viewWithTag:215];
            CGRect bgFrame = CGRectMake(0, 0, cell.frame.size.width, cell.frame.size.height - cellExpandButton.frame.size.height);
            [descriptionBgImageView setFrame:bgFrame];
            [descriptionBgImageView setBackgroundColor:[UIColor whiteColor]];
            
            return cell;
            
        }return nil;
        
        
    }else if (([cellType intValue] == CELL_TYPE_ITEM_DETAIL) && (indexPath.section == ITEM_DETAIL_SECTION)){
     
        if (indexPath.row == ITEM_DETAIL_IMAGE_ROW) {

            static NSString *CellIdentifier = @"ItemDetailImageCell";
            UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
            
            UIImageView *itemDetailImageView = (UIImageView *)[cell viewWithTag:221];
            [itemDetailImageView setImage:self.itemImage];
            
            UIButton *itemShareButton = (UIButton *)[cell viewWithTag:230];
            CGRect itemShareButtonFrame = CGRectMake(cell.frame.size.width - itemShareButton.frame.size.width, 0, itemShareButton.frame.size.width, itemShareButton.frame.size.height);
            [itemShareButton setFrame:itemShareButtonFrame];
            [itemShareButton setImage:[UIImage imageNamed:@"icon_share_green_round"] forState:UIControlStateNormal];
            [itemShareButton addTarget:self action:@selector(shareItemButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
            
            UIColor *buttonBgColor = [UIColor colorWithWhite:0.8 alpha:0.4];
            UIColor *buttonColor = UIColorFromRGB(0xeb6468);
            UIFont *buttonFont = [UIFont systemFontOfSize:12];
            
            UIButton *itemLikeButton = (UIButton *)[cell viewWithTag:222];
            [itemLikeButton setBackgroundColor:buttonBgColor];
            [itemLikeButton setImage:[ViewUtil getLikeIconImageWithLiked:self.item.liked colorType:@"red"] forState:UIControlStateNormal];
            [itemLikeButton setTitle:[NSString stringWithFormat:@" %@ %ld", NSLocalizedString(@"Like", @"Like"), (long)self.item.likes] forState:UIControlStateNormal];
            [itemLikeButton.titleLabel setFont:buttonFont];
            [itemLikeButton setTitleColor:buttonColor forState:UIControlStateNormal];
            [itemLikeButton addTarget:self action:@selector(likeItButtonTappedInItemDetail:) forControlEvents:UIControlEventTouchUpInside];
            
            UIButton *itemRewardButton = (UIButton *)[cell viewWithTag:223];
            [itemRewardButton setBackgroundColor:[Util getRewardButtonBackgroundColorWithType:[self.item getRewardState] page:ITEM_LIST_VIEW_PAGE]];
            UIImage *rewardButtonImage = [ViewUtil getRewardIconImageWithImagePath:@"icon_scan" type:[self.item getRewardState]];
            NSString *rewardButtonTitle = [Util getRewardButtonTitleWithType:[self.item getRewardState] reward:self.item.reward];
            [itemRewardButton setImage:rewardButtonImage forState:UIControlStateNormal];
            [itemRewardButton setImageEdgeInsets:UIEdgeInsetsMake(10, 0, 10, 0)];
            [itemRewardButton.imageView setContentMode:UIViewContentModeScaleAspectFit];
            [itemRewardButton setTitle:rewardButtonTitle forState:UIControlStateNormal];
            [itemRewardButton.titleLabel setFont:buttonFont];
            [itemRewardButton setTitleColor:[Util getRewardButtonColorWithType:[self.item getRewardState]] forState:UIControlStateNormal];
            [itemRewardButton addTarget:self action:@selector(itemRewardButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
            
            UIButton *itemMapButton = (UIButton *)[cell viewWithTag:224];
            [itemMapButton setBackgroundColor:buttonBgColor];
            [itemMapButton setImage:[UIImage imageNamed:@"icon_map_red"] forState:UIControlStateNormal];
            [itemMapButton addTarget:self action:@selector(showLocationButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
            
            return cell;
            
        }else if (indexPath.row == ITEM_DETAIL_DESCRIPTION_ROW){
            
            static NSString *CellIdentifier = @"ItemDetailDescriptionCell";
            UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
            
            UILabel *itemDetailNameLabel = (UILabel *)[cell viewWithTag:225];
            CGRect nameFrame = [self.item.name boundingRectWithSize:CGSizeMake(collectionView.frame.size.width - itemDetailTextPadding*2 - itemDetailTextMargin*2, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:itemDetailNameFont} context:nil];
            CGRect itemNameFrame = CGRectMake(itemDetailTextPadding, itemDetailTextPadding, nameFrame.size.width, nameFrame.size.height);
            itemDetailNameLabel.frame = itemNameFrame;
            [itemDetailNameLabel setText:self.item.name];
            [itemDetailNameLabel setFont:itemDetailNameFont];
            [itemDetailNameLabel setNumberOfLines:0];
            
            UILabel *itemDetailDescriptionLabel = (UILabel *)[cell viewWithTag:226];
            CGRect descriptionFrame = [self.item.description boundingRectWithSize:CGSizeMake(collectionView.frame.size.width - itemDetailTextPadding*2 - itemDetailTextMargin*2, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:itemDetailDescriptionFont} context:nil];
            CGRect itemDescriptionLabelFrame = CGRectMake(itemDetailTextPadding, itemDetailNameLabel.frame.origin.y + itemDetailNameLabel.frame.size.height, descriptionFrame.size.width, descriptionFrame.size.height);
            itemDetailDescriptionLabel.frame = itemDescriptionLabelFrame;
            [itemDetailDescriptionLabel setText:self.item.description];
            [itemDetailDescriptionLabel setFont:itemDetailDescriptionFont];
            [itemDetailDescriptionLabel setNumberOfLines:0];
            
            UILabel *itemDetailOldPriceLabel = (UILabel *)[cell viewWithTag:227];
            CGRect oldPriceFrame = [self.item.oldPrice boundingRectWithSize:CGSizeMake(200, 50) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:itemDetailOldPriceFont} context:nil];
            CGRect itemOldPriceFrame = CGRectMake(cell.frame.size.width - itemDetailTextPadding - oldPriceFrame.size.width, cell.frame.size.height - oldPriceFrame.size.height - itemDetailTextPadding, oldPriceFrame.size.width, oldPriceFrame.size.height);
            itemDetailOldPriceLabel.frame = itemOldPriceFrame;
            [itemDetailOldPriceLabel setText:self.item.oldPrice];
            [itemDetailOldPriceLabel setTextColor:UIColorFromRGB(0xeb6468)];
            [itemDetailOldPriceLabel setFont:itemDetailOldPriceFont];
            [itemDetailOldPriceLabel setNumberOfLines:0];
            
            if ([self.item hasOldPrice]) {
                UIImageView *oldPriceLineImageView = (UIImageView *)[cell viewWithTag:229];
                CGRect lineFrame = CGRectMake(itemOldPriceFrame.origin.x - 5, itemOldPriceFrame.origin.y + itemOldPriceFrame.size.height/2, itemOldPriceFrame.size.width + 5*2, 1);
                oldPriceLineImageView.frame = lineFrame;
                [oldPriceLineImageView setBackgroundColor:[UIColor colorWithWhite:0.5 alpha:1]];
            }
            
            UILabel *itemDetailCurrentPriceLabel = (UILabel *)[cell viewWithTag:228];
            CGRect currentPriceFrame = [self.item.price boundingRectWithSize:CGSizeMake(200, 50) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:itemDetailCurrentPriceFont} context:nil];
            CGRect itemCurrentPriceLabelFrame = CGRectMake(cell.frame.size.width - itemDetailTextPadding - currentPriceFrame.size.width, itemOldPriceFrame.origin.y - currentPriceFrame.size.height, currentPriceFrame.size.width, currentPriceFrame.size.height);
            itemDetailCurrentPriceLabel.frame = itemCurrentPriceLabelFrame;
            [itemDetailCurrentPriceLabel setText:self.item.price];
            [itemDetailCurrentPriceLabel setFont:itemDetailCurrentPriceFont];
            [itemDetailCurrentPriceLabel setTextColor:[UIColor colorWithWhite:0.4 alpha:1]];
            [itemDetailCurrentPriceLabel setNumberOfLines:1];
            [itemDetailCurrentPriceLabel setTextAlignment:NSTextAlignmentRight];
            
            [cell setBackgroundColor:[UIColor whiteColor]];
            
            return cell;

        }else return nil;
        
        
    }else{
        
        static NSString *CellIdentifier = @"ItemCell";
        UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    
        Item *theItem = (Item *)[allItemData objectInListAtIndex:indexPath.row];
        
        UIImage *theImage = (UIImage *)[imageData imageInListWithId:theItem.itemId];
        UIImageView *itemImageView = (UIImageView *)[cell viewWithTag:201];
        
        UIButton *itemScanButton = (UIButton *)[cell viewWithTag:204];
        UIImage *itemScanButtonImage = [ViewUtil getRewardIconImageWithImagePath:@"icon_scan" type:[theItem getRewardState]];
//        NSString *itemScanButtonTitle = [NSString stringWithFormat:@"%ld달", (long)theItem.reward];
//        UIFont *itemScanButtonFont = [UIFont boldSystemFontOfSize:14];
//        CGRect titleFrame = [itemScanButtonTitle boundingRectWithSize:CGSizeMake(70, 28) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:itemScanButtonFont} context:nil];
        [itemScanButton setImage:itemScanButtonImage forState:UIControlStateNormal];
        [itemScanButton setImageEdgeInsets:UIEdgeInsetsMake(5, 0, 5, 0)];
        [itemScanButton.imageView setContentMode:UIViewContentModeScaleAspectFit];
//        [itemScanButton setTitle:itemScanButtonTitle forState:UIControlStateNormal];
//        [itemScanButton setTitleColor:[UIColor colorWithWhite:0.3 alpha:1] forState:UIControlStateNormal];
//        [itemScanButton.titleLabel setFont:itemScanButtonFont];
        [itemScanButton addTarget:self action:@selector(scanButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
        [itemScanButton setHidden:!theItem.rewardable];
        
        
        UIButton *itemLikeButton = (UIButton *)[cell viewWithTag:206];
        UIImage *itemLikeButtonImage = [ViewUtil getLikeIconImageWithLiked:theItem.liked colorType:@"red"];
        NSString *itemLikeButtonTitle = [NSString stringWithFormat:@" %@ %ld", NSLocalizedString(@"Like", @"Like"), (long)theItem.likes];
        [itemLikeButton setImage:itemLikeButtonImage forState:UIControlStateNormal];
        [itemLikeButton setImageEdgeInsets:UIEdgeInsetsMake(5, 0, 5, 0)];
        [itemLikeButton.imageView setContentMode:UIViewContentModeScaleAspectFit];
        [itemLikeButton setTitle:itemLikeButtonTitle forState:UIControlStateNormal];
        [itemLikeButton setTitleColor:UIColorFromRGB(0xEB6468) forState:UIControlStateNormal];
        [itemLikeButton.titleLabel setFont:[UIFont systemFontOfSize:12]];
        [itemLikeButton addTarget:self action:@selector(likeItemButtonTappedInItemList:) forControlEvents:UIControlEventTouchUpInside];
        
        [itemImageView setImage:theImage];
        [itemImageView.layer setBorderColor:[UIColor colorWithWhite:0 alpha:0.1].CGColor];
        [itemImageView.layer setBorderWidth:0.5f];
        
        
        // Border line
        cell.layer.borderColor = [UIColor colorWithWhite:0 alpha:0.1].CGColor;
        cell.layer.borderWidth = 0.5f;
        
        return cell;
        
    }
}

#pragma mark - Collection view delegate
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSNumber *cellType = [[collectionViewCell objectAtIndex:indexPath.section] valueForKey:@"type"];
    
    if (([cellType integerValue] == CELL_TYPE_SHOP_INFO) && (indexPath.section == SHOP_INFO_SECTION)) {
        
        if (indexPath.row == SHOP_EVENT_IMAGE_ROW) {
            
            CGFloat cellHeight;
            CGFloat imageHeight = 190.0f;
            
            CGRect descriptionFrame = [self.shop.description boundingRectWithSize:CGSizeMake(collectionView.frame.size.width - shopDescriptionTextPadding - shopDescriptionTextMargin, shopDescriptionSectionMaxHeight) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: shopDescriptionFont} context:nil];
            CGFloat descriptionHeight = shopDescriptionTextPadding + shopDescriptionTextPadding;
            
            if (descriptionFrame.size.height > shopDescriptionSectionMaxHeight) {
                descriptionHeight += shopDescriptionSectionMaxHeight;
            }else descriptionHeight += descriptionFrame.size.height;
            
            if (isShopInfoCellExpanded) {
                cellHeight = imageHeight + descriptionHeight;
            }else cellHeight = imageHeight;
            
            return CGSizeMake(310.0f, cellHeight);
            
        }else{
            
            CGRect descriptionFrame = [self.shop.description boundingRectWithSize:CGSizeMake(collectionView.frame.size.width - shopDescriptionTextPadding - shopDescriptionTextMargin, shopDescriptionSectionMaxHeight) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: shopDescriptionFont} context:nil];
            CGFloat height = shopDescriptionTextPadding + shopDescriptionTextPadding + shopDescriptionExpandButtonHeight;
            
            if (descriptionFrame.size.height > shopDescriptionSectionMaxHeight) {
                height += shopDescriptionSectionMaxHeight;
            }else height += descriptionFrame.size.height;
            
            return CGSizeMake(310.0f, height);
        }
        
    }if (([cellType integerValue] == CELL_TYPE_ITEM_DETAIL) && (indexPath.section == ITEM_DETAIL_SECTION)) {
        
        if (indexPath.row == ITEM_DETAIL_IMAGE_ROW) {
            
            return CGSizeMake(310.0f, 389.0f);
            
        }else{
            
            CGRect nameFrame = [self.item.name boundingRectWithSize:CGSizeMake(collectionView.frame.size.width - itemDetailTextMargin*2 - itemDetailTextPadding*2, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:itemDetailNameFont} context:nil];
            CGRect descriptionFrame = [self.item.description boundingRectWithSize:CGSizeMake(collectionView.frame.size.width - itemDetailTextMargin*2 - itemDetailTextPadding*2, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:itemDetailDescriptionFont} context:nil];
            CGFloat height = itemDetailTextPadding + nameFrame.size.height + descriptionFrame.size.height + itemDetailPricePartHeight + itemDetailTextPadding;

            return CGSizeMake(310.0f, height);
        }
        
    }else return CGSizeMake(153.0f, 220.0f);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    NSNumber *cellType = [[collectionViewCell objectAtIndex:section] valueForKey:@"type"];
    
    if (([cellType integerValue] == CELL_TYPE_SHOP_INFO) && (section == SHOP_INFO_SECTION)) {
        return 4;
    }if (([cellType integerValue] == CELL_TYPE_ITEM_DETAIL) && (section == ITEM_DETAIL_SECTION)) {
        return 0;
    }else{
        return 4;
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    NSNumber *cellType = [[collectionViewCell objectAtIndex:section] valueForKey:@"type"];
    
    if (([cellType integerValue] == CELL_TYPE_SHOP_INFO) && (section == SHOP_INFO_SECTION)) {
        return CGSizeZero;
    }if (([cellType integerValue] == CELL_TYPE_ITEM_DETAIL) && (section == ITEM_DETAIL_SECTION)) {
        return CGSizeZero;
    }else{
        if ((self.parentPage == ITEM_LIST_VIEW_PAGE) && ([allItemData countOfList])) {
            return CGSizeMake(collectionView.frame.size.width, 30.0f);
        }else return CGSizeZero;
    }
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *reusableView = nil;
    
    if(kind == UICollectionElementKindSectionHeader){
        
        UICollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"ItemListHeaderCell" forIndexPath:indexPath];
        UIButton *headerBgButton = (UIButton *)[headerView viewWithTag:240];
        UIImage *iconImage = [UIImage imageNamed:@"icon_star"];
        [headerBgButton setBackgroundImage:[UIImage imageNamed:@"bg_item_list_header"] forState:UIControlStateNormal];
        [headerBgButton setTitle:NSLocalizedString(@"Recommend", @"Recommend") forState:UIControlStateNormal];
        [headerBgButton.titleLabel setFont:[UIFont systemFontOfSize:13]];
        [headerBgButton.titleLabel setTextColor:[UIColor whiteColor]];
        [headerBgButton setTitleEdgeInsets:UIEdgeInsetsMake(0, -iconImage.size.width + 15, 0, iconImage.size.width)];
        [headerBgButton setImage:iconImage forState:UIControlStateNormal];
        [headerBgButton setImageEdgeInsets:UIEdgeInsetsMake(2, -iconImage.size.width + 5, 2, iconImage.size.width)];
        [headerBgButton.imageView setContentMode:UIViewContentModeScaleAspectFit];
        [headerBgButton setTintColor:UIColorFromRGB(0xeb6468)];
        
        reusableView = headerView;
    }
    return reusableView;
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSNumber *cellType = [[collectionViewCell objectAtIndex:indexPath.section] valueForKey:@"type"];
    
    if (([cellType integerValue] == CELL_TYPE_SHOP_INFO) && (indexPath.section == SHOP_INFO_SECTION)) {
        
        [self shopInfoCellSelectedWithIndexPath:indexPath];
        
    }else if (([cellType integerValue] == CELL_TYPE_ITEM_DETAIL) && (indexPath.section == ITEM_DETAIL_SECTION)) {
        
        DLog(@"item detail image tapped");
        
    }else{
        
        [self itemCellSelectedWithIndexPath:indexPath];
        
    }
}

- (void)shopInfoCellSelectedWithIndexPath:(NSIndexPath *)indexPath
{
    // GA
    [GAUtil sendGADataWithUIAction:@"expand_description_tapped" label:@"inside_view" value:nil];
    
    
    [self performSelector:@selector(expandCellButtonTapped:) withObject:nil];
}

- (void)itemCellSelectedWithIndexPath:(NSIndexPath *)indexPath
{
    // GA
    [GAUtil sendGADataWithUIAction:@"see_item_image" label:@"escape_view" value:nil];
    
    
    Item *theItem = (Item *)[allItemData objectInListAtIndex:indexPath.row];
    UIImage *theItemImage = [imageData imageInListWithId:theItem.itemId];
    
    UIStoryboard *storyboard = [ViewUtil getStoryboard];
    ItemListViewController *childViewController = (ItemListViewController *)[storyboard instantiateViewControllerWithIdentifier:@"ItemListView"];
    
    [childViewController setUser:self.user];
    [childViewController setItem:theItem];
    [childViewController setItemImage:theItemImage];
    [childViewController setParentPage:ITEM_LIST_VIEW_PAGE];
    
//    ItemDetailViewController *childViewController = (ItemDetailViewController *)[storyboard instantiateViewControllerWithIdentifier:@"ItemDetailView"];
//    
//    childViewController.user = self.user;
//    childViewController.item = theItem;
//    childViewController.itemImage = theItemImage;
//    childViewController.parentPage = ITEM_LIST_VIEW_PAGE;
//    
//    childViewController.itemListViewController = self;
//    childViewController.selectedItemIndexpathRow = indexPath.row;
    
    [self.navigationController pushViewController:childViewController animated:YES];
}

#pragma mark - IBAction
- (IBAction)expandCellButtonTapped:(id)sender
{
    DLog(@"expand description tapped");
    
//    if (isShopInfoCellExpanded) {
//        [self.collectionView deleteItemsAtIndexPaths:@[[NSIndexPath indexPathForItem:SHOP_DESCRIPTION_ROW inSection:SHOP_INFO_SECTION]]];
//    }else{
//        [self.collectionView insertItemsAtIndexPaths:@[[NSIndexPath indexPathForItem:SHOP_DESCRIPTION_ROW inSection:SHOP_INFO_SECTION]]];
//    }
    isShopInfoCellExpanded = !isShopInfoCellExpanded;
    
    [self.collectionView reloadData];
}

- (IBAction)scanButtonTapped:(UIButton *)sender
{
    CGPoint buttonOrigiInCollectionView = [sender convertPoint:CGPointZero toView:self.collectionView];
    NSIndexPath *indexPath = [self.collectionView indexPathForItemAtPoint:buttonOrigiInCollectionView];
    Item *theItem = (Item *)[allItemData objectInListAtIndex:indexPath.row];
    
    [self showItemScanViewWithItem:theItem];
    

    // Analytics
    [GAUtil sendGADataWithUIAction:@"item_scan_click" label:@"inside_view" value:nil];
    [DaLogClient sendDaLogWithCategory:CATEGORY_ITEM_SCAN target:[theItem.itemId integerValue] value:0];
}

- (IBAction)cancelButtonTapped:(id)sender
{
    // Analytics
    [GAUtil sendGADataWithUIAction:@"go_back" label:@"escape_view" value:nil];
    [DaLogClient sendDaLogWithCategory:CATEGORY_VIEW_DISAPPEAR target:view_type value:0];
    
    
    if (self.parentPage == SLIDE_MENU_PAGE) {
        
        [self dismissViewControllerAnimated:YES completion:nil];
    
    }else if (self.parentPage == COLLECT_REWARD_SELECT_VIEW_PAGE){
    
        DLog(@"cancel button tapped");
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



#pragma mark
#pragma mark - Item Detail Implemetation
- (IBAction)likeItButtonTappedInItemDetail:(id)sender
{
    // Analytics
    [GAUtil sendGADataWithUIAction:@"like_item_click" label:@"inside_view" value:nil];
    [DaLogClient sendDaLogWithCategory:CATEGORY_ITEM_LIKE target:[self.item.itemId integerValue] value:0];
    
    
    [self likeItemButtonTappedWithItem:self.item];
}

- (IBAction)likeItemButtonTappedInItemList:(id)sender
{
    CGPoint tappedPoint = [Util getPointForTappedObjectWithSender:sender toView:self.collectionView];
    NSIndexPath *indexpath = [self.collectionView indexPathForItemAtPoint:tappedPoint];
    Item *theItem = [allItemData objectInListAtIndex:indexpath.row];
    [self likeItemButtonTappedWithItem:theItem];
    
    
    // Analytics
    [GAUtil sendGADataWithUIAction:@"like_item_in_list_click" label:@"inside_view" value:nil];
    [DaLogClient sendDaLogWithCategory:CATEGORY_ITEM_LIKE target:[theItem.itemId integerValue] value:0];
}

- (IBAction)itemRewardButtonTapped:(id)sender
{
    // Analytics
    [GAUtil sendGADataWithUIAction:@"reward_item_click" label:@"inside_view" value:nil];
    [DaLogClient sendDaLogWithCategory:CATEGORY_ITEM_SCAN target:[self.item.itemId integerValue] value:0];
    
    
    if ([self.item getRewardState] == REWARD_STATE_BEFORE) {
        
        DLog(@"item reward");
        
    }else if ([self.item getRewardState] == REWARD_STATE_DISABLED){
        
        [Util showAlertView:nil message:[NSString stringWithFormat:@"%@%@", self.item.name, NSLocalizedString(@"will cooperate with us. Please wait", @"will cooperate with us. Please wait")] title:NSLocalizedString(@"No Reward", @"No Reward")];
        
    }else if ([self.item getRewardState] == REWARD_STATE_DONE){
        
        [Util showAlertView:nil message:[NSString stringWithFormat:@"%@%@", self.item.name, NSLocalizedString(@"is already rewarded", @"is already rewarded")] title:NSLocalizedString(@"Reward Complete", @"Reward Complete")];
        
    }
}

- (IBAction)shareShopButtonTapped:(id)sender
{
    // Analytics
    [GAUtil sendGADataWithUIAction:@"share_shop_tapped" label:@"inside_view" value:nil];
    [DaLogClient sendDaLogWithCategory:CATEGORY_SHOP_SHARE target:[self.shop.shopId integerValue] value:0];
    
    
    [self shareShopThrouhKakaoTalk];
}

- (IBAction)shareItemButtonTapped:(id)sender
{
    // Analytics
    [GAUtil sendGADataWithUIAction:@"share_item_tapped" label:@"inside_view" value:nil];
    [DaLogClient sendDaLogWithCategory:CATEGORY_ITEM_SHARE target:[self.item.itemId integerValue] value:0];
    
    
    [self shareItemThroughKakaoTalk];
}

- (IBAction)showLocationButtonTapped:(id)sender
{
    // Analytics
    [GAUtil sendGADataWithUIAction:@"show_location_click" label:@"inside_view" value:nil];
    [DaLogClient sendDaLogWithCategory:CATEGORY_ITEM_MAP target:[self.item.itemId integerValue] value:0];
    
    
    [self presentMapView];
}

- (void)likeItemButtonTappedWithItem:(Item *)theItem
{
    if ([theItem isItemLiked]) {
        [self cancelLikeItemWithItem:theItem];
    }else{
        [self likeItemWithItem:theItem];
    }
}

- (void)likeItemWithItem:(Item *)theItem
{
    NSDate *startDate = [NSDate date];
    
    GTLServiceFlagengine *service = [FlagClient flagengineService];
    
    GTLFlagengineLike *like = [GTLFlagengineLike alloc];
    [like setTargetId:theItem.itemId];
    [like setUserId:self.user.userId];
    [like setType:[NSNumber numberWithInt:LIKE_ITEM]];
    GTLQueryFlagengine *query = [GTLQueryFlagengine queryForLikesInsertWithObject:like];
    
    [service executeQuery:query completionHandler:^(GTLServiceTicket *ticket, GTLFlagengineLike *object, NSError *error){
        
        DLog(@"result object %@", object);
        
        if (error == nil) {
            // GA
            [GAUtil sendGADataLoadTimeWithInterval:[[NSDate date] timeIntervalSinceDate:startDate] actionName:@"like_item" label:nil];
            
            
            [DataUtil saveLikeObjectWithObjectId:theItem.itemId type:LIKE_ITEM];
            [theItem likeItem];
            [self.collectionView reloadData];
        }
        
    }];
}

- (void)cancelLikeItemWithItem:(Item *)theItem
{
    URLParameters *urlParams = [self getURLToCancelLikeItemWithItem:theItem];
    
    [FlagClient getDataResultWithURL:[urlParams getURLForRequest] methodName:[urlParams getMethodName] completion:^(NSDictionary *results){
        
        if (!results) {
            [DataUtil deleteLikeObjectWithObjectId:theItem.itemId type:LIKE_ITEM];
            [theItem cancelLikeItem];
            [self.collectionView reloadData];
            
        }
    }];
}

- (URLParameters *)getURLToCancelLikeItemWithItem:(Item *)theItem
{
    URLParameters *urlParam = [[URLParameters alloc] init];
    [urlParam setMethodName:@"like"];
    [urlParam addParameterWithKey:@"itemId" withParameter:theItem.itemId];
    [urlParam addParameterWithKey:@"type" withParameter:[NSNumber numberWithInt:LIKE_ITEM]];
    [urlParam addParameterWithUserId:self.user.userId];
    
    return urlParam;
}

- (void)shareShopThrouhKakaoTalk
{
    NSDictionary *kakaoTalkParams = [[NSDictionary alloc] initWithObjectsAndKeys:@"shop", @"method", self.shop.shopId, @"shopId", nil];
    NSString *kakaoTalkMessage = [NSString stringWithFormat:@"%@\n%@", NSLocalizedString(@"DALSHOP found SALE For you", @"DALSHOP found SALE For you"), self.shop.description];
    CGFloat imageWidth  = 150;
    CGFloat imageHeight = self.shopEventImage.size.height * imageWidth / self.shopEventImage.size.width;
    
    [SNSUtil makeKakaoTalkLinkToKakaoTalkLinkObjects:kakaoTalkLinkObjects message:kakaoTalkMessage imageURL:self.shop.imageUrl imageWidth:imageWidth Height:imageHeight execParameter:kakaoTalkParams];
    [SNSUtil sendKakaoTalkLinkByKakaoTalkLinkObjects:kakaoTalkLinkObjects];
}

- (void)shareItemThroughKakaoTalk
{
    NSDictionary *kakaoTalkParams = [[NSDictionary alloc] initWithObjectsAndKeys:@"item", @"method", self.item.shopId, @"shopId", self.item.itemId, @"itemId", nil];
    NSString *kakaoTalkMessage = [NSString stringWithFormat:@"%@\n%@", NSLocalizedString(@"DALSHOP found Hot Item For you", @"DALSHOP found Hot Item For you"), self.item.description];
    CGFloat imageWidth  = 150;
    CGFloat imageHeight = self.itemImage.size.height * imageWidth / self.itemImage.size.width;
    
    [SNSUtil makeKakaoTalkLinkToKakaoTalkLinkObjects:kakaoTalkLinkObjects message:kakaoTalkMessage imageURL:self.item.thumbnailUrl imageWidth:imageWidth Height:imageHeight execParameter:kakaoTalkParams];
    [SNSUtil sendKakaoTalkLinkByKakaoTalkLinkObjects:kakaoTalkLinkObjects];
}

- (void)presentMapView
{
    UIStoryboard *storyboard = [ViewUtil getStoryboard];
    FlagViewController *childViewController = (FlagViewController *)[storyboard instantiateViewControllerWithIdentifier:@"FlagView"];
    childViewController.user = self.user;
    childViewController.objectIdForFlag = self.item.itemId;
    childViewController.parentPage = ITEM_DETAIL_VIEW_PAGE;
    
    [self.navigationController pushViewController:childViewController animated:YES];
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

- (void)configureScanRewardTutorial
{
    if (![DataUtil getUserActionHistoryForRewardShopWatched]) {
        NSString *tutorialMessage = @"상품의 바코드를 스캔하세요\n스캔으로 달을 딸 수 있어요!!";
        [Util showAlertView:nil message:tutorialMessage title:@"서비스소개"];
        [DataUtil saveUserHistoryForRewardShopWatched];
    }
}

@end
