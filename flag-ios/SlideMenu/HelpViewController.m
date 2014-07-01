//
//  HelpViewController.m
//  flag-ios
//
//  Created by Hwang Gyuyoung on 2014. 5. 2..
//
//

#import "HelpViewController.h"

#import "User.h"

#import "Util.h"
#import "ViewUtil.h"

#import "FlagClient.h"
#import "GTLFlagengine.h"
#import "GoogleAnalytics.h"

@interface HelpViewController ()

@end

@implementation HelpViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self configureViewContent];
}

- (void)configureViewContent
{
    NSString *title;
    NSString *description;
    NSString *messageTitle;
    
    if (self.parentPage == SLIDE_MENU_PAGE) {
        
        title = @"달샵에게 물어보기";
        description = @"달샵에게 궁금하거나 필요한 것이 있으면\n어떤 것이든 말씀해주세요^^(쫑끗)";
        messageTitle = @"문의 내용:";
        
    }else if (self.parentPage == REDEEM_VIEW_PAGE){
        
        title = @"달샵에게 요청합니다!";
        description = @"달로 사고 싶은 물품을 말씀해주세요~\n어떤 수단과 방법을 동원해서라도 넣어드릴게요!";
        messageTitle = @"물품 내용:";
        
    }
    
    self.title = title;
    
    [self.viewDescription setText:description];
    [self.viewDescription setTextAlignment:NSTextAlignmentCenter];
    [self.viewDescription setTextColor:UIColorFromRGB(BASE_COLOR)];
    
    [self.messageTitle setText:messageTitle];
    
    self.emailAddressTextField.layer.borderColor = UIColorFromRGB(BASE_COLOR).CGColor;
    self.emailAddressTextField.layer.borderWidth = 1.0f;
    self.emailAddressTextField.layer.cornerRadius = 5;
    
    self.messageTextView.layer.borderColor = UIColorFromRGB(BASE_COLOR).CGColor;
    self.messageTextView.layer.borderWidth = 1.0f;
    self.messageTextView.layer.cornerRadius = 5;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self setUser:[DelegateUtil getUser]];
    [ViewUtil setAppDelegatePresentingViewControllerWithViewController:self];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    // GA
    [[[GAI sharedInstance] defaultTracker] set:kGAIScreenName value:GAI_SCREEN_NAME_HELP_VIEW];
    [[[GAI sharedInstance] defaultTracker] send:[[GAIDictionaryBuilder createAppView] build]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark -
#pragma mark IBAction
- (IBAction)cancelButtonTapped:(id)sender
{
    // GA
    [GAUtil sendGADataWithUIAction:@"go_back" label:@"escape_view" value:nil];

    
    if (self.parentPage == SLIDE_MENU_PAGE) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }else if (self.parentPage == REDEEM_VIEW_PAGE){
        [self.navigationController popViewControllerAnimated:YES];
    }

}

- (IBAction)sendButtonTapped:(id)sender
{
    // GA
    [GAUtil sendGADataWithUIAction:@"send_help_mail" label:@"inside_view" value:nil];

    
    if ([self.emailAddressTextField isEqual:[NSNull null]]) {
        return;
    }
    if ([self.messageTextView isEqual:[NSNull null]]) {
        return;
    }
    
    [self sendFeedback];
}

- (void)sendFeedback
{
    NSDate *startDate = [NSDate date];
    
    GTLServiceFlagengine *service = [FlagClient flagengineService];

    GTLFlagengineText *text = [GTLFlagengineText alloc];
    [text setValue:[self appendReferenceToMessageText:self.messageTextView.text]];
    
    GTLFlagengineFeedbackMessage *feedback = [GTLFlagengineFeedbackMessage alloc];
    [feedback setEmail:self.emailAddressTextField.text];
    [feedback setMessage:text];
    [feedback setUserId:self.user.userId];
    GTLQueryFlagengine *query = [GTLQueryFlagengine queryForAppsFeedbacksInsertWithObject:feedback];
    
    [service executeQuery:query completionHandler:^(GTLServiceTicket *ticket, GTLFlagengineFeedbackMessage *feedback, NSError *error){
        NSLog(@"result object %@", feedback);
        
        [GAUtil sendGADataLoadTimeWithInterval:[[NSDate date] timeIntervalSinceDate:startDate] actionName:@"send_feedback" label:nil];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"To 달샵" message:@"좋은 의견 감사합니다.잠시만 기다려주시면 바로 답변해드리도록 하겠습니다." delegate:self cancelButtonTitle:@"확인" otherButtonTitles:nil, nil];
        [alert show];
    }];
}

- (NSString *)appendReferenceToMessageText:(NSString *)text
{
    text = [text stringByAppendingString:@"\n\n 아이폰에서 보낸 메세지"];
    
    return text;
}

- (IBAction)backgroundViewTapped:(id)sender
{
//    [self.emailAddressTextField resignFirstResponder];
    [self.messageTextView resignFirstResponder];
}

#pragma mark -
#pragma mark alert view
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (self.parentPage == SLIDE_MENU_PAGE) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }else if (self.parentPage == REDEEM_VIEW_PAGE){
        [self.navigationController popViewControllerAnimated:YES];
    }

}

#pragma mark -
#pragma mark Implementation
- (void)keyboardWillShow:(NSNotification*)notification {
    [self moveTextViewForKeyboard:notification up:YES];
}

- (void)keyboardWillHide:(NSNotification*)notification {
    [self moveTextViewForKeyboard:notification up:NO];
}

- (void)moveTextViewForKeyboard:(NSNotification*)notification up:(BOOL)up {
    NSDictionary *userInfo = [notification userInfo];
    UIViewAnimationCurve animationCurve;
    CGRect keyboardRect;
    
    [[userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] getValue:&animationCurve];
    keyboardRect = [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    keyboardRect = [self.view convertRect:keyboardRect fromView:nil];
    
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:.1];
    [UIView setAnimationCurve:animationCurve];
    
    if (up == YES) {

        CGFloat keyboardTop = keyboardRect.origin.y;
        CGRect frame = self.messageTextView.frame;
        frame.size.height = keyboardTop - self.messageTextView.frame.origin.y - 2;
        self.messageTextView.frame = frame;

    } else {
        // Keyboard is going away (down) - restore original frame
        CGRect frame = self.messageTextView.frame;
        frame.size.height = self.view.frame.size.height - self.messageTextView.frame.origin.y - 100;
        self.messageTextView.frame = frame;

    }
    
    [UIView commitAnimations];
}
@end
