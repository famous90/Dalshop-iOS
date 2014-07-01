//
//  UserPolicyViewController.m
//  Dalshop
//
//  Created by Hwang Gyuyoung on 2014. 6. 2..
//
//

#import "UserPolicyViewController.h"

#import "Util.h"
#import "ViewUtil.h"

#import "GoogleAnalytics.h"

@interface UserPolicyViewController ()

@end

@implementation UserPolicyViewController

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    // navigation bar
    self.navigationController.navigationBar.tintColor = UIColorFromRGB(BASE_COLOR);
    
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"button_back"] style:UIBarButtonItemStyleBordered target:self action:@selector(cancelButtonTapped:)];
    self.navigationItem.leftBarButtonItem = cancelButton;
    
    
    // text view
    CGFloat textViewOrigin = self.navigationController.navigationBar.frame.origin.y + self.navigationController.navigationBar.frame.size.height;
    CGRect textViewFrame = CGRectMake(0, textViewOrigin, self.view.frame.size.width, self.view.frame.size.height - textViewOrigin);
    self.policyTextView.frame = textViewFrame;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.policyTextView.text = [Util getFileContentWithFileName:self.textFileName];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [ViewUtil setAppDelegatePresentingViewControllerWithViewController:self];
    
    // GA
    [[[GAI sharedInstance] defaultTracker] set:kGAIScreenName value:GAI_SCREEN_NAME_USER_POLIVY_VIEW];
    [[[GAI sharedInstance] defaultTracker] send:[[GAIDictionaryBuilder createAppView] build]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (IBAction)cancelButtonTapped:(id)sender
{
    // GA
    [GAUtil sendGADataWithUIAction:@"go_back" label:@"escape_view" value:nil];

    
    if (self.parentPage == JOIN_VIEW_PAGE) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

@end
