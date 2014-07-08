//
//  JoinViewController.m
//  flag-ios
//
//  Created by Gyuyoung Hwang on 2014. 3. 17..
//
//

#import "JoinViewController.h"
#import "FlagViewController.h"
#import "SWRevealViewController.h"
#import "PhoneCertificationViewController.h"

#import "User.h"

#import "Util.h"
#import "ViewUtil.h"
#import "DataUtil.h"

#import "GTLFlagengine.h"
#import "FlagClient.h"
#import "GoogleAnalytics.h"

@interface JoinViewController ()

@end

@implementation JoinViewController{
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    self.view.backgroundColor = UIColorFromRGB(BASE_COLOR);
    
    [Util setHorizontalPaddingWithTextField:self.emailTextField];
    [Util setHorizontalPaddingWithTextField:self.passwordTextField];
    [Util setHorizontalPaddingWithTextField:self.confirmPasswordTextField];
    self.emailTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentBottom;
    self.passwordTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentBottom;
    self.confirmPasswordTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentBottom;
    
    [Util setPlaceholderAttributeWithTextField:self.emailTextField placeholderContent:@"e-mail"];
    [Util setPlaceholderAttributeWithTextField:self.passwordTextField placeholderContent:@"password"];
    [Util setPlaceholderAttributeWithTextField:self.confirmPasswordTextField placeholderContent:@"confirm password"];
    
    
    // button
    self.cancelButton.layer.borderColor = [UIColor whiteColor].CGColor;
    self.cancelButton.layer.borderWidth = 0.8f;
    self.cancelButton.layer.cornerRadius = 5;
    
    self.joinButton.layer.borderColor = [UIColor whiteColor].CGColor;
    self.joinButton.layer.borderWidth = 0.8f;
    self.joinButton.layer.cornerRadius = 5;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // GA
    [self setScreenName:GAI_SCREEN_NAME_REGISTER_VIEW];
    //    [[[GAI sharedInstance] defaultTracker] set:kGAIScreenName value:GAI_SCREEN_NAME_REGISTER_VIEW];
    //    [[[GAI sharedInstance] defaultTracker] send:[[GAIDictionaryBuilder createAppView] build]];
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

- (IBAction)joinButtonTapped:(id)sender
{
    // GA
    [GAUtil sendGADataWithUIAction:@"register_button_tapped" label:@"escape_view" value:nil];

    
    if ([self userFormCheck]) {
        NSLog(@"registering");
        [self registerUser];
    }
}

- (void)registerUser
{
    NSDate *startDate = [NSDate date];
    
    GTLServiceFlagengine *service = [FlagClient flagengineService];
    
    GTLFlagengineUserForm *userForm =  [GTLFlagengineUserForm alloc];
    [userForm setEmail:self.emailTextField.text];
    [userForm setPassword:[Util encryptPasswordWithPassword:self.passwordTextField.text]];
    [userForm setIdentifier:self.user.userId];
    
    GTLQueryFlagengine *query = [GTLQueryFlagengine queryForUsersInsertWithObject:userForm];
    
    [service executeQuery:query completionHandler:^(GTLServiceTicket *ticket, GTLFlagengineUserForm *user, NSError *error){
        
        if (error == nil) {
            [GAUtil sendGADataLoadTimeWithInterval:[[NSDate date] timeIntervalSinceDate:startDate] actionName:@"register_user" label:nil];
            [self changeUserForm];
            [self presentPhoneCertView];
        }else{
            [Util showAlertView:nil message:@"회원가입 중에 에러가 발생했습니다" title:@"회원가입"];
        }

    }];
}

- (void)changeUserForm
{
    self.user.registered = YES;
    self.user.email = self.emailTextField.text;
}

- (void)presentPhoneCertView
{
    UIStoryboard *storyboard = [ViewUtil getStoryboard];
    PhoneCertificationViewController *childViewController = (PhoneCertificationViewController *)[storyboard instantiateViewControllerWithIdentifier:@"PhoneCertificationView"];
    
    childViewController.user = self.user;
    
    [DataUtil saveUserFormForRegisterWithEmail:self.emailTextField.text];
    
    [self presentViewController:childViewController animated:YES completion:nil];
}

- (IBAction)backgroundTapped:(id)sender
{
    // GA
    [GAUtil sendGADataWithUIAction:@"background_tapped" label:@"inside_view" value:nil];

    
    [self.emailTextField resignFirstResponder];
    [self.passwordTextField resignFirstResponder];
    [self.confirmPasswordTextField resignFirstResponder];
}

- (IBAction)cancelButtonTapped:(id)sender
{
    // GA
    [GAUtil sendGADataWithUIAction:@"go_back" label:@"escape_view" value:nil];

    
    if (self.parentPage == TAB_BAR_VIEW_PAGE) {

        [self dismissViewControllerAnimated:YES completion:nil];
        
    }else if (self.parentPage == LOGIN_VIEW_PAGE){
        
        [self dismissViewControllerAnimated:YES completion:nil];

    }else if (self.parentPage == SLIDE_MENU_PAGE){
        
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (IBAction)showUserAgreementButtonTapped:(id)sender
{
    // GA
    [GAUtil sendGADataWithUIAction:@"go_to_user_agreement" label:@"escape_view" value:nil];

    
    [ViewUtil presentUserPolicyInView:self policyType:POLICY_FOR_USER_AGREEMENT];
}

- (IBAction)showUserInfoPolicyButtonTapped:(id)sender
{
    // GA
    [GAUtil sendGADataWithUIAction:@"go_to_user_info_policy" label:@"escape_view" value:nil];

    
    [ViewUtil presentUserPolicyInView:self policyType:POLICY_FOR_USER_INFO];
}

#pragma mark -
#pragma mark Implementation
- (BOOL)userFormCheck
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
        
        [Util textFieldHasProblemWithTextField:self.emailTextField message:@"이메일을 입력해주세요" alertTitle:@"회원가입"];
        return NO;
        
    }else if (![self emailFieldCheckWithEmail:self.emailTextField.text]){
        
        [Util textFieldHasProblemWithTextField:self.emailTextField message:@"이메일 형식이 올바르지 않습니다" alertTitle:@"회원가입"];
        return NO;
        
    }else return YES;
}

- (BOOL)passwordTextFieldCheck
{
    if ([self.passwordTextField.text length] == 0) {
        
        [Util textFieldHasProblemWithTextField:self.passwordTextField message:@"비밀번호를 입력해주세요" alertTitle:@"회원가입"];
        return NO;
        
    }else if (![self.passwordTextField.text isEqualToString:self.confirmPasswordTextField.text]){
        
        [Util textFieldHasProblemWithTextField:self.confirmPasswordTextField message:@"비밀번호를 확인해서 다시 입력해주세요" alertTitle:@"회원가입"];
        return NO;
        
    }else return YES;
}

- (BOOL)emailFieldCheckWithEmail:(NSString *)email
{
    if ([email rangeOfString:@"@"].location == NSNotFound) {
        return NO;
    }else return YES;
}

@end
