//
//  SideMenuViewController.m
//  flag-ios
//
//  Created by Gyuyoung Hwang on 2014. 4. 11..
//
//

#define LOGIN_STATE_SECTION 0
#define MENU_LIST_SECTION       1

//#define MY_REWARD_STATE_ROW     0
#define LOGIN_REGISTER_ROW      0

#define MY_INFO_ROW 0
#define MY_LIKE_ROW 1
//#define REDEEM_ROW  2
#define MESSAGE_ROW 2
#define INVITE_ROW  3
#define SETTING_ROW 4
#define HELP_ROW    5

#import "SideMenuViewController.h"
#import "SWRevealViewController.h"
#import "AppDelegate.h"
#import "ItemListViewController.h"
#import "HelpViewController.h"
#import "SettingViewController.h"
#import "MyInfoViewController.h"
#import "LoginViewController.h"
#import "JoinViewController.h"
#import "RedeemViewController.h"

#import "User.h"

#import "Util.h"
#import "ViewUtil.h"
#import "SNSUtil.h"
#import "DataUtil.h"

#import <KakaoOpenSDK/KakaoOpenSDK.h>

@interface SideMenuViewController ()

@property (nonatomic, retain) NSMutableDictionary *kakaoTalkLinkObjects;

@end

@implementation SideMenuViewController{
    NSArray *menuTableCell;
    
    CGFloat menuSlideVisibleWidth;
    CGFloat menuCellHeight;
    CGFloat menuHeaderImagePadding;
    CGFloat menuHeaderHeight;
    CGFloat menuFooterHeight;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.kakaoTalkLinkObjects = [[NSMutableDictionary alloc] init];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    self.tableView.backgroundColor = [UIColor whiteColor];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initializeMenuTableViewCell];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self setUser:[DelegateUtil getUser]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initializeMenuTableViewCell
{
    menuSlideVisibleWidth = 261.0f;
    menuCellHeight = 43.0f;
    menuHeaderImagePadding = 36.0f;
    menuHeaderHeight = 103.0f;
    menuFooterHeight = 150.0f;

    NSDictionary *dic1 = [[NSDictionary alloc] initWithObjectsAndKeys:@"MyInfoCell", @"CellIdentifier", @"나의 정보", @"title", @"icon_myInfo", @"iconImage", nil];
    NSDictionary *dic2 = [[NSDictionary alloc] initWithObjectsAndKeys:@"MyLikeCell", @"CellIdentifier", @"나의 좋아요", @"title", @"icon_myLike", @"iconImage", nil];
//    NSDictionary *dic3 = [[NSDictionary alloc] initWithObjectsAndKeys:@"RedeemCell", @"CellIdentifier", @"달 사용하기", @"title", @"icon_redeem", @"iconImage", nil];
    NSDictionary *dic4 = [[NSDictionary alloc] initWithObjectsAndKeys:@"MessageCell", @"CellIdentifier", @"메세지", @"title", @"icon_message", @"iconImage", nil];
    NSDictionary *dic5 = [[NSDictionary alloc] initWithObjectsAndKeys:@"InviteCell", @"CellIdentifier", @"친구초대", @"title", @"icon_invite", @"iconImage", nil];
    NSDictionary *dic6 = [[NSDictionary alloc] initWithObjectsAndKeys:@"SettingCell", @"CellIdentifier", @"설정", @"title", @"icon_setting", @"iconImage", nil];
    NSDictionary *dic7 = [[NSDictionary alloc] initWithObjectsAndKeys:@"HelpCell", @"CellIdentifier", @"달샵에게 물어보기", @"title", @"icon_help", @"iconImage", nil];
    
    menuTableCell = [[NSArray alloc] initWithObjects:dic1, dic2, dic4, dic5, dic6, dic7, nil];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == LOGIN_STATE_SECTION) {

        return 1;
//        if (self.user.registered) {
//            return 1;
//        }else{
//            return 2;
//        }
        
    }else if (section == MENU_LIST_SECTION){
        
        return [menuTableCell count];
        
    }else return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == LOGIN_STATE_SECTION) {
        
        if (indexPath.row == LOGIN_REGISTER_ROW){
            
            NSString *CellIdentifier = @"LoginRegisterCell";
            UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            
            
            CGFloat buttonPadding = 18.0f;
            CGFloat buttonWidth = 104.0f;
            CGFloat buttonHeight = 21.0f;
            UIFont *buttonFont = [UIFont boldSystemFontOfSize:12];
            
            
            // login button
            UIButton *loginButton = [[UIButton alloc] initWithFrame:CGRectMake(buttonPadding, 0, buttonWidth, buttonHeight)];
            [loginButton setBackgroundColor:UIColorFromRGB(0xeb6468)];
            [loginButton setTitle:@"로그인" forState:UIControlStateNormal];
            [loginButton.titleLabel setFont:buttonFont];
            [loginButton addTarget:self action:@selector(loginButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
            [loginButton.layer setCornerRadius:10];
            [cell addSubview:loginButton];
            [loginButton setHidden:self.user.registered];
            
            
            // register button
            UIButton *registerButton = [[UIButton alloc] initWithFrame:CGRectMake(menuSlideVisibleWidth - buttonPadding - buttonWidth, 0, buttonWidth, buttonHeight)];
            [registerButton addTarget:self action:@selector(registerButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
            [registerButton setBackgroundColor:UIColorFromRGB(0xb94c52)];
            [registerButton setTitle:@"회원가입" forState:UIControlStateNormal];
            [registerButton.titleLabel setFont:buttonFont];
            [registerButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [registerButton.layer setCornerRadius:10];
            [cell addSubview:registerButton];
            [registerButton setHidden:self.user.registered];
            
            
            // point button
            UIImage *pointButtonBackgroundImage = [UIImage imageNamed:@"bg_point"];
            CGFloat pointButtonWidth = [ViewUtil getMagnifiedImageWidthWithImage:pointButtonBackgroundImage height:buttonHeight];
            UIButton *pointButton = [[UIButton alloc] initWithFrame:CGRectMake(menuSlideVisibleWidth - buttonPadding - pointButtonWidth, 0, pointButtonWidth, buttonHeight)];
            [pointButton setBackgroundImage:pointButtonBackgroundImage forState:UIControlStateNormal];
            [pointButton setTitle:[NSString stringWithFormat:@"%ld달", (long)self.user.reward]    forState:UIControlStateNormal];
            [pointButton.titleLabel setFont:buttonFont];
            [pointButton.titleLabel setTextAlignment:NSTextAlignmentRight];
            [pointButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [cell addSubview:pointButton];
            [pointButton setHidden:!self.user.registered];
            
            NSLog(@"registered %d", self.user.registered);
            
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            
            return cell;
            
        }else return nil;
        
    }else if (indexPath.section == MENU_LIST_SECTION){
        
//        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: forIndexPath:indexPath];
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[[menuTableCell objectAtIndex:indexPath.row] valueForKey:@"CellIdentifier"]];
        
        
        // cell background color
        [cell setBackgroundColor:[UIColor whiteColor]];

        
        // cell customize
//        CGFloat lineSpace = 3.0f;
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
        [menuTitleLabel setTextColor:UIColorFromRGB(BASE_COLOR)];
        [cell addSubview:menuTitleLabel];
        
        
        // indicator
//        UIImageView *indicatorImageView = [[UIImageView alloc] initWithFrame:CGRectMake(260 - cellPadding - iconImageHeight, (menuCellHeight - iconImageHeight)/2, iconImageHeight, iconImageHeight)];
//        indicatorImageView.image = [UIImage imageNamed:@"button_front"];
//        [cell addSubview:indicatorImageView];

        
        // cell background image
//        UIImageView *menuBackgroundImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, cell.frame.size.width, cell.frame.size.height)];
//        [menuBackgroundImageView setBackgroundColor:[UIColor whiteColor]];
//        [cell addSubview:menuBackgroundImageView];
        
        
        // selection view
        UIView *bgColorView = [[UIView alloc] init];
        bgColorView.backgroundColor = UIColorFromRGBWithAlpha(BASE_COLOR, 0.6);
        [cell setSelectedBackgroundView:bgColorView];

        return cell;
        
    }

    else return nil;
}

#pragma mark - table view delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == LOGIN_STATE_SECTION) {
     
            if (indexPath.row == LOGIN_REGISTER_ROW){
            
            return menuCellHeight;
            
        }
        else return 0;
        
    }else if (indexPath.section == MENU_LIST_SECTION){
        
        return menuCellHeight;
        
    }
    else return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == LOGIN_STATE_SECTION) {
        return menuHeaderHeight;
    }else return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == LOGIN_STATE_SECTION) {
        
        UIView *menuHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, menuHeaderHeight)];
        UIImage *menuHeaderImage = [UIImage imageNamed:@"slide_header"];
        UIImageView *menuHeaderImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, menuHeaderImagePadding, menuSlideVisibleWidth, [ViewUtil getMagnifiedImageHeightWithImage:menuHeaderImage width:menuSlideVisibleWidth])];
        
        [menuHeaderImageView setImage:menuHeaderImage];
        [menuHeaderView addSubview:menuHeaderImageView];
        
        return menuHeaderView;
        
    }return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == LOGIN_STATE_SECTION) {
        return 0;
    }else if (section == MENU_LIST_SECTION){
        return menuFooterHeight;
    }else return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (section == MENU_LIST_SECTION) {
        
        UIView *menuFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, menuFooterHeight)];
        UIImage *menuFooterImage = [UIImage imageNamed:@"slide_footer"];
        CGFloat menuFooterImageHeight = [ViewUtil getMagnifiedImageHeightWithImage:menuFooterImage width:menuSlideVisibleWidth];
        UIImageView *menuFooterImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, menuFooterView.frame.size.height - menuFooterImageHeight, menuSlideVisibleWidth, menuFooterImageHeight)];
        [menuFooterImageView setImage:menuFooterImage];
        [menuFooterView addSubview:menuFooterImageView];
        
        return menuFooterView;
        
    }else return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIStoryboard *storyboard = [ViewUtil getStoryboard];
    
    if (indexPath.section == LOGIN_STATE_SECTION) {
        
        NSLog(@"my reward state section");
        
        return;
    }
    
    switch (indexPath.row) {
        // GA
        [GAUtil sendGADataWithUIAction:[NSString stringWithFormat:@"%@_click", [[menuTableCell objectAtIndex:indexPath.row] valueForKey:@"CellIdentifier"]] label:@"escape_view" value:nil];

            
        case MY_INFO_ROW:{
            
            if (self.user.registered) {
                
                UINavigationController *navController = (UINavigationController *)[storyboard instantiateViewControllerWithIdentifier:@"MyInfoViewNav"];
                MyInfoViewController *childViewController = (MyInfoViewController *)[navController topViewController];
                childViewController.user = self.user;
                childViewController.parentPage = SLIDE_MENU_PAGE;
                
                [navController.navigationBar setTintColor:UIColorFromRGB(BASE_COLOR)];
                
                [self presentViewController:navController animated:YES completion:nil];
                
            }else{
                [Util showAlertView:nil message:@"로그인 후 이용 가능합니다" title:@"나의 정보"];
                [ViewUtil presentLoginViewInView:self withUser:self.user];
            }
            
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
            
//        case REDEEM_ROW:{
//            
//            UINavigationController *navController = (UINavigationController *)[storyboard instantiateViewControllerWithIdentifier:@"RedeemViewNav"];
//            RedeemViewController *childViewController = (RedeemViewController *)[navController topViewController];
//            childViewController.user = self.user;
//            
//            [navController.navigationBar setTintColor:UIColorFromRGB(BASE_COLOR)];
//            
//            [self presentViewController:navController animated:YES completion:nil];
//            
//            break;
//        }
            
        case MESSAGE_ROW:{
            
            [Util showAlertView:nil message:@"서비스 준비 중입니다\n폭풍 야근으로 개발하고 있사오니\n업데이트를 기다려주세요:)" title:@"죄송합니다"];
            [tableView deselectRowAtIndexPath:indexPath animated:NO];
            
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
            [childViewController setParentPage:SLIDE_MENU_PAGE];
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
    NSDictionary *kakaoTalkParams = [[NSDictionary alloc] initWithObjectsAndKeys:@"main", @"method", nil];
    
    [SNSUtil makeKakaoTalkLinkToKakaoTalkLinkObjects:self.kakaoTalkLinkObjects message:@"달샵을 이용해 쇼핑에 즐거움을 더하세요" imageURL:@"https://fbcdn-sphotos-f-a.akamaihd.net/hphotos-ak-prn2/t1.0-9/10262117_639256986165999_4859364690509549062_n.png" imageWidth:138 Height:138 execParameter:kakaoTalkParams];
    [SNSUtil sendKakaoTalkLinkByKakaoTalkLinkObjects:self.kakaoTalkLinkObjects];
}

#pragma mark - 
#pragma mark IBAction
- (IBAction)loginButtonTapped:(id)sender
{
    // GA
    [GAUtil sendGADataWithUIAction:@"go_to_login" label:@"escape_view" value:nil];

    
    UIStoryboard *storyboard = [ViewUtil getStoryboard];
    LoginViewController *childViewController = [storyboard instantiateViewControllerWithIdentifier:@"LoginView"];
    
    childViewController.user = self.user;
    childViewController.parentPage = SLIDE_MENU_PAGE;
    
    [self presentViewController:childViewController animated:YES completion:nil];
}

- (IBAction)registerButtonTapped:(id)sender
{
    // GA
    [GAUtil sendGADataWithUIAction:@"go_to_register" label:@"escape_view" value:nil];

    
    UIStoryboard *storyboard = [ViewUtil getStoryboard];
    JoinViewController *childViewController = [storyboard instantiateViewControllerWithIdentifier:@"JoinView"];
    
    childViewController.user = self.user;
    childViewController.parentPage = SLIDE_MENU_PAGE;
    
    [self presentViewController:childViewController animated:YES completion:nil];
}

- (IBAction)refreshReward:(id)sender
{
    // GA
    [GAUtil sendGADataWithUIAction:@"refresh_reward_click" label:@"inside_view" value:nil];

    
    [DataUtil getUserFormServerAtCompletionHandler:^(User *user){
        self.user.userId = user.userId;
        self.user.reward = user.reward;
        [self.tableView reloadData];
    }];
}
@end
