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
#import "SaleInfoViewController.h"
#import "ItemListViewController.h"
#import "ActivityIndicatorView.h"

#import "User.h"
#import "Shop.h"
#import "URLParameters.h"

#import "ViewUtil.h"
#import "SNSUtil.h"

#import "FlagClient.h"
#import "GTLFlagengine.h"
#import "GoogleAnalytics.h"

@interface SaleInfoViewController ()

@property (nonatomic, weak) AppDelegate *appDelegate;

@end

@implementation SaleInfoViewController{
    UIImage *saleImage;
    CGFloat labelHeight;
    
    BOOL showItemFirstTapped;
}

CGFloat viewPadding = 0.0f;
CGFloat textPadding = 30.0f;

CGFloat shopFunctionButtonWidth = 107.0f;
CGFloat shopFunctionButtonHeight = 44.0f;

CGFloat showEventButtonHeight = 41.0f;
CGFloat showEventButtonWidth = 171.0f;

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.user = [[User alloc] init];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.appDelegate.timeCriteria = [NSDate date];
    [[GAI sharedInstance].defaultTracker set:kGAIScreenName value:GAI_SCREEN_NAME_SALE_INFO_VIEW];
    [[GAI sharedInstance].defaultTracker send:[[GAIDictionaryBuilder createAppView] build]];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    showItemFirstTapped = NO;
    
    [self performSelectorInBackground:@selector(getSaleInfo) withObject:nil];
}

#pragma mark -
#pragma mark - server connection

- (void)getSaleInfo
{
    // Activity Indicator
    ActivityIndicatorView *aiView = [ActivityIndicatorView startActivityIndicatorInParentView:self.view];
    
    if (self.parentPage == SHOP_INFO_VIEW_PAGE) {
        
        ActivityIndicatorView *activityIndicatorView = [ActivityIndicatorView startActivityIndicatorInParentView:self.view];
        
        // GAI time criteria
        NSDate *loadBeforeTime = [NSDate date];
        
        // Load Data
        URLParameters *urlParam = [[URLParameters alloc] init];
        [urlParam setMethodName:@"shop"];
        [urlParam addParameterWithKey:@"id" withParameter:self.shopId];
        [urlParam addParameterWithUserId:self.user.userId];
        NSURL *url = [urlParam getURLForRequest];
        
        [[[NSOperationQueue alloc] init] addOperationWithBlock:^{
            
            NSDictionary *results = [FlagClient getURLResultWithURL:url];
            
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                
                [self setShopWithJsonData:results];
                                
                // GAI Data Load Time
                [[[GAI sharedInstance] defaultTracker] send:[[GAIDictionaryBuilder createTimingWithCategory:@"data_load" interval:[NSNumber numberWithDouble:[[NSDate date] timeIntervalSinceDate:loadBeforeTime]] name:@"get_shop" label:nil] build]];
                
                [activityIndicatorView stopActivityIndicator];
                [self.tableView reloadData];
            }];
        }];
        
    }else if (self.parentPage == SHOP_LIST_VIEW_PAGE){
        
    }

    if (self.shop) {
        [self getSaleImage];
    }
    
    [aiView stopActivityIndicator];
}

- (void)setShopWithJsonData:(NSDictionary *)results
{
    self.shop = [[Shop alloc] initWithData:results];
    
    if (self.shop) {
        [self getSaleImage];
    }
}

- (void)getSaleImage
{
    UIImage *shopImage = [FlagClient getImageWithImagePath:self.shop.imageUrl];

    if (shopImage) {
        saleImage = [ViewUtil imageWithImage:shopImage scaledToWidth:self.view.frame.size.width - viewPadding*2];
    }
    [self.tableView reloadData];
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
        
        CGRect frame = [self.shop.description boundingRectWithSize:CGSizeMake(280, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont fontWithName:@"Helvetica" size:14]} context:nil];
        
        labelHeight = frame.size.height;
        return frame.size.height + textPadding*2 + showEventButtonHeight;
        
    }else return 0;
}

#pragma mark - IBAction
- (IBAction)cancelButtonTapped:(id)sender
{
    if (self.parentPage == SHOP_INFO_VIEW_PAGE) {
        
        [self dismissViewControllerAnimated:YES completion:nil];
        
    }else if (self.parentPage == SHOP_LIST_VIEW_PAGE){
        
        [self.navigationController popViewControllerAnimated:YES];
        
    }else if (self.parentPage == MALL_SHOP_VIEW_PAGE){
        
        [self.navigationController popViewControllerAnimated:YES];
        
    }
}

- (IBAction)likeItButtonTapped:(id)sender
{
    [self likeItem];
    NSLog(@"like it button tapped");
}

- (IBAction)shareButtonTapped:(id)sender
{
    NSLog(@"share button tapped");
}

- (IBAction)showLocationButtonTapped:(id)sender
{
    NSLog(@"show location button tapped");
}

- (void)likeItem
{
    GTLServiceFlagengine *service = [FlagClient flagengineService];
    
    GTLFlagengineLike *like = [GTLFlagengineLike alloc];
    [like setTargetId:self.shop.shopId];
    [like setUserId:self.user.userId];
    [like setType:[NSNumber numberWithInt:LIKE_SHOP]];
    GTLQueryFlagengine *query = [GTLQueryFlagengine queryForLikesInsertWithObject:like];
    
    [service executeQuery:query completionHandler:^(GTLServiceTicket *ticket, GTLFlagengineLike *object, NSError *error){
        
        NSLog(@"result object %@", object);
        
    }];
}

- (void)shareItemWithKakaoTalk
{
    NSMutableDictionary *kakaoTalkLinkObjects = [[NSMutableDictionary alloc] init];
    NSString *message = [NSString stringWithFormat:@"%@\n%@", self.shop.name, self.shop.description];
    NSString *imageURL = self.shop.imageUrl;
    
    [SNSUtil makeKakaoTalkLinkToKakaoTalkLinkObjects:kakaoTalkLinkObjects message:message imageURL:imageURL imageWidth:saleImage.size.width Height:saleImage.size.height execParameter:@{@"method":@"shop", @"shopId":self.shop.shopId}];
    [SNSUtil sendKakaoTalkLinkByKakaoTalkLinkObjects:kakaoTalkLinkObjects];
}

#pragma mark - Implementation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"ShowItem"]) {
        // GAI event
        if (!showItemFirstTapped) {
            [[[GAI sharedInstance] defaultTracker] send:[[GAIDictionaryBuilder createTimingWithCategory:@"ui_delay" interval:[NSNumber numberWithDouble:[[NSDate date] timeIntervalSinceDate:self.appDelegate.timeCriteria]] name:@"go_to_items" label:nil] build]];
            showItemFirstTapped = YES;
        }
        [[[GAI sharedInstance] defaultTracker] send:[[GAIDictionaryBuilder createEventWithCategory:@"ui_action" action:@"go_to_items" label:@"escape_view" value:nil] build]];

//        ItemParentViewController *childViewController = (ItemParentViewController *)[segue destinationViewController];
//        [self setItemParentViewController:childViewController];
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

@end
