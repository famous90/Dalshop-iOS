//
//  EventPopupViewController.m
//  flag-ios
//
//  Created by Hwang Gyuyoung on 2014. 5. 7..
//
//

#import "EventPopupViewController.h"

@interface EventPopupViewController ()

@end

@implementation EventPopupViewController{
    CGFloat titleLabelOriginFromBG;
    CGFloat mainImageOriginFromBG;
    CGFloat messageLabelOriginFromBG;
    CGFloat cancelButtonOriginFromBG;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    titleLabelOriginFromBG = 50.0f;
    mainImageOriginFromBG = 96.0f;
    messageLabelOriginFromBG = 294.0f;
    cancelButtonOriginFromBG = 20.0f;
    
    [self setContentFrame];
}

- (void)setContentFrame
{
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
    // Do any additional setup after loading the view from its nib.
}

- (void)setContent
{
    self.backgroundImageView.backgroundColor = UIColorFromRGBWithAlpha(0xEB6468, 0.7f);
    [self.titleLabel setTextColor:[UIColor whiteColor]];
    self.mainImageView.image = self.eventImage;
    self.messageLabel.text = self.eventMessage;
    [self.messageLabel setTextColor:[UIColor whiteColor]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)cancelButtonTapped:(id)sender
{
//    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
