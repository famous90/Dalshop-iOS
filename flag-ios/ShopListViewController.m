//
//  ShopListViewController.m
//  flag-ios
//
//  Created by Gyuyoung Hwang on 2014. 2. 6..
//
//

#import "AppDelegate.h"
#import "ShopListViewController.h"
#import "SaleInfoViewController.h"
#import "ActivityIndicatorView.h"
#import "SWRevealViewController.h"
#import "CollectRewardViewController.h"
#import "TransitionDelegate.h"
#import "FlagViewController.h"
#import "ItemListViewController.h"
#import "SVPullToRefresh.h"
#import "PageTutorialViewController.h"

#import "User.h"
#import "FlagDataController.h"
#import "Flag.h"
#import "ShopDataController.h"
#import "Shop.h"
#import "ImageDataController.h"
#import "URLParameters.h"

#import "Util.h"
#import "ViewUtil.h"
#import "DataUtil.h"
#import "URLParameters.h"

#import "FlagClient.h"
#import "GTLFlagengine.h"
#import "GoogleAnalytics.h"

@interface ShopListViewController ()

@end

@implementation ShopListViewController{
    URLParameters *shopListURLParam;
    ShopDataController *shopData;
    FlagDataController *flagData;
    FlagDataController *orderedFlagData;
    ImageDataController *logoImageData;
    ImageDataController *eventImageData;
    
    NSInteger shopListMarker;
    
    CLLocation *applicationLocation;
    
    NSInteger view_type;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.user = [[User alloc] init];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    [self.view setBackgroundColor:UIColorFromRGB(BASE_COLOR)];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    [self configureViewContent];
    [self initializeParameters];
    [self initializeContent];
    
    
    // Analytics
    [[GAI sharedInstance].defaultTracker set:kGAIScreenName value:GAI_SCREEN_NAME_SHOP_LIST_VIEW];
    [[GAI sharedInstance].defaultTracker send:[[GAIDictionaryBuilder createAppView] build]];
    [DaLogClient sendDaLogWithCategory:CATEGORY_VIEW_APPEAR target:VIEW_TABBAR_SHOP_LIST value:0];
}

- (void)configureViewContent
{
    if (self.parentPage == TAB_BAR_VIEW_PAGE) {
        
        UIBarButtonItem *menuButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icon_slide_menu"] style:UIBarButtonItemStyleBordered target:self.revealViewController action:@selector(revealToggle:)];
        
        self.navigationItem.leftBarButtonItem = menuButton;
        menuButton.tintColor = UIColorFromRGB(BASE_COLOR);
        [self.tableView addGestureRecognizer:self.revealViewController.panGestureRecognizer];
        
        UIBarButtonItem *rewardMenuButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icon_slide_menu"] style:UIBarButtonItemStyleBordered target:self.revealViewController action:@selector(rightRevealToggle:)];
        [rewardMenuButton setTintColor:UIColorFromRGB(0xf2b518)];
        self.navigationItem.rightBarButtonItem = rewardMenuButton;
        
        [self.view addGestureRecognizer:self.revealViewController.tapGestureRecognizer];
        
//        UIBarButtonItem *collectRewardButton = [[UIBarButtonItem alloc] initWithTitle:@"달따기" style:UIBarButtonItemStyleBordered target:self action:@selector(presentCollectRewardSelectView:)];
//        self.navigationItem.rightBarButtonItem = collectRewardButton;
        
    }else if (self.parentPage == SLIDE_MENU_PAGE){
        
        [self setTitle:NSLocalizedString(@"Check-In Shop", @"Check-In Shop")];
        [self.navigationController.navigationBar setTintColor:UIColorFromRGB(BASE_COLOR)];
        
        UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"button_back"] style:UIBarButtonItemStyleBordered target:self action:@selector(cancel:)];
        [self.navigationItem setLeftBarButtonItem:cancelButton];
        
        UIBarButtonItem *rewardMapButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icon_map"] style:UIBarButtonItemStyleBordered target:self action:@selector(rewardFlagListInMapButtonTapped:)];
        [self.navigationItem setRightBarButtonItem:rewardMapButton];
    }
}

- (void)initializeParameters
{
    shopListMarker = 0;

    shopData = [[ShopDataController alloc] init];
    flagData = [[FlagDataController alloc] init];
    logoImageData = [[ImageDataController alloc] init];
    eventImageData = [[ImageDataController alloc] init];
}

- (void)initializeContent
{
    if (self.parentPage == TAB_BAR_VIEW_PAGE) {
        
        shopListURLParam = [self urlParamsToGetShopListWithLocation:applicationLocation];
        
        __weak ShopListViewController *weakSelf = self;
        
        // setup infinite scrolling
        [self.tableView addInfiniteScrollingWithActionHandler:^{
            [weakSelf insertRowAtBottom];
        }];
        
    }else if (self.parentPage == SLIDE_MENU_PAGE){
        
        shopListURLParam = [self urlParamToGetRewardShopListWithLocation:applicationLocation];
        
//        __weak ShopListViewController *weakSelf = self;
//
//        // setup infinite scrolling
//        [self.tableView addInfiniteScrollingWithActionHandler:^{
//            [weakSelf insertRowAtBottom];
//        }];
    }
    
    [self performSelectorInBackground:@selector(getShopListWithURLParam:) withObject:shopListURLParam];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self setUser:[DelegateUtil getUser]];
    [ViewUtil setAppDelegatePresentingViewControllerWithViewController:self];
    
    applicationLocation = [DelegateUtil getCurrentLocation];
}


- (void)viewDidAppear:(BOOL)animated
{
    [self.tableView triggerPullToRefresh];
}

#pragma mark
#pragma mark - connect server
- (void)getShopListWithURLParam:(URLParameters *)urlParam
{
    // Activity Indicator
    ActivityIndicatorView *aiView = [ActivityIndicatorView startActivityIndicatorInParentView:self.tableView];
    
    [FlagClient getDataResultWithURL:[urlParam getURLForRequest] methodName:[urlParam getMethodName] completion:^(NSDictionary *results){
        
        if (results) {
            [self setFlagDataWithJsonData:results];
            [self setShopDataWithJsonData:results];
            DLog(@"marker %ld", (long)shopListMarker);
            shopListMarker++;
        }
        
        [aiView stopActivityIndicator];
        
    }];
}

- (URLParameters *)urlParamsToGetShopListWithLocation:(CLLocation *)theLocation
{
    URLParameters *urlParam = [[URLParameters alloc] init];
    [urlParam setMethodName:@"shop_start"];
    [urlParam addParameterWithKey:@"mark" withParameter:[NSNumber numberWithInteger:shopListMarker]];
    [urlParam addParameterWithUserId:self.user.userId];
    
    return urlParam;
}

- (URLParameters *)urlParamToGetRewardShopListWithLocation:(CLLocation *)theLocation
{
    URLParameters *urlParam = [[URLParameters alloc] init];
    [urlParam setMethodName:@"shop_list_reward"];
    [urlParam addParameterWithKey:@"mark" withParameter:[NSNumber numberWithInteger:shopListMarker]];
    [urlParam addParameterWithUserId:self.user.userId];
    
    return urlParam;
}

- (void)setShopDataWithJsonData:(NSDictionary *)results
{
    NSArray *shops = [results objectForKey:@"shops"];
    for(id object in shops){
        Shop *theShop = [[Shop alloc] initWithData:object];
        [shopData addObjectWithObject:theShop];
        
        if (![theShop.logoUrl isEqual:(id)[NSNull null]]) {
            [self getImageDataWithImageURL:theShop.logoUrl objectId:theShop.shopId imageType:IMAGE_SHOP_LOGO imageData:logoImageData];
        }
        
        if (![theShop.imageUrl isEqual:(id)[NSNull null]]) {
            [self getImageDataWithImageURL:theShop.imageUrl objectId:theShop.shopId imageType:IMAGE_SHOP_EVENT imageData:eventImageData];
        }
    }
    
    [self.tableView reloadData];
}

- (void)getImageDataWithImageURL:(NSString *)imageUrl objectId:(NSNumber *)objectId imageType:(NSInteger)type imageData:(ImageDataController *)imageData
{
    if ([DataUtil isImageCachedWithObjectId:objectId imageUrl:imageUrl inListType:type]) {
        
        UIImage *image = [DataUtil getImageWithObjectId:objectId inListType:type];
        [imageData addImageWithImage:image withId:objectId];
        
    }else{
        
        [FlagClient getImageWithImageURL:imageUrl imageDataController:imageData objectId:objectId objectType:type view:self.tableView completion:^(UIImage *image){
            [DataUtil insertImageWithImage:image imageUrl:imageUrl objectId:objectId inListType:type];
        }];
    }
}

- (void)setFlagDataWithJsonData:(NSDictionary *)results
{
    NSArray *flags = [results objectForKey:@"flags"];
    for(id object in flags){
        Flag *theFlag = [[Flag alloc] initWithData:object];
        [flagData addObjectWithObject:theFlag];
    }
    
//    NSArray *sortedFlags = [flagData sortFlagsByDistanceFromCurrentLocation];
    NSArray *sortedFlags = [NSArray arrayWithArray:[flagData getMasterData]];
    orderedFlagData = [[FlagDataController alloc] initWithArray:sortedFlags];
    
    [self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [shopData countOfList];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"ShopCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    
//    Flag *theFlag = (Flag *)[orderedFlagData objectInListAtIndex:indexPath.row];
//    Shop *theShop = (Shop *)[shopData objectInlistWithObjectId:theFlag.shopId];
    Shop *theShop = (Shop *)[shopData objectInListAtIndex:indexPath.row];
//    Flag *theFlag = (Flag *)[flagData objectWithShopId:theShop.shopId];
    
    
    UIImage *shopLogoImage = (UIImage *)[logoImageData imageInListWithId:theShop.shopId];
    UIImage *shopEventImage = (UIImage *)[eventImageData imageInListWithId:theShop.shopId];
    
    
    if (theShop) {
        
        UIColor *buttonColor = UIColorFromRGB(0xEB6468);
        UIColor *lineColor = UIColorFromRGBWithAlpha(0xEB6468, 0.5);
        UIFont *buttonFont = [UIFont systemFontOfSize:13];

        UILabel *shopNameLabel = (UILabel *)[cell viewWithTag:601];
        [shopNameLabel setText:[Util changeStringFirstSpaceToLineBreak:theShop.name]];
        
        UIImageView *shopLogoImageView = (UIImageView *)[cell viewWithTag:604];
        [shopLogoImageView setImage:shopLogoImage];
        [shopLogoImageView setContentMode:UIViewContentModeScaleAspectFit];
        
        UIImageView *shopEventImageView = (UIImageView *)[cell viewWithTag:608];
        [shopEventImageView setImage:shopEventImage];
        [shopEventImageView.layer setCornerRadius:4.0f];
        [shopEventImageView setClipsToBounds:YES];
    
        UIButton *shopLikeButton = (UIButton *)[cell viewWithTag:609];
        [shopLikeButton setImage:[ViewUtil getLikeIconImageWithLiked:theShop.liked colorType:@"red"] forState:UIControlStateNormal];
        [shopLikeButton setTitle:[NSString stringWithFormat:@" %@ %ld", NSLocalizedString(@"Like", @"Like"), (long)theShop.likes] forState:UIControlStateNormal];
        [shopLikeButton.titleLabel setFont:buttonFont];
        [shopLikeButton setTitleColor:buttonColor forState:UIControlStateNormal];
        [shopLikeButton addTarget:self action:@selector(likeItButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
        
        UIButton *shopCheckInButton = (UIButton *)[cell viewWithTag:610];
        [shopCheckInButton setBackgroundColor:[Util getRewardButtonBackgroundColorWithType:[theShop getCheckInStateType] page:SHOP_LIST_VIEW_PAGE]];
        UIImage *checkInButtonImage = [ViewUtil getRewardIconImageWithImagePath:@"icon_checkIn" type:[theShop getCheckInStateType]];
        NSString *checkInButtonTitle = [Util getRewardButtonTitleWithType:[theShop getCheckInStateType] reward:theShop.reward];
        [shopCheckInButton.imageView setContentMode:UIViewContentModeScaleAspectFit];
        [shopCheckInButton setImageEdgeInsets:UIEdgeInsetsMake(10, 0, 10, 0)];
        [shopCheckInButton setImage:checkInButtonImage forState:UIControlStateNormal];
        [shopCheckInButton setTitle:checkInButtonTitle forState:UIControlStateNormal];
        [shopCheckInButton setTitleColor:[Util getRewardButtonColorWithType:[theShop getCheckInStateType]] forState:UIControlStateNormal];
        [shopCheckInButton.titleLabel setFont:buttonFont];
        [shopCheckInButton addTarget:self action:@selector(checkInButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
        
        UIButton *shopLocationButton = (UIButton *)[cell viewWithTag:611];
        UIImage *locationButtonImage = [UIImage imageNamed:@"icon_map_red"];
        [shopLocationButton setImage:locationButtonImage forState:UIControlStateNormal];
        [shopLocationButton.titleLabel setFont:buttonFont];
        [shopLocationButton addTarget:self action:@selector(showLocationButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
        
        UIImageView *shopCellBgImageView = (UIImageView *)[cell viewWithTag:607];
        [shopCellBgImageView.layer setCornerRadius:4.0f];
        
        UIView *line1 = [[UIView alloc] initWithFrame:CGRectMake(5, 213, 310, 0.5f)];
        [line1 setBackgroundColor:lineColor];
        [cell addSubview:line1];

        UIView *line2 = [[UIView alloc] initWithFrame:CGRectMake(108, 213, 0.5f, 40)];
        [line2 setBackgroundColor:lineColor];
        [cell addSubview:line2];
        
        UIView *line3 = [[UIView alloc] initWithFrame:CGRectMake(211, 213, 0.5f, 40)];
        [line3 setBackgroundColor:lineColor];
        [cell addSubview:line3];
        
        UIView *line4 = [[UIView alloc] initWithFrame:CGRectMake(5, 173, 310, 0.5f)];
        [line4 setBackgroundColor:lineColor];
        [cell addSubview:line4];
        
        [cell setBackgroundColor:UIColorFromRGB(BASE_COLOR)];
    }
    
    return cell;
}


#pragma mark - table view delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 256.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    Flag *theFlag = (Flag *)[orderedFlagData objectInListAtIndex:indexPath.row];
//    Shop *theShop = (Shop *)[shopData objectInlistWithObjectId:theFlag.shopId];
    Shop *theShop = (Shop *)[shopData objectInListAtIndex:indexPath.row];
//    Flag *theFlag = (Flag *)[flagData objectWithShopId:theShop.shopId];
    UIImage *shopEventImage = [eventImageData imageInListWithId:theShop.shopId];

    
    // Analytics
    [GAUtil sendGADataWithUIAction:@"pick_shop" label:@"escape_view" value:nil];
    [DaLogClient sendDaLogWithCategory:CATEGORY_VIEW_DISAPPEAR target:VIEW_TABBAR_SHOP_LIST value:0];
    [DaLogClient sendDaLogWithCategory:CATEGORY_SHOP_VIEW target:[theShop.shopId integerValue] value:0];

    
    [self presentItemListViewWithShop:theShop shopEventImage:shopEventImage];
}

- (void)presentItemListViewWithShop:(Shop *)theShop shopEventImage:(UIImage *)image;
{
    UIStoryboard *storyboard = [ViewUtil getStoryboard];
    ItemListViewController *childViewController = (ItemListViewController *)[storyboard instantiateViewControllerWithIdentifier:@"ItemListView"];
    
    [childViewController setUser:self.user];
    [childViewController setShop:theShop];
    [childViewController setParentPage:SHOP_LIST_VIEW_PAGE];
    [childViewController setShopEventImage:image];
    
    [self.navigationController pushViewController:childViewController animated:YES];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 2.0f)];
    UIImageView *headerImageView = [[UIImageView alloc] initWithFrame:headerView.frame];
    
    headerImageView.backgroundColor = UIColorFromRGB(BASE_COLOR);
    [headerView addSubview:headerImageView];
    
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 2.0f;
}


#pragma mark -
#pragma mark pull to refresh delegate
- (void)insertRowAtBottom
{
    // GA
    [GAUtil sendGADataWithUIAction:@"pull_bottom_to_refresh_reward_shop_list" label:@"inside_view" value:nil];
    
    
    __weak ShopListViewController *weakSelf = self;
    
    int64_t delayInSeconds = 2.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        
        URLParameters *urlParam;
        if (self.parentPage == TAB_BAR_VIEW_PAGE) {
            urlParam = [self urlParamsToGetShopListWithLocation:applicationLocation];
        }else if (self.parentPage == SLIDE_MENU_PAGE){
            urlParam = [self urlParamToGetRewardShopListWithLocation:applicationLocation];
        }
        
        [weakSelf performSelectorInBackground:@selector(getShopListWithURLParam:) withObject:urlParam];
        [weakSelf.tableView.infiniteScrollingView stopAnimating];
        
    });
}


#pragma mark -
#pragma mark IBAction

- (IBAction)cancel:(id)sender
{
    // Analytics
    [GAUtil sendGADataWithUIAction:@"go_back" label:@"escape_view" value:nil];
    [DaLogClient sendDaLogWithCategory:CATEGORY_VIEW_DISAPPEAR target:VIEW_TABBAR_SHOP_LIST value:0];
    
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)likeItButtonTapped:(id)sender
{
    Shop *theShop = [self getShopByUIButton:sender];

    // Analytics
    [GAUtil sendGADataWithUIAction:@"like_shop_button_tapped" label:@"inside_view" value:nil];
    [DaLogClient sendDaLogWithCategory:CATEGORY_SHOP_LIKE target:[theShop.shopId integerValue] value:0];
    
    
    if ([theShop isShopLiked]) {
        [self cancelLikeShopWithShop:theShop];
    }else{
        [self likeShopWithShop:theShop];
    }
}

- (IBAction)checkInButtonTapped:(id)sender
{
    [ViewUtil presentBluetoothTutorialInView:self];
    
//    Shop *theShop = [self getShopByUIButton:sender];
//
//    // Analytics
//    [GAUtil sendGADataWithUIAction:@"check_in_button_tapped" label:@"inside_view" value:nil];
//    [DaLogClient sendDaLogWithCategory:CATEGORY_CHECK_IN target:[theShop.shopId integerValue] value:0];
//
//    
//    if ([theShop getCheckInStateType] == REWARD_STATE_BEFORE) {
//        [self checkInShopWithShop:theShop];
//    }else if ([theShop getCheckInStateType] == REWARD_STATE_DISABLED){
//        [Util showAlertView:nil message:[NSString stringWithFormat:@"%@는 입점 준비 중입니다\n하지만 이런 사소하지만 소중한 터치가\n브랜드와 제휴를 가능케합니다!", theShop.name] title:@"적립불가"];
//    }else if ([theShop getCheckInStateType] == REWARD_STATE_DONE){
//        [Util showAlertView:nil message:[NSString stringWithFormat:@"%@에서 이미 적립하였습니다\n쿨타임이 끝난 뒤에 다시 방문해주세요^^", theShop.name] title:@"적립완료"];
//    }
}

- (IBAction)showLocationButtonTapped:(id)sender
{
    Shop *theShop = [self getShopByUIButton:sender];

    // Analytics
    [GAUtil sendGADataWithUIAction:@"shop_location_button_tapped" label:@"inside_view" value:nil];
    [DaLogClient sendDaLogWithCategory:CATEGORY_SHOP_MAP target:[theShop.shopId integerValue] value:0];
    
    
    DLog(@"%@ %@", theShop.shopId, theShop.name);
    [self presentFlagListWithShop:theShop];
}

- (Shop *)getShopByUIButton:(UIButton *)sender
{
    CGPoint buttonOriginInTableView = [Util getPointForTappedObjectWithSender:sender toView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:buttonOriginInTableView];
    Shop *theShop = [shopData objectInListAtIndex:indexPath.row];
    
    return theShop;
}

- (IBAction)rewardFlagListInMapButtonTapped:(id)sender
{
    [self presentRewardFlagListInMapView];
}

- (void)likeShopWithShop:(Shop *)theShop;
{
    NSDate *startDate = [NSDate date];
    
    GTLServiceFlagengine *service = [FlagClient flagengineService];
    
    GTLFlagengineLike *like = [GTLFlagengineLike alloc];
    [like setTargetId:theShop.shopId];
    [like setUserId:self.user.userId];
    [like setType:[NSNumber numberWithInt:LIKE_SHOP]];
    GTLQueryFlagengine *query = [GTLQueryFlagengine queryForLikesInsertWithObject:like];
    
    [service executeQuery:query completionHandler:^(GTLServiceTicket *ticket, GTLFlagengineLike *object, NSError *error){
        
        DLog(@"result object %@", object);
        
        if (error == nil) {
            // GA
            [GAUtil sendGADataLoadTimeWithInterval:[[NSDate date] timeIntervalSinceDate:startDate] actionName:@"like_shop" label:nil];
            
            
            [DataUtil saveLikeObjectWithObjectId:theShop.shopId type:LIKE_SHOP];
            [theShop likeShop];
            [self.tableView reloadData];
        }
        
    }];
}

- (void)cancelLikeShopWithShop:(Shop *)theShop
{
    URLParameters *urlParams = [self urlParamsToDeleteShopLikeWithShop:theShop];
    
    [FlagClient getDataResultWithURL:[urlParams getURLForRequest] methodName:[urlParams getMethodName] completion:^(NSDictionary *results){
        
        if (!results) {
            [DataUtil deleteLikeObjectWithObjectId:theShop.shopId type:LIKE_SHOP];
            [theShop canceLikeShop];
            [self.tableView reloadData];
        }
    }];
}

- (URLParameters *)urlParamsToDeleteShopLikeWithShop:(Shop *)theShop
{
    URLParameters *urlParams = [[URLParameters alloc] init];
    [urlParams setMethodName:@"like"];
    [urlParams addParameterWithKey:@"itemId" withParameter:theShop.shopId];
    [urlParams addParameterWithKey:@"type" withParameter:[NSNumber numberWithInt:LIKE_SHOP]];
    [urlParams addParameterWithUserId:self.user.userId];
    
    return urlParams;
}

- (void)checkInShopWithShop:(Shop *)theShop
{
    DLog(@"check in shop button tapped");
}

- (void)presentFlagListWithShop:(Shop *)theShop
{
    UIStoryboard *storyboard = [ViewUtil getStoryboard];
    FlagViewController *childViewController = (FlagViewController *)[storyboard instantiateViewControllerWithIdentifier:@"FlagView"];
    [childViewController setUser:self.user];
    [childViewController setObjectIdForFlag:theShop.shopId];
    [childViewController setTitle:theShop.name];
    [childViewController setParentPage:SHOP_LIST_VIEW_PAGE];
    [childViewController setType:MAP_TYPE_FLAG_LIST_FOR_SHOP];
    
    [self.navigationController pushViewController:childViewController animated:YES];
}

- (void)presentRewardFlagListInMapView
{
    UIStoryboard *storyboard = [ViewUtil getStoryboard];
    FlagViewController *childViewContoller = (FlagViewController *)[storyboard instantiateViewControllerWithIdentifier:@"FlagView"];
    
    [childViewContoller setUser:self.user];
    [childViewContoller setParentPage:SHOP_LIST_VIEW_PAGE];
    [childViewContoller setType:MAP_TYPE_CHECKIN_REWARD_FLAG_LIST];
    
    [self.navigationController pushViewController:childViewContoller animated:YES];
}
@end
