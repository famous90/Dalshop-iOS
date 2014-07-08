//
//  CheckInPopUpViewController.h
//  Dalshop
//
//  Created by Hwang Gyuyoung on 2014. 6. 5..
//
//

#import <UIKit/UIKit.h>

@interface CheckInPopUpViewController : GAITrackedViewController

@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;

@property (nonatomic, strong) NSNumber *shopId;
@property (nonatomic, strong) NSString *shopName;
@property (nonatomic, assign) NSInteger reward;

- (IBAction)cancelButtonTapped:(id)sender;
- (IBAction)backgroundTapped:(id)sender;

@end
