//
//  EventViewController.h
//  Dalshop
//
//  Created by Hwang Gyuyoung on 2014. 6. 17..
//
//

#import <UIKit/UIKit.h>

@interface EventViewController : GAITrackedViewController

@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *mainImageView;
@property (weak, nonatomic) IBOutlet UILabel *messageLabel;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;

@property (nonatomic, strong) UIImage *mainImage;
@property (nonatomic, strong) NSString *message;

- (IBAction)cancelButtonTapped:(id)sender;
- (IBAction)backgroundTapped:(id)sender;

@end
