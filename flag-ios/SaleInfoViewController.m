//
//  SaleInfoViewController.m
//  flag-ios
//
//  Created by Gyuyoung Hwang on 2014. 3. 4..
//
//

#define SALE_IMAGE_ROW  0
#define SALE_INFO_ROW   1

#import "AppDelegate.h"
#import "TransitionDelegate.h"
#import "FirstTutorialViewController.h"

#import "SaleInfoViewController.h"
#import "ItemListViewController.h"
#import "ActivityIndicatorView.h"
#import "FlagViewController.h"

#import "User.h"
#import "Shop.h"
#import "Flag.h"
#import "URLParameters.h"

#import "Util.h"
#import "ViewUtil.h"
#import "SNSUtil.h"
#import "DataUtil.h"

#import "FlagClient.h"
#import "GTLFlagengine.h"
#import "GoogleAnalytics.h"

@interface SaleInfoViewController ()

@property (nonatomic, weak) AppDelegate *appDelegate;

@end

@implementation SaleInfoViewController{
    UIImage *saleImage;
    CGFloat labelHeight;
    
    NSMutableDictionary *kakaoTalkLinkObjects;
    
    CGFloat viewPadding;
    CGFloat textPadding;
    CGFloat shopFunctionButtonWidth;
    CGFloat shopFunctionButtonHeight;
    CGFloat showEventButtonHeight;
    CGFloat showEventButtonWidth;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.user = [[User alloc] init];
    self.shop = [[Shop alloc] init];
    self.flag = [[Flag alloc] init];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self setUser:[DelegateUtil getUser]];
    [ViewUtil setAppDelegatePresentingViewControllerWithViewController:self];

    // GA
    [[GAI sharedInstance].defaultTracker set:kGAIScreenName value:GAI_SCREEN_NAME_SALE_INFO_VIEW];
    [[GAI sharedInstance].defaultTracker send:[[GAIDictionaryBuilder createAppView] build]];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    kakaoTalkLinkObjects = [[NSMutableDictionary alloc] init];
    
    [self configureViewContent];
    [self performSelectorInBackground:@selector(getSaleInfo) withObject:nil];
    
    [self configureScanRewardTutorial];
}

- (void)configureViewContent
{
    viewPadding = 0.0f;
    textPadding = 30.0f;
    
    shopFunctionButtonWidth = 107.0f;
    shopFunctionButtonHeight = 44.0f;
    
    showEventButtonHeight = 41.0f;
    showEventButtonWidth = 171.0f;
    
    if (self.parentPage == INITIALIZE_VIEW_PAGE) {
        
        [self.navigationController.navigationBar setTintColor:UIColorFromRGB(BASE_COLOR)];
        [self setBarCancelButton];
    }
}

- (void)setBarCancelButton
{
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"button_back"] style:UIBarButtonItemStyleBordered target:self action:@selector(cancelAndGoMain:)];
    self.navigationItem.leftBarButtonItem = cancelButton;
}

#pragma mark -
#pragma mark - server connection

- (void)getSaleInfo
{
    // Activity Indicator
    ActivityIndicatorView *aiView = [ActivityIndicatorView startActivityIndicatorInParentView:self.view];
    
    if (self.parentPage == SHOP_INFO_VIEW_PAGE) {
        
        [self getShopSaleInfo];
        
    }else if (self.parentPage == SHOP_LIST_VIEW_PAGE){

        if (self.shop) {
            [self getSaleImage];
        }

    }else if (self.parentPage == INITIALIZE_VIEW_PAGE){
        
        [self getShopSaleInfo];
    }
    
    [aiView stopActivityIndicator];
}

- (void)getShopSaleInfo
{
    // Load Data
    URLParameters *urlParam = [[URLParameters alloc] init];
    [urlParam setMethodName:@"shop"];
    [urlParam addParameterWithKey:@"id" withParameter:self.shopId];
    [urlParam addParameterWithUserId:self.user.userId];
    NSURL *url = [urlParam getURLForRequest];
    NSString *methodName = [urlParam getMethodName];
    
    [FlagClient getDataResultWithURL:url methodName:methodName completion:^(NSDictionary *results){
       
        if (results) {
            [self setShopWithJsonData:results];
            [self.tableView reloadData];
        }
        
    }];
}

- (void)setShopWithJsonData:(NSDictionary *)results
{
    self.shop = [[Shop alloc] initWithData:results];
    self.title = self.shop.name;
    
    if (self.shop) {
        [self getSaleImage];
    }
}

- (void)getSaleImage
{
    UIImage *shopImage;
    
    if ([DataUtil isImageCachedWithObjectId:self.shop.shopId imageUrl:self.shop.imageUrl inListType:IMAGE_SHOP_EVENT]) {
        
        shopImage = [DataUtil getImageWithObjectId:self.shop.shopId inListType:IMAGE_SHOP_EVENT];
        
    }else{
        
        [FlagClient getImageWithImageURL:self.shop.imageUrl imageDataController:nil objectId:self.shop.shopId objectType:IMAGE_SHOP_EVENT view:self.tableView completion:^(UIImage *image){
            
            saleImage = [ViewUtil imageWithImage:image scaledToWidth:(self.view.frame.size.width - viewPadding*2)];
            [DataUtil insertImageWithImage:image imageUrl:self.shop.imageUrl objectId:self.shop.shopId inListType:IMAGE_SHOP_EVENT];
        }];
        
    }
    
    if (shopImage) {
        saleImage = [ViewUtil imageWithImage:shopImage scaledToWidth:self.view.frame.size.width - viewPadding*2];
        [self.tableView reloadData];
    }
}

- (void)removeOverlay:(UIView *)overlayView
{
    [overlayView removeFromSuperview];
}

#pragma mark - table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *CellIdentifierArray = [[NSArray alloc] initWithObjects:@"SaleImageCell", @"SaleInfoCell", nil];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[CellIdentifierArray objectAtIndex:indexPath.row] forIndexPath:indexPath];
    
    if (cell == Nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[CellIdentifierArray objectAtIndex:indexPath.row]];
    }
    
    if (indexPath.row == SALE_IMAGE_ROW) {
        
        if (saleImage) {
            
            // Sale image
            UIImageView *saleImageView = [[UIImageView alloc] initWithFrame:CGRectMake(viewPadding, viewPadding, cell.frame.size.width - viewPadding*2, saleImage.size.height)];
            saleImageView.image = saleImage;
            
            [cell addSubview:saleImageView];
            
            
            // Like button
            UIButton *likeItButton = [[UIButton alloc] initWithFrame:CGRectMake(0, cell.frame.size.height - shopFunctionButtonHeight, shopFunctionButtonWidth, shopFunctionButtonHeight)];
            likeItButton.backgroundColor = UIColorFromRGBWithAlpha(BASE_COLOR, 0.8);
            if (self.shop.liked) {
                [likeItButton setImage:[UIImage imageNamed:@"icon_likeIt_done_white"] forState:UIControlStateNormal];
            }else{
                [likeItButton setImage:[UIImage imageNamed:@"icon_likeIt_white"] forState:UIControlStateNormal];
            }
            [likeItButton setTitle:[NSString stringWithFormat:@"%ld", (long)self.shop.likes] forState:UIControlStateNormal];
            [likeItButton.titleLabel setFont:[UIFont fontWithName:@"system" size:12]];
            [likeItButton setTintColor:[UIColor whiteColor]];
            [likeItButton setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 10)];                                                                                                                                                                                                    
            [likeItButton addTarget:self action:@selector(likeItButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
            [cell addSubview:likeItButton];
            
            
            // Share Button
            UIButton *shareButton = [[UIButton alloc] initWithFrame:CGRectMake(likeItButton.frame.origin.x + likeItButton.frame.size.width, cell.frame.size.height - shopFunctionButtonHeight, shopFunctionButtonWidth, shopFunctionButtonHeight)];
            shareButton.backgroundColor = UIColorFromRGBWithAlpha(BASE_COLOR, 0.8);
            [shareButton setImage:[UIImage imageNamed:@"icon_share"] forState:UIControlStateNormal];
            [shareButton setTintColor:[UIColor whiteColor]];
            [shareButton addTarget:self action:@selector(shareButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
            [cell addSubview:shareButton];
            
            
            // show location Button
            UIButton *showLocationButton = [[UIButton alloc] initWithFrame:CGRectMake(shareButton.frame.origin.x + shareButton.frame.size.width, cell.frame.size.height - shopFunctionButtonHeight, shopFunctionButtonWidth, shopFunctionButtonHeight)];
            showLocationButton.backgroundColor = UIColorFromRGBWithAlpha(BASE_COLOR, 0.8);
            [showLocationButton setImage:[UIImage imageNamed:@"icon_map"] forState:UIControlStateNormal];
            [showLocationButton setTintColor:[UIColor whiteColor]];
            [showLocationButton addTarget:self action:@selector(showLocationButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
            [cell addSubview:showLocationButton];
        }
        
    }else if (indexPath.row == SALE_INFO_ROW){
        
        if (self.shop) {
            
            // Text view
            UIFont *labelFont = [UIFont fontWithName:@"Helvetica" size:14];
            CGRect labelFrame = [self.shop.description boundingRectWithSize:CGSizeMake(cell.frame.size.width - textPadding*2, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:labelFont} context:Nil];
            UILabel *saleInfoLabel = [[UILabel alloc] initWithFrame:CGRectMake(textPadding, textPadding, labelFrame.size.width, labelFrame.size.height)];

            saleInfoLabel.text = self.shop.description;
            [saleInfoLabel setTextColor:UIColorFromRGB(BASE_COLOR)];
            saleInfoLabel.font = labelFont;
            saleInfoLabel.numberOfLines = 0;
            [saleInfoLabel sizeToFit];
            
            [cell addSubview:saleInfoLabel];
            
            // Show Item Button
            UIButton *showItemButton = [[UIButton alloc] initWithFrame:CGRectMake((cell.frame.size.width - showEventButtonWidth)/2, cell.frame.size.height - showEventButtonHeight, showEventButtonWidth, showEventButtonHeight)];
            [showItemButton setBackgroundColor:UIColorFromRGB(BASE_COLOR)];
            [showItemButton setTitle:@"이벤트 보러가기" forState:UIControlStateNormal];
            [showItemButton addTarget:self action:@selector(pushItemListView) forControlEvents:UIControlEventTouchUpInside];
            
            [cell addSubview:showItemButton];
        }
        
    }
    
    return cell;
}

#pragma mark - table view delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == SALE_IMAGE_ROW) {
        
        if (saleImage.size.height == 0) {
            return 200;
        }
        return saleImage.size.height + viewPadding;
        
    }else if (indexPath.row ==  SALE_INFO_ROW){
        
        if (saleImage.size.height == 0) {
            return 0;
        }
        CGRect frame = [self.shop.description boundingRectWithSize:CGSizeMake(280, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont fontWithName:@"Helvetica" size:14]} context:nil];
        
        labelHeight = frame.size.height;
        return frame.size.height + textPadding*2 + showEventButtonHeight;
        
    }else return 0;
}

#pragma mark - IBAction
- (IBAction)cancelButtonTapped:(id)sender
{
    // GA
    [GAUtil sendGADataWithUIAction:@"go_back" label:@"escape_view" value:nil];

    
    if (self.parentPage == SHOP_INFO_VIEW_PAGE) {
        
        [self dismissViewControllerAnimated:YES completion:nil];
        
    }else if (self.parentPage == SHOP_LIST_VIEW_PAGE){
        
        [self.navigationController popViewControllerAnimated:YES];
        
    }else if (self.parentPage == MALL_SHOP_VIEW_PAGE){
        
        [self.navigationController popViewControllerAnimated:YES];
        
    }
}

- (IBAction)cancelAndGoMain:(id)sender
{
    // GA
    [GAUtil sendGADataWithUIAction:@"go_back" label:@"escape_view" value:nil];

    
    [ViewUtil presentTabbarViewControllerInView:self withUser:self.user];
}

- (IBAction)likeItButtonTapped:(id)sender
{
    // GA
    [GAUtil sendGADataWithUIAction:@"like_shop_click" label:@"inside_view" value:nil];

    if (self.shop.liked) {
        [self cancelLikeShop];
    }else{
        [self likeShop];
    }
}

- (IBAction)shareButtonTapped:(id)sender
{
    // GA
    [GAUtil sendGADataWithUIAction:@"share_shop_click" label:@"inside_view" value:nil];

    
    [self shareShopSaleEventThroughKakaoTalk];
}

- (IBAction)showLocationButtonTapped:(id)sender
{
    // GA
    [GAUtil sendGADataWithUIAction:@"show_location_click" label:@"inside_view" value:nil];

    
    [self presentMapView];
}

- (void)likeShop
{
    NSDate *startDate = [NSDate date];
    
    GTLServiceFlagengine *service = [FlagClient flagengineService];
    
    GTLFlagengineLike *like = [GTLFlagengineLike alloc];
    [like setTargetId:self.shop.shopId];
    [like setUserId:self.user.userId];
    [like setType:[NSNumber numberWithInt:LIKE_SHOP]];
    GTLQueryFlagengine *query = [GTLQueryFlagengine queryForLikesInsertWithObject:like];
    
    [service executeQuery:query completionHandler:^(GTLServiceTicket *ticket, GTLFlagengineLike *object, NSError *error){
        
        NSLog(@"result object %@", object);
        
        if (error == nil) {
            [GAUtil sendGADataLoadTimeWithInterval:[[NSDate date] timeIntervalSinceDate:startDate] actionName:@"like_shop" label:nil];
            [DataUtil saveLikeObjectWithObjectId:self.shop.shopId type:LIKE_SHOP];
            self.shop.likes++;
            self.shop.liked = YES;
            [self.tableView reloadData];
        }
        
    }];
}

- (void)cancelLikeShop
{
    URLParameters *urlParams = [self urlParamsToDeleteShopLike];
    
    [FlagClient getDataResultWithURL:[urlParams getURLForRequest] methodName:[urlParams getMethodName] completion:^(NSDictionary *results){
        
        if (!results) {
            [DataUtil deleteLikeObjectWithObjectId:self.shop.shopId type:LIKE_SHOP];
            self.shop.likes--;
            self.shop.liked = NO;
            [self.tableView reloadData];
        }
    }];
}

- (URLParameters *)urlParamsToDeleteShopLike
{
    URLParameters *urlParams = [[URLParameters alloc] init];
    [urlParams setMethodName:@"like"];
    [urlParams addParameterWithKey:@"itemId" withParameter:self.shop.shopId];
    [urlParams addParameterWithKey:@"type" withParameter:[NSNumber numberWithInt:LIKE_SHOP]];
    [urlParams addParameterWithUserId:self.user.userId];
    
    return urlParams;
}

- (void)shareShopSaleEventThroughKakaoTalk
{
    NSDictionary *kakaoTalkParams = [[NSDictionary alloc] initWithObjectsAndKeys:@"shop", @"method", self.shop.shopId, @"shopId", nil];
    NSString *kakaoTalkMessage = [NSString stringWithFormat:@"%@\n%@", @"달샵에서 기가 막힌 세일정보를 발견했어요!", self.shop.description];
    CGFloat imageWidth  = 150;
    CGFloat imageHeight = saleImage.size.height * imageWidth / saleImage.size.width;
    
    [SNSUtil makeKakaoTalkLinkToKakaoTalkLinkObjects:kakaoTalkLinkObjects message:kakaoTalkMessage imageURL:self.shop.imageUrl imageWidth:imageWidth Height:imageHeight execParameter:kakaoTalkParams];
    [SNSUtil sendKakaoTalkLinkByKakaoTalkLinkObjects:kakaoTalkLinkObjects];
}

- (void)presentMapView
{
    UIStoryboard *storyboard = [ViewUtil getStoryboard];
    FlagViewController *childViewController = (FlagViewController *)[storyboard instantiateViewControllerWithIdentifier:@"FlagView"];
    childViewController.user = self.user;
    childViewController.objectIdForFlag = self.shop.shopId;
    childViewController.parentPage = SALE_INFO_VIEW_PAGE;
    
    [self.navigationController pushViewController:childViewController animated:YES];
}

#pragma mark - Implementation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"ShowItem"]) {
        
        // GA
        [GAUtil sendGADataWithUIAction:@"go_to_items" label:@"escape_view" value:nil];
    }
}

- (void)setItemParentViewController:(ItemListViewController *)controller
{
    controller.user = self.user;
    controller.shop = self.shop;
    controller.title = self.title;
    controller.parentPage = SALE_INFO_VIEW_PAGE;
}

- (void)pushItemListView
{
    UIStoryboard *storyboard = [ViewUtil getStoryboard];
    ItemListViewController *childViewController = (ItemListViewController *)[storyboard instantiateViewControllerWithIdentifier:@"ItemListView"];
    
    [self setItemParentViewController:childViewController];
    
    [self.navigationController pushViewController:childViewController animated:YES];
}

#pragma mark - 
#pragma mark notification
- (void)configureScanRewardTutorial
{
    if (![DataUtil getUserActionHistoryForRewardShopWatched]) {
        NSString *tutorialMessage = @"상품의 바코드를 스캔하세요\n스캔으로 달을 딸 수 있어요!!";
        [Util showAlertView:nil message:tutorialMessage title:@"서비스소개"];
        [DataUtil saveUserHistoryForRewardShopWatched];
    }
}

@end
