//
//  RewardHistoryViewController.m
//  flag-ios
//
//  Created by Gyuyoung Hwang on 2014. 2. 22..
//
//

#import "RewardHistoryViewController.h"

#import "User.h"
#import "RewardDataController.h"
#import "Reward.h"
#import "URLParameters.h"

#import "FlagClient.h"

@interface RewardHistoryViewController ()

@end

@implementation RewardHistoryViewController{
    RewardDataController *rewardData;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.user = [[User alloc] init];
    rewardData = [[RewardDataController alloc] init];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self getRewardHistory];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self configureViewContent];
}

- (void)configureViewContent
{
    [self setTitle:@"적립 내역"];
    
    if (self.parentPage == SLIDE_MENU_PAGE) {
        UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"button_back"] style:UIBarButtonItemStyleBordered target:self action:@selector(cancelButtonTapped:)];
        self.navigationItem.leftBarButtonItem = cancelButton;
    }
}

#pragma mark -
#pragma mark - server connect

- (void)getRewardHistory
{
    URLParameters *urlParam = [[URLParameters alloc] init];
    [urlParam setMethodName:@"reward"];
    [urlParam addParameterWithUserId:self.user.userId];
    NSURL *url = [urlParam getURLForRequest];
    
    [[[NSOperationQueue alloc] init] addOperationWithBlock:^{
        
        NSDictionary *results = [FlagClient getURLResultWithURL:url];
        
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
           
            [self setRewardHistoryWithJsonData:results];
            
        }];
    }];
}

- (void)setRewardHistoryWithJsonData:(NSDictionary *)results
{
    NSArray *rewards = [results objectForKey:@"rewards"];
    for(id object in rewards){
        Reward *theReward = [[Reward alloc] initWithData:object];
        [rewardData addObjectWithObject:theReward];
    }
    
    [self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [rewardData countOfList];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [rewardData countOfOnedayRewardAtIndex:section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    
    if (indexPath.row == 0) {
        
        static NSString *CellIdentifier = @"DateCell";
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
        NSString *dateString = [rewardData dateStringAtIndex:indexPath.section];
        UILabel *dateLabel = (UILabel *)[cell viewWithTag:501];
        
        dateLabel.text = dateString;
        
    }else{
        
        static NSString *CellIdentifier = @"RewardCell";
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
        Reward *theReward = [rewardData objectAtIndex:indexPath.section rewardIndex:indexPath.row];
        UILabel *shopNameLabel = (UILabel *)[cell viewWithTag:502];
        UILabel *rewardTypeLabel = (UILabel *)[cell viewWithTag:503];
        UILabel *rewardLabel = (UILabel *)[cell viewWithTag:504];
        
        shopNameLabel.text = theReward.targetName;
        if (theReward.type == 1) {
            rewardTypeLabel.text = @"체크인";
        }else if (theReward.type == 2){
            rewardTypeLabel.text = @"아이템스캔";
        }
        rewardLabel.text = [NSString stringWithFormat:@"%ld원", (long)theReward.reward];
    }

    return cell;
}

#pragma mark - table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return 44.0f;
    }else return 30.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}


#pragma mark - IBAction
- (IBAction)cancelButtonTapped:(id)sender
{
    // GA
    [GAUtil sendGADataWithUIAction:@"go_back" label:@"escape_view" value:nil];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
