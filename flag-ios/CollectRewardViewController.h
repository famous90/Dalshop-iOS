//
//  CollectRewardViewController.h
//  Dalshop
//
//  Created by Hwang Gyuyoung on 2014. 5. 27..
//
//

#import <UIKit/UIKit.h>

@class User;

@interface CollectRewardViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@property (weak, nonatomic) IBOutlet UIButton *collectCheckInRewardButton;
@property (weak, nonatomic) IBOutlet UIButton *collectScanRewardButton;

@property (nonatomic, strong) User *user;

- (IBAction)collectCheckInRewardButtonTapped:(id)sender;
- (IBAction)collectScanRewardButtonTapped:(id)sender;
- (IBAction)cancelButtonTapped:(id)sender;
- (IBAction)backgroundTapped:(id)sender;

@end
