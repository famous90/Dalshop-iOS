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

#import "GoogleAnalytics.h"

@interface SaleInfoViewController ()

@property (nonatomic, weak) AppDelegate *appDelegate;

@end

@implementation SaleInfoViewController{
    UIImage *saleImage;
    CGFloat labelHeight;
    
    BOOL showItemFirstTapped;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.user = [[User alloc] init];
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
//    ActivityIndicatorView *aiView = [ActivityIndicatorView startActivityIndicatorInParentView:self.view];
    
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
    
//    [aiView stopActivityIndicator];
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
        saleImage = [ViewUtil imageWithImage:shopImage scaledToWidth:self.view.frame.size.width];
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
            UIImageView *saleImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, cell.frame.size.width, saleImage.size.height)];
            CGFloat buttonDiameter = 79;
            CGFloat buttonPadding = 20;
            UIButton *showItemButton = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width - buttonPadding - buttonDiameter, saleImageView.frame.size.height - buttonPadding - buttonDiameter, buttonDiameter, buttonDiameter)];
            
            saleImageView.image = saleImage;
            [showItemButton setBackgroundImage:[UIImage imageNamed:@"button_double_circle"] forState:UIControlStateNormal];
            [showItemButton setTitle:@"구경하기" forState:UIControlStateNormal];
            [showItemButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [showItemButton addTarget:self action:@selector(pushItemListView) forControlEvents:UIControlEventTouchUpInside];
            [cell addSubview:saleImageView];
            [cell addSubview:showItemButton];
        }
        
    }else if (indexPath.row == SALE_INFO_ROW){
        
        if (self.shop) {
            
            CGFloat padding = 20;
            UIFont *labelFont = [UIFont fontWithName:@"Helvetica" size:14];
            CGRect labelFrame = [self.shop.description boundingRectWithSize:CGSizeMake(cell.frame.size.width - padding*2, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:labelFont} context:Nil];
            UILabel *saleInfoLabel = [[UILabel alloc] initWithFrame:CGRectMake(padding, padding, labelFrame.size.width, labelFrame.size.height)];
            UIView *innerDivisionLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, cell.frame.size.width, 0.5f)];
            
            saleInfoLabel.text = self.shop.description;
            saleInfoLabel.font = labelFont;
            saleInfoLabel.numberOfLines = 0;
            [saleInfoLabel sizeToFit];
            
            innerDivisionLine.backgroundColor = UIColorFromRGB(BASE_COLOR);
            
            [cell addSubview:innerDivisionLine];
            [cell addSubview:saleInfoLabel];
        }
        
    }
    
    return cell;
}

#pragma mark - table view delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == SALE_IMAGE_ROW) {
        
        return saleImage.size.height;
        
    }else if (indexPath.row ==  SALE_INFO_ROW){
        
        CGRect frame = [self.shop.description boundingRectWithSize:CGSizeMake(280, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont fontWithName:@"Helvetica" size:14]} context:nil];
        
        labelHeight = frame.size.height;
        return frame.size.height + 20*2;
        
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
