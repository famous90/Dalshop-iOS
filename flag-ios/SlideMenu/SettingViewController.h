//
//  SettingViewController.h
//  flag-ios
//
//  Created by Hwang Gyuyoung on 2014. 5. 3..
//
//

#import <UIKit/UIKit.h>

@class User;

@interface SettingViewController : UITableViewController <UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *currentVersionLabel;
@property (weak, nonatomic) IBOutlet UILabel *newestVersionLabel;

@property (weak, nonatomic) IBOutlet UISwitch *pushSoundSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *pushVibrationSwitch;

@property (nonatomic, strong) User *user;

- (IBAction)pushSoundSwitchTapped:(id)sender;
- (IBAction)pushVibrationSwitchTapped:(id)sender;

@end
