//
//  HelpViewController.h
//  flag-ios
//
//  Created by Hwang Gyuyoung on 2014. 5. 2..
//
//

#import <UIKit/UIKit.h>

@class User;

@interface HelpViewController : UIViewController<UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UITextField *emailAddressTextField;
@property (weak, nonatomic) IBOutlet UITextField *contentsTextView;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@property (weak, nonatomic) IBOutlet UIButton *sendButton;

@property (nonatomic, strong) User *user;

- (IBAction)cancelButtonTapped:(id)sender;
- (IBAction)sendButtonTapped:(id)sender;
- (IBAction)backgroundViewTapped:(id)sender;

@end
