//
//  MyInfoViewController.h
//  flag-ios
//
//  Created by Hwang Gyuyoung on 2014. 5. 8..
//
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "AbstractActionSheetPicker.h"
#import "ActionSheetStringPicker.h"

@class User;
@class AbstractActionSheetPicker;

@interface MyInfoViewController : UIViewController<UIActionSheetDelegate, CLLocationManagerDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *lineImageView1;
@property (weak, nonatomic) IBOutlet UIImageView *lineImageView2;
@property (weak, nonatomic) IBOutlet UIImageView *lineImageView3;
@property (weak, nonatomic) IBOutlet UIImageView *lineImageView4;
@property (weak, nonatomic) IBOutlet UIButton *manButton;
@property (weak, nonatomic) IBOutlet UIButton *womanButton;
@property (weak, nonatomic) IBOutlet UIButton *birthYearButton;
@property (weak, nonatomic) IBOutlet UIButton *occupationButton;
@property (weak, nonatomic) IBOutlet UIButton *saveButton;

// picker
@property (nonatomic, strong) AbstractActionSheetPicker *picker;

@property (nonatomic, strong) User *user;

- (IBAction)manButtonTapped:(id)sender;
- (IBAction)womanButtonTapped:(id)sender;
- (IBAction)birthYearButtonTapped:(id)sender;
- (IBAction)occupationButtonTapped:(id)sender;
- (IBAction)saveButtonTapped:(id)sender;

- (IBAction)occupationPickerButtonTapped:(UIBarButtonItem *)sender;
- (IBAction)birthYearPickerButtonTapped:(UIBarButtonItem *)sender;

@end
