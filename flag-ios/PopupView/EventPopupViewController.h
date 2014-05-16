//
//  EventPopupViewController.h
//  flag-ios
//
//  Created by Hwang Gyuyoung on 2014. 5. 7..
//
//

#import <UIKit/UIKit.h>

@interface EventPopupViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *mainImageView;
@property (weak, nonatomic) IBOutlet UILabel *messageLabel;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;

@property (nonatomic, strong) UIImage *eventImage;
@property (nonatomic, strong) NSString *eventMessage;

- (IBAction)cancelButtonTapped:(id)sender;

@end
