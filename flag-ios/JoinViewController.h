//
//  JoinViewController.h
//  flag-ios
//
//  Created by Gyuyoung Hwang on 2014. 3. 17..
//
//

#import <UIKit/UIKit.h>
#import "GTMHTTPFetcherLogging.h"

@interface JoinViewController : GAITrackedViewController

@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UITextField *confirmPasswordTextField;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@property (weak, nonatomic) IBOutlet UIButton *joinButton;
@property (weak, nonatomic) IBOutlet UIButton *showUserAgreementButton;
@property (weak, nonatomic) IBOutlet UIButton *showUserInfoPolicyButton;
@property (weak, nonatomic) IBOutlet UILabel *dalshopLabel;

@property (nonatomic, strong) User *user;
@property (nonatomic, assign) NSInteger parentPage;

- (IBAction)joinButtonTapped:(id)sender;
- (IBAction)backgroundTapped:(id)sender;
- (IBAction)cancelButtonTapped:(id)sender;
- (IBAction)showUserAgreementButtonTapped:(id)sender;
- (IBAction)showUserInfoPolicyButtonTapped:(id)sender;

@end
