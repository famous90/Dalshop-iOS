//
//  MallShopViewController.m
//  flag-ios
//
//  Created by Gyuyoung Hwang on 2014. 2. 6..
//
//

#import "MallShopViewController.h"
#import "ItemListViewController.h"

#import "ShopDataController.h"
#import "Shop.h"

@interface MallShopViewController ()

@end

@implementation MallShopViewController{
    ShopDataController *shopData;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    shopData = [[ShopDataController alloc] init];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [shopData initForTest];
}

#pragma mark - Data load


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [shopData countOfList];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"ShopCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    Shop *theShop = (Shop *)[shopData objectInListAtIndex:indexPath.row];
    UILabel *shopNameLabel = (UILabel *)[cell viewWithTag:1];
    UILabel *shopDescriptionLabel = (UILabel *)[cell viewWithTag:3];
    UILabel *shopRewardLabel = (UILabel *)[cell viewWithTag:2];
    UILabel *shopRewardLabel2 = (UILabel *)[cell viewWithTag:4];
//    UIImage *shopNewItemBgImage = (UIImage *)[cell viewWithTag:5];
//    UILabel *shopNewItemLabel = (UILabel *)[cell viewWithTag:6];
//    UIImage *shopSaleItemBGImage = (UIImage *)[cell viewWithTag:7];
//    UILabel *shopSaleItemLabel = (UILabel *)[cell viewWithTag:8];
    
    shopNameLabel.text = theShop.name;
    shopRewardLabel.text = [NSString stringWithFormat:@"매장방문시\n%ld원 적립", (long)theShop.reward];
    shopRewardLabel2.text = [NSString stringWithFormat:@"아이템 스캔시\n%ld원 적립", (long)theShop.reward];
//    shopSaleItemLabel.text = @"30%";

    shopDescriptionLabel.text = theShop.description;
    
    return cell;
}

#pragma mark - table view delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 142;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 3.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 3.0f)];
    UIImageView *headerImageView = [[UIImageView alloc] initWithFrame:headerView.frame];
    
    headerImageView.backgroundColor = UIColorFromRGB(0xa09f9d);
    [headerView addSubview:headerImageView];
    
    return headerView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}
//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:Nil];
//    ItemListViewController *childViewController = (ItemListViewController *)[storyboard instantiateViewControllerWithIdentifier:@"ItemListView"];
//    [self.navigationController presentViewController:childViewController animated:YES completion:nil];
//}

#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"ShowItem"]) {
        ItemListViewController *childViewController = (ItemListViewController *)[segue destinationViewController];
//        childViewController.parentPage = MALL_SHOP_VIEW_PAGE;
//        childViewController.shopId = self.shopId;
        childViewController.title = self.shopName;
        NSLog(@"%@", self.shopId);
    }
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

#pragma mark - IBAction
- (IBAction)cancel:(id)sender
{
    if (self.parentPage == SHOP_LIST_VIEW_PAGE) {
        [self.navigationController popViewControllerAnimated:YES];
        
    }else if (self.parentPage == SHOP_INFO_VIEW_PAGE){
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}
@end
