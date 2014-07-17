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
    
    
    // Anaytics
    [[[GAI sharedInstance] defaultTracker] set:kGAIScreenName value:GAI_SCREEN_NAME_SETTING_VIEW];
    [[[GAI sharedInstance] defaultTracker] send:[[GAIDictionaryBuilder createAppView] build]];
    [DaLogClient sendDaLogWithCategory:CATEGORY_VIEW_APPEAR target:VIEW_SETTING value:0];
}

- (void)setNavigationBar
{
    self.title = NSLocalizedString(@"Setting", @"Setting");
    
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
    // Anaytics
    [GAUtil sendGADataWithUIAction:@"go_back" label:@"escape_view" value:nil];
    [DaLogClient sendDaLogWithCategory:CATEGORY_VIEW_DISAPPEAR target:VIEW_SETTING value:0];

    
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
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Logout", @"Logout") message:NSLocalizedString(@"Really want to logout", @"Really want to logout") delegate:self cancelButtonTitle:NSLocalizedString(@"Cancel", @"Cancel") otherButtonTitles:NSLocalizedString(@"Logout", @"Logout"), nil];
            [alert setTag:LOGOUT_TAG];
            [alert show];
            
        }else if (indexPath.row == LEAVE_OUT_ROW){
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Quit", @"Quit") message:NSLocalizedString(@"Really want to quit?", @"Really want to quit?") delegate:self cancelButtonTitle:NSLocalizedString(@"Cancel to quit", @"Cancel to quit") otherButtonTitles:NSLocalizedString(@"Keep in mind to quit", @"Keep in mind to quit"), nil];
            [alert setTag:LEAVE_OUT_TAG];
            [alert show];

        }
        
    }else if (indexPath.section == USER_AGREEMENT_SECTION){
        
        // Analytics
        [DaLogClient sendDaLogWithCategory:CATEGORY_VIEW_DISAPPEAR target:VIEW_SETTING value:0];
        
        UIViewController *childViewController = [[UIViewController alloc] init];
        UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];

        [childViewController setView:textView];
        
        if (indexPath.row == USER_AGREEMENT_ROW) {
        
            childViewController.title = NSLocalizedString(@"User Agreement", @"User Agreement");
            textView.text = [Util getFileContentWithFileName:@"user_agreement"];
            
        }else if (indexPath.row == USER_INFO_POLICY_ROW){
            
            childViewController.title = NSLocalizedString(@"User Infomation Policy", @"User Infomation Policy");
            textView.text = [Util getFileContentWithFileName:@"user_info_policy"];
            
        }else if (indexPath.row == OPEN_SOURCE_LICENSE_ROW){
            
            childViewController.title = NSLocalizedString(@"Open Source License", @"Open Source License");
            textView.text = [Util getFileContentWithFileName:@"open_source_license"];
        }

        [self.navigationController pushViewController:childViewController animated:YES];
        
    }
}

- (void)presentNoticeViewWithNotice:(NSString *)notice
{
    // Analytics
    [DaLogClient sendDaLogWithCategory:CATEGORY_VIEW_DISAPPEAR target:VIEW_SETTING value:0];
    
    
    UIViewController *childViewController = [[UIViewController alloc] init];
    UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.width)];
    
    [childViewController setView:textView];
    childViewController.title = NSLocalizedString(@"Notice", @"Notice");
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
            
            // Analytics
            [DaLogClient sendDaLogWithCategory:CATEGORY_VIEW_DISAPPEAR target:VIEW_SETTING value:0];
            
            
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
            [Util showAlertView:nil message:NSLocalizedString(@"We are making this function", @"We are making this function") title:NSLocalizedString(@"Quit", @"Quit")];
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
