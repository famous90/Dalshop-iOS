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

#import "GoogleAnalytics.h"

@interface ItemListViewController ()
@end

@implementation ItemListViewController{
    ItemDataController *allItemData;
//    ItemDataController *itemData;
//    ItemDataController *scanData;
    ImageDataController *imageData;
}

CGFloat itemImageWidth = 306.0f;
CGFloat itemImageHeight = 384.0f;

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.user = [[User alloc] init];
    self.shop = [[Shop alloc] init];
    
    allItemData = [[ItemDataController alloc] init];
//    itemData = [[ItemDataController alloc] init];
//    scanData = [[ItemDataController alloc] init];
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
    
    NSURL *url;
    
    if (self.parentPage == TAB_BAR_VIEW_PAGE) {
        
        UIBarButtonItem *menuButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icon_slide_menu"] style:UIBarButtonItemStyleBordered target:self.revealViewController action:@selector(revealToggle:)];
        
        self.navigationItem.leftBarButtonItem = menuButton;
        menuButton.tintColor = UIColorFromRGB(BASE_COLOR);
        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
        url = [self getURLPathWithRandomItem];
        
    }else if (self.parentPage == SALE_INFO_VIEW_PAGE){
    
        url = [self getURLPathWithSaleInfo];
        
    }

    [self performSelectorInBackground:@selector(getItemListWithURL:) withObject:url];

}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self.collectionView reloadData];
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

- (void)getItemListWithURL:(NSURL *)url
{
    // Activity Indicator
    ActivityIndicatorView *aiView = [ActivityIndicatorView startActivityIndicatorInParentView:self.view];
    
    NSDate *loadBeforeTime = [NSDate date];
    
    [[[NSOperationQueue alloc] init] addOperationWithBlock:^{
        
        NSDictionary *results = [FlagClient getURLResultWithURL:url];
        
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            
            [self setItemDataWithJsonData:results];
            
            // GAI Data Load Time
            [[[GAI sharedInstance] defaultTracker] send:[[GAIDictionaryBuilder createTimingWithCategory:@"data_load" interval:[NSNumber numberWithDouble:[[NSDate date] timeIntervalSinceDate:loadBeforeTime]] name:@"item_list" label:nil] build]];

            [self.collectionView reloadData];
            [aiView stopActivityIndicator];
            
        }];
    }];
    
//    NSURLRequest *request = [NSURLRequest requestWithURL:url];
//    
//    [NSURLConnection sendAsynchronousRequest:request queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error){
//        
//        if (!data) {
//            NSLog(@"Error downloading data : %@", error.localizedFailureReason);
//            return;
//        }
//        
//        NSLog(@"%@", data);
//    }];
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
//    if (self.pageType == ITEM_LIST_VIEW_PAGE) {
//        
//        return [itemData countOfList];
//        
//    }else if (self.pageType == SCAN_LIST_VIEW_PAGE){
//        
//        return [scanData countOfList];
//        
//    }else return 0;
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

    
    // Division line
//    UIView *cellInnerDivisionLine = [[UIView alloc] initWithFrame:CGRectMake(0, itemImageView.frame.size.height, cell.frame.size.width, 0.5f)];
//    [cellInnerDivisionLine setBackgroundColor:[UIColor colorWithWhite:0 alpha:0.1]];
//    [cell addSubview:cellInnerDivisionLine];


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
