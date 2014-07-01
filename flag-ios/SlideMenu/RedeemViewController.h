//
//  RedeemViewController.h
//  Dalshop
//
//  Created by Hwang Gyuyoung on 2014. 5. 29..
//
//

#import <UIKit/UIKit.h>

@class User;

@interface RedeemViewController : UIViewController <UICollectionViewDataSource, UICollectionViewDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *redeemCollectionView;
@property (weak, nonatomic) IBOutlet UILabel *myRewardTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *myRewardLabel;
@property (weak, nonatomic) IBOutlet UIImageView *dalImageView;

@property (nonatomic, strong) User *user;

@end
