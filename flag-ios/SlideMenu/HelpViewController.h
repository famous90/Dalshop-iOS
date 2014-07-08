//
//  HelpViewController.h
//  flag-ios
//
//  Created by Hwang Gyuyoung on 2014. 5. 2..
//
//

#import <UIKit/UIKit.h>

@class User;

@interface HelpViewController : GAITrackedViewController <UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *viewDescription;
@property (weak, nonatomic) IBOutlet UITextField *emailAddressTextField;
@property (weak, nonatomic) IBOutlet UILabel *messageTitle;
@property (weak, nonatomic) IBOutlet UITextView *messageTextView;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@property (weak, nonatomic) IBOutlet UIButton *sendButton;

@property (nonatomic, strong) User *user;
@property (nonatomic, assign) NSInteger parentPage;

- (IBAction)cancelButtonTapped:(id)sender;
- (IBAction)sendButtonTapped:(id)sender;
- (IBAction)backgroundViewTapped:(id)sender;

@end
