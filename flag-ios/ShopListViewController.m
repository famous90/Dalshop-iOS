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
#import "MallShopViewController.h"
#import "ActivityIndicatorView.h"
#import "SWRevealViewController.h"

#import "User.h"
#import "FlagDataController.h"
#import "Flag.h"
#import "ShopDataController.h"
#import "Shop.h"
#import "ImageDataController.h"
#import "URLParameters.h"

#import "Util.h"
#import "ViewUtil.h"

#import "FlagClient.h"
#import "GoogleAnalytics.h"

@interface ShopListViewController ()

@property (nonatomic, weak) AppDelegate *appDelegate;

@end

@implementation ShopListViewController{
    ShopDataController *shopData;
    ImageDataController *imageData;
    
    BOOL shopFirstTapped;
    
    CLLocationManager *locationManager;
    CLLocation *location;
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
    
    self.appDelegate.timeCriteria = [NSDate date];
    [[GAI sharedInstance].defaultTracker set:kGAIScreenName value:GAI_SCREEN_NAME_SHOP_LIST_VIEW];
    [[GAI sharedInstance].defaultTracker send:[[GAIDictionaryBuilder createAppView] build]];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (self.parentPage == TAB_BAR_VIEW_PAGE) {
        
        UIBarButtonItem *menuButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icon_slide_menu"] style:UIBarButtonItemStyleBordered target:self.revealViewController action:@selector(revealToggle:)];
        
        self.navigationItem.leftBarButtonItem = menuButton;
        menuButton.tintColor = UIColorFromRGB(BASE_COLOR);
        [self.tableView addGestureRecognizer:self.revealViewController.panGestureRecognizer];
        
    }
    
    shopFirstTapped = NO;
    
    shopData = [[ShopDataController alloc] init];
    imageData = [[ImageDataController alloc] init];
    
//    [self performSelectorInBackground:@selector(getShopList) withObject:nil];
    [self initializeLocationManager];
}

#pragma mark
#pragma mark - connect server
- (void)getShopListWithLocation:(CLLocation *)theLocation
{
    // Activity Indicator
    ActivityIndicatorView *aiView = [ActivityIndicatorView startActivityIndicatorInParentView:self.tableView];
    
    NSDate *loadBeforeTime = [NSDate date];
    
//    NSArray *shopIdList = [self.flagData shopIdListInFlagList];
    
    URLParameters *urlParam = [[URLParameters alloc] init];
    [urlParam setMethodName:@"shop_init"];
    [urlParam addParameterWithKey:@"lat" withParameter:[NSNumber numberWithDouble:theLocation.coordinate.latitude]];
    [urlParam addParameterWithKey:@"lon" withParameter:[NSNumber numberWithDouble:theLocation.coordinate.longitude]];
    [urlParam addParameterWithUserId:self.user.userId];
    
    NSURL *url = [urlParam getURLForRequest];
    
    [[[NSOperationQueue alloc] init] addOperationWithBlock:^{
        
        NSDictionary *results = [FlagClient getURLResultWithURL:url];
        
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
       
            [self setShopDataWithJsonData:results];
            
            // GAI Data Load Time
            [[[GAI sharedInstance] defaultTracker] send:[[GAIDictionaryBuilder createTimingWithCategory:@"data_load" interval:[NSNumber numberWithDouble:[[NSDate date] timeIntervalSinceDate:loadBeforeTime]] name:@"shop_list" label:nil] build]];
            
            [aiView stopActivityIndicator];
        }];
    }];
}

- (void)setShopDataWithJsonData:(NSDictionary *)results
{
    NSArray *shops = [results objectForKey:@"shops"];
    for(id object in shops){
        Shop *theShop = [[Shop alloc] initWithData:object];
        [shopData addObjectWithObject:theShop];
        
        if (![theShop.logoUrl isEqual:(id)[NSNull null]]) {
            
//            NSString *imageUrl = [Util addImageParameterInImagePath:theShop.logoUrl width:88.0f height:88.0f];
            NSString *imageUrl = theShop.logoUrl;
            [FlagClient setImageFromUrl:imageUrl imageDataController:imageData itemId:theShop.shopId view:self.tableView completion:^{
            }];
//            UIImage *shopLogoImage = [FlagClient getImageWithImagePath:theShop.logoUrl];
//            [imageData addImageWithImage:shopLogoImage withId:theShop.shopId];
        }
    }
    
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
    
//    Flag *theFlag = (Flag *)[self.flagData objectInListAtIndex:indexPath.row];
//    Shop *theShop = (Shop *)[shopData objectInlistWithObjectId:theFlag.shopId];
    Shop *theShop = (Shop *)[shopData objectInListAtIndex:indexPath.row];
    UIImage *shopLogo = (UIImage *)[imageData imageInListWithId:theShop.shopId];
    
    if (theShop) {

        UILabel *shopNameLabel = (UILabel *)[cell viewWithTag:601];
        UILabel *shopDescriptionLabel = (UILabel *)[cell viewWithTag:602];
        UILabel *shopCheckinRewardLabel = (UILabel *)[cell viewWithTag:603];
        UIImageView *shopLogoImageView = (UIImageView *)[cell viewWithTag:604];
        UILabel *shopSaleLabel = (UILabel *)[cell viewWithTag:605];
        UILabel *shopDistanceLabel = (UILabel *)[cell viewWithTag:606];
        UIImageView *shopCellBgImageView = (UIImageView *)[cell viewWithTag:607];
        UIView *cellInnerDivisionLine = [[UIView alloc] initWithFrame:CGRectMake(6, 65, 308, 0.5f)];
//        CLLocation *shopLocation = [[CLLocation alloc] initWithLatitude:[theFlag.lat floatValue] longitude:[theFlag.lon floatValue]];
        
        shopNameLabel.text = [Util changeStringFirstSpaceToLineBreak:theShop.name];
        shopDescriptionLabel.text = theShop.description;
        shopCheckinRewardLabel.text = [NSString stringWithFormat:@"%ld달", (long)theShop.reward];
shopLogoImageView.image = shopLogo;
        [shopLogoImageView setContentMode:UIViewContentModeScaleAspectFit];
        shopSaleLabel.text = [NSString stringWithFormat:@"%d%%SALE", (rand() % 99)];
        [shopDistanceLabel setHidden:YES];
//        shopDistanceLabel.text = [NSString stringWithFormat:@"%dm", (rand() % 200)];
//        if (self.currentLocation) {
//            CLLocationDistance distance = [shopLocation distanceFromLocation:self.currentLocation];
//            shopDistanceLabel.text = [NSString stringWithFormat:@"%.0fm", distance];
//        }else{
//            shopDistanceLabel.text = @"?m";
//        }
        
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
    return 140.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // GAI event
    if (!shopFirstTapped) {
        [[[GAI sharedInstance] defaultTracker] send:[[GAIDictionaryBuilder createTimingWithCategory:@"ui_delay" interval:[NSNumber numberWithDouble:[[NSDate date] timeIntervalSinceDate:self.appDelegate.timeCriteria]] name:@"pick_shop" label:nil] build]];
        shopFirstTapped = YES;
    }
    [[[GAI sharedInstance] defaultTracker] send:[[GAIDictionaryBuilder createEventWithCategory:@"ui_action" action:@"pick_shop" label:@"escape_view" value:nil] build]];
    
    BOOL isMall = NO;
    UIStoryboard *storyboard = [ViewUtil getStoryboard];
//    Flag *theFlag = (Flag *)[self.flagData objectInListAtIndex:indexPath.row];
//    Shop *theShop = (Shop *)[shopData objectInlistWithObjectId:theFlag.shopId];
    Shop *theShop = (Shop *)[shopData objectInListAtIndex:indexPath.row];
    
    // IF SHOP IS MALL
    if (isMall) {
        
        MallShopViewController *childViewController = (MallShopViewController *)[storyboard instantiateViewControllerWithIdentifier:@"MallShopView"];
        
        childViewController.user = self.user;
        childViewController.parentPage = SHOP_LIST_VIEW_PAGE;
        childViewController.shopId = theShop.shopId;
        childViewController.shopName = theShop.name;
        childViewController.title = theShop.name;

        [self.navigationController pushViewController:childViewController animated:YES];
        
    // IF SHOP IS NOT MALL
    }else{
        
        SaleInfoViewController *childViewController = (SaleInfoViewController *)[storyboard instantiateViewControllerWithIdentifier:@"SaleInfoView"];
        
        childViewController.user = self.user;
        childViewController.shopId = theShop.shopId;
        childViewController.shop = theShop;
        childViewController.parentPage = SHOP_LIST_VIEW_PAGE;
        childViewController.title = theShop.name;
        
        [self.navigationController pushViewController:childViewController animated:YES];
    }
}

//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 3.0f)];
//    UIImageView *headerImageView = [[UIImageView alloc] initWithFrame:headerView.frame];
//    
//    headerImageView.backgroundColor = UIColorFromRGB(BASE_COLOR);
//    [headerView addSubview:headerImageView];
//    
//    return headerView;
//}

//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
//{
//    return 3.0f;
//}


#pragma mark - implementation
- (void)initializeLocationManager
{
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.distanceFilter = kCLDistanceFilterNone;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    
    [locationManager startUpdatingLocation];
}

#pragma mark -
#pragma mark CLLocation
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    CLLocation *currentLocation = [locations objectAtIndex:0];
    
    if (!currentLocation) {
        currentLocation = [[CLLocation alloc] initWithLatitude:BASE_LATITUDE longitude:BASE_LONGITUDE];
    }
    location = currentLocation;
    [self performSelectorInBackground:@selector(getShopListWithLocation:) withObject:location];
    
    [manager stopUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"fail to error %@", error.localizedDescription);
    
    location = [[CLLocation alloc] initWithLatitude:BASE_LATITUDE longitude:BASE_LONGITUDE];
    
    [manager stopUpdatingLocation];
}

#pragma mark - IBAction

- (IBAction)cancel:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
