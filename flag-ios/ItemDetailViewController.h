//
//  ItemDetailViewController.h
//  flag-ios
//
//  Created by Gyuyoung Hwang on 2014. 4. 3..
//
//

#import <UIKit/UIKit.h>

@class User;
@class Item;

@interface ItemDetailViewController : UITableViewController

@property (nonatomic, strong) User *user;
@property (nonatomic, strong) Item *item;
@property (nonatomic, strong) UIImage *itemImage;


@end
