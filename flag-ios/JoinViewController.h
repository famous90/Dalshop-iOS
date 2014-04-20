//
//  JoinViewController.h
//  flag-ios
//
//  Created by Gyuyoung Hwang on 2014. 3. 17..
//
//

#import <UIKit/UIKit.h>
#import "GTMHTTPFetcherLogging.h"
//#import "GTLFlagengine.h"

@interface JoinViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UITextField *confirmPasswordTextField;
@property (weak, nonatomic) IBOutlet UIButton *joinButton;

@property (nonatomic, strong) User *user;
@property (nonatomic, assign) NSInteger parentPage;

- (IBAction)emailTextFieldTapped:(id)sender;
- (IBAction)passwordTextFieldTapped:(id)sender;
- (IBAction)confirmPasswordTextFieldTapped:(id)sender;
- (IBAction)joinButtonTapped:(id)sender;
- (IBAction)backgroundTapped:(id)sender;
- (IBAction)cancelButtonTapped:(id)sender;
@end
