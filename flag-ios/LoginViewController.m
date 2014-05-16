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

#import "FlagClient.h"
#import "GTLFlagengine.h"

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
}

#pragma mark -
#pragma mark IBAction

- (IBAction)loginButtonTapped:(id)sender
{
    if ([self loginFormCheck]) {
        NSLog(@"logining");
        [self loginUser];
    }
}

- (void)loginUser
{
    GTLServiceFlagengine *service = [FlagClient flagengineService];
    
    GTLFlagengineUserForm *userForm = [GTLFlagengineUserForm alloc];
    [userForm setEmail:self.emailTextField.text];
    [userForm setPassword:[Util encryptPasswordWithPassword:self.passwordTextField.text]];
    [userForm setIdentifier:self.user.userId];
    
    GTLQueryFlagengine *query = [GTLQueryFlagengine queryForUsersGetWithObject:userForm];
    
    [service executeQuery:query completionHandler:^(GTLServiceTicket *ticket, GTLFlagengineUser *user, NSError *error){
        
        if (error == nil) {
            [self changeUserFormWithUser:user];
            [self restartView];
        }else{
            [Util showAlertView:nil message:@"로그인에 실패하였습니다\n다시 시도해주세요" title:@"로그인"];
        }
        
    }];
}

- (void)changeUserFormWithUser:(GTLFlagengineUser *)user
{
    User *theUser = [[User alloc] initWithLoginData:user];
    self.user = theUser;
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
    UIStoryboard *storyboard = [ViewUtil getStoryboard];
    JoinViewController *childViewController = (JoinViewController *)[storyboard instantiateViewControllerWithIdentifier:@"JoinView"];
    
    childViewController.parentPage = LOGIN_VIEW_PAGE;
    
    [self presentViewController:childViewController animated:YES completion:nil];
}

- (IBAction)backgroundTapped:(id)sender
{
    [self.emailTextField resignFirstResponder];
    [self.passwordTextField resignFirstResponder];
}

- (IBAction)cancelButtonTapped:(id)sender
{
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
