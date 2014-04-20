//
//  SettingViewController.m
//  flag-ios
//
//  Created by Gyuyoung Hwang on 2014. 2. 20..
//
//
//

//// SECTION
//#define VERSION_INFO_SECTION    0
//#define USER_INFO_SECTION       1
//#define USER_AGREEMENT_SECTION  2
//#define SYSTEM_SECTION          3
//
//// VERSION INFO SECTION
//#define CURRENT_VERSION_ROW     0
//#define NEWEST_VERSION_ROW      1
//
//// USER INFO SECTION
//#define USER_BASE_INFO_EDIT_ROW         0
//#define USER_ADDITIONAL_INFO_EDIT_ROW   1
//#define LEAVE_OUT_ROW                   2
//
//// USER AGREEMENT SECTION
//#define USER_AGREEMENT_ROW      0
//
//// SYSTEM SECTION
//#define LOG_OUT_ROW     0

#define VERSION_INFO_ROW            0
#define USER_AGREEMENT_ROW          1
#define USER_BASE_INFO_ROW          2
#define USER_ADDITIONAL_INFO_ROW    3
#define LOGOUT_ROW                  4
#define LEAVE_OUT_ROW               5

#define LOGOUT_TAG      4
#define LEAVE_OUT_TAG   5

#import "SettingViewController.h"

#import "ViewUtil.h"
#import "Util.h"

@interface SettingViewController ()

@end

@implementation SettingViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"설정";
}

#pragma mark -
#pragma mark - table view data source

//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
//{
//    return 4;
//}
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
//{
//    if (section == VERSION_INFO_SECTION) {
//        return 2;
//    }else if (section == USER_INFO_SECTION){
//        return 3;
//    }else if (section == USER_AGREEMENT_SECTION){
//        return 1;
//    }else if (section == SYSTEM_SECTION) {
//        return 1;
//    }else return 0;
//}
//
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    UITableViewCell *cell;
//    static NSString *CellIdentifier = @"Cell";
//    cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
//    
//    if (indexPath.section == VERSION_INFO_SECTION) {
//        
//        cell setSelectionStyle:uitabl
//        if (indexPath.row == CURRENT_VERSION_ROW) {
//            
//        }else if (indexPath.row == NEWEST_VERSION_ROW){
//            
//        }
//        
//    }else if (indexPath.section == USER_INFO_SECTION){
//        
//    }else if (indexPath.section == USER_AGREEMENT_SECTION){
//        
//    }else if (indexPath.section == SYSTEM_SECTION) {
//        
//    }
//    
//    return cell;
//}
//
//#pragma mark - table view delegate


#pragma mark - collection view data source
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 6;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *CellIdentifierArray = [[NSArray alloc] initWithObjects:@"VersionCell", @"UserAgreementCell", @"UserInfoEditCell", @"UserAdditionalInfoEditCell", @"LogoutCell", @"LeaveOutCell", nil];
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[CellIdentifierArray objectAtIndex:indexPath.row] forIndexPath:indexPath];
    
//    UIImageView *bgImageView = (UIImageView *)[cell viewWithTag:401];
//    UIImageView *iconImageView = (UIImageView *)[cell viewWithTag:402];
//    UILabel *cellTitleLabel = (UILabel *)[cell viewWithTag:403];
//    
//    CGFloat iOSDeviceScreenHeight = [ViewUtil getIOSDeviceScreenHeight];
//    
//    if (iOSDeviceScreenHeight == ScreenHeightForiPhone4) {
//        CGRect bgFrame = bgImageView.frame;
//        CGRect iconFrame = iconImageView.frame;
//        CGRect labelFrame = cellTitleLabel.frame;
//        
//        bgFrame.origin.y += 11.0f;
//        iconFrame.origin.y += 11.0f;
//        labelFrame.origin.y += 11.0f;
//        
//        bgImageView.frame = bgFrame;
//        iconImageView.frame = iconFrame;
//        cellTitleLabel.frame = labelFrame;
//        
//        NSLog(@"%f", bgImageView.frame.origin.y);
//    }
    
    return cell;
}

#pragma mark - collection view delegate
//- (CGSize)collectionView:(UICollectionViewCell *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
//{
//    CGFloat iOSDeviceScreenHeight = [ViewUtil getIOSDeviceScreenHeight];
//
//    if (iOSDeviceScreenHeight== ScreenHeightForiPhone35) {
//        return CGSizeMake(160.0f, 104.0f);
//    }
//    else if (iOSDeviceScreenHeight== ScreenHeightForiPhone4){
//        return CGSizeMake(160.0f, 126.0f);
//    }
//    else return CGSizeZero;
//}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == USER_AGREEMENT_ROW) {
        
        UIViewController *childViewController = [[UIViewController alloc] init];
//        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
        UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
//        UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
        
        childViewController.title = @"이용약관";
        [childViewController setView:textView];
        textView.text = [Util getFileContentWithFileName:@"user_agreement"];
        
        [self.navigationController pushViewController:childViewController animated:YES];
        
    }else if (indexPath.row == LOGOUT_ROW) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"로그아웃" message:@"로그아웃합니다\n정말 로그아웃하시겠습니까?" delegate:nil cancelButtonTitle:@"취소" otherButtonTitles:@"로그아웃", nil];
        [alert setTag:LOGOUT_TAG];
//        [alert performSelectorOnMainThread:@selector(show) withObject:nil waitUntilDone:NO];
        [alert show];
        
    }else if (indexPath.row == LEAVE_OUT_ROW){
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"회원탈퇴" message:@"탈퇴하시면 저희와의 인연이 모두 끝납니다\n정말...정말 탈퇴하시겠어요?ㅠ" delegate:nil cancelButtonTitle:@"마음돌림" otherButtonTitles:@"확고한탈퇴", nil];
        [alert setTag:LEAVE_OUT_TAG];
//        [alert performSelectorOnMainThread:@selector(show) withObject:nil waitUntilDone:NO];
        [alert show];
    }
}

#pragma mark - alert view delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == LOGOUT_TAG) {
        NSLog(@"logout");
    }else if (alertView.tag == LEAVE_OUT_TAG){
        NSLog(@"leave out");
    }
}
@end
