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

@implementation HelpViewController{
    CGFloat viewPadding;
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    [self configureViewContent];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    // GA
    [self setScreenName:GAI_SCREEN_NAME_HELP_VIEW];
}

- (void)configureViewContent
{
    NSString *description;
    NSString *emailLabelName;
    NSString *title;
    NSString *messageTitle;
    
    UIFont *descriptionFont = [UIFont systemFontOfSize:11];
    UIFont *LabelNameFont = [UIFont systemFontOfSize:15];
    
    CGFloat lineSpace = 10.0f;
    viewPadding = 20.0f;
    
    if (self.parentPage == SLIDE_MENU_PAGE) {
        
        emailLabelName = [NSString stringWithFormat:@"%@:", NSLocalizedString(@"Email", @"Email")];
        title = NSLocalizedString(@"Ask DALSHOP", @"Ask DALSHOP");
        description = [NSString stringWithFormat:@"%@\n%@", NSLocalizedString(@"Ask Us Anything you want", @"Ask Us Anything you want"), NSLocalizedString(@"With a corrent Email, We can help ASAP", @"With a corrent Email, We can help ASAP")];
        messageTitle = [NSString stringWithFormat:@"%@:", NSLocalizedString(@"Ask Message", @"Ask Message")];
        
    }else if (self.parentPage == REDEEM_VIEW_PAGE){
        
        emailLabelName = [NSString stringWithFormat:@"%@:", NSLocalizedString(@"Email", @"Email")];
        title = NSLocalizedString(@"Ask DALSHOP", @"Ask DALSHOP");
        description = [NSString stringWithFormat:@"%@\n%@", NSLocalizedString(@"Tell us you want to buy with DAL", @"Tell us you want to buy with DAL"), NSLocalizedString(@"We will try every possible means and include it", @"We will try every possible means and include it")];
        messageTitle = [NSString stringWithFormat:@"%@:", NSLocalizedString(@"Want to get", @"Want to get")];
        
    }
    
    [self setTitle:title];
    
    [self.navigationItem.rightBarButtonItem setTitle:NSLocalizedString(@"Send", @"Send")];
    
    CGRect descriptionFrame = [description boundingRectWithSize:CGSizeMake(self.view.frame.size.width, self.view.frame.size.height) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: descriptionFont} context:nil];
    CGRect descriptionLabelFrame = CGRectMake((self.view.frame.size.width - descriptionFrame.size.width)/2, self.viewDescription.frame.origin.y, descriptionFrame.size.width, descriptionFrame.size.height);
    [self.viewDescription setFrame:descriptionLabelFrame];
    [self.viewDescription setText:description];
    [self.viewDescription setFont:descriptionFont];
    [self.viewDescription setTextAlignment:NSTextAlignmentLeft];
    [self.viewDescription setTextColor:UIColorFromRGB(BASE_COLOR)];
    [self.viewDescription setNumberOfLines:0];
    
    CGRect emailNameFrame = [emailLabelName boundingRectWithSize:CGSizeMake(200, 100) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: LabelNameFont} context:nil];
    CGRect emailLabelNameFrame = CGRectMake(self.emailLabel.frame.origin.x, [ViewUtil getOriginYBottomToFrame:self.viewDescription.frame] + lineSpace, emailNameFrame.size.width, emailNameFrame.size.height);
    [self.emailLabel setFrame:emailLabelNameFrame];
    [self.emailLabel setText:emailLabelName];
    [self.emailLabel setFont:LabelNameFont];
    
    CGRect emailFieldFrame = CGRectMake([ViewUtil getOriginXNextToFrame:self.emailLabel.frame] + lineSpace, [ViewUtil getOriginYBottomToFrame:self.viewDescription.frame] + lineSpace, self.view.frame.size.width - viewPadding - [ViewUtil getOriginXNextToFrame:self.emailLabel.frame] - lineSpace, self.emailAddressTextField.frame.size.height);
    [self.emailAddressTextField setFrame:emailFieldFrame];
    [self.emailAddressTextField setPlaceholder:NSLocalizedString(@"Email to answer", @"Email to answer")];
    
    CGRect messageNameFrame = [messageTitle boundingRectWithSize:CGSizeMake(300, 100) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: LabelNameFont} context:nil];
    CGRect messageTitleFrame = CGRectMake(self.messageTitle.frame.origin.x, [ViewUtil getOriginYBottomToFrame:self.emailAddressTextField.frame] + lineSpace, messageNameFrame.size.width, messageNameFrame.size.height);
    [self.messageTitle setFrame:messageTitleFrame];
    [self.messageTitle setText:messageTitle];
    [self.messageTitle setFont:LabelNameFont];
    
    CGFloat messageFrameOriginY = [ViewUtil getOriginYBottomToFrame:self.messageTitle.frame] + lineSpace;
    CGRect messageFrame = CGRectMake(self.messageTextView.frame.origin.x, messageFrameOriginY, self.messageTextView.frame.size.width, self.view.frame.size.height - messageFrameOriginY - viewPadding);
    [self.messageTextView setFrame:messageFrame];
    
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
        DLog(@"result object %@", feedback);
        
        [GAUtil sendGADataLoadTimeWithInterval:[[NSDate date] timeIntervalSinceDate:startDate] actionName:@"send_feedback" label:nil];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"To %@", NSLocalizedString(@"DALSHOP", @"DALSHOP")] message:NSLocalizedString(@"Thank you for telling us", @"Thank you for telling us") delegate:self cancelButtonTitle:NSLocalizedString(@"Okay", @"Okay") otherButtonTitles:nil, nil];
        [alert show];
    }];
}

- (NSString *)appendReferenceToMessageText:(NSString *)text
{
    NSString *appVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
    NSString *systemVersion  = [[UIDevice currentDevice] systemVersion];
    NSString *systemName = [[UIDevice currentDevice] systemName];
    NSString *model = [[UIDevice currentDevice] model];
    NSString *name = [[UIDevice currentDevice] name];

    text = [text stringByAppendingString:@"\n\n아이폰에서 보낸 메세지"];
    text = [text stringByAppendingFormat:@"\n model : %@ \n name : %@ \n systemName : %@ \n systemVersion : %@ \n appVersion : %@", model, name, systemName, systemVersion, appVersion];
    
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
        frame.size.height = self.view.frame.size.height - self.messageTextView.frame.origin.y - viewPadding;
        self.messageTextView.frame = frame;

    }
    
    [UIView commitAnimations];
}
@end
