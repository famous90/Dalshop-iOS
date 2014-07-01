//
//  RightSlideMenuTableViewController.m
//  Dalshop
//
//  Created by Hwang Gyuyoung on 2014. 6. 30..
//
//

#define SELECT_REWARD_SECTION   0
#define SELECT_REWARD_ROW       0

#define MY_INFO_SECTION         1
#define MY_INFO_ROW             0

#define MENU_SECTION            2
#define REDEEM_ROW              0
#define REWARD_HISTORY_ROW      1

#import "RightSlideMenuTableViewController.h"
#import "FlagViewController.h"
#import "RedeemViewController.h"
#import "RewardHistoryViewController.h"

#import "ViewUtil.h"
#import "DelegateUtil.h"

#import "GoogleAnalytics.h"

@interface RightSlideMenuTableViewController ()

@end

@implementation RightSlideMenuTableViewController{
    NSArray *menuTableCell;
    
    CGFloat slideMenuVisibleWidth;
    CGFloat slideMenuOriginX;
    CGFloat menuFooterHeight;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self setUser:[DelegateUtil getUser]];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initializeMenuTableCell];
}

- (void)initializeMenuTableCell
{
    slideMenuVisibleWidth = 261.0f;
    slideMenuOriginX = self.tableView.frame.size.width - slideMenuVisibleWidth;
    menuFooterHeight = 150.0f;
    
    NSDictionary *dic_select_reward = [[NSDictionary alloc] initWithObjectsAndKeys:@"SelectRewardCell", @"CellIdentifier", @"", @"cellTitle", @"", @"cellIconImage", nil];
    NSArray *array_select_reward = [[NSArray alloc] initWithObjects:dic_select_reward, nil];
    
    NSDictionary *dic_my_info = [[NSDictionary alloc] initWithObjectsAndKeys:@"MyInfoCell", @"CellIdentifier", @"", @"cellTitle", @"", @"cellIconImage", nil];
    NSArray *array_my_info = [[NSArray alloc] initWithObjects:dic_my_info, nil];
    
    NSDictionary *dic_menu1 = [[NSDictionary alloc] initWithObjectsAndKeys:@"RedeemCell", @"CellIdentifier", @"사용하기", @"cellTitle", @"icon_redeem", @"cellIconImage", nil];
    NSDictionary *dic_menu2 = [[NSDictionary alloc] initWithObjectsAndKeys:@"RewardHistoryCell", @"CellIdentifier", @"적립내역", @"cellTitle", @"icon_reward_history", @"cellIconImage", nil];
    NSArray *array_menu = [[NSArray alloc] initWithObjects:dic_menu1, dic_menu2, nil];
    
    menuTableCell = [[NSArray alloc] initWithObjects:array_select_reward, array_my_info, array_menu, nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == SELECT_REWARD_SECTION) {

        return 1;
        
    }else if (section == MY_INFO_SECTION) {
        
        return 1;
        
    }else if (section == MENU_SECTION) {
        
        return 2;
        
    }else return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *cell_dic = [[menuTableCell objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    NSString *CellIdentifier = [cell_dic valueForKey:@"CellIdentifier"];
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    
    CGFloat cellPadding = 30.0f;
    CGFloat iconImageHeight = 15.0f;
    CGFloat titleLabelHeight = 20.0f;
    CGFloat titleLabelWidth = slideMenuVisibleWidth - (cellPadding + iconImageHeight + cellPadding + iconImageHeight + cellPadding);
    
    if (indexPath.section == SELECT_REWARD_SECTION) {
        
        if (indexPath.row == SELECT_REWARD_ROW) {
            
            // CHECK IN SHOP BUTTON
            CGFloat buttonTextPadding = 10.0f;
            CGFloat buttonWidth = 129.0f;
            CGFloat buttonHeight = 140.0f;
            CGFloat buttonPadding = 60.0f;
            UIImage *checkInIconImage = [UIImage imageNamed:@"icon_checkIn_round"];
            UIButton *collectCheckInRewardButton = [[UIButton alloc] initWithFrame:CGRectMake(slideMenuOriginX + (slideMenuVisibleWidth - buttonWidth)/2, buttonPadding, buttonWidth, buttonHeight)];
            
            [collectCheckInRewardButton addTarget:self action:@selector(checkInRewardShopsButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
            [collectCheckInRewardButton.titleLabel setNumberOfLines:2];
            [collectCheckInRewardButton setTitle:@"달이 뜨는 가게\nCHECK-IN" forState:UIControlStateNormal];
            [collectCheckInRewardButton setTitleColor:UIColorFromRGB(0xf2b518) forState:UIControlStateNormal];
            [collectCheckInRewardButton.titleLabel setFont:[UIFont boldSystemFontOfSize:15]];
            [collectCheckInRewardButton.titleLabel setTextAlignment:NSTextAlignmentCenter];
            [collectCheckInRewardButton setImage:checkInIconImage forState:UIControlStateNormal];
            
            CGSize checkInImageSize = collectCheckInRewardButton.imageView.frame.size;
            [collectCheckInRewardButton setTitleEdgeInsets:UIEdgeInsetsMake(0, -checkInImageSize.width, -checkInImageSize.height - buttonTextPadding, 0)];
            
            CGSize checkInTitleSize = collectCheckInRewardButton.titleLabel.frame.size;
            collectCheckInRewardButton.imageEdgeInsets = UIEdgeInsetsMake(-checkInTitleSize.height - buttonTextPadding, 0, 0, -checkInTitleSize.width);
            
            [cell addSubview:collectCheckInRewardButton];
            
            
            // Cell background
            [cell setBackgroundColor:[UIColor colorWithWhite:0.2 alpha:1]];
        }
        
    }else if (indexPath.section == MY_INFO_SECTION){
        
        if (indexPath.row == MY_INFO_ROW) {
            
            CGFloat buttonPadding = 18.0f;
            
            
            // name label
            NSString *userName = self.user.email;
            if (!userName) {
                userName = @"guest";
            }
            
            UILabel *userNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(slideMenuOriginX + cellPadding, (cell.frame.size.height - titleLabelHeight)/2, 150.0f, titleLabelHeight)];
            [userNameLabel setText:userName];
            [userNameLabel setFont:[UIFont boldSystemFontOfSize:14]];
            [userNameLabel setTextColor:[UIColor whiteColor]];
            [userNameLabel setTextAlignment:NSTextAlignmentLeft];
            [cell addSubview:userNameLabel];
            
            
            // point button
            UIImage *pointButtonBackgroundImage = [UIImage imageNamed:@"bg_point"];
            CGFloat pointButtonWidth = [ViewUtil getMagnifiedImageWidthWithImage:pointButtonBackgroundImage height:titleLabelHeight];
            UIButton *pointButton = [[UIButton alloc] initWithFrame:CGRectMake(cell.frame.size.width - buttonPadding - pointButtonWidth, (cell.frame.size.height - titleLabelHeight)/2, pointButtonWidth, titleLabelHeight)];
            [pointButton setBackgroundImage:pointButtonBackgroundImage forState:UIControlStateNormal];
            [pointButton setTitle:[NSString stringWithFormat:@"%d달", self.user.reward]    forState:UIControlStateNormal];
            [pointButton.titleLabel setFont:[UIFont systemFontOfSize:12]];
            [pointButton.titleLabel setTextAlignment:NSTextAlignmentRight];
            [pointButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [cell addSubview:pointButton];
            
            
            // Cell background
            [cell setBackgroundColor:UIColorFromRGB(0xf2b518)];
        }
        
    }else if (indexPath.section == MENU_SECTION) {
        
        // cell customize
        UIImageView *menuIconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(slideMenuOriginX + cellPadding, (cell.frame.size.height - iconImageHeight)/2, iconImageHeight, iconImageHeight)];
        [menuIconImageView setContentMode:UIViewContentModeScaleAspectFit];
        menuIconImageView.image = [UIImage imageNamed:[cell_dic valueForKey:@"cellIconImage"]];
        [cell addSubview:menuIconImageView];
        
        UILabel *menuTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(menuIconImageView.frame.origin.x + menuIconImageView.frame.size.width + cellPadding, (cell.frame.size.height - titleLabelHeight)/2, titleLabelWidth, titleLabelHeight)];
        [menuTitleLabel setText:[cell_dic valueForKey:@"cellTitle"]];
        [menuTitleLabel setFont:[UIFont systemFontOfSize:15]];
        [menuTitleLabel setTextColor:UIColorFromRGB(BASE_COLOR)];
        [cell addSubview:menuTitleLabel];
        
        
        // separator line
        UIView *seperatorLine = [[UIView alloc] initWithFrame:CGRectMake(0, cell.frame.size.height - 0.5f, cell.frame.size.width, 0.5f)];
        [seperatorLine setBackgroundColor:UIColorFromRGB(BASE_COLOR)];
        [cell addSubview:seperatorLine];
    }
    
    return cell;
}

#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == MY_INFO_SECTION) {
        if (indexPath.row == MY_INFO_ROW) {
            
        }
        
    }else if (indexPath.section == MENU_SECTION){
        
        if (indexPath.row == REDEEM_ROW) {
            
            UIStoryboard *storyboard = [ViewUtil getStoryboard];
            UINavigationController *navController = (UINavigationController *)[storyboard instantiateViewControllerWithIdentifier:@"RedeemViewNav"];
            RedeemViewController *childViewController = (RedeemViewController *)[navController topViewController];
            childViewController.user = self.user;

            [navController.navigationBar setTintColor:UIColorFromRGB(BASE_COLOR)];

            [self presentViewController:navController animated:YES completion:nil];
            
        }else if (indexPath.row == REWARD_HISTORY_ROW){
            
            UIStoryboard *storyboard = [ViewUtil getStoryboard];
            UINavigationController *navController = (UINavigationController *)[storyboard instantiateViewControllerWithIdentifier:@"RewardHistoryViewNav"];
            RewardHistoryViewController *childViewController = (RewardHistoryViewController *)[navController topViewController];
            [childViewController setUser:self.user];
            [childViewController setParentPage:SLIDE_MENU_PAGE];
            
            [navController.navigationBar setTintColor:UIColorFromRGB(BASE_COLOR)];
            
            [self presentViewController:navController animated:YES completion:nil];
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = 0;
    
    if (indexPath.section == SELECT_REWARD_SECTION) {
        
        height = 272.0f;
        
    }else if (indexPath.section == MY_INFO_SECTION){
        
        height = 42.0f;
        
    }else if (indexPath.section == MENU_SECTION){
        
        height =  42.0f;
        
    }

    return height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == MENU_SECTION) {
        return menuFooterHeight;
    }else return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (section == MENU_SECTION) {
        
        UIView *menuFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, menuFooterHeight)];
        UIImage *menuFooterImage = [UIImage imageNamed:@"slide_footer"];
        CGFloat menuFooterImageHeight = [ViewUtil getMagnifiedImageHeightWithImage:menuFooterImage width:slideMenuVisibleWidth];
        UIImageView *menuFooterImageView = [[UIImageView alloc] initWithFrame:CGRectMake(slideMenuOriginX, menuFooterView.frame.size.height - menuFooterImageHeight, slideMenuVisibleWidth, menuFooterImageHeight)];
        [menuFooterImageView setImage:menuFooterImage];
        [menuFooterView addSubview:menuFooterImageView];
        
        return menuFooterView;
            
    }else return nil;
}

#pragma mark - IBAction
- (IBAction)checkInRewardShopsButtonTapped:(id)sender
{
    // GA
    [GAUtil sendGADataWithUIAction:@"go_to_check_in_reward_map" label:@"escape_view" value:nil];
    
    [self presentCheckInShopsInMap];
}

#pragma mark -
#pragma mark Implementation
- (void)presentCheckInShopsInMap
{
    UIStoryboard *storyboard = [ViewUtil getStoryboard];
    UINavigationController *navController = (UINavigationController *)[storyboard instantiateViewControllerWithIdentifier:@"FlagViewNav"];
    FlagViewController *childViewController = (FlagViewController *)[navController topViewController];
    childViewController.user = self.user;
    childViewController.parentPage = COLLECT_REWARD_SELECT_VIEW_PAGE;
    
    [self presentViewController:navController animated:YES completion:nil];
}
@end
