//
//  ItemListViewController.h
//  flag-ios
//
//  Created by Gyuyoung Hwang on 2014. 2. 5..
//
//

#import <UIKit/UIKit.h>

@class User;
@class Shop;
@class Item;
@class ItemListViewController;

@interface ItemListViewController : UICollectionViewController

@property (nonatomic, strong) User *user;
@property (nonatomic, strong) Shop *shop;
@property (nonatomic, assign) NSInteger parentPage;
@property (nonatomic, assign) BOOL afterItemScan;
@property (nonatomic, strong) UIImage *shopEventImage;

@property (nonatomic, strong) Item *item;
@property (nonatomic, strong) UIImage *itemImage;

- (IBAction)cancel:(UIStoryboardSegue *)segue;

@end
