//
//  PhoneCertificationViewController.h
//  Dalshop
//
//  Created by Hwang Gyuyoung on 2014. 6. 2..
//
//

#import <UIKit/UIKit.h>

@class User;

@interface PhoneCertificationViewController : GAITrackedViewController

@property (weak, nonatomic) IBOutlet UITextField *phoneNumberTextField;
@property (weak, nonatomic) IBOutlet UITextField *certificationNumberTextField;
@property (weak, nonatomic) IBOutlet UIButton *passButton;
@property (weak, nonatomic) IBOutlet UIButton *requestCertificationNumberButton;
@property (weak, nonatomic) IBOutlet UIButton *reRequestCertificationNumberButton;
@property (weak, nonatomic) IBOutlet UIButton *sendButton;
@property (weak, nonatomic) IBOutlet UILabel *phoneNumberAdviceLabel;

@property (nonatomic, strong) User *user;

- (IBAction)passButtonTapped:(id)sender;
- (IBAction)requestCertificationNumberButtonTapped:(id)sender;
- (IBAction)reRequestCertificationButtonTapped:(id)sender;
- (IBAction)sendButtonTapped:(id)sender;
- (IBAction)backgroundTapeed:(id)sender;

@end
