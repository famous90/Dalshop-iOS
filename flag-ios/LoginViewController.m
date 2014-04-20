//
//  LoginViewController.m
//  flag-ios
//
//  Created by Gyuyoung Hwang on 2014. 3. 17..
//
//

#import "LoginViewController.h"
#import "JoinViewController.h"
#import "FlagViewController.h"

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

#pragma mark
#pragma mark - text field delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    NSString *message = nil;
    
    if (textField == self.emailTextField) {
        
        if ([textField.text isEqual:[NSNull null]]) {
        
            message = @"이메일을 입력해주세요";
            [self.emailTextField becomeFirstResponder];
            
        }else{
            
            [self.emailTextField endEditing:YES];
            [self.passwordTextField becomeFirstResponder];
            [self passwordTextFieldTapped:self.passwordTextField];
            
        }
        
    }else if (textField == self.passwordTextField){
        
        if ([textField.text isEqual:[NSNull null]]) {
            
            message = @"비밀번호를 입력해주세요";
            [self.passwordTextField becomeFirstResponder];
            
        }else{
            
            [self.passwordTextField endEditing:YES];
            [self loginButtonTapped:self.loginButton];
        }
        
    }
    
    if ([message isEqual:[NSNull null]]) {
        
        [Util showAlertView:nil message:message title:@"확인"];
        return NO;
        
    }else return YES;
}

#pragma mark - 
#pragma mark GTL
- (GTLServiceFlagengine *)flagengineService
{
    static GTLServiceFlagengine *service = nil;
    if (!service) {
        service = [[GTLServiceFlagengine alloc] init];
        
        // have the service object set tickets to retry temporary error conditions automatically
        service.retryEnabled = YES;
        
        [GTMHTTPFetcher setLoggingEnabled:YES];
    }
    
    return service;
}

#pragma mark -
#pragma mark IBAction

- (IBAction)emailTextFieldTapped:(id)sender
{
}

- (IBAction)passwordTextFieldTapped:(id)sender
{
}

- (IBAction)loginButtonTapped:(id)sender
{
//    User *user = [[User alloc] init];
//    
//    UIStoryboard *storyboard = [ViewUtil getStoryboard];
//    FlagViewController *childViewController = [storyboard instantiateViewControllerWithIdentifier:@"FlagView"];
//    childViewController.user = user;
    
    // POST Request Test
    GTLServiceFlagengine *service = [FlagClient flagengineService];
    
    GTLFlagengineNotice *notice = [GTLFlagengineNotice alloc];
    [notice setMessage:@"Game of Thrones S4E2, Joffrey Baratheon dies at the end.."];
    GTLQueryFlagengine *query = [GTLQueryFlagengine queryForAppsNoticesInsertWithObject:notice];
    
    [service executeQuery:query completionHandler:^(GTLServiceTicket *ticket, GTLFlagengineNotice *notice, NSError *error){
        NSLog(@"result object \n %@", notice);
    }];
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

@end
