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

#define ITEM_DETAIL_LOAD    1
#define SHOP_DETAIL_LOAD    2

#import "ItemDetailViewController.h"
#import "ActivityIndicatorView.h"

#import "User.h"
#import "Item.h"
#import "Shop.h"
#import "URLParameters.h"

#import "Util.h"

#import "FlagClient.h"
#import "GTLFlagengine.h"
#import "GoogleAnalytics.h"

@interface ItemDetailViewController ()

@end

@implementation ItemDetailViewController{
    CGFloat textPadding;
}

CGFloat tableViewPadding = 5.0f;

CGFloat itemDetailImageWidth = 310.0f;
CGFloat itemDetailImageHeight = 380.0f;

CGFloat itemFunctionButtonWidth = 104.0f;
CGFloat itemFunctionButtonHeight = 44.0f;

CGFloat itemDetailViewPadding = 12.5f;

CGFloat lineSpace = 7.0f;

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.user = [[User alloc] init];
    self.item = [[Item alloc] init];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    [self.tableView setBackgroundColor:UIColorFromRGB(BASE_COLOR)];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    textPadding = tableViewPadding + itemDetailViewPadding;
    
    [self getItemDetail];
    [self performSelectorInBackground:@selector(getItemDetailImage) withObject:nil];
}

#pragma mark - 
#pragma mark - Connect server
- (void)getItemDetail
{
    NSURL *url = [self getURLPathWithItem];
    [self getDataWithURL:url loadType:ITEM_DETAIL_LOAD];
}

- (NSURL *)getURLPathWithItem
{
    URLParameters *urlParams = [[URLParameters alloc] init];
    [urlParams setMethodName:@"one_item"];
    [urlParams addParameterWithKey:@"itemId" withParameter:self.item.itemId];
    [urlParams addParameterWithUserId:self.user.userId];
    NSURL *url = [urlParams getURLForRequest];
    
    return url;
}

- (void)getDataWithURL:(NSURL *)url loadType:(NSInteger)type
{
    // Activity Indicator
    ActivityIndicatorView *aiView = [ActivityIndicatorView startActivityIndicatorInParentView:self.tableView];
    
    NSDate *loadBeforeTime = [NSDate date];
    
    [[[NSOperationQueue alloc] init] addOperationWithBlock:^{
        
        NSDictionary *results = [FlagClient getURLResultWithURL:url];
        
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            
            if (type == ITEM_DETAIL_LOAD) {
                
                [self setItemDetailDataWithJsonData:results];
                
                // GAI Data Load Time
                [[[GAI sharedInstance] defaultTracker] send:[[GAIDictionaryBuilder createTimingWithCategory:@"data_load" interval:[NSNumber numberWithDouble:[[NSDate date] timeIntervalSinceDate:loadBeforeTime]] name:@"item_detail" label:nil] build]];
                
                [self.tableView reloadData];
                
            }else if (type == SHOP_DETAIL_LOAD){
                
                Shop *theShop = [[Shop alloc] initWithData:results];
                self.title = theShop.name;
            }

            [aiView stopActivityIndicator];
        }];
    }];
}

- (void)setItemDetailDataWithJsonData:(NSDictionary *)results
{
    Item *theItem = [[Item alloc] initWithData:results];
    self.item = theItem;
    
    NSURL *url = [self getURLPathWithShop:theItem.shopId];
    [self getDataWithURL:url loadType:SHOP_DETAIL_LOAD];
}

- (NSURL *)getURLPathWithShop:(NSNumber *)shopId
{
    URLParameters *urlParams = [[URLParameters alloc] init];
    [urlParams setMethodName:@"shop"];
    [urlParams addParameterWithKey:@"id" withParameter:shopId];
    [urlParams addParameterWithUserId:self.user.userId];
    
    
    NSURL *url = [urlParams getURLForRequest];
    
    return url;
}

- (void)getItemDetailImage
{
    if (self.item.thumbnailUrl) {
        NSString *imagePath = [Util addImageParameterInImagePath:self.item.thumbnailUrl width:itemDetailImageWidth*2 height:itemDetailImageHeight*2];
        self.itemImage = [FlagClient getImageWithImagePath:imagePath];
        NSLog(@"image height %f", self.itemImage.size.height);
        
        [self.tableView reloadData];
    }
}

#pragma mark -
#pragma mark Table view data source

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
    
    
    // Image Cell
    if (indexPath.row == ITEM_IMAGE_CELL) {
        
        CellIdentifier = @"ItemImageCell";
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
        if(cell == nil) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        
        
        // Item image
        
        CGFloat imageWidth = cell.frame.size.width - tableViewPadding*2;
        CGFloat imageHeight = self.itemImage.size.height * imageWidth / self.itemImage.size.width;
        
        UIImageView *itemImageView = [[UIImageView alloc] initWithFrame:CGRectMake(tableViewPadding, tableViewPadding, imageWidth, imageHeight)];
        [itemImageView setContentMode:UIViewContentModeScaleAspectFit];
        itemImageView.image = self.itemImage;
        
        [cell addSubview:itemImageView];
        
        
        // Like button
        
        UIButton *likeItButton = [[UIButton alloc] initWithFrame:CGRectMake(tableViewPadding, cell.frame.size.height - itemFunctionButtonHeight, itemFunctionButtonWidth, itemFunctionButtonHeight)];
        likeItButton.backgroundColor = UIColorFromRGBWithAlpha(BASE_COLOR, 0.8);
        if (self.item.liked) {
            [likeItButton setImage:[UIImage imageNamed:@"icon_likeIt_done_white"] forState:UIControlStateNormal];
        }else {
            [likeItButton setImage:[UIImage imageNamed:@"icon_likeIt_white"] forState:UIControlStateNormal];
        }
        [likeItButton setTitle:[NSString stringWithFormat:@"%ld", (long)self.item.likes] forState:UIControlStateNormal];
        [likeItButton.titleLabel setFont:[UIFont fontWithName:@"system" size:12]];
        [likeItButton setTintColor:[UIColor whiteColor]];
        [likeItButton setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 10)];
        [likeItButton addTarget:self action:@selector(likeItButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
        [cell addSubview:likeItButton];
        
        
        // Share Button
        
        UIButton *shareButton = [[UIButton alloc] initWithFrame:CGRectMake(likeItButton.frame.origin.x + likeItButton.frame.size.width, cell.frame.size.height - itemFunctionButtonHeight, itemFunctionButtonWidth, itemFunctionButtonHeight)];
        shareButton.backgroundColor = UIColorFromRGBWithAlpha(BASE_COLOR, 0.8);
        [shareButton setImage:[UIImage imageNamed:@"icon_share"] forState:UIControlStateNormal];
        [shareButton setTintColor:[UIColor whiteColor]];
        [shareButton addTarget:self action:@selector(shareButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
        [cell addSubview:shareButton];
        
        
        // show location Button
        
        UIButton *showLocationButton = [[UIButton alloc] initWithFrame:CGRectMake(shareButton.frame.origin.x + shareButton.frame.size.width, cell.frame.size.height - itemFunctionButtonHeight, itemFunctionButtonWidth, itemFunctionButtonHeight)];
        showLocationButton.backgroundColor = UIColorFromRGBWithAlpha(BASE_COLOR, 0.8);
        [showLocationButton setImage:[UIImage imageNamed:@"icon_map"] forState:UIControlStateNormal];
        [showLocationButton setTintColor:[UIColor whiteColor]];
        [showLocationButton addTarget:self action:@selector(showLocationButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
        [cell addSubview:showLocationButton];
        
        
    // Name Cell
    }else if (indexPath.row == ITEM_NAME_CELL) {
        
        CellIdentifier = @"ItemNameCell";
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
        if(cell == nil) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        
        
        // name label
        UIFont *textFont = [UIFont fontWithName:@"Helvetica" size:17];
        CGRect descriptionLabelFrame = [self.item.name boundingRectWithSize:CGSizeMake(tableView.frame.size.width - textPadding*2, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:textFont} context:nil];
        
        UILabel *itemNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(textPadding, itemDetailViewPadding, descriptionLabelFrame.size.width, descriptionLabelFrame.size.height)];
        itemNameLabel.text = self.item.name;
        itemNameLabel.font = textFont;
        itemNameLabel.numberOfLines = 0;
        [cell addSubview:itemNameLabel];
        

        // background color
        UIImageView *backgroundImageView = [[UIImageView alloc] initWithFrame:CGRectMake(tableViewPadding, 0, cell.frame.size.width - tableViewPadding*2, cell.frame.size.height)];
        backgroundImageView.backgroundColor = [UIColor whiteColor];
        [cell addSubview:backgroundImageView];
        [cell sendSubviewToBack:backgroundImageView];
        
    }else if (indexPath.row == ITEM_DESCRIPTION_CELL){
        
        CellIdentifier = @"ItemDescriptionCell";
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
        if(cell == nil) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        
        // description label
        UIFont *textFont = [UIFont fontWithName:@"Helvetica" size:14];
        CGRect descriptionLabelFrame = [self.item.description boundingRectWithSize:CGSizeMake(tableView.frame.size.width - textPadding*2, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:textFont} context:nil];
        UILabel *itemDescriptionLabel = [[UILabel alloc] initWithFrame:CGRectMake(textPadding, 0, descriptionLabelFrame.size.width, descriptionLabelFrame.size.height)];
        itemDescriptionLabel.text = self.item.description;
        itemDescriptionLabel.font = textFont;
        itemDescriptionLabel.numberOfLines = 0;
        [cell addSubview:itemDescriptionLabel];
        
        
        // background color
        UIImageView *backgroundImageView = [[UIImageView alloc] initWithFrame:CGRectMake(tableViewPadding, 0, cell.frame.size.width - tableViewPadding*2, cell.frame.size.height)];
        backgroundImageView.backgroundColor = [UIColor whiteColor];
        [cell addSubview:backgroundImageView];
        [cell sendSubviewToBack:backgroundImageView];
        
    }else if (indexPath.row == ITEM_REWARD_PRICE_CELL){
        
        CellIdentifier = @"ItemRewardPriceCell";
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
        if(cell == nil) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        UIImageView *itemScanImageView = (UIImageView *)[cell viewWithTag:806];
        UILabel *itemRewardLabel = (UILabel *)[cell viewWithTag:807];
        UILabel *itemSalePercentLabel = (UILabel *)[cell viewWithTag:808];
//        UILabel *itemOldPriceLabel = (UILabel *)[cell viewWithTag:809];
        UILabel *itemCurrentPriceLabel = (UILabel *)[cell viewWithTag:810];
        
        UIFont *oldPriceTextFont = [UIFont fontWithName:@"Helvetica" size:14];
        CGRect oldPriceFrame = [self.item.oldPrice boundingRectWithSize:CGSizeMake(100, 40) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:oldPriceTextFont} context:nil];
        UILabel *itemOldPriceLabel = [[UILabel alloc] initWithFrame:CGRectMake(cell.frame.size.width - 20 - oldPriceFrame.size.width, 5, oldPriceFrame.size.width, oldPriceFrame.size.height)];
        UIView *deleteLineView = [[UIView alloc] initWithFrame:CGRectMake(itemOldPriceLabel.frame.origin.x - 3, itemOldPriceLabel.center.y, itemOldPriceLabel.frame.size.width + 3*2, 1)];
        
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
        
        itemRewardLabel.text = [NSString stringWithFormat:@"%ld달", (long)self.item.reward];
        itemOldPriceLabel.text = self.item.oldPrice;
        itemOldPriceLabel.font = oldPriceTextFont;
        itemCurrentPriceLabel.text = self.item.price;
        
        [cell addSubview:itemOldPriceLabel];
        [cell addSubview:deleteLineView];
        
        
        // background color
        UIImageView *backgroundImageView = [[UIImageView alloc] initWithFrame:CGRectMake(tableViewPadding, 0, cell.frame.size.width - tableViewPadding*2, cell.frame.size.height)];
        backgroundImageView.backgroundColor = [UIColor whiteColor];
        [cell addSubview:backgroundImageView];
        [cell sendSubviewToBack:backgroundImageView];
        
    }
    [cell setBackgroundColor:UIColorFromRGB(BASE_COLOR)];
    
    return cell;
}

#pragma mark - table view delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == ITEM_IMAGE_CELL) {
        
        CGFloat height = tableViewPadding + self.itemImage.size.height*(self.tableView.frame.size.width - tableViewPadding*2)/self.itemImage.size.width;
//        CGFloat height = tableViewPadding + itemDetailImageHeight;
        
        return height;
        
    }else if (indexPath.row == ITEM_NAME_CELL){
        
        CGRect frame = [self.item.name boundingRectWithSize:CGSizeMake(tableView.frame.size.width - textPadding*2, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont fontWithName:@"Helvetica" size:17]} context:nil];
        CGFloat height = itemDetailViewPadding + frame.size.height + lineSpace;
        
        return height;
        
    }else if (indexPath.row == ITEM_DESCRIPTION_CELL){
        
        CGRect frame = [self.item.description boundingRectWithSize:CGSizeMake(tableView.frame.size.width - textPadding*2, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont fontWithName:@"Helvetica" size:14]} context:nil];
        
        return frame.size.height;
        
    }else if (indexPath.row == ITEM_REWARD_PRICE_CELL){
        
        return 42;
        
    }else return 0;
}

#pragma mark - IBAction
- (IBAction)likeItButtonTapped:(id)sender
{
    NSLog(@"like it button tapped");
    [self likeItem];
}

- (IBAction)shareButtonTapped:(id)sender
{
    NSLog(@"share button tapped");
}

- (IBAction)showLocationButtonTapped:(id)sender
{
    NSLog(@"show location button tapped");
}

- (void)likeItem
{
    GTLServiceFlagengine *service = [FlagClient flagengineService];
    
    GTLFlagengineLike *like = [GTLFlagengineLike alloc];
    [like setTargetId:self.item.itemId];
    [like setUserId:self.user.userId];
    [like setType:[NSNumber numberWithInt:LIKE_ITEM]];
    GTLQueryFlagengine *query = [GTLQueryFlagengine queryForLikesInsertWithObject:like];
    
    [service executeQuery:query completionHandler:^(GTLServiceTicket *ticket, GTLFlagengineLike *object, NSError *error){
       
        NSLog(@"result object %@", object);
        
        [self getItemDetail];
    }];
}

@end
