//
//  MyPageViewController.h
//  flag-ios
//
//  Created by Gyuyoung Hwang on 2014. 2. 20..
//
//

#import <UIKit/UIKit.h>

@class User;

@interface MyPageViewController : UICollectionViewController

@property (nonatomic, strong) User *user;

- (IBAction)cancel:(id)sender;

@end
