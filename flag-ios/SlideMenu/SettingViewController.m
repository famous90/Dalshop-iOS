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
#define OPEN_SOURCE_LICENSE_ROW 2


// tag
#define LOGOUT_TAG      10
#define LEAVE_OUT_TAG   11

#import "SettingViewController.h"

#import "AppDelegate.h"

#import "User.h"

#import "Util.h"
#import "ViewUtil.h"
#import "DataUtil.h"
#import "URLParameters.h"

#import "FlagClient.h"
#import "GTLFlagengine.h"
#import "GoogleAnalytics.h"

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
    
    
    // GA
    [[[GAI sharedInstance] defaultTracker] set:kGAIScreenName value:GAI_SCREEN_NAME_SETTING_VIEW];
    [[[GAI sharedInstance] defaultTracker] send:[[GAIDictionaryBuilder createAppView] build]];
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
    self.newestVersionLabel.text =  [self getNewestVersion];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self setUser:[DelegateUtil getUser]];
    [ViewUtil setAppDelegatePresentingViewControllerWithViewController:self];
}

- (NSString *)getNewestVersion
{
    NSString *version = [DelegateUtil getNewestVersion];
    if (version) {
        return version;
    }else return @"1.0.0";
}

#pragma mark -
#pragma mark IBAction
- (IBAction)cancel:(id)sender
{
    // GA
    [GAUtil sendGADataWithUIAction:@"go_back" label:@"escape_view" value:nil];

    
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Table view data source

#pragma mark - 
#pragma mark table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // GA
    [GAUtil sendGADataWithUIAction:[NSString stringWithFormat:@"setting_cell_%d_section_%d_row_click", (int)indexPath.section, (int)indexPath.row] label:@"escape_view" value:nil];

    
    if (indexPath.section == VERSION_SECTION) {
        
    }else if (indexPath.section == NOTICE_SECTION){
        
        [self getNotice];
        
    }else if (indexPath.section == PUSH_SETTING_SECTION){
        
    }else if (indexPath.section == SYSTEM_SECTION){
        
        if (indexPath.row == LOGOUT_ROW) {
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"로그아웃" message:@"로그아웃을 하면 서비스 이용에 제한이 있을 수 있습니다\n정말 로그아웃하시겠습니까?" delegate:self cancelButtonTitle:@"취소" otherButtonTitles:@"로그아웃", nil];
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
            
        }else if (indexPath.row == OPEN_SOURCE_LICENSE_ROW){
            
            childViewController.title = @"오픈소스 라이센스";
            textView.text = [Util getFileContentWithFileName:@"open_source_license"];
        }

        [self.navigationController pushViewController:childViewController animated:YES];
        
    }
}

- (void)presentNoticeViewWithNotice:(NSString *)notice
{
    UIViewController *childViewController = [[UIViewController alloc] init];
    UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.width)];
    
    [childViewController setView:textView];
    childViewController.title = @"공지사항";
    textView.text = notice;
    
    [self.navigationController pushViewController:childViewController animated:YES];
}

- (void)getNotice
{
    URLParameters *urlParam = [[URLParameters alloc] init];
    [urlParam setMethodName:@"notice"];
    NSURL *url = [urlParam getURLForRequest];
    NSString *methodName = [urlParam getMethodName];
    
    [FlagClient getDataResultWithURL:url methodName:methodName completion:^(NSDictionary *result){
        NSString *notice = [result valueForKey:@"message"];
        [self presentNoticeViewWithNotice:notice];
    }];
}

- (void)logout
{
    [DataUtil deleteUserInfo];
    

    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    delegate.user = nil;
    
    GTLServiceFlagengine *service = [FlagClient flagengineService];
    
    GTLQueryFlagengine *query = [GTLQueryFlagengine queryForUsersGuest];
    
    [service executeQuery:query completionHandler:^(GTLServiceTicket *ticket, GTLFlagengineUser *object, NSError *error){
       
        if (object) {
            User *user = [[User alloc] init];
            user.userId = [object identifier];
            user.reward = [[object reward] integerValue];
            self.user = user;
            
            [DataUtil saveGuestSessionWithUser:user];
            [ViewUtil presentTabbarViewControllerInView:self withUser:user];
        }
        
    }];
}

#pragma mark - 
#pragma mark alert
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == LOGOUT_TAG) {
        
        if (buttonIndex == 1) {
            // GA
            [GAUtil sendGADataWithUIAction:@"logout" label:@"escape_view" value:nil];

            
            [self logout];
        }
        
    }else if (alertView.tag == LEAVE_OUT_TAG){
        
        if (buttonIndex == 1) {
            // GA
            [GAUtil sendGADataWithUIAction:@"leave_out" label:@"escape_view" value:nil];

            
            NSLog(@"leave out");
            [Util showAlertView:nil message:@"죄송합니다\n아직 탈퇴 기능이 완성되지 않았습니다\n얼른 만들어서 탈퇴할 수 있도록... 해드리겠습니다\n그전에는 메뉴의 달샵에게 문의하기로 말씀해주세요\n다시 한 번 죄송합니다(--)(__)" title:@"탈퇴"];
        }
        
    }
}
- (IBAction)pushSoundSwitchTapped:(id)sender
{
    // GA
    [GAUtil sendGADataWithUIAction:@"push_sound_switch_click" label:@"inside_view" value:nil];

}

- (IBAction)pushVibrationSwitchTapped:(id)sender
{
    // GA
    [GAUtil sendGADataWithUIAction:@"push_vibration_switch_click" label:@"inside_view" value:nil];

}
@end
