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

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    CGFloat viewHeight = [ViewUtil getIOSDeviceScreenHeight];
    UIImage *launchImage;
    
    if (viewHeight == ScreenHeightForiPhone35) {
        launchImage = [UIImage imageNamed:@"launchImage"];
    }else if (viewHeight == ScreenHeightForiPhone4){
        launchImage = [UIImage imageNamed:@"launchImage-568h"];
    }
    
    UIImageView *launchImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    launchImageView.image = launchImage;
    [self.view addSubview:launchImageView];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
