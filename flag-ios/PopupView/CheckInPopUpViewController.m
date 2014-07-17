//
//  CheckInPopUpViewController.m
//  Dalshop
//
//  Created by Hwang Gyuyoung on 2014. 6. 5..
//
//

#import "CheckInPopUpViewController.h"

#import "ViewUtil.h"

#import "GoogleAnalytics.h"

@interface CheckInPopUpViewController ()

@end

@implementation CheckInPopUpViewController{
    CGFloat titleLabelOriginFromBG;
    CGFloat iconImageOriginFromBG;
    CGFloat descriptionLabelOriginFromBG;
    CGFloat cancelButtonOriginFromBG;
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    [self setContentFrame];
}

- (void)setContentFrame
{
    titleLabelOriginFromBG = 50.0f;
    iconImageOriginFromBG = 105.0f;
    descriptionLabelOriginFromBG = 210.0f;
    cancelButtonOriginFromBG = 20.0f;
    
    self.backgroundImageView.backgroundColor = UIColorFromRGB(BASE_COLOR);
    [self.titleLabel setTextColor:[UIColor whiteColor]];
    [self.descriptionLabel setTextColor:[UIColor whiteColor]];
    
    self.backgroundImageView.frame = CGRectMake(self.backgroundImageView.frame.origin.x, (self.view.frame.size.height - self.backgroundImageView.frame.size.height)/2,  self.backgroundImageView.frame.size.width, self.backgroundImageView.frame.size.height);
    CGFloat backgroundViewOrigin = self.backgroundImageView.frame.origin.y;
    self.titleLabel.frame = CGRectMake(self.titleLabel.frame.origin.x, backgroundViewOrigin + titleLabelOriginFromBG, self.titleLabel.frame.size.width, self.titleLabel.frame.size.height);
    self.iconImageView.frame = CGRectMake(self.iconImageView.frame.origin.x, backgroundViewOrigin + iconImageOriginFromBG, self.iconImageView.frame.size.width, self.iconImageView.frame.size.height);
    self.descriptionLabel.frame = CGRectMake(self.descriptionLabel.frame.origin.x, backgroundViewOrigin + descriptionLabelOriginFromBG, self.descriptionLabel.frame.size.width, self.descriptionLabel.frame.size.height);
    self.cancelButton.frame = CGRectMake(self.cancelButton.frame.origin.x, backgroundViewOrigin + cancelButtonOriginFromBG, self.cancelButton.frame.size.width, self.cancelButton.frame.size.height);
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setContent];
    
    
    // Analytics
    [self setScreenName:GAI_SCREEN_NAME_CHECKIN_POPUP_VIEW];
    [DaLogClient sendDaLogWithCategory:CATEGORY_VIEW_APPEAR target:VIEW_POPUP value:0];
}

- (void)setContent
{
    self.descriptionLabel.text = [NSString stringWithFormat:@"CHECK IN 리워드!\n%ld달이 적립되었습니다 :-)", (long)self.reward];
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
    // Analytics
    [GAUtil sendGADataWithUIAction:@"go_back" label:@"escape_view" value:nil];
    [DaLogClient sendDaLogWithCategory:CATEGORY_VIEW_DISAPPEAR target:VIEW_POPUP value:0];

    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)backgroundTapped:(id)sender
{
    // GA
    [GAUtil sendGADataWithUIAction:@"go_back" label:@"escape_view" value:nil];
    [DaLogClient sendDaLogWithCategory:CATEGORY_VIEW_DISAPPEAR target:VIEW_POPUP value:0];

    
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
