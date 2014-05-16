//
//  DidRewardPopupViewController.m
//  flag-ios
//
//  Created by Hwang Gyuyoung on 2014. 5. 7..
//
//

#import "DidRewardPopupViewController.h"

#import "ViewUtil.h"

@interface DidRewardPopupViewController ()

@end

@implementation DidRewardPopupViewController{
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
    mainImageOriginFromBG = 105.0f;
    messageLabelOriginFromBG = 210.0f;
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
    
    self.view.backgroundColor = UIColorFromRGBWithAlpha(BASE_COLOR, 0.3);
    
    [self setContent];
}

- (void)setContent
{
    self.backgroundImageView.backgroundColor = UIColorFromRGBWithAlpha(BASE_COLOR, 0.8f);
    [self.titleLabel setTextColor:[UIColor whiteColor]];
    NSString *rewardType;
//    if (self.type == REWARD_CHECHIN) {
        rewardType = @"CHECH IN";
//    }else if (self.type == REWARD_SCAN){
//        rewardType = @"SCAN";
//    }
    self.messageLabel.text = [NSString stringWithFormat:@"%@ 리워드!\n달이 적립되었습니다 :-)", rewardType];
    [self.messageLabel setTextColor:[UIColor whiteColor]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (IBAction)cancelButtonTapped:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
