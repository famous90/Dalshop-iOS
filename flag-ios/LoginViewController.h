//
//  LoginViewController.h
//  flag-ios
//
//  Created by Gyuyoung Hwang on 2014. 3. 17..
//
//

#import <UIKit/UIKit.h>
#import "GTMHTTPFetcherLogging.h"
//#import "GTLFlagengine.h"

@class User;

@interface LoginViewController : GAITrackedViewController <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UIButton *joinButton;
@property (weak, nonatomic) IBOutlet UILabel *dalshopLabel;

@property (nonatomic, strong) User *user;
@property (nonatomic, assign) NSInteger parentPage;

- (IBAction)loginButtonTapped:(id)sender;
- (IBAction)joinButtonTapped:(id)sender;
- (IBAction)backgroundTapped:(id)sender;
- (IBAction)cancelButtonTapped:(id)sender;

@end
