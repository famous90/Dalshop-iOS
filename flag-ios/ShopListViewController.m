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

#import "FlagClient.h"
#import "GoogleAnalytics.h"

@interface ShopListViewController ()

@property (nonatomic, weak) AppDelegate *appDelegate;
@property (nonatomic, strong) TransitionDelegate *transitionDelegate;

@end

@implementation ShopListViewController{
    ShopDataController *shopData;
    FlagDataController *flagData;
    FlagDataController *orderedFlagData;
    ImageDataController *imageData;
    
    CLLocation *applicationLocation;
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

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self setUser:[DelegateUtil getUser]];
    [ViewUtil setAppDelegatePresentingViewControllerWithViewController:self];
    
    // GA
    [[GAI sharedInstance].defaultTracker set:kGAIScreenName value:GAI_SCREEN_NAME_SHOP_LIST_VIEW];
    [[GAI sharedInstance].defaultTracker send:[[GAIDictionaryBuilder createAppView] build]];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    [self configureViewContent];
    [self initializeContent];
    
    [self performSelectorInBackground:@selector(getShopListWithLocation:) withObject:applicationLocation];
}

- (void)configureViewContent
{
    if (self.parentPage == TAB_BAR_VIEW_PAGE) {
        
        UIBarButtonItem *menuButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icon_slide_menu"] style:UIBarButtonItemStyleBordered target:self.revealViewController action:@selector(revealToggle:)];
        
        self.navigationItem.leftBarButtonItem = menuButton;
        menuButton.tintColor = UIColorFromRGB(BASE_COLOR);
        [self.tableView addGestureRecognizer:self.revealViewController.panGestureRecognizer];
        
        UIBarButtonItem *rewardMenuButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icon_slide_menu"] style:UIBarButtonItemStyleBordered target:self.revealViewController action:@selector(rightRevealToggle:)];
        [rewardMenuButton setTintColor:UIColorFromRGB(0xeb6468)];
        self.navigationItem.rightBarButtonItem = rewardMenuButton;
//        UIBarButtonItem *collectRewardButton = [[UIBarButtonItem alloc] initWithTitle:@"달따기" style:UIBarButtonItemStyleBordered target:self action:@selector(presentCollectRewardSelectView:)];
//        self.navigationItem.rightBarButtonItem = collectRewardButton;
        
        
    }
}

- (void)initializeContent
{
    self.transitionDelegate = [[TransitionDelegate alloc] init];
    
    shopData = [[ShopDataController alloc] init];
    flagData = [[FlagDataController alloc] init];
    imageData = [[ImageDataController alloc] init];
    
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    applicationLocation = delegate.savedLocation;
}

#pragma mark
#pragma mark - connect server
- (void)getShopListWithLocation:(CLLocation *)theLocation
{
    // Activity Indicator
    ActivityIndicatorView *aiView = [ActivityIndicatorView startActivityIndicatorInParentView:self.tableView];
    
    URLParameters *urlParams = [self urlParamsToGetShopListWithLocation:theLocation];
    
    [FlagClient getDataResultWithURL:[urlParams getURLForRequest] methodName:[urlParams getMethodName] completion:^(NSDictionary *results){
        
        if (results) {
            [self setFlagDataWithJsonData:results];
            [self setShopDataWithJsonData:results];
        }
        
        [aiView stopActivityIndicator];
        
    }];
}

- (URLParameters *)urlParamsToGetShopListWithLocation:(CLLocation *)theLocation
{
    URLParameters *urlParam = [[URLParameters alloc] init];
    [urlParam setMethodName:@"shop_init"];
    [urlParam addParameterWithKey:@"lat" withParameter:[NSNumber numberWithDouble:theLocation.coordinate.latitude]];
    [urlParam addParameterWithKey:@"lon" withParameter:[NSNumber numberWithDouble:theLocation.coordinate.longitude]];
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
            
            [self getImageDataWithImageURL:theShop.logoUrl objectId:theShop.shopId];

        }
    }
    
    [self.tableView reloadData];
}

- (void)getImageDataWithImageURL:(NSString *)imageUrl objectId:(NSNumber *)objectId
{
    if ([DataUtil isImageCachedWithObjectId:objectId imageUrl:imageUrl inListType:IMAGE_SHOP_LOGO]) {
        
        UIImage *image = [DataUtil getImageWithObjectId:objectId inListType:IMAGE_SHOP_LOGO];
        [imageData addImageWithImage:image withId:objectId];
        
    }else{
        
        [FlagClient getImageWithImageURL:imageUrl imageDataController:imageData objectId:objectId objectType:IMAGE_SHOP_LOGO view:self.tableView completion:^(UIImage *image){
            [DataUtil insertImageWithImage:image imageUrl:imageUrl objectId:objectId inListType:IMAGE_SHOP_LOGO];
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
    
    NSArray *sortedFlags = [flagData sortFlagsByDistanceFromCurrentLocation];
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
    
    Flag *theFlag = (Flag *)[orderedFlagData objectInListAtIndex:indexPath.row];
    Shop *theShop = (Shop *)[shopData objectInlistWithObjectId:theFlag.shopId];
//    Shop *theShop = (Shop *)[shopData objectInListAtIndex:indexPath.row];
//    Flag *theFlag = (Flag *)[flagData objectWithShopId:theShop.shopId];
    UIImage *shopLogo = (UIImage *)[imageData imageInListWithId:theShop.shopId];
    
    if (theShop) {

        UILabel *shopNameLabel = (UILabel *)[cell viewWithTag:601];
        UILabel *shopDescriptionLabel = (UILabel *)[cell viewWithTag:602];
        UILabel *shopCheckinRewardLabel = (UILabel *)[cell viewWithTag:603];
        UIImageView *shopLogoImageView = (UIImageView *)[cell viewWithTag:604];
        UILabel *shopDistanceLabel = (UILabel *)[cell viewWithTag:606];
        UIImageView *shopCellBgImageView = (UIImageView *)[cell viewWithTag:607];
        UILabel *shopFirstFeatureLabel = (UILabel *)[cell viewWithTag:608];
        UILabel *shopSecondFeatureLabel = (UILabel *)[cell viewWithTag:609];
        UIView *cellInnerDivisionLine = [[UIView alloc] initWithFrame:CGRectMake(6, 65, 308, 0.5f)];
        CLLocation *shopLocation = [[CLLocation alloc] initWithLatitude:[theFlag.lat floatValue] longitude:[theFlag.lon floatValue]];
        
        shopNameLabel.text = [Util changeStringFirstSpaceToLineBreak:theShop.name];
        shopDescriptionLabel.text = theShop.description;
        shopCheckinRewardLabel.text = [NSString stringWithFormat:@"%ld달", (long)theShop.reward];
        shopLogoImageView.image = shopLogo;
        [shopLogoImageView setContentMode:UIViewContentModeScaleAspectFit];

        [shopSecondFeatureLabel setText:@"S A L E !"];
        [shopSecondFeatureLabel setBackgroundColor:UIColorFromRGB(0xEB6468)];
        
        if (theShop.reward != 0) {
            
            [shopFirstFeatureLabel setText:@"리 워 드"];
            [shopFirstFeatureLabel setBackgroundColor:UIColorFromRGB(0xF4D12A)];
            [shopFirstFeatureLabel setHidden:NO];
            
            [shopSecondFeatureLabel setHidden:!theShop.onSale];
            
        }else{

            [shopFirstFeatureLabel setText:@"S A L E !"];
            [shopFirstFeatureLabel setBackgroundColor:UIColorFromRGB(0xEB6468)];
            [shopFirstFeatureLabel setHidden:!theShop.onSale];
            
            [shopSecondFeatureLabel setHidden:YES];
        }

        if (applicationLocation) {
            shopDistanceLabel.text = [Util distanceFromLocation:shopLocation toLocation:applicationLocation];
        }else{
            shopDistanceLabel.text = @"?m";
        }
        
        [cell setBackgroundColor:UIColorFromRGB(BASE_COLOR)];
        cellInnerDivisionLine.backgroundColor = UIColorFromRGBWithAlpha(BASE_COLOR, 0.5f);
        [cell addSubview:cellInnerDivisionLine];
        
        shopCellBgImageView.layer.borderColor = UIColorFromRGB(BASE_COLOR).CGColor;
        shopCellBgImageView.layer.borderWidth = 0.5f;
    }
    
    return cell;
}

#pragma mark - table view delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 135.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // GA
    [GAUtil sendGADataWithUIAction:@"pick_shop" label:@"escape_view" value:nil];
    
    
    UIStoryboard *storyboard = [ViewUtil getStoryboard];
    Flag *theFlag = (Flag *)[orderedFlagData objectInListAtIndex:indexPath.row];
    Shop *theShop = (Shop *)[shopData objectInlistWithObjectId:theFlag.shopId];
//    Shop *theShop = (Shop *)[shopData objectInListAtIndex:indexPath.row];
//    Flag *theFlag = (Flag *)[flagData objectWithShopId:theShop.shopId];

    SaleInfoViewController *childViewController = (SaleInfoViewController *)[storyboard instantiateViewControllerWithIdentifier:@"SaleInfoView"];
    
    childViewController.user = self.user;
    childViewController.shopId = theShop.shopId;
    childViewController.shop = theShop;
    childViewController.flag = theFlag;
    childViewController.parentPage = SHOP_LIST_VIEW_PAGE;
    childViewController.title = theShop.name;
    
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

#pragma mark - IBAction

- (IBAction)cancel:(id)sender
{
    // GA
    [GAUtil sendGADataWithUIAction:@"go_back" label:@"escape_view" value:nil];

    
    [self dismissViewControllerAnimated:YES completion:nil];
}

//- (IBAction)presentCollectRewardSelectView:(id)sender
//{
//    // GA
//    [GAUtil sendGADataWithUIAction:@"go_to_reward_collection" label:@"escape_view" value:nil];
//
//    
//    UIStoryboard *storyboard = [ViewUtil getStoryboard];
//    CollectRewardViewController *childViewController = (CollectRewardViewController *)[storyboard instantiateViewControllerWithIdentifier:@"CollectRewardView"];
//    childViewController.user = self.user;
//    
//    childViewController.view.backgroundColor = UIColorFromRGBWithAlpha(0x000000, 0.7);
//    [childViewController setTransitioningDelegate:self.transitionDelegate];
//    childViewController.modalPresentationStyle = UIModalPresentationCustom;
//    
//    [self presentViewController:childViewController animated:YES completion:nil];
//}
@end
