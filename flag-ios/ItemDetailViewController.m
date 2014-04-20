//
//  ItemDetailViewController.m
//  flag-ios
//
//  Created by Gyuyoung Hwang on 2014. 4. 3..
//
//

#define ITEM_IMAGE_CELL         0
#define ITEM_NAME_CELL          1
#define ITEM_DESCRIPTION_CELL   2
#define ITEM_REWARD_PRICE_CELL  3

#import "ItemDetailViewController.h"

#import "User.h"
#import "Item.h"

@interface ItemDetailViewController ()

@end

@implementation ItemDetailViewController{
    CGFloat descriptionLabelHeight;
}

CGFloat tableViewPadding = 9.0f;

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.user = [[User alloc] init];
    self.item = [[Item alloc] init];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.tableView setBackgroundColor:UIColorFromRGB(BASE_COLOR)];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier = nil;
    UITableViewCell *cell = nil;
    
    if (indexPath.row == ITEM_IMAGE_CELL) {
        
        CellIdentifier = @"ItemImageCell";
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
        if(cell == nil) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        UIImageView *itemImageView = [[UIImageView alloc] initWithFrame:CGRectMake(tableViewPadding, tableViewPadding, cell.frame.size.width - tableViewPadding*2, self.itemImage.size.height)];
        
        itemImageView.image = self.itemImage;
        
        [cell addSubview:itemImageView];
        
    }else if (indexPath.row == ITEM_NAME_CELL) {
        
        CellIdentifier = @"ItemNameCell";
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
        if(cell == nil) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        UILabel *itemNameLabel = (UILabel *)[cell viewWithTag:801];
        UIButton *itemShareButton = (UIButton *)[cell viewWithTag:802];
        
        itemNameLabel.text = self.item.name;
        
        [itemShareButton addTarget:self action:@selector(shareItemButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
        
    }else if (indexPath.row == ITEM_DESCRIPTION_CELL){
        
        CellIdentifier = @"ItemDescriptionCell";
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
        if(cell == nil) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        
        UIFont *textFont = [UIFont fontWithName:@"Helvetica" size:14];
        CGRect descriptionLabelFrame = [self.item.description boundingRectWithSize:CGSizeMake(280, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:textFont} context:nil];
        
        UILabel *itemDescriptionLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, descriptionLabelFrame.size.width, descriptionLabelFrame.size.height)];
        UIImageView *itemDescriptionBgImageView = [[UIImageView alloc] initWithFrame:CGRectMake(9, 0, cell.frame.size.width - 9*2, descriptionLabelFrame.size.height)];
        
        itemDescriptionLabel.text = self.item.description;
        itemDescriptionLabel.font = textFont;
        itemDescriptionLabel.numberOfLines = 0;
        itemDescriptionBgImageView.backgroundColor = [UIColor whiteColor];
        
        [cell addSubview:itemDescriptionBgImageView];
        [cell addSubview:itemDescriptionLabel];
        
    }else if (indexPath.row == ITEM_REWARD_PRICE_CELL){
        
        CellIdentifier = @"ItemRewardPriceCell";
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
        if(cell == nil) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        UIImageView *itemLikeImageView = (UIImageView *)[cell viewWithTag:804];
        UILabel *itemLikeCountLabel = (UILabel *)[cell viewWithTag:805];
        UIImageView *itemScanImageView = (UIImageView *)[cell viewWithTag:806];
        UILabel *itemRewardLabel = (UILabel *)[cell viewWithTag:807];
        UILabel *itemSalePercentLabel = (UILabel *)[cell viewWithTag:808];
//        UILabel *itemOldPriceLabel = (UILabel *)[cell viewWithTag:809];
        UILabel *itemCurrentPriceLabel = (UILabel *)[cell viewWithTag:810];
        
        UIFont *oldPriceTextFont = [UIFont fontWithName:@"Helvetica" size:14];
        CGRect oldPriceFrame = [self.item.oldPrice boundingRectWithSize:CGSizeMake(100, 40) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:oldPriceTextFont} context:nil];
        UILabel *itemOldPriceLabel = [[UILabel alloc] initWithFrame:CGRectMake(cell.frame.size.width - 20 - oldPriceFrame.size.width, 5, oldPriceFrame.size.width, oldPriceFrame.size.height)];
        UIView *deleteLineView = [[UIView alloc] initWithFrame:CGRectMake(itemOldPriceLabel.frame.origin.x - 3, itemOldPriceLabel.center.y, itemOldPriceLabel.frame.size.width + 3*2, 1)];
        
        if (self.item.liked) {
            itemLikeImageView.image = [UIImage imageNamed:@"icon_like_selected"];
        }else{
            itemLikeImageView.image = [UIImage imageNamed:@"icon_like_unselected"];
        }
        
        if (self.item.rewarded) {
            itemScanImageView.image = [UIImage imageNamed:@"icon_scan_done"];
        }else{
            itemScanImageView.image = [UIImage imageNamed:@"icon_scan"];
        }
        
        if (self.item.sale) {
            itemSalePercentLabel.text = [NSString stringWithFormat:@"%ld%%", (long)self.item.sale];
        }else{
            [itemSalePercentLabel setHidden:YES];
        }
        
        if (self.item.oldPrice) {
            deleteLineView.backgroundColor = [UIColor blackColor];
        }else{
            [deleteLineView setHidden:YES];
        }
        
        itemLikeCountLabel.text = [NSString stringWithFormat:@"%ld", (long)self.item.likes];
        itemRewardLabel.text = [NSString stringWithFormat:@"%ld달", (long)self.item.reward];
        itemOldPriceLabel.text = self.item.oldPrice;
        itemOldPriceLabel.font = oldPriceTextFont;
        itemCurrentPriceLabel.text = self.item.price;
        
        [cell addSubview:itemOldPriceLabel];
        [cell addSubview:deleteLineView];
        
    }
    [cell setBackgroundColor:UIColorFromRGB(BASE_COLOR)];
    
    return cell;
}

#pragma mark - table view delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == ITEM_IMAGE_CELL) {
        
        return tableViewPadding + self.itemImage.size.height;
        
    }else if (indexPath.row == ITEM_NAME_CELL){
        
        return 27;
        
    }else if (indexPath.row == ITEM_DESCRIPTION_CELL){
        
        CGRect frame = [self.item.description boundingRectWithSize:CGSizeMake(280, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont fontWithName:@"Helvetica" size:14]} context:nil];
        
        return frame.size.height;
        
    }else if (indexPath.row == ITEM_REWARD_PRICE_CELL){
        
        return 42;
        
    }else return 0;
}

#pragma mark - IBAction
- (IBAction)shareItemButtonTapped:(UIButton *)sender
{
    NSLog(@"share item button Tapped");
}

@end
