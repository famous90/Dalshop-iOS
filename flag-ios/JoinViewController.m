//
//  JoinViewController.m
//  flag-ios
//
//  Created by Gyuyoung Hwang on 2014. 3. 17..
//
//

#import "JoinViewController.h"
#import "FlagViewController.h"

#import "User.h"

#import "Util.h"
#import "ViewUtil.h"

#import "GTMHTTPFetcherLogging.h"
//#import "GTLFlagengine.h"

@interface JoinViewController ()

@end

@implementation JoinViewController

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    [Util setHorizontalPaddingWithTextField:self.emailTextField];
    [Util setHorizontalPaddingWithTextField:self.passwordTextField];
    [Util setHorizontalPaddingWithTextField:self.confirmPasswordTextField];
    self.emailTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentBottom;
    self.passwordTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentBottom;
    self.confirmPasswordTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentBottom;
    
    [Util setPlaceholderAttributeWithTextField:self.emailTextField placeholderContent:@"e-mail"];
    [Util setPlaceholderAttributeWithTextField:self.passwordTextField placeholderContent:@"password"];
    [Util setPlaceholderAttributeWithTextField:self.confirmPasswordTextField placeholderContent:@"confirm password"];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (IBAction)emailTextFieldTapped:(id)sender
{
}

- (IBAction)passwordTextFieldTapped:(id)sender
{
}

- (IBAction)confirmPasswordTextFieldTapped:(id)sender
{
}

- (IBAction)joinButtonTapped:(id)sender
{
//    GTLServiceFlagengine *service = [self flagengineService];
//    
//    GTLFlagengineUser *user = [GTLFlagengineUser alloc];
////    GTLFlagengineUserForm *user = [GTLFlagengineUserForm alloc];
//    [user setEmail:@"3@tankers.com"];
//    [user setPassword:@"111"];
//    
//    GTLQueryFlagengine *query = [GTLQueryFlagengine queryForUsersInsertWithObject:user];
//    NSLog(@"query %@", query);
//    
//    [service executeQuery:query completionHandler:^(GTLServiceTicket *ticket, GTLFlagengineUser *user, NSError *error){
//        NSLog(@"ticket %@", ticket);
//        NSLog(@"service %@", ticket.service);
//        NSLog(@"result %@", user);
//    }];
    User *user = [[User alloc] init];
    
    UIStoryboard *storyboard = [ViewUtil getStoryboard];
    FlagViewController *childViewController = [storyboard instantiateViewControllerWithIdentifier:@"FlagView"];
    childViewController.user = user;
}
- (IBAction)backgroundTapped:(id)sender
{
    [self.emailTextField resignFirstResponder];
    [self.passwordTextField resignFirstResponder];
    [self.confirmPasswordTextField resignFirstResponder];
}

- (IBAction)cancelButtonTapped:(id)sender
{
    if (self.parentPage == TAB_BAR_VIEW_PAGE) {

        [self dismissViewControllerAnimated:YES completion:nil];
        
    }else if (self.parentPage == LOGIN_VIEW_PAGE){
        
        [self dismissViewControllerAnimated:YES completion:nil];

    }
}

#pragma mark - GTL service flagengine
//- (GTLServiceFlagengine *)flagengineService
//{
//    static GTLServiceFlagengine *service = nil;
//    if (!service) {
//        service = [[GTLServiceFlagengine alloc] init];
//        
//        // Have the service object set tickets to retry temporary error conditions
//        // automatically
//        service.retryEnabled = YES;
//        
//        [GTMHTTPFetcher setLoggingEnabled:YES];
//    }
//    return service;
//}
@end
