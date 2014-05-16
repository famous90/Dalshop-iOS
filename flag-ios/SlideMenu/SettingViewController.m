//
//  SettingViewController.m
//  flag-ios
//
//  Created by Hwang Gyuyoung on 2014. 5. 3..
//
//


// section
#define VERSION_SECTION         0
#define NOTICE_SECTION          1
#define PUSH_SETTING_SECTION    2
#define SYSTEM_SECTION          3
#define USER_AGREEMENT_SECTION  4


// row
#define CURRENT_VERSION_ROW     0
#define NEWEST_VERSION_ROW      1

#define NOTICE_ROW              0

#define PUSH_SOUND_ROW          0
#define PUSH_VIBRATION_ROW      1

#define LOGOUT_ROW              0
#define LEAVE_OUT_ROW           1

#define USER_AGREEMENT_ROW      0
#define USER_INFO_POLICY_ROW    1


// tag
#define LOGOUT_TAG      10
#define LEAVE_OUT_TAG   11

#import "SettingViewController.h"

#import "User.h"

#import "Util.h"

@interface SettingViewController ()

@end

@implementation SettingViewController

- (void)awakeFromNib
{
    [super awakeFromNib];

    self.user = [[User alloc] init];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setNavigationBar];
    [self setMenuCell];
}

- (void)setNavigationBar
{
    self.title = @"설정";
    
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"button_back"] style:UIBarButtonItemStyleBordered target:self action:@selector(cancel:)];
    self.navigationItem.leftBarButtonItem = backButton;
    
    [self.navigationController.navigationBar setTintColor:UIColorFromRGB(BASE_COLOR)];
}

- (void)setMenuCell
{
    self.currentVersionLabel.text = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
    self.newestVersionLabel.text = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
}

#pragma mark -
#pragma mark IBAction
- (IBAction)cancel:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Table view data source

#pragma mark - 
#pragma mark table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == VERSION_SECTION) {
        
    }else if (indexPath.section == NOTICE_SECTION){
        
    }else if (indexPath.section == PUSH_SETTING_SECTION){
        
    }else if (indexPath.section == SYSTEM_SECTION){
        
        if (indexPath.row == LOGOUT_ROW) {
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"로그아웃" message:@"로그아웃합니다\n정말 로그아웃하시겠습니까?" delegate:self cancelButtonTitle:@"취소" otherButtonTitles:@"로그아웃", nil];
            [alert setTag:LOGOUT_TAG];
            [alert show];
            
        }else if (indexPath.row == LEAVE_OUT_ROW){
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"회원탈퇴" message:@"탈퇴하시면 저희와의 인연이 모두 끝납니다\n정말...정말 탈퇴하시겠어요?ㅠ" delegate:self cancelButtonTitle:@"마음돌림" otherButtonTitles:@"확고한탈퇴", nil];
            [alert setTag:LEAVE_OUT_TAG];
            [alert show];

        }
        
    }else if (indexPath.section == USER_AGREEMENT_SECTION){
        
        UIViewController *childViewController = [[UIViewController alloc] init];
        UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];

        [childViewController setView:textView];
        
        if (indexPath.row == USER_AGREEMENT_ROW) {
        
            childViewController.title = @"이용약관";
            textView.text = [Util getFileContentWithFileName:@"user_agreement"];
            
        }else if (indexPath.row == USER_INFO_POLICY_ROW){
            
            childViewController.title = @"개인정보 취급방침";
            textView.text = [Util getFileContentWithFileName:@"user_info_policy"];
        }

        [self.navigationController pushViewController:childViewController animated:YES];
        
    }
}

#pragma mark - 
#pragma mark alert
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == LOGOUT_TAG) {
        
        if (buttonIndex == 1) {
            NSLog(@"logout");
        }
        
    }else if (alertView.tag == LEAVE_OUT_TAG){
        
        if (buttonIndex == 1) {
            NSLog(@"leave out");
        }
        
    }
}
- (IBAction)pushSoundSwitchTapped:(id)sender {
}

- (IBAction)pushVibrationSwitchTapped:(id)sender {
}
@end
