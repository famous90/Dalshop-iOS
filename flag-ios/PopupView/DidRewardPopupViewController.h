//
//  DidRewardPopupViewController.h
//  flag-ios
//
//  Created by Hwang Gyuyoung on 2014. 5. 7..
//
//

#import <UIKit/UIKit.h>

@interface DidRewardPopupViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property (weak, nonatomic) IBOutlet UIImageView *mainImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *messageLabel;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;

@property (nonatomic, assign) NSInteger type;
@property (nonatomic, assign) NSInteger reward;

- (IBAction)cancelButtonTapped:(id)sender;
@end
