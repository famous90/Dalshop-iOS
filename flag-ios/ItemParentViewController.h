//
//  ItemParentViewController.h
//  flag-ios
//
//  Created by Gyuyoung Hwang on 2014. 3. 7..
//
//

#import <UIKit/UIKit.h>
#import "ItemListViewController.h"

@class User;
@class Shop;

@interface ItemParentViewController : UIViewController

@property (weak, nonatomic) IBOutlet UISegmentedControl *itemListTypeSegment;
@property (weak, nonatomic) IBOutlet UIView *itemListView;

@property (nonatomic, strong) ItemListViewController *itemListViewController;
@property (nonatomic, strong) User *user;
@property (nonatomic, strong) Shop *shop;
@property (nonatomic, assign) NSInteger parentPage;

- (IBAction)itemListTypeSegmentTapped:(id)sender;
- (IBAction)cancel:(UIStoryboardSegue *)segue;

@end
