//
//  LaunchImageViewController.m
//  Dalshop
//
//  Created by Hwang Gyuyoung on 2014. 5. 13..
//
//

#import "LaunchImageViewController.h"

#import "ViewUtil.h"

@interface LaunchImageViewController ()

@end

@implementation LaunchImageViewController

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    CGFloat viewHeight = [ViewUtil getIOSDeviceScreenHeight];
    UIImage *launchImage;
    
    if (viewHeight == ScreenHeightForiPhone35) {
        launchImage = [UIImage imageNamed:@"LaunchImage"];
    }else if (viewHeight == ScreenHeightForiPhone4){
        launchImage = [UIImage imageNamed:@"LaunchImage-568h"];
    }
    
    UIImageView *launchImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    launchImageView.image = launchImage;
    [self.view addSubview:launchImageView];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
