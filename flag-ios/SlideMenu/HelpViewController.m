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

#import "FlagClient.h"
#import "GTLFlagengine.h"
#import "GoogleAnalytics.h"

@interface HelpViewController ()

@end

@implementation HelpViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"달샵에게 물어보기";
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark -
#pragma mark IBAction
- (IBAction)cancelButtonTapped:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)sendButtonTapped:(id)sender
{
    if ([self.emailAddressTextField isEqual:[NSNull null]]) {
        return;
    }
    if ([self.contentsTextView isEqual:[NSNull null]]) {
        return;
    }
    
    [self sendFeedback];
}

- (void)sendFeedback
{
    GTLServiceFlagengine *service = [FlagClient flagengineService];

    GTLFlagengineText *text = [GTLFlagengineText alloc];
    [text setValue:self.contentsTextView.text];
    
    GTLFlagengineFeedbackMessage *feedback = [GTLFlagengineFeedbackMessage alloc];
    [feedback setEmail:self.emailAddressTextField.text];
    [feedback setMessage:text];
    [feedback setUserId:self.user.userId];
    GTLQueryFlagengine *query = [GTLQueryFlagengine queryForAppsFeedbacksInsertWithObject:feedback];
    
    [service executeQuery:query completionHandler:^(GTLServiceTicket *ticket, GTLFlagengineFeedbackMessage *feedback, NSError *error){
        NSLog(@"result object %@", feedback);
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"달샵에게 물어보기" message:@"좋은 의견 감사합니다.잠시만 기다려주시면 바로 답변해드리도록 하겠습니다." delegate:self cancelButtonTitle:@"확인" otherButtonTitles:nil, nil];
        [alert show];
    }];
}

- (IBAction)backgroundViewTapped:(id)sender
{
//    [self.emailAddressTextField resignFirstResponder];
    [self.contentsTextView resignFirstResponder];
}

#pragma mark -
#pragma mark alert view
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [self dismissViewControllerAnimated:YES completion:nil];
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
        CGRect frame = self.contentsTextView.frame;
        frame.size.height = keyboardTop - self.contentsTextView.frame.origin.y - 2;
        self.contentsTextView.frame = frame;

    } else {
        // Keyboard is going away (down) - restore original frame
        CGRect frame = self.contentsTextView.frame;
        frame.size.height = self.view.frame.size.height - self.contentsTextView.frame.origin.y;
        self.contentsTextView.frame = frame;

    }
    
    [UIView commitAnimations];
}
@end
