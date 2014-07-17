//
//  PhoneCertificationViewController.m
//  Dalshop
//
//  Created by Hwang Gyuyoung on 2014. 6. 2..
//
//

#import "PhoneCertificationViewController.h"
#import "MyInfoViewController.h"

#import "Util.h"
#import "ViewUtil.h"
#import "DataUtil.h"

#import "GTLFlagengine.h"
#import "FlagClient.h"
#import "GoogleAnalytics.h"

@interface PhoneCertificationViewController ()

@end

@implementation PhoneCertificationViewController{
    BOOL isRequestCertNumBtnTapped;
    
    NSString *phoneNumber;
    NSString *verificationCode;
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    // view
    self.view.backgroundColor = UIColorFromRGB(BASE_COLOR);
    
    
    // text field
    [Util setHorizontalPaddingWithTextField:self.phoneNumberTextField];
    self.phoneNumberTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentBottom;
    [Util setPlaceholderAttributeWithTextField:self.phoneNumberTextField placeholderContent:NSLocalizedString(@"Phone Number", @"Phone Number")];
    
    [Util setHorizontalPaddingWithTextField:self.certificationNumberTextField];
    self.certificationNumberTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentBottom;
    [Util setPlaceholderAttributeWithTextField:self.certificationNumberTextField placeholderContent:NSLocalizedString(@"Verification Code", @"Verificatino Code")];
    
    
    // button
    self.passButton.layer.borderColor = [UIColor whiteColor].CGColor;
    self.passButton.layer.borderWidth = 0.8f;
    self.passButton.layer.cornerRadius = 5;
    
    self.requestCertificationNumberButton.layer.borderColor = [UIColor whiteColor].CGColor;
    self.requestCertificationNumberButton.layer.borderWidth = 0.8f;
    self.requestCertificationNumberButton.layer.cornerRadius = 5;
    
    self.reRequestCertificationNumberButton.layer.borderColor = [UIColor whiteColor].CGColor;
    self.reRequestCertificationNumberButton.layer.borderWidth = 0.8f;
    self.reRequestCertificationNumberButton.layer.cornerRadius = 5;
    
    self.sendButton.layer.borderColor = [UIColor whiteColor].CGColor;
    self.sendButton.layer.borderWidth = 0.8f;
    self.sendButton.layer.cornerRadius = 5;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initializeContent];
    
    
    // Analtics
    [self setScreenName:GAI_SCREEN_NAME_PHONE_CERTIFICATION_VIEW];
    [DaLogClient sendDaLogWithCategory:CATEGORY_VIEW_APPEAR target:VIEW_PHONE_INPUT value:0];
}

- (void)initializeContent
{
    [self configureViewContentWithRequestCertNumBtnTapped:NO];
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


#pragma mark - 
#pragma mark IBAction
- (IBAction)passButtonTapped:(id)sender
{
    // Analtics
    [GAUtil sendGADataWithUIAction:@"pass_phone_certificate" label:@"escape_view" value:nil];
    [DaLogClient sendDaLogWithCategory:CATEGORY_VIEW_DISAPPEAR target:VIEW_PHONE_INPUT value:0];

    
    [self presentAdditionalUserInfoView];
}

- (IBAction)requestCertificationNumberButtonTapped:(id)sender
{
    // GA
    [GAUtil sendGADataWithUIAction:@"request_button_tapped" label:@"inside_view" value:nil];
    
    
    phoneNumber = self.phoneNumberTextField.text;
    
    if ([Util isCorrectPhoneNumberForm:phoneNumber]) {
        [self requestPhoneCertificationNumber];
    }else{
        [Util showAlertView:nil message:NSLocalizedString(@"Phone number is not valid", @"Phone number is not valid") title:NSLocalizedString(@"Phone Number", @"Phone Number")];
    }
}

- (IBAction)reRequestCertificationButtonTapped:(id)sender
{
    // GA
    [GAUtil sendGADataWithUIAction:@"re_request_button_tapped" label:@"inside_view" value:nil];

    
    if ([Util isCorrectPhoneNumberForm:phoneNumber]) {
        [self requestPhoneCertificationNumber];
    }else{
        [Util showAlertView:nil message:NSLocalizedString(@"Phone number is not valid", @"Phone number is not valid") title:NSLocalizedString(@"Phone Number", @"Phone Number")];
    }
}

- (IBAction)sendButtonTapped:(id)sender
{
    // GA
    [GAUtil sendGADataWithUIAction:@"send_verification_number" label:@"inside_view" value:nil];

    
    if (![self.certificationNumberTextField.text isEqual:(id)[NSNull null]]) {
        [self sendCertificationNumber];
    }else{
        [Util showAlertView:nil message:NSLocalizedString(@"Enter the verification code", @"Enter the verification code") title:NSLocalizedString(@"Verification Code", @"Verification Code")];
    }
}

- (IBAction)backgroundTapeed:(id)sender
{
    // GA
    [GAUtil sendGADataWithUIAction:@"background_tapped" label:@"inside_view" value:nil];

    
    [self.phoneNumberTextField resignFirstResponder];
    [self.certificationNumberTextField resignFirstResponder];
}


#pragma mark -
#pragma mark GTLibrary
- (void)requestPhoneCertificationNumber
{
    NSDate *startDate = [NSDate date];
    
    GTLService *service = [FlagClient flagengineService];
    
    GTLFlagengineUserInfo *userInfo = [GTLFlagengineUserInfo alloc];
    [userInfo setUserId:self.user.userId];
    [userInfo setPhone:[Util addNationalCodeToNumber:phoneNumber]];
    
    GTLQueryFlagengine *query = [GTLQueryFlagengine queryForUserinfosPhoneTestWithObject:userInfo];
    [service executeQuery:query completionHandler:^(GTLServiceTicket *ticket, GTLFlagengineUserInfo *userInfo, NSError *error){
        
        NSLog(@"result %@", userInfo);
        if (error == nil) {
            
            // Analytics
            [GAUtil sendGADataLoadTimeWithInterval:[[NSDate date] timeIntervalSinceDate:startDate] actionName:@"request_phone_verification" label:nil];
            [DaLogClient sendDaLogWithCategory:CATEGORY_VIEW_DISAPPEAR target:VIEW_PHONE_INPUT value:0];
            [DaLogClient sendDaLogWithCategory:CATEGORY_VIEW_APPEAR target:VIEW_CERTIFICATION_INPUT value:0];
            
            
            [self didReceiveCertificationNumber];
            
        }else{
            DLog(@"request certification number error %@ %@", error, [error localizedDescription]);
            [Util showAlertView:nil message:NSLocalizedString(@"Receiving verification code Error", @"There are some problem to receive the certification code\nPlease try again") title:NSLocalizedString(@"Verification Code", @"Verification Code")];
        }
        
    }];
}

- (void)sendCertificationNumber
{
    NSDate *startDate = [NSDate date];
    
    GTLService *service = [FlagClient flagengineService];
    
    GTLFlagengineUserInfo *userInfo = [GTLFlagengineUserInfo alloc];
    [userInfo setUserId:self.user.userId];
    [userInfo setPhone:self.certificationNumberTextField.text];
    
    GTLQueryFlagengine *query = [GTLQueryFlagengine queryForUserinfosPhoneInsertWithObject:userInfo];
    
    [service executeQuery:query completionHandler:^(GTLServiceTicket *ticket, GTLFlagengineUserInfo *userInfo, NSError *error){
        
        if (error == nil) {
            
            // Analytics
            [GAUtil sendGADataLoadTimeWithInterval:[[NSDate date] timeIntervalSinceDate:startDate] actionName:@"send_phone_verification" label:nil];
            [DaLogClient sendDaLogWithCategory:CATEGORY_VIEW_DISAPPEAR target:VIEW_CERTIFICATION_INPUT value:0];

            
            [self successPhoneCertification];
            [self presentAdditionalUserInfoView];
        }else{
            NSLog(@"phone certification error %@ %@", error, [error localizedDescription]);
            [Util showAlertView:nil message:NSLocalizedString(@"Please check the certification code and try again", @"Please check the certification code and try again") title:NSLocalizedString(@"Verification Code", @"Verification Code")];
        }
        
    }];
}

#pragma mark -
#pragma mark Implementation
- (void)didReceiveCertificationNumber
{
    [self configureViewContentWithRequestCertNumBtnTapped:YES];
}

- (void)configureViewContentWithRequestCertNumBtnTapped:(BOOL)isbuttonTapped
{
    isRequestCertNumBtnTapped = isbuttonTapped;
    
    [self.phoneNumberAdviceLabel setHidden:isRequestCertNumBtnTapped];
    [self.passButton setHidden:isRequestCertNumBtnTapped];
    [self.requestCertificationNumberButton setHidden:isRequestCertNumBtnTapped];
    
    [self.certificationNumberTextField setHidden:!isRequestCertNumBtnTapped];
    [self.reRequestCertificationNumberButton setHidden:!isRequestCertNumBtnTapped];
    [self.sendButton setHidden:!isRequestCertNumBtnTapped];
}

- (void)successPhoneCertification
{
    self.user.phoneCertificated = YES;
    [DataUtil savePhoneCertificationSeccess];
}

- (void)presentAdditionalUserInfoView
{
    UIStoryboard *storyboard = [ViewUtil getStoryboard];
    MyInfoViewController *childViewController = (MyInfoViewController *)[storyboard instantiateViewControllerWithIdentifier:@"MyInfoView"];
    childViewController.user = self.user;
    childViewController.parentPage = PHONE_CERTIFICATION_VIEW_PAGE;
    
    [self presentViewController:childViewController animated:YES completion:nil];
}
@end
