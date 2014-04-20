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

@interface ItemListViewController : UICollectionViewController

@property (nonatomic, strong) User *user;
@property (nonatomic, strong) Shop *shop;
@property (nonatomic, assign) NSInteger parentPage;

- (IBAction)cancel:(UIStoryboardSegue *)segue;
- (void)changeItemRewardToRewardedWithItemId:(NSNumber *)itemId;

@end
