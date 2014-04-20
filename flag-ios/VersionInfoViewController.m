//
//  VersionInfoViewController.m
//  flag-ios
//
//  Created by Gyuyoung Hwang on 2014. 3. 3..
//
//

#define CURRENT_VERSION_ROW 0
#define NEWEST_VERSION_ROW  1

#import "VersionInfoViewController.h"

@interface VersionInfoViewController ()

@end

@implementation VersionInfoViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.currentVersionLabel.text = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
    self.newestVersionLabel.text = @"1.0.1";
}

@end
