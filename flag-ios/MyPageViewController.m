//
//  MyPageViewController.m
//  flag-ios
//
//  Created by Gyuyoung Hwang on 2014. 2. 20..
//
//

#define MY_REDEEM_SECTION   0
#define MENU_SECTION        1

#import "AppDelegate.h"
#import "MyPageViewController.h"
#import "RewardHistoryViewController.h"

#import "User.h"

#import "ViewUtil.h"

#import "GoogleAnalytics.h"

@interface MyPageViewController ()

@end

@implementation MyPageViewController

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.user = [[User alloc] init];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[GAI sharedInstance].defaultTracker set:kGAIScreenName value:GAI_SCREEN_NAME_MY_PAGE_VIEW];
    [[GAI sharedInstance].defaultTracker send:[[GAIDictionaryBuilder createAppView] build]];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"마이페이지";
}

#pragma mark - 
#pragma mark - Implementation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"ShowMyRewardHistory"]) {
        RewardHistoryViewController *childViewController = (RewardHistoryViewController *)[segue destinationViewController];
        childViewController.user = self.user;
    }
}

#pragma mark - collection view data source
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 2;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (section == MY_REDEEM_SECTION) {
        return 1;
    }else if (section == MENU_SECTION){
        return 4;
    }else return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = nil;
    
    if (indexPath.section == MY_REDEEM_SECTION) {
    
        static NSString *CellIdentifier = @"MyRedeemCell";
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
        UILabel *myRedeemLabel = (UILabel *)[cell viewWithTag:303];
        
        myRedeemLabel.text = [NSString stringWithFormat:@"%ld원", (long)self.user.reward];
    
    }else if (indexPath.section == MENU_SECTION){
        
        NSArray *CellIdentifierArray = [[NSArray alloc] initWithObjects:@"HistoryCell", @"WithdrawCell", @"MallCell", @"SettingCell", nil];
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:[CellIdentifierArray objectAtIndex:indexPath.row] forIndexPath:indexPath];
    }
    
    return cell;
}

#pragma mark - collection view delegate
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout  *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == MENU_SECTION) {

        CGFloat iOSDeviceScreenHeight = [ViewUtil getIOSDeviceScreenHeight];
        if (iOSDeviceScreenHeight == ScreenHeightForiPhone35) return CGSizeMake(160.0f, 152.0f);
        else if (iOSDeviceScreenHeight == ScreenHeightForiPhone4) return CGSizeMake(160.f, 152.0f);
        
    }else if(indexPath.section == MY_REDEEM_SECTION){
        
        CGFloat iOSDeviceScreenHeight = [ViewUtil getIOSDeviceScreenHeight];
        if (iOSDeviceScreenHeight == ScreenHeightForiPhone35) {
            return CGSizeMake(320.f, 94.0f);
        }else if (iOSDeviceScreenHeight == ScreenHeightForiPhone4){
            return CGSizeMake(320.0f, 115.0f);
        }
        
    }
    return CGSizeZero;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [collectionView deselectItemAtIndexPath:indexPath animated:NO];
}

#pragma mark - IBAction

- (IBAction)cancel:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:Nil];
}
@end
