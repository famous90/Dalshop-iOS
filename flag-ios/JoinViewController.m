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

#import "User.h"

#import "Util.h"
#import "ViewUtil.h"

#import "GTLFlagengine.h"
#import "FlagClient.h"

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
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (IBAction)joinButtonTapped:(id)sender
{
    if ([self userFormCheck]) {
        NSLog(@"registering");
        [self registerUser];
    }
}

- (void)registerUser
{
    GTLServiceFlagengine *service = [FlagClient flagengineService];
    
    GTLFlagengineUserForm *userForm =  [GTLFlagengineUserForm alloc];
    [userForm setEmail:self.emailTextField.text];
    [userForm setPassword:[Util encryptPasswordWithPassword:self.passwordTextField.text]];
    [userForm setIdentifier:self.user.userId];
    
    GTLQueryFlagengine *query = [GTLQueryFlagengine queryForUsersInsertWithObject:userForm];
    
    [service executeQuery:query completionHandler:^(GTLServiceTicket *ticket, GTLFlagengineUserForm *user, NSError *error){
        
        if (error == nil) {
            [self changeUserForm];
            [self restartView];
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

- (void)restartView
{
    UIStoryboard *storyboard = [ViewUtil getStoryboard];
    SWRevealViewController *restartViewController = (SWRevealViewController *)[storyboard instantiateViewControllerWithIdentifier:@"RevealView"];
    restartViewController.user = self.user;
    
    [self saveUserFormInCoreData];
    
    [self presentViewController:restartViewController animated:YES completion:nil];
}

- (void)saveUserFormInCoreData
{
    NSManagedObjectContext *context = [self managedObjectContext];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"UserInfo"];
    NSMutableArray *userInfos = [[context executeFetchRequest:fetchRequest error:nil] mutableCopy];
    NSManagedObject *userInfo = [userInfos objectAtIndex:0];
    
    if (userInfo) {
        [userInfo setValue:self.emailTextField.text forKey:@"email"];
        [userInfo setValue:[NSNumber numberWithBool:YES] forKey:@"registered"];
    }
    
    NSError *error = nil;
    if (![context save:&error]) {
        NSLog(@"Can't save! %@ %@", error, [error localizedDescription]);
    }
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

    }else if (self.parentPage == SLIDE_MENU_PAGE){
        
        [self dismissViewControllerAnimated:YES completion:nil];
    }
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

#pragma mark -
#pragma mark core data
- (NSManagedObjectContext *)managedObjectContext
{
    NSManagedObjectContext *context = nil;
    id delegate = [[UIApplication sharedApplication] delegate];
    if ([delegate performSelector:@selector(managedObjectContext)]) {
        context = [delegate managedObjectContext];
    }
    return context;
}

@end
