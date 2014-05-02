//
//  SideMenuViewController.m
//  flag-ios
//
//  Created by Gyuyoung Hwang on 2014. 4. 11..
//
//

#define MY_REWARD_STATE_SECTION 0
#define MENU_LIST_SECTION       1
#define FOOTER_SECTION          2

#define MY_INFO_ROW 0
#define MY_LIKE_ROW 1
#define MESSAGE_ROW 2
#define SETTING_ROW 3
#define REDEEM_ROW  4
#define INVITE_ROW  5
#define HELP_ROW    6

#import "SideMenuViewController.h"
#import "SWRevealViewController.h"
#import "AppDelegate.h"

#import "User.h"

@interface SideMenuViewController ()

@end

@implementation SideMenuViewController

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    self.tableView.backgroundColor = UIColorFromRGB(0x2a7c8e);
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == MY_REWARD_STATE_SECTION) {
        
        return 1;
        
    }else if (section == MENU_LIST_SECTION){
        
        return 7;
        
    }else if (section == FOOTER_SECTION){
        
        return 1;
        
    }
    else return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == MY_REWARD_STATE_SECTION) {
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
        
        UILabel *myLevelLabel = (UILabel *)[cell viewWithTag:911];
        UILabel *myRewardLabel = (UILabel *)[cell viewWithTag:912];
        
        myLevelLabel.text = [NSString stringWithFormat:@"level. %d", 1];
        myRewardLabel.text = [NSString stringWithFormat:@"'%@'님의 %ld달", @"나", (long)self.user.reward];
        
        [myLevelLabel setTextColor:[UIColor whiteColor]];
        [myRewardLabel setTextColor:[UIColor whiteColor]];
        
        UIImageView *backgroundImageView = [[UIImageView alloc] initWithFrame:CGRectMake(-1, 0, 261.0f, cell.frame.size.height)];
        backgroundImageView.image = [UIImage imageNamed:@"slide_header"];
        [cell addSubview:backgroundImageView];
        [cell sendSubviewToBack:backgroundImageView];
        
        return cell;
        
    }else if (indexPath.section == MENU_LIST_SECTION){
        
//        NSArray *CellIdentifierArray = [[NSArray alloc] initWithObjects:@"MyInfoCell", @"MyLikeCell", @"MessageCell", @"SettingCell", @"RedeemCell", @"InviteCell", @"HelpCell", nil];
        static NSString *CellIdentifier = @"MenuCell";
        NSArray *CellTitleArray = [[NSArray alloc] initWithObjects:@"나의 정보", @"나의 좋아요", @"메세지", @"설정", @"달 사용하기", @"친구초대", @"달샵에게 물어보기", nil];
        NSArray *CellIconImageNameArray = [[NSArray alloc] initWithObjects:@"icon_myInfo", @"icon_myLike", @"icon_message", @"icon_setting", @"icon_redeem", @"icon_invite", @"icon_help", nil];
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
        
        CGFloat cellPadding = 6.0f;
        UIImageView *menuBackgroundImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, cellPadding, cell.frame.size.width, cell.frame.size.height - cellPadding)];
        UIImageView *menuIconImageView = (UIImageView *)[cell viewWithTag:901];
        UILabel *menuTitleLabel = (UILabel *)[cell viewWithTag:902];
        
        menuIconImageView.image = [UIImage imageNamed:[CellIconImageNameArray objectAtIndex:indexPath.row]];
        menuTitleLabel.text = [CellTitleArray objectAtIndex:indexPath.row];
        
        menuBackgroundImageView.backgroundColor = UIColorFromRGBWithAlpha(0xffffff, 0.1f);
        [menuTitleLabel setTextColor:[UIColor whiteColor]];
        [cell setBackgroundColor:UIColorFromRGB(0x2a7c8e)];
        
        [cell addSubview:menuBackgroundImageView];
        return cell;
        
    }else if (indexPath.section == FOOTER_SECTION){
        
        static NSString *CellIdentifier = @"FooterCell";
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
        
        UIImageView *backgroundImageView = [[UIImageView alloc] initWithFrame:CGRectMake(-1.0f, 0, 261.0f, cell.frame.size.height)];
//        [backgroundImageView setContentMode:UIViewContentModeLeft];
        backgroundImageView.image = [UIImage imageNamed:@"slide_footer"];
        
        [cell addSubview:backgroundImageView];
        
        return cell;
    }
    else return nil;
}

#pragma mark - table view delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == MY_REWARD_STATE_SECTION) {
     
        return 159;
        
    }else if (indexPath.section == MENU_LIST_SECTION){
        
        return 43;
        
    }else if (indexPath.section == FOOTER_SECTION){
        
        return 113;
        
    }
    else return 0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == SETTING_ROW) {
        
    }
}

#pragma mark - implementation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue isKindOfClass:[SWRevealViewControllerSegue class]]) {
        SWRevealViewControllerSegue *swSegue = (SWRevealViewControllerSegue *)segue;
        
        swSegue.performBlock = ^(SWRevealViewControllerSegue *rvc_segue, UIViewController *svc, UIViewController *dvc){
            UINavigationController *navController = (UINavigationController *)self.revealViewController.frontViewController;
            [navController setViewControllers:@[dvc] animated:NO];
            [self.revealViewController setFrontViewPosition:FrontViewPositionLeft animated:YES];
        };
    }
}

@end
