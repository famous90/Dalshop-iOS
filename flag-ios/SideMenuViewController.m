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

#define MY_REWARD_STATE_ROW     0
#define LOGIN_REGISTER_ROW      1

#define MY_INFO_ROW 0
#define MY_LIKE_ROW 1
#define REDEEM_ROW  2
#define MESSAGE_ROW 3
#define INVITE_ROW  4
#define SETTING_ROW 5
#define HELP_ROW    6

#import "SideMenuViewController.h"
#import "SWRevealViewController.h"
#import "AppDelegate.h"
#import "ItemListViewController.h"
#import "HelpViewController.h"
#import "SettingViewController.h"
#import "MyInfoViewController.h"
#import "LoginViewController.h"
#import "JoinViewController.h"

#import "User.h"

#import "Util.h"
#import "ViewUtil.h"
#import "SNSUtil.h"

#import <KakaoOpenSDK/KakaoOpenSDK.h>

@interface SideMenuViewController ()

@property (nonatomic, retain) NSMutableDictionary *kakaoTalkLinkObjects;

@end

@implementation SideMenuViewController{
    NSArray *menuTableCell;
    
    CGFloat menuCellHeight;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.kakaoTalkLinkObjects = [[NSMutableDictionary alloc] init];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    self.tableView.backgroundColor = UIColorFromRGB(0x2a7c8e);
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    menuCellHeight = 43.0f;
    [self setMenuTableViewCell];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setMenuTableViewCell
{
    NSDictionary *dic1 = [[NSDictionary alloc] initWithObjectsAndKeys:@"MyInfoCell", @"CellIdentifier", @"나의 정보", @"title", @"icon_myInfo", @"iconImage", nil];
    NSDictionary *dic2 = [[NSDictionary alloc] initWithObjectsAndKeys:@"MyLikeCell", @"CellIdentifier", @"나의 좋아요", @"title", @"icon_myLike", @"iconImage", nil];
    NSDictionary *dic3 = [[NSDictionary alloc] initWithObjectsAndKeys:@"RedeemCell", @"CellIdentifier", @"달 사용하기", @"title", @"icon_redeem", @"iconImage", nil];
    NSDictionary *dic4 = [[NSDictionary alloc] initWithObjectsAndKeys:@"MessageCell", @"CellIdentifier", @"메세지", @"title", @"icon_message", @"iconImage", nil];
    NSDictionary *dic5 = [[NSDictionary alloc] initWithObjectsAndKeys:@"InviteCell", @"CellIdentifier", @"친구초대", @"title", @"icon_invite", @"iconImage", nil];
    NSDictionary *dic6 = [[NSDictionary alloc] initWithObjectsAndKeys:@"SettingCell", @"CellIdentifier", @"설정", @"title", @"icon_setting", @"iconImage", nil];
    NSDictionary *dic7 = [[NSDictionary alloc] initWithObjectsAndKeys:@"HelpCell", @"CellIdentifier", @"달샵에게 물어보기", @"title", @"icon_help", @"iconImage", nil];
    
    menuTableCell = [[NSArray alloc] initWithObjects:dic1, dic2, dic3, dic4, dic5, dic6, dic7, nil];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == MY_REWARD_STATE_SECTION) {

        if (self.user.registered) {
            return 1;
        }else{
            return 2;
        }
        
    }else if (section == MENU_LIST_SECTION){
        
        return [menuTableCell count];
        
    }else if (section == FOOTER_SECTION){
        
        return 1;
        
    }
    else return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == MY_REWARD_STATE_SECTION) {
        
        if (indexPath.row == MY_REWARD_STATE_ROW) {
            
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
            
            UILabel *myLevelLabel = (UILabel *)[cell viewWithTag:911];
            UILabel *myRewardLabel = (UILabel *)[cell viewWithTag:912];
            NSString *userType = nil;
            if (self.user.registered) {
                userType = @"나";
            }else{
                userType = @"guest";
            }
            
            [myLevelLabel setHidden:YES];
            myLevelLabel.text = [NSString stringWithFormat:@"level. %d", 1];
            
            myRewardLabel.text = [NSString stringWithFormat:@"%@의 %ld달", userType, (long)self.user.reward];
            
            [myLevelLabel setTextColor:[UIColor whiteColor]];
            [myRewardLabel setTextColor:[UIColor whiteColor]];
            
            
            // background image
            UIImageView *backgroundImageView = [[UIImageView alloc] initWithFrame:CGRectMake(-1, 0, 261.0f, cell.frame.size.height)];
            backgroundImageView.image = [UIImage imageNamed:@"slide_header"];
            [cell addSubview:backgroundImageView];
            [cell sendSubviewToBack:backgroundImageView];
            
            
            // selection style
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            
            return cell;
            
        }else if (indexPath.row == LOGIN_REGISTER_ROW){
            
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LoginRegisterCell" forIndexPath:indexPath];
            
            
            CGFloat lineSpace = 3.0f;
            CGFloat buttonWidth = 130.0f;
            
            cell.backgroundColor = UIColorFromRGB(0x2a7c8e);
            
            
            // login button
            UIButton *loginButton = [[UIButton alloc] initWithFrame:CGRectMake(0, lineSpace, buttonWidth, cell.frame.size.height - lineSpace*2)];
            [loginButton addTarget:self action:@selector(loginButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
            loginButton.backgroundColor = [UIColor colorWithWhite:1 alpha:0.2];
            [loginButton setTitle:@"로그인" forState:UIControlStateNormal];
            [loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [cell addSubview:loginButton];
            
            
            // line
            UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(loginButton.frame.size.width, lineSpace, 1.0f, cell
                                                                        .frame.size.height - lineSpace*2)];
            lineView.backgroundColor = [UIColor colorWithWhite:1 alpha:0.5];
            [cell addSubview:lineView];
            
            
            // register button
            UIButton *registerButton = [[UIButton alloc] initWithFrame:CGRectMake(lineView.frame.origin.x + lineView.frame.size.width, lineSpace, buttonWidth, cell.frame.size.height - lineSpace*2)];
            [registerButton addTarget:self action:@selector(registerButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
            registerButton.backgroundColor = [UIColor colorWithWhite:1 alpha:0.2];
            [registerButton setTitle:@"회원가입" forState:UIControlStateNormal];
            [registerButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [cell addSubview:registerButton];
            
            
            return cell;
            
        }else return nil;
        
    }else if (indexPath.section == MENU_LIST_SECTION){
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[[menuTableCell objectAtIndex:indexPath.row] valueForKey:@"CellIdentifier"] forIndexPath:indexPath];
        
        
        // cell background color
        [cell setBackgroundColor:UIColorFromRGB(0x2a7c8e)];

        
        // cell customize
        CGFloat lineSpace = 3.0f;
        CGFloat cellPadding = 30.0f;
        
        CGFloat iconImageHeight = 15.0f;
        CGFloat titleLabelHeight = 20.0f;
        CGFloat titleLabelWidth = 260 - (cellPadding + iconImageHeight + cellPadding + iconImageHeight + cellPadding);
        
        UIImageView *menuIconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(cellPadding, (menuCellHeight - iconImageHeight)/2, iconImageHeight, iconImageHeight)];
        [menuIconImageView setContentMode:UIViewContentModeScaleAspectFit];
        menuIconImageView.image = [UIImage imageNamed:[[menuTableCell objectAtIndex:indexPath.row] valueForKey:@"iconImage"]];
        [cell addSubview:menuIconImageView];
        
        UILabel *menuTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(menuIconImageView.frame.origin.x + menuIconImageView.frame.size.width + cellPadding, (menuCellHeight - titleLabelHeight)/2, titleLabelWidth, titleLabelHeight)];
        [menuTitleLabel setText:[[menuTableCell objectAtIndex:indexPath.row] valueForKey:@"title"]];
        [menuTitleLabel setFont:[UIFont fontWithName:@"system" size:15]];
        [menuTitleLabel setTextColor:[UIColor whiteColor]];
        [cell addSubview:menuTitleLabel];
        
        UIImageView *indicatorImageView = [[UIImageView alloc] initWithFrame:CGRectMake(260 - cellPadding - iconImageHeight, (menuCellHeight - iconImageHeight)/2, iconImageHeight, iconImageHeight)];
        indicatorImageView.image = [UIImage imageNamed:@"button_front"];
        [cell addSubview:indicatorImageView];

        
        // cell background image
        UIImageView *menuBackgroundImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, lineSpace, cell.frame.size.width, cell.frame.size.height - lineSpace*2)];
        menuBackgroundImageView.backgroundColor = UIColorFromRGBWithAlpha(0xffffff, 0.1f);
        [cell addSubview:menuBackgroundImageView];
        
        
        // selection view
        UIView *bgColorView = [[UIView alloc] init];
        bgColorView.backgroundColor = UIColorFromRGB(BASE_COLOR);
        [cell setSelectedBackgroundView:bgColorView];
        
        return cell;
        
    }else if (indexPath.section == FOOTER_SECTION){
        
        static NSString *CellIdentifier = @"FooterCell";
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
        
        
        // background image
        UIImageView *backgroundImageView = [[UIImageView alloc] initWithFrame:CGRectMake(-1.0f, 0, 261.0f, cell.frame.size.height)];
        backgroundImageView.image = [UIImage imageNamed:@"slide_footer"];
        [cell addSubview:backgroundImageView];
        
        
        // selection style
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        return cell;
    }
    else return nil;
}

#pragma mark - table view delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == MY_REWARD_STATE_SECTION) {
     
        if (indexPath.row == MY_REWARD_STATE_ROW) {
        
            return 159;
            
        }else if (indexPath.row == LOGIN_REGISTER_ROW){
            
            return menuCellHeight;
            
        }
        else return 0;
        
    }else if (indexPath.section == MENU_LIST_SECTION){
        
        return menuCellHeight;
        
    }else if (indexPath.section == FOOTER_SECTION){
        
        return 113;
        
    }
    else return 0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"section %ld, row %ld", (long)indexPath.section, (long)indexPath.row);
    
    UIStoryboard *storyboard = [ViewUtil getStoryboard];
    
    if (indexPath.section == MY_REWARD_STATE_SECTION) {
        
        NSLog(@"my reward state section");
        
        return;
    }
    
    switch (indexPath.row) {
        case MY_INFO_ROW:{
            
            UINavigationController *navController = (UINavigationController *)[storyboard instantiateViewControllerWithIdentifier:@"MyInfoViewNav"];
            MyInfoViewController *childViewController = (MyInfoViewController *)[navController topViewController];
            childViewController.user = self.user;
            
            [navController.navigationBar setTintColor:UIColorFromRGB(BASE_COLOR)];
            
            [self presentViewController:navController animated:YES completion:nil];
            
            break;
        }
        
        case MY_LIKE_ROW:{
            
            UINavigationController *navController = (UINavigationController *)[storyboard instantiateViewControllerWithIdentifier:@"ItemListViewNav"];
            ItemListViewController *childViewController = (ItemListViewController *)[navController topViewController];
            childViewController.user = self.user;
            childViewController.parentPage = SLIDE_MENU_PAGE;
            
            [navController.navigationBar setTintColor:UIColorFromRGB(BASE_COLOR)];
            
            [self presentViewController:navController animated:YES completion:nil];

            break;
        }
            
        case REDEEM_ROW:{
            break;
        }
            
        case MESSAGE_ROW:{
            break;
        }
            
        case INVITE_ROW:{
            
            [self inviteFriendByKakaoTalk];
            break;
        }
            
        case HELP_ROW:{
            
            UINavigationController *navController = (UINavigationController *)[storyboard instantiateViewControllerWithIdentifier:@"HelpViewNav"];
            HelpViewController *childViewController = (HelpViewController *)[navController topViewController];
            childViewController.user = self.user;
            
            [navController.navigationBar setTintColor:UIColorFromRGB(BASE_COLOR)];
            
            [self presentViewController:navController animated:YES completion:nil];
            
            break;
        }
            
        case SETTING_ROW:{
            
            UINavigationController *navController = (UINavigationController *)[storyboard instantiateViewControllerWithIdentifier:@"SettingViewNav"];
            SettingViewController *childViewController = (SettingViewController *)[navController topViewController];
            childViewController.user = self.user;
            
            [navController.navigationBar setTintColor:UIColorFromRGB(BASE_COLOR)];
            
            [self presentViewController:navController animated:YES completion:nil];
            
            break;
        }
            
        default:{
            break;
        }
    }

}

#pragma mark - implementation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
//    UIStoryboard *storyboard = [ViewUtil getStoryboard];
//    UINavigationController *navController;
//    
//    if ([[segue identifier] isEqualToString:@"ShowMyLikeItem"]) {
//        navController = (UINavigationController *)[segue destinationViewController];
//        ItemListViewController *childViewController = (ItemListViewController *)[navController topViewController];
//        childViewController.user = self.user;
//        childViewController.parentPage = SLIDE_MENU_PAGE;
//        [self showMyLikeItemsWithNav:navController inStoryboard:storyboard];
//    }
    if ([segue isKindOfClass:[SWRevealViewControllerSegue class]]) {
        SWRevealViewControllerSegue *swSegue = (SWRevealViewControllerSegue *)segue;
        
        swSegue.performBlock = ^(SWRevealViewControllerSegue *rvc_segue, UIViewController *svc, UIViewController *dvc){
            UINavigationController *navController = (UINavigationController *)self.revealViewController.frontViewController;
            [navController setViewControllers:@[dvc] animated:NO];
            [self.revealViewController setFrontViewPosition:FrontViewPositionLeft animated:YES];
        };
    }
}


#pragma mark - 
#pragma mark kakaoTalk link

- (void)inviteFriendByKakaoTalk
{
    [SNSUtil makeKakaoTalkLinkToKakaoTalkLinkObjects:self.kakaoTalkLinkObjects message:@"달샵을 이용해 쇼핑에 즐거움을 더하세요" imageURL:@"https://fbcdn-sphotos-f-a.akamaihd.net/hphotos-ak-prn2/t1.0-9/10262117_639256986165999_4859364690509549062_n.png" imageWidth:138 Height:138 execParameter:nil];
    [SNSUtil sendKakaoTalkLinkByKakaoTalkLinkObjects:self.kakaoTalkLinkObjects];
}

#pragma mark - 
#pragma mark IBAction
- (IBAction)loginButtonTapped:(id)sender
{
    UIStoryboard *storyboard = [ViewUtil getStoryboard];
    LoginViewController *childViewController = [storyboard instantiateViewControllerWithIdentifier:@"LoginView"];
    
    childViewController.user = self.user;
    childViewController.parentPage = SLIDE_MENU_PAGE;
    
    [self presentViewController:childViewController animated:YES completion:nil];
}

- (IBAction)registerButtonTapped:(id)sender
{
    UIStoryboard *storyboard = [ViewUtil getStoryboard];
    JoinViewController *childViewController = [storyboard instantiateViewControllerWithIdentifier:@"JoinView"];
    
    childViewController.user = self.user;
    childViewController.parentPage = SLIDE_MENU_PAGE;
    
    [self presentViewController:childViewController animated:YES completion:nil];
}
@end
