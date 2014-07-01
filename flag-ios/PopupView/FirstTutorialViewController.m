//
//  FirstTutorialViewController.m
//  Dalshop
//
//  Created by Hwang Gyuyoung on 2014. 6. 18..
//
//

#import "FirstTutorialViewController.h"

#import "ViewUtil.h"

#import "GoogleAnalytics.h"

@interface FirstTutorialViewController ()

@end

@implementation FirstTutorialViewController

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    [self configureFirstTutorialViewFrame];
}

- (void)configureFirstTutorialViewFrame
{
    UIImage *buttonImage = [UIImage imageNamed:@"tutorial1_button"];
    CGFloat buttonImageWidth = 53.0f;
    CGSize buttonImageSize = CGSizeMake(buttonImageWidth, buttonImage.size.height * buttonImageWidth / buttonImage.size.width);
    
    UIImage *pointImage = [UIImage imageNamed:@"tutorial1_point"];
    CGFloat pointImageWidth = 130.0f;
    CGSize pointImageSize = CGSizeMake(pointImageWidth, pointImage.size.height * pointImageWidth / pointImage.size.width);
    
    UIImage *coffeeImage = [UIImage imageNamed:@"tutorial1_coffee"];
    CGSize coffeeImageSize = CGSizeMake(self.view.frame.size.width/3, coffeeImage.size.height * (self.view.frame.size.width/3) / coffeeImage.size.width);
    
    UIImage *moneyImage = [UIImage imageNamed:@"tutorial1_money"];
    CGSize moneyImageSize = CGSizeMake(35, 35 * moneyImage.size.height / moneyImage.size.width);

    NSString *mainMessageStr = @"달 따서 커피먹자!";
    UIFont *mainMessageFont = [UIFont fontWithName:@"Helvetica-Bold" size:22];
    NSDictionary *mainMessageAttribute = [NSDictionary dictionaryWithObjectsAndKeys:mainMessageFont, NSFontAttributeName, nil];
    CGRect mainMessageFrame = [ViewUtil frameWithString:mainMessageStr inBoundingRect:CGSizeMake(self.view.frame.size.width, 50) attribute:mainMessageAttribute];
    
    NSString *dalDescriptionStr = @"\'달\' = \'돈\'";
    UIFont *dalDescriptionFont = [UIFont fontWithName:@"Helvetica" size:13];
    NSDictionary *dalDescriptionAttribute = [NSDictionary dictionaryWithObjectsAndKeys:dalDescriptionFont, NSFontAttributeName, nil];
    CGRect dalDescriptionFrame = [ViewUtil frameWithString:dalDescriptionStr inBoundingRect:CGSizeMake(self.view.frame.size.width, 30) attribute:dalDescriptionAttribute];
    
    CGFloat framePadding = 8.0f;
    CGFloat centerTotalFrameHeight = coffeeImageSize.height + framePadding + mainMessageFrame.size.height + framePadding + dalDescriptionFrame.size.height + framePadding + moneyImageSize.height;
    CGFloat centerTotalFrameOrigin = (self.view.frame.size.height/2) - (centerTotalFrameHeight/2);
    
    NSString *detailMessageStr = @"내 주위 달이 뜬 가게를 방문하세요 :)\n방문만 해도 달이 쌓여요 :-)";
    UIFont *detailMessageFont = [UIFont fontWithName:@"Helvetica" size:15];
    NSDictionary *detailMessageAttribute = [NSDictionary dictionaryWithObjectsAndKeys:detailMessageFont, NSFontAttributeName, nil];
    CGRect detailMessageFrame = [ViewUtil frameWithString:detailMessageStr inBoundingRect:CGSizeMake(self.view.frame.size.width, 150) attribute:detailMessageAttribute];
    
    
    // BUTTON
    UIImageView *buttonImageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.frame.size.width - 8 - buttonImageSize.width, 30, buttonImageSize.width, buttonImageSize.height)];
    [buttonImageView setImage:buttonImage];
    [self.view addSubview:buttonImageView];
    
    
    // POINT
    UIImageView *pointImageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.frame.size.width - 8 - pointImageSize.width, 15, pointImageSize.width, pointImageSize.height)];
    [pointImageView setImage:pointImage];
    [self.view addSubview:pointImageView];
    
    
    // COFFEE
    UIImageView *coffeeImageView = [[UIImageView alloc] initWithFrame:CGRectMake((self.view.frame.size.width - coffeeImageSize.width)/2, centerTotalFrameOrigin, coffeeImageSize.width, coffeeImageSize.height)];
    [coffeeImageView setImage:coffeeImage];
    [self.view addSubview:coffeeImageView];
    
    
    // MAIN MESSAGE
    UILabel *mainMessageLabel = [[UILabel alloc] initWithFrame:CGRectMake((self.view.frame.size.width - mainMessageFrame.size.width)/2, coffeeImageView.frame.origin.y + coffeeImageView.frame.size.height + framePadding, mainMessageFrame.size.width, mainMessageFrame.size.height)];
    [mainMessageLabel setText:mainMessageStr];
    [mainMessageLabel setTextColor:[UIColor whiteColor]];
    [mainMessageLabel setTextAlignment:NSTextAlignmentCenter];
    [mainMessageLabel setFont:mainMessageFont];
    [self.view addSubview:mainMessageLabel];
    
    
    // DAL DESCRIPTION
    UILabel *dalDeacriptionLabel = [[UILabel alloc] initWithFrame:CGRectMake(mainMessageLabel.frame.origin.x, mainMessageLabel.frame.origin.y + mainMessageLabel.frame.size.height, mainMessageLabel.frame.size.width, dalDescriptionFrame.size.height)];
    [dalDeacriptionLabel setText:dalDescriptionStr];
    [dalDeacriptionLabel setTextColor:[UIColor whiteColor]];
    [dalDeacriptionLabel setTextAlignment:NSTextAlignmentRight];
    [dalDeacriptionLabel setFont:dalDescriptionFont];
    [self.view addSubview:dalDeacriptionLabel];
    
    
    // MONEY
    UIImageView *moneyImageView = [[UIImageView alloc] initWithFrame:CGRectMake((self.view.frame.size.width - moneyImage.size.width)/2, dalDeacriptionLabel.frame.origin.y + framePadding + dalDeacriptionLabel.frame.size.height, moneyImageSize.width, moneyImageSize.height)];
    [moneyImageView setImage:moneyImage];
    [self.view addSubview:moneyImageView];
    
    
    // DEATIL MESSAGE
    UILabel *detailMessageLabel = [[UILabel alloc] initWithFrame:CGRectMake((self.view.frame.size.width - detailMessageFrame.size.width)/2, self.view.frame.size.height * 3/4, detailMessageFrame.size.width, detailMessageFrame.size.height)];
    [detailMessageLabel setText:detailMessageStr];
    [detailMessageLabel setTextColor:[UIColor whiteColor]];
    [detailMessageLabel setTextAlignment:NSTextAlignmentCenter];
    [detailMessageLabel setFont:detailMessageFont];
    [detailMessageLabel setNumberOfLines:0];
    [self.view addSubview:detailMessageLabel];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [ViewUtil setAppDelegatePresentingViewControllerWithViewController:self];
    
    // GA
    [[[GAI sharedInstance] defaultTracker] set:kGAIScreenName value:GAI_SCREEN_NAME_TUTORIAL_VIEW];
    [[[GAI sharedInstance] defaultTracker] send:[[GAIDictionaryBuilder createAppView] build]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


- (IBAction)backgroundTapped:(id)sender
{
    // GA
    [GAUtil sendGADataWithUIAction:@"go_back" label:@"escape_view" value:nil];

    
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
