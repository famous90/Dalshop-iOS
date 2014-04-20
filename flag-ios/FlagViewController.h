//
//  FlagViewController.h
//  flag-ios
//
//  Created by Gyuyoung Hwang on 2014. 2. 7..
//
//

#import <UIKit/UIKit.h>
#import "MapViewController.h"
#import "ShopInfoViewController.h"

@class User;

@interface FlagViewController : UIViewController <MapViewControllerDelegate, UIAlertViewDelegate>

@property (nonatomic, strong) MapViewController *mapViewController;
@property (nonatomic, strong) ShopInfoViewController *shopInfoViewController;
@property (weak, nonatomic) IBOutlet UIView *mapView;
@property (weak, nonatomic) IBOutlet UIView *shopInfoView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *menuButton;

@property (nonatomic, strong) User *user;
//@property (nonatomic, weak) CLLocation *currentLocation;

- (IBAction)showMyPageButtonTapped:(id)sender;
- (IBAction)showShopListButtonTapped:(id)sender;
- (IBAction)findCurrentPositionButtonTapped:(id)sender;
@end
