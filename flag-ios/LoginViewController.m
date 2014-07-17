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
    [Util setPlaceholderAttributeWithTextField:self.emailTextField placeholderContent:NSLocalizedString(@"Email", "Email")];
    self.emailTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentBottom;
    
    [Util setHorizontalPaddingWithTextField:self.passwordTextField];
    [Util setPlaceholderAttributeWithTextField:self.passwordTextField placeholderContent:NSLocalizedString(@"Password", @"Password")];
    self.passwordTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentBottom;
    
    [self.cancelButton setTitle:NSLocalizedString(@"Back", @"Back") forState:UIControlStateNormal];
    [self.cancelButton.layer setCornerRadius:5];
    [self.cancelButton.layer setBorderColor:[UIColor whiteColor].CGColor];
    [self.cancelButton.layer setBorderWidth:0.8f];
    
    [self.loginButton setTitle:NSLocalizedString(@"Login", @"Login") forState:UIControlStateNormal];
    [self.loginButton.layer setCornerRadius:5];
    [self.loginButton.layer setBorderColor:[UIColor whiteColor].CGColor];
    [self.loginButton.layer setBorderWidth:0.8f];
    
    [self.joinButton setTitle:NSLocalizedString(@"Join", @"Join") forState:UIControlStateNormal];
    [self.joinButton.layer setCornerRadius:5];
    [self.joinButton.layer setBorderColor:[UIColor whiteColor].CGColor];
    [self.joinButton.layer setBorderWidth:0.8f];
    [self.joinButton setHidden:NO];
    
    [self.dalshopLabel setText:[NSString stringWithFormat:@"%@ shop", NSLocalizedString(@"DAL", @"DAL")]];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // ANALYTICS
    [self setScreenName:GAI_SCREEN_NAME_LOGIN_VIEW];
    [DaLogClient sendDaLogWithCategory:CATEGORY_VIEW_APPEAR target:VIEW_LOGIN value:0];
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
    // ANALYTICS
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
    
    GTLQueryFlagengine *query = [GTLQueryFlagengine queryForUsersGetWithObject:userForm];
    
    [service executeQuery:query completionHandler:^(GTLServiceTicket *ticket, id object, NSError *error){
        
        if (error == nil) {
            
            // GA
            [GAUtil sendGADataLoadTimeWithInterval:[[NSDate date] timeIntervalSinceDate:startDate] actionName:@"get_user_info" label:nil];
            
            
            [self changeUserFormWithUserForm:userForm];
            [self restartView];
            
        }else{
            [Util showAlertView:nil message:NSLocalizedString(@"Login Error", @"Login Error") title:NSLocalizedString(@"Login", @"Login")];
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
    // ANALTICS
    [GAUtil sendGADataWithUIAction:@"go_back" label:@"escape_view" value:nil];
    [DaLogClient sendDaLogWithCategory:CATEGORY_VIEW_DISAPPEAR target:VIEW_LOGIN value:0];

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
        
        [Util textFieldHasProblemWithTextField:self.emailTextField message:NSLocalizedString(@"Email field is empty", @"Email field is empty") alertTitle:NSLocalizedString(@"Login", @"Login")];
        return NO;
        
    }else return YES;
}

- (BOOL)passwordTextFieldCheck
{
    if ([self.passwordTextField.text length] == 0) {
        
        [Util textFieldHasProblemWithTextField:self.passwordTextField message:NSLocalizedString(@"Password field is empty", @"Password field is empty") alertTitle:NSLocalizedString(@"Login", @"Login")];
        return NO;
        
    }else return YES;
}

@end
