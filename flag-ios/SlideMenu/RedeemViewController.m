//
//  RedeemViewController.m
//  Dalshop
//
//  Created by Hwang Gyuyoung on 2014. 5. 29..
//
//

#define BASE_REDEEM_CELL_COUNT  12

#import "RedeemViewController.h"

#import "User.h"
#import "Redeem.h"
#import "RedeemDataController.h"
#import "ImageDataController.h"
#import "HelpViewController.h"

#import "Util.h"
#import "ViewUtil.h"
#import "DataUtil.h"
#import "URLParameters.h"

#import "FlagClient.h"
#import "GTLFlagengine.h"
#import "GoogleAnalytics.h"

@interface RedeemViewController ()

@end

@implementation RedeemViewController{
    RedeemDataController *redeemData;
    ImageDataController *imageData;
    
    CGFloat redeemImageWidth;
    CGFloat redeemImageHeight;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.user = [[User alloc] init];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    [self configureViewContent];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initializeContent];
    [self getUserInfo];
    
    URLParameters *urlParams = [self urlToGetRedeemList];
    [self performSelectorInBackground:@selector(getRedeemListWithURLParams:) withObject:urlParams];
    
    
    // Analytics
    [self setScreenName:GAI_SCREEN_NAME_REDEEM_LIST_VIEW];
    [DaLogClient sendDaLogWithCategory:CATEGORY_VIEW_APPEAR target:VIEW_REDEEM value:0];
}

- (void)initializeContent
{
    redeemData = [[RedeemDataController alloc] init];
    imageData = [[ImageDataController alloc] init];
    redeemImageWidth = 92.0f;
    redeemImageHeight = 92.0f;
}

- (void)configureViewContent
{
    // navigation bar
    [self setTitle:NSLocalizedString(@"Use DAL", @"Use DAL")];
    
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"button_back"] style:UIBarButtonItemStyleBordered target:self action:@selector(cancelButtonTapped:)];
    self.navigationItem.leftBarButtonItem = cancelButton;
    
    UIBarButtonItem *refreshButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icon_refresh"] style:UIBarButtonItemStyleBordered target:self action:@selector(refreshReward:)];
    self.navigationItem.rightBarButtonItem = refreshButton;
    
    
    // view frame
    CGFloat myRewardViewHeight = 40.0f;
    CGFloat collectionViewOrigin = self.navigationController.navigationBar.frame.origin.y + self.navigationController.navigationBar.frame.size.height + myRewardViewHeight;
    
    CGRect collectionViewFrame = CGRectMake(0, collectionViewOrigin, self.view.frame.size.width, self.view.frame.size.height - collectionViewOrigin);
    self.redeemCollectionView.frame = collectionViewFrame;
    
    
    // view content
    self.view.backgroundColor = UIColorFromRGB(BASE_COLOR);
    self.redeemCollectionView.backgroundColor = UIColorFromRGB(BASE_COLOR);
    
    self.myRewardTitleLabel.textColor = [UIColor whiteColor];
    self.myRewardLabel.textColor = [UIColor whiteColor];
    self.dalImageView.image = [UIImage imageNamed:@"icon_moon"];
    
    
    // collection view
    [self.redeemCollectionView setContentInset:UIEdgeInsetsMake(0, 0, 0, 0)];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self setUser:[DelegateUtil getUser]];
    [ViewUtil setAppDelegatePresentingViewControllerWithViewController:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)getUserInfo
{
    [DataUtil getUserFormServerAtCompletionHandler:^(User *theUser){
        
        self.user.reward = theUser.reward;
        
    }];
}

- (void)setMyReward
{
    self.myRewardLabel.text = [NSString stringWithFormat:@"%ld%@", (long)self.user.reward, NSLocalizedString(@"Dal", @"Dal")];
}

- (URLParameters *)urlToGetRedeemList
{
    URLParameters *urlParam = [[URLParameters alloc] init];
    [urlParam setMethodName:@"redeem"];
    [urlParam addParameterWithKey:@"mark" withParameter:[NSNumber numberWithInteger:0]];
    
    return urlParam;
}

- (void)getRedeemListWithURLParams:(URLParameters *)urlParams
{
    NSURL *url = [urlParams getURLForRequest];
    NSString *methodName = [urlParams getMethodName];
    
    [FlagClient getDataResultWithURL:url methodName:methodName completion:^(NSDictionary *results){
        
        if (results) {
            [self configureRedeemListWithResult:results];
            [self.redeemCollectionView reloadData];
        }
    }];
}

- (void)configureRedeemListWithResult:(NSDictionary *)results
{
    NSArray *redeemList = [results objectForKey:@"redeems"];
    
    for(id object in redeemList){
        Redeem *theRedeem = [[Redeem alloc] initWithData:object];
        [redeemData addObjectWithObject:theRedeem];
        
//        if (![theRedeem.imageUrl isEqual:(id)[NSNull null]]) {
//            NSLog(@"image exist");
            [self getRedeemImageWithImagePath:theRedeem.imageUrl redeemId:theRedeem.redeemId];
//        }
    }
    
    [self.redeemCollectionView reloadData];
}

- (void)getRedeemImageWithImagePath:(NSString *)imagePath redeemId:(NSNumber *)redeemId
{
    [FlagClient getImageWithImageURL:imagePath imageDataController:imageData objectId:redeemId objectType:IMAGE_REDEEM_ITEM view:self.redeemCollectionView completion:^(UIImage *image){}];
}

#pragma mark - 
#pragma mark Collection view data source
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if ([redeemData countOfList] >= BASE_REDEEM_CELL_COUNT) {
        return [redeemData countOfList]+1;
    }else return BASE_REDEEM_CELL_COUNT;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = nil;
    
    if (indexPath.row < [redeemData countOfList]) {
        
        static NSString *CellIdentifier = @"RedeemItemCell";
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
        
        Redeem *theRedeem = [redeemData objectInListAtIndex:indexPath.row];
        UIImage *redeemImage = [imageData imageInListWithId:theRedeem.redeemId];
        
        UIImageView *redeemItemImageView = (UIImageView *)[cell viewWithTag:1001];
        UILabel *redeemShopNameLabel = (UILabel *)[cell viewWithTag:1002];
        UILabel *redeemItemNameLabel = (UILabel *)[cell viewWithTag:1003];
        UILabel *redeemItemPriceLabel = (UILabel  *)[cell viewWithTag:1004];
        UIImageView *redeemCellBgImageView = (UIImageView *)[cell viewWithTag:1005];
        
        redeemItemImageView.image = redeemImage;
        
        redeemShopNameLabel.text = theRedeem.vendor;
        redeemShopNameLabel.textColor = UIColorFromRGB(BASE_COLOR);
        
        redeemItemNameLabel.text = theRedeem.name;
        redeemItemNameLabel.textColor = UIColorFromRGB(BASE_COLOR);
        
        redeemItemPriceLabel.text = [NSString stringWithFormat:@"%ld달", (long)theRedeem.price];
        redeemItemPriceLabel.textColor = UIColorFromRGB(BASE_COLOR);
        
        redeemCellBgImageView.image = [ViewUtil drawBorderLineOnFrame:cell.frame byCellRow:indexPath.row];
        
        cell.backgroundColor = [UIColor whiteColor];
        
    }else{
        
        static NSString *CellIdentifier = @"RedeemHelpCell";
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
        
        UIImageView *cellIconImageView = (UIImageView *)[cell viewWithTag:1001];
        UILabel *titleLabel = (UILabel *)[cell viewWithTag:1002];
        UILabel *subtitleLabel = (UILabel *)[cell viewWithTag:1003];
        UIImageView *cellBgImageView = (UIImageView *)[cell viewWithTag:1005];
        UIImage *cellIcon = nil;
        NSString *title = nil;
        NSString *subTitle = nil;
        
        if (indexPath.row == [redeemData countOfList]) {
            
            cellIcon = [UIImage imageNamed:@"appIcon"];
            title = NSLocalizedString(@"Request Redeem", @"Request Redeem");
            subTitle = NSLocalizedString(@"Tell us what you want to buy with reward", @"Tell us what you want to buy with reward");
            
        }else{
            
            cellIconImageView.layer.borderColor = UIColorFromRGB(BASE_COLOR).CGColor;
            cellIconImageView.layer.borderWidth = 1.0f;
            
            cellIcon = [ViewUtil drawDiagonalCrossLineOnFrame:cellIconImageView.frame];
            title = NSLocalizedString(@"Ready", @"Ready");
        }
        
        cellIconImageView.image = cellIcon;
        cellIconImageView.layer.cornerRadius = 10.0;
        cellIconImageView.layer.masksToBounds = YES;

        titleLabel.text = title;
        titleLabel.textColor = UIColorFromRGB(BASE_COLOR);
        
        subtitleLabel.text = subTitle;
        subtitleLabel.textColor = UIColorFromRGB(BASE_COLOR);
        
        cellBgImageView.image = [ViewUtil drawBorderLineOnFrame:cell.frame byCellRow:indexPath.row];
        
        cell.backgroundColor = [UIColor whiteColor];
        
    }
    
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *reusableView;
    
    if (kind == UICollectionElementKindSectionHeader) {
        
        static NSString *HeaderIdentifier = @"RedeemHeaderCell";
        UICollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:HeaderIdentifier forIndexPath:indexPath];
        
        UIImageView *headerImageView = (UIImageView *)[headerView viewWithTag:1011];
        UILabel *headerTitleLabel = (UILabel *)[headerView viewWithTag:1012];
        
        headerImageView.backgroundColor = [UIColor whiteColor];
        headerTitleLabel.text = [NSString stringWithFormat:@"%@ %@ - %@", NSLocalizedString(@"Dal", @"Dal"), @"store", NSLocalizedString(@"Giftishop", @"Giftishop")];
        headerTitleLabel.textColor = UIColorFromRGB(BASE_COLOR);
        
        reusableView = headerView;
    }
    
    return reusableView;
}

#pragma mark collection delegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row < [redeemData countOfList]) {
        
        // Analytics
        [GAUtil sendGADataWithUIAction:@"redeem_cell_click" label:@"escape_view" value:nil];
        [DaLogClient sendDaLogWithCategory:CATEGORY_VIEW_DISAPPEAR target:VIEW_REDEEM value:0];

        
    }else if (indexPath.row == [redeemData countOfList]) {
        
        // Analytics
        [GAUtil sendGADataWithUIAction:@"redeem_help_click" label:@"escape_view" value:nil];
        [DaLogClient sendDaLogWithCategory:CATEGORY_VIEW_DISAPPEAR target:VIEW_REDEEM value:0];

        
        UIStoryboard *storyboard = [ViewUtil getStoryboard];
        HelpViewController *childViewController = (HelpViewController *)[storyboard instantiateViewControllerWithIdentifier:@"HelpView"];
        
        [childViewController setUser:self.user];
        [childViewController setParentPage:REDEEM_VIEW_PAGE];
        
        [self.navigationController pushViewController:childViewController animated:YES];
        
    }else if (indexPath.row > [redeemData countOfList]){
        
        // Analytics
        [GAUtil sendGADataWithUIAction:@"redeem_blank_click" label:@"inside_view" value:nil];

    }
}

#pragma mark - 
#pragma mark IBAction
- (IBAction)cancelButtonTapped:(id)sender
{
    // Analytics
    [GAUtil sendGADataWithUIAction:@"go_back" label:@"escape_view" value:nil];
    [DaLogClient sendDaLogWithCategory:CATEGORY_VIEW_DISAPPEAR target:VIEW_REDEEM value:0];
    
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)refreshReward:(id)sender
{
    // GA
    [GAUtil sendGADataWithUIAction:@"redeem_refresh_click" label:@"inside_view" value:nil];

    
    [DataUtil getUserFormServerAtCompletionHandler:^(User *user){
        
        self.myRewardLabel.text = [NSString stringWithFormat:@"%ld%@", (long)user.reward, NSLocalizedString(@"Dal", @"Dal")];
        [self.user setUserId:user.userId];
        [self.user setReward:user.reward];
        
    }];
}

@end
