//
//  VersionInfoViewController.h
//  flag-ios
//
//  Created by Gyuyoung Hwang on 2014. 3. 3..
//
//

#import <UIKit/UIKit.h>

@interface VersionInfoViewController : UITableViewController

@property (weak, nonatomic) IBOutlet UILabel *currentVersionLabel;
@property (weak, nonatomic) IBOutlet UILabel *newestVersionLabel;

@end
