//
//  LoginViewController.m
//  flag-ios
//
//  Created by Gyuyoung Hwang on 2014. 3. 17..
//
//

#import "LoginViewController.h"
#import "JoinViewController.h"
#import "SWRevealViewController.h"

#import "User.h"

#import "Util.h"
#import "ViewUtil.h"
#import "DataUtil.h"

#import "FlagClient.h"
#import "GTLFlagengine.h"
#import "GoogleAnalytics.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];

    self.view.backgroundColor = UIColorFromRGB(BASE_COLOR);

    [Util setHorizontalPaddingWithTextField:self.emailTextField];
    [Util setHorizontalPaddingWithTextField:self.passwordTextField];
    self.emailTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentBottom;
    self.passwordTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentBottom;
    
    [Util setPlaceholderAttributeWithTextField:self.emailTextField placeholderContent:@"e-mail"];
    [Util setPlaceholderAttributeWithTextField:self.passwordTextField placeholderContent:@"password"];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // GA
    [self setScreenName:GAI_SCREEN_NAME_LOGIN_VIEW];
//    [[[GAI sharedInstance] defaultTracker] set:kGAIScreenName value:GAI_SCREEN_NAME_LOGIN_VIEW];
//    [[[GAI sharedInstance] defaultTracker] send:[[GAIDictionaryBuilder createAppView] build]];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self setUser:[DelegateUtil getUser]];
    [ViewUtil setAppDelegatePresentingViewControllerWithViewController:self];
}

#pragma mark -
#pragma mark IBAction

- (IBAction)loginButtonTapped:(id)sender
{
    // GA
    [GAUtil sendGADataWithUIAction:@"login_button_tapped" label:@"escape_view" value:nil];

    
    if ([self loginFormCheck]) {
        [self loginUser];
    }
}

- (void)loginUser
{
    NSDate *startDate = [NSDate date];
    
    GTLServiceFlagengine *service = [FlagClient flagengineService];
    
    GTLFlagengineUserForm *userForm = [GTLFlagengineUserForm alloc];
    [userForm setEmail:self.emailTextField.text];
    [userForm setPassword:[Util encryptPasswordWithPassword:self.passwordTextField.text]];
    [userForm setIdentifier:self.user.userId];
    NSLog(@"user info %@", userForm);
    
    GTLQueryFlagengine *query = [GTLQueryFlagengine queryForUsersGetWithObject:userForm];
    
    [service executeQuery:query completionHandler:^(GTLServiceTicket *ticket, id object, NSError *error){
        
        if (error == nil) {
                
            [GAUtil sendGADataLoadTimeWithInterval:[[NSDate date] timeIntervalSinceDate:startDate] actionName:@"get_user_info" label:nil];
            
            [self changeUserFormWithUserForm:userForm];
            [self restartView];
            
        }else{
            [Util showAlertView:nil message:@"로그인에 실패하였습니다\n다시 시도해주세요" title:@"로그인"];
        }
        
    }];
}

- (void)changeUserFormWithUserForm:(GTLFlagengineUserForm *)userForm
{
    [self.user setEmail:userForm.email];
    [self.user setRegistered:YES];
    
    [DelegateUtil updateUserWithUser:self.user];
    [self updateUserInfoInCoreDataWithUser:self.user];
}

- (void)updateUserInfoInCoreDataWithUser:(User *)theUser
{
    [DataUtil saveUserFormForRegisterWithEmail:theUser.email];
    [DataUtil updateRegisteredWithUserRegistered:theUser.registered];
}

- (void)restartView
{
    UIStoryboard *storyboard = [ViewUtil getStoryboard];
    SWRevealViewController *restartViewController = (SWRevealViewController *)[storyboard instantiateViewControllerWithIdentifier:@"RevealView"];
    restartViewController.user = self.user;
    
    [self presentViewController:restartViewController animated:YES completion:nil];
}

- (IBAction)joinButtonTapped:(id)sender
{
    // GA
    [GAUtil sendGADataWithUIAction:@"go_to_register_view" label:@"escape_view" value:nil];

    
    UIStoryboard *storyboard = [ViewUtil getStoryboard];
    JoinViewController *childViewController = (JoinViewController *)[storyboard instantiateViewControllerWithIdentifier:@"JoinView"];
    
    childViewController.parentPage = LOGIN_VIEW_PAGE;
    
    [self presentViewController:childViewController animated:YES completion:nil];
}

- (IBAction)backgroundTapped:(id)sender
{
    // GA
    [GAUtil sendGADataWithUIAction:@"background_tapped" label:@"inside_view" value:nil];

    
    [self.emailTextField resignFirstResponder];
    [self.passwordTextField resignFirstResponder];
}

- (IBAction)cancelButtonTapped:(id)sender
{
    // GA
    [GAUtil sendGADataWithUIAction:@"go_back" label:@"escape_view" value:nil];

    
    if (self.parentPage == SLIDE_MENU_PAGE) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

#pragma mark -
#pragma mark Implementation
- (BOOL)loginFormCheck
{
    if ([self emailTextFieldCheck]) {
        
        if ([self passwordTextFieldCheck]) {
            return YES;
        }else return NO;
        
    }else return NO;
}

- (BOOL)emailTextFieldCheck
{
    if ([self.emailTextField.text length] == 0) {
        
        [Util textFieldHasProblemWithTextField:self.emailTextField message:@"이메일을 입력해주세요" alertTitle:@"로그인"];
        return NO;
        
    }else return YES;
}

- (BOOL)passwordTextFieldCheck
{
    if ([self.passwordTextField.text length] == 0) {
        
        [Util textFieldHasProblemWithTextField:self.passwordTextField message:@"비밀번호를 입력해주세요" alertTitle:@"로그인"];
        return NO;
        
    }else return YES;
}

@end
