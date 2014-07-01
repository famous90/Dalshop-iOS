//
//  ItemDetailViewController.m
//  flag-ios
//
//  Created by Gyuyoung Hwang on 2014. 4. 3..
//
//

#define ITEM_IMAGE_CELL         0
#define ITEM_NAME_CELL          1
#define ITEM_DESCRIPTION_CELL   2
#define ITEM_REWARD_PRICE_CELL  3

#define ITEM_DETAIL_LOAD    1
#define SHOP_DETAIL_LOAD    2

#import "ItemDetailViewController.h"
#import "ActivityIndicatorView.h"
#import "FlagViewController.h"
#import "ItemListViewController.h"

#import "AppDelegate.h"

#import "User.h"
#import "Item.h"
#import "Shop.h"
#import "Like.h"
#import "LikeDataController.h"
#import "URLParameters.h"

#import "Util.h"
#import "SNSUtil.h"
#import "ViewUtil.h"
#import "DataUtil.h"

#import "FlagClient.h"
#import "GTLFlagengine.h"
#import "GoogleAnalytics.h"

@interface ItemDetailViewController ()

@end

@implementation ItemDetailViewController{
    CGFloat textPadding;
    
    NSMutableDictionary *kakaoTalkLinkObjects;
    
    CGFloat tableViewPadding;
    CGFloat itemDetailImageWidth;
    CGFloat itemDetailImageHeight;
    CGFloat itemFunctionButtonWidth;
    CGFloat itemFunctionButtonHeight;
    CGFloat itemDetailViewPadding;
    CGFloat lineSpace;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.user = [[User alloc] init];
    self.item = [[Item alloc] init];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    [self.tableView setBackgroundColor:UIColorFromRGB(BASE_COLOR)];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    tableViewPadding = 5.0f;
    itemDetailImageWidth = 310.0f;
    itemDetailImageHeight = 380.0f;
    itemFunctionButtonWidth = 104.0f;
    itemFunctionButtonHeight = 44.0f;
    itemDetailViewPadding = 12.5f;
    lineSpace = 7.0f;
    textPadding = tableViewPadding + itemDetailViewPadding;
    
    kakaoTalkLinkObjects = [[NSMutableDictionary alloc] init];
    
    [self getItemViewConfigure];
}

- (void)getItemViewConfigure
{
    if (self.parentPage == INITIALIZE_VIEW_PAGE) {
        
        [self.navigationController.navigationBar setTintColor:UIColorFromRGB(BASE_COLOR)];
        
        UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"button_back"] style:UIBarButtonItemStyleBordered target:self action:@selector(cancelAndGoMain:)];
        self.navigationItem.leftBarButtonItem = cancelButton;
 
        [self getItemDetail];
        
    }else if (self.parentPage == ITEM_LIST_VIEW_PAGE){
        
        [self getItemDetail];
        [self performSelectorInBackground:@selector(getItemDetailImage) withObject:nil];
        
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self setUser:[DelegateUtil getUser]];
    [ViewUtil setAppDelegatePresentingViewControllerWithViewController:self];
    
    // GA
    [[[GAI sharedInstance] defaultTracker] set:kGAIScreenName value:GAI_SCREEN_NAME_ITEM_DETAIL_VIEW];
    [[[GAI sharedInstance] defaultTracker] send:[[GAIDictionaryBuilder createAppView] build]];
}

#pragma mark - 
#pragma mark - Connect server
- (void)getItemDetail
{
    URLParameters *urlParams = [self getURLPathWithItem];
    [self getDataWithURLParams:urlParams loadType:ITEM_DETAIL_LOAD];
}

- (URLParameters *)getURLPathWithItem
{
    URLParameters *urlParams = [[URLParameters alloc] init];
    [urlParams setMethodName:@"one_item"];
    [urlParams addParameterWithKey:@"itemId" withParameter:self.item.itemId];
    [urlParams addParameterWithUserId:self.user.userId];
    
    return urlParams;
}

- (void)getDataWithURLParams:(URLParameters *)urlParams loadType:(NSInteger)type
{
    [FlagClient getDataResultWithURL:[urlParams getURLForRequest] methodName:[urlParams getMethodName] completion:^(NSDictionary *results){
        
        if (type == ITEM_DETAIL_LOAD) {
            
            [self setItemDetailDataWithJsonData:results];
            [self.tableView reloadData];
            
        }else if (type == SHOP_DETAIL_LOAD){
            
            Shop *theShop = [[Shop alloc] initWithData:results];
            self.title = theShop.name;
        }
        
    }];
}

- (void)setItemDetailDataWithJsonData:(NSDictionary *)results
{
    Item *theItem = [[Item alloc] initWithData:results];
    self.item = theItem;
    
    URLParameters *urlParams = [self getURLPathWithShop:theItem.shopId];
    [self getDataWithURLParams:urlParams loadType:SHOP_DETAIL_LOAD];
    
    if (self.parentPage == INITIALIZE_VIEW_PAGE) {
        [self performSelectorInBackground:@selector(getItemDetailImage) withObject:nil];
    }
}

- (URLParameters *)getURLPathWithShop:(NSNumber *)shopId
{
    URLParameters *urlParams = [[URLParameters alloc] init];
    [urlParams setMethodName:@"shop"];
    [urlParams addParameterWithKey:@"id" withParameter:shopId];
    [urlParams addParameterWithUserId:self.user.userId];
    
    return urlParams;
}

- (void)getItemDetailImage
{
    if (self.item.thumbnailUrl) {
        
        NSString *imagePath = [Util addImageParameterInImagePath:self.item.thumbnailUrl width:itemDetailImageWidth*2 height:itemDetailImageHeight*2];
        
        [FlagClient getImageWithImageURL:imagePath imageDataController:nil objectId:nil objectType:IMAGE_ITEM view:self.tableView completion:^(UIImage *image){
            
            [self setItemImage:image];
        }];
//        [self.tableView reloadData];
    }
}

#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier = nil;
    UITableViewCell *cell = nil;
    
    // Image Cell
    if (indexPath.row == ITEM_IMAGE_CELL) {
        
        CellIdentifier = @"ItemImageCell";
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
        // Item image
        
        CGFloat imageWidth = 0;
        CGFloat imageHeight = 0;
        
        if (self.itemImage) {
            imageWidth = cell.frame.size.width - tableViewPadding*2;
            imageHeight = self.itemImage.size.height * imageWidth / self.itemImage.size.width;
        }
        
        UIImageView *itemImageView = [[UIImageView alloc] initWithFrame:CGRectMake(tableViewPadding, tableViewPadding, imageWidth, imageHeight)];
        [itemImageView setContentMode:UIViewContentModeScaleAspectFit];
        itemImageView.image = self.itemImage;
        
        [cell addSubview:itemImageView];
        
        
        CGFloat buttonFrameOrigin = itemImageView.frame.origin.y + itemImageView.frame.size.height - itemFunctionButtonHeight;
        
        
        // Like button
        
        UIButton *likeItButton = [[UIButton alloc] initWithFrame:CGRectMake(tableViewPadding, buttonFrameOrigin, itemFunctionButtonWidth, itemFunctionButtonHeight)];
        likeItButton.backgroundColor = UIColorFromRGBWithAlpha(BASE_COLOR, 0.8);
        if (self.item.liked) {
            [likeItButton setImage:[UIImage imageNamed:@"icon_likeIt_done_white"] forState:UIControlStateNormal];
        }else {
            [likeItButton setImage:[UIImage imageNamed:@"icon_likeIt_white"] forState:UIControlStateNormal];
        }
        [likeItButton setTitle:[NSString stringWithFormat:@"%ld", (long)self.item.likes] forState:UIControlStateNormal];
        [likeItButton.titleLabel setFont:[UIFont fontWithName:@"system" size:12]];
        [likeItButton setTintColor:[UIColor whiteColor]];
        [likeItButton setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 10)];
        [likeItButton addTarget:self action:@selector(likeItButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
        [cell addSubview:likeItButton];
        
        
        // Share Button
        
        UIButton *shareButton = [[UIButton alloc] initWithFrame:CGRectMake(likeItButton.frame.origin.x + likeItButton.frame.size.width, buttonFrameOrigin, itemFunctionButtonWidth, itemFunctionButtonHeight)];
        shareButton.backgroundColor = UIColorFromRGBWithAlpha(BASE_COLOR, 0.8);
        [shareButton setImage:[UIImage imageNamed:@"icon_share"] forState:UIControlStateNormal];
        [shareButton setTintColor:[UIColor whiteColor]];
        [shareButton addTarget:self action:@selector(shareButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
        [cell addSubview:shareButton];
        
        
        // show location Button
        
        UIButton *showLocationButton = [[UIButton alloc] initWithFrame:CGRectMake(shareButton.frame.origin.x + shareButton.frame.size.width, buttonFrameOrigin, itemFunctionButtonWidth, itemFunctionButtonHeight)];
        showLocationButton.backgroundColor = UIColorFromRGBWithAlpha(BASE_COLOR, 0.8);
        [showLocationButton setImage:[UIImage imageNamed:@"icon_map"] forState:UIControlStateNormal];
        [showLocationButton setTintColor:[UIColor whiteColor]];
        [showLocationButton addTarget:self action:@selector(showLocationButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
        [cell addSubview:showLocationButton];
        
        
    // Name Cell
    }else if (indexPath.row == ITEM_NAME_CELL) {
        
        CellIdentifier = @"ItemNameCell";
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
        if(cell == nil) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        
        
        // name label
        UIFont *textFont = [UIFont fontWithName:@"Helvetica" size:17];
        CGRect descriptionLabelFrame = [self.item.name boundingRectWithSize:CGSizeMake(tableView.frame.size.width - textPadding*2, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:textFont} context:nil];
        
        UILabel *itemNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(textPadding, itemDetailViewPadding, descriptionLabelFrame.size.width, descriptionLabelFrame.size.height)];
        itemNameLabel.text = self.item.name;
        itemNameLabel.font = textFont;
        itemNameLabel.numberOfLines = 0;
        [cell addSubview:itemNameLabel];
        

        // background color
        UIImageView *backgroundImageView = [[UIImageView alloc] initWithFrame:CGRectMake(tableViewPadding, 0, cell.frame.size.width - tableViewPadding*2, cell.frame.size.height)];
        backgroundImageView.backgroundColor = [UIColor whiteColor];
        [cell addSubview:backgroundImageView];
        [cell sendSubviewToBack:backgroundImageView];
        
    }else if (indexPath.row == ITEM_DESCRIPTION_CELL){
        
        CellIdentifier = @"ItemDescriptionCell";
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
        if(cell == nil) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
    
        
        // description label
        UIFont *textFont = [UIFont fontWithName:@"Helvetica" size:14];
        CGRect descriptionLabelFrame = [self.item.description boundingRectWithSize:CGSizeMake(tableView.frame.size.width - textPadding*2, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:textFont} context:nil];
        UILabel *itemDescriptionLabel = [[UILabel alloc] initWithFrame:CGRectMake(textPadding, 0, descriptionLabelFrame.size.width, descriptionLabelFrame.size.height)];
        itemDescriptionLabel.text = self.item.description;
        itemDescriptionLabel.font = textFont;
        itemDescriptionLabel.numberOfLines = 0;
        [cell addSubview:itemDescriptionLabel];
        
        
        // background color
        UIImageView *backgroundImageView = [[UIImageView alloc] initWithFrame:CGRectMake(tableViewPadding, 0, cell.frame.size.width - tableViewPadding*2, cell.frame.size.height)];
        backgroundImageView.backgroundColor = [UIColor whiteColor];
        [cell addSubview:backgroundImageView];
        [cell sendSubviewToBack:backgroundImageView];
        
    }else if (indexPath.row == ITEM_REWARD_PRICE_CELL){
        
        CellIdentifier = @"ItemRewardPriceCell";
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
        if(cell == nil) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        UIImageView *itemScanImageView = (UIImageView *)[cell viewWithTag:806];
        UILabel *itemRewardLabel = (UILabel *)[cell viewWithTag:807];
        UILabel *itemSalePercentLabel = (UILabel *)[cell viewWithTag:808];
//        UILabel *itemOldPriceLabel = (UILabel *)[cell viewWithTag:809];
        UILabel *itemCurrentPriceLabel = (UILabel *)[cell viewWithTag:810];
        
        UIFont *oldPriceTextFont = [UIFont fontWithName:@"Helvetica" size:14];
        CGRect oldPriceFrame = [self.item.oldPrice boundingRectWithSize:CGSizeMake(100, 40) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:oldPriceTextFont} context:nil];
        UILabel *itemOldPriceLabel = [[UILabel alloc] initWithFrame:CGRectMake(cell.frame.size.width - 20 - oldPriceFrame.size.width, 5, oldPriceFrame.size.width, oldPriceFrame.size.height)];
        UIView *deleteLineView = [[UIView alloc] initWithFrame:CGRectMake(itemOldPriceLabel.frame.origin.x - 3, itemOldPriceLabel.center.y, itemOldPriceLabel.frame.size.width + 3*2, 1)];
        
        if (self.item.rewarded) {
            itemScanImageView.image = [UIImage imageNamed:@"icon_scan_done"];
        }else{
            itemScanImageView.image = [UIImage imageNamed:@"icon_scan"];
        }
        
        if (self.item.sale) {
            itemSalePercentLabel.text = [NSString stringWithFormat:@"%ld%%", (long)self.item.sale];
        }else{
            [itemSalePercentLabel setHidden:YES];
        }
        
        if (self.item.oldPrice) {
            deleteLineView.backgroundColor = [UIColor blackColor];
        }else{
            [deleteLineView setHidden:YES];
        }
        
        itemRewardLabel.text = [NSString stringWithFormat:@"%ld달", (long)self.item.reward];
        itemOldPriceLabel.text = self.item.oldPrice;
        itemOldPriceLabel.font = oldPriceTextFont;
        itemCurrentPriceLabel.text = self.item.price;
        
        [cell addSubview:itemOldPriceLabel];
        [cell addSubview:deleteLineView];
        
        
        // background color
        UIImageView *backgroundImageView = [[UIImageView alloc] initWithFrame:CGRectMake(tableViewPadding, 0, cell.frame.size.width - tableViewPadding*2, cell.frame.size.height)];
        backgroundImageView.backgroundColor = [UIColor whiteColor];
        [cell addSubview:backgroundImageView];
        [cell sendSubviewToBack:backgroundImageView];
        
    }
    [cell setBackgroundColor:UIColorFromRGB(BASE_COLOR)];
    
    return cell;
}

#pragma mark - table view delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == ITEM_IMAGE_CELL) {

        CGFloat height = 0;
        if (self.itemImage) {
            height = tableViewPadding + self.itemImage.size.height*(tableView.frame.size.width - tableViewPadding*2)/self.itemImage.size.width;
        }
        
        return height;
        
    }else if (indexPath.row == ITEM_NAME_CELL){
        
        CGRect frame = [self.item.name boundingRectWithSize:CGSizeMake(tableView.frame.size.width - textPadding*2, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont fontWithName:@"Helvetica" size:17]} context:nil];
        CGFloat height = itemDetailViewPadding + frame.size.height + lineSpace;
        
        return height;
        
    }else if (indexPath.row == ITEM_DESCRIPTION_CELL){
        
        CGRect frame = [self.item.description boundingRectWithSize:CGSizeMake(tableView.frame.size.width - textPadding*2, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont fontWithName:@"Helvetica" size:14]} context:nil];
        
        return frame.size.height;
        
    }else if (indexPath.row == ITEM_REWARD_PRICE_CELL){
        
        return 42;
        
    }else return 0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // GA
    [GAUtil sendGADataWithUIAction:@"item_detail_info_click" label:@"inside_view" value:nil];
}

#pragma mark - IBAction
- (IBAction)cancelAndGoMain:(id)sender
{
    // GA
    [GAUtil sendGADataWithUIAction:@"go_back" label:@"escape_view" value:nil];

    
    [ViewUtil presentTabbarViewControllerInView:self withUser:self.user];
}

- (IBAction)likeItButtonTapped:(id)sender
{
    // GA
    [GAUtil sendGADataWithUIAction:@"like_item_click" label:@"inside_view" value:nil];

    
    if (self.item.liked) {
        [self cancelLikeItem];
    }else{
        [self likeItem];
    }
}

- (IBAction)shareButtonTapped:(id)sender
{
    // GA
    [GAUtil sendGADataWithUIAction:@"share_item_click" label:@"inside_view" value:nil];

    
    [self shareItemThroughKakaoTalk];
}

- (IBAction)showLocationButtonTapped:(id)sender
{
    // GA
    [GAUtil sendGADataWithUIAction:@"show_location_click" label:@"inside_view" value:nil];

    
    [self presentMapView];
}

- (void)likeItem
{
    NSDate *startDate = [NSDate date];
    
    GTLServiceFlagengine *service = [FlagClient flagengineService];
    
    GTLFlagengineLike *like = [GTLFlagengineLike alloc];
    [like setTargetId:self.item.itemId];
    [like setUserId:self.user.userId];
    [like setType:[NSNumber numberWithInt:LIKE_ITEM]];
    GTLQueryFlagengine *query = [GTLQueryFlagengine queryForLikesInsertWithObject:like];
    
    [service executeQuery:query completionHandler:^(GTLServiceTicket *ticket, GTLFlagengineLike *object, NSError *error){

        NSLog(@"result object %@", object);
        
        if (error == nil) {
            [GAUtil sendGADataLoadTimeWithInterval:[[NSDate date] timeIntervalSinceDate:startDate] actionName:@"like_item" label:nil];
            [DataUtil saveLikeObjectWithObjectId:self.item.itemId type:LIKE_ITEM];
            self.item.likes++;
            self.item.liked = YES;
            [self.itemListViewController addItemLikesWithIndexpathRow:self.selectedItemIndexpathRow];
            [self.tableView reloadData];
        }
        
    }];
}

- (void)cancelLikeItem
{
    URLParameters *urlParams = [self urlToDeleteItemLike];
    
    [FlagClient getDataResultWithURL:[urlParams getURLForRequest] methodName:[urlParams getMethodName] completion:^(NSDictionary *results){

        if (!results) {
            [DataUtil deleteLikeObjectWithObjectId:self.item.itemId type:LIKE_ITEM];
            self.item.likes--;
            self.item.liked = NO;
            [self.itemListViewController minusItemLikesWithIndexpathRow:self.selectedItemIndexpathRow];
            [self.tableView reloadData];

        }
    }];
}

- (URLParameters *)urlToDeleteItemLike
{
    URLParameters *urlParam = [[URLParameters alloc] init];
    [urlParam setMethodName:@"like"];
    [urlParam addParameterWithKey:@"itemId" withParameter:self.item.itemId];
    [urlParam addParameterWithKey:@"type" withParameter:[NSNumber numberWithInt:LIKE_ITEM]];
    [urlParam addParameterWithUserId:self.user.userId];
    
    return urlParam;
}

- (void)shareItemThroughKakaoTalk
{
    NSDictionary *kakaoTalkParams = [[NSDictionary alloc] initWithObjectsAndKeys:@"item", @"method", self.item.shopId, @"shopId", self.item.itemId, @"itemId", nil];
    NSString *kakaoTalkMessage = [NSString stringWithFormat:@"%@\n%@", @"달샵에서 설레는 아이템을 발견했어요!", self.item.description];
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
    childViewController.parentPage = SALE_INFO_VIEW_PAGE;
    
    [self.navigationController pushViewController:childViewController animated:YES];
}

@end
