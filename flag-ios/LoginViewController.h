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

@interface LoginViewController : UIViewController <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;

- (IBAction)emailTextFieldTapped:(id)sender;
- (IBAction)passwordTextFieldTapped:(id)sender;
- (IBAction)loginButtonTapped:(id)sender;
- (IBAction)joinButtonTapped:(id)sender;
- (IBAction)backgroundTapped:(id)sender;
@end
