//
//  EventViewController.m
//  Dalshop
//
//  Created by Hwang Gyuyoung on 2014. 6. 17..
//
//

#import "EventViewController.h"

#import "ViewUtil.h"

#import "GoogleAnalytics.h"

@interface EventViewController ()

@end

@implementation EventViewController{
    CGFloat titleLabelOriginFromBG;
    CGFloat mainImageOriginFromBG;
    CGFloat messageLabelOriginFromBG;
    CGFloat cancelButtonOriginFromBG;
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    [self configureContentFrame];
}

- (void)configureContentFrame
{
    titleLabelOriginFromBG = 50.0f;
    mainImageOriginFromBG = 96.0f;
    messageLabelOriginFromBG = 294.0f;
    cancelButtonOriginFromBG = 20.0f;
    
    self.backgroundImageView.frame = CGRectMake(self.backgroundImageView.frame.origin.x, (self.view.frame.size.height - self.backgroundImageView.frame.size.height)/2,  self.backgroundImageView.frame.size.width, self.backgroundImageView.frame.size.height);
    CGFloat backgroundViewOrigin = self.backgroundImageView.frame.origin.y;
    self.titleLabel.frame = CGRectMake(self.titleLabel.frame.origin.x, backgroundViewOrigin + titleLabelOriginFromBG, self.titleLabel.frame.size.width, self.titleLabel.frame.size.height);
    self.mainImageView.frame = CGRectMake(self.mainImageView.frame.origin.x, backgroundViewOrigin + mainImageOriginFromBG, self.mainImageView.frame.size.width, self.mainImageView.frame.size.height);
    self.messageLabel.frame = CGRectMake(self.messageLabel.frame.origin.x, backgroundViewOrigin + messageLabelOriginFromBG, self.messageLabel.frame.size.width, self.messageLabel.frame.size.height);
    self.cancelButton.frame = CGRectMake(self.cancelButton.frame.origin.x, backgroundViewOrigin + cancelButtonOriginFromBG, self.cancelButton.frame.size.width, self.cancelButton.frame.size.height);
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self configureContent];
    
    
    // Analytics
    [self setScreenName:GAI_SCREEN_NAME_EVENT_POPUP_VIEW];
    [DaLogClient sendDaLogWithCategory:CATEGORY_VIEW_APPEAR target:VIEW_POPUP value:0];
}

- (void)configureContent
{
    self.backgroundImageView.backgroundColor = UIColorFromRGBWithAlpha(0xEB6468, 0.7f);
    [self.titleLabel setTextColor:[UIColor whiteColor]];
    [self.mainImageView setImage:self.mainImage];
    [self.messageLabel setText:self.message];
    [self.messageLabel setTextColor:[UIColor whiteColor]];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (IBAction)cancelButtonTapped:(id)sender
{
    // GA
    [GAUtil sendGADataWithUIAction:@"go_back" label:@"escape_view" value:nil];
    [DaLogClient sendDaLogWithCategory:CATEGORY_VIEW_DISAPPEAR target:VIEW_POPUP value:0];

    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)backgroundTapped:(id)sender
{
    // GA
    [GAUtil sendGADataWithUIAction:@"go_back" label:@"escape_view" value:nil];
    [DaLogClient sendDaLogWithCategory:CATEGORY_VIEW_DISAPPEAR target:VIEW_POPUP value:0];

    
    [self dismissViewControllerAnimated:NO completion:nil];
}
@end
