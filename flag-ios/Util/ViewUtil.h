//
//  ViewUtil.h
//  flag-ios
//
//  Created by Gyuyoung Hwang on 2014. 2. 18..
//
//

#import <Foundation/Foundation.h>

@class User;
@class Shop;
@class Item;

@interface ViewUtil : NSObject

// DEVICE
+ (UIStoryboard *)getStoryboard;
+ (CGFloat)getIOSDeviceScreenHeight;


+ (UIImage *)imageWithImage:(UIImage *)image scaledToWidth:(CGFloat)width;
+ (CAGradientLayer *)gradientVerticalTop:(UIColor *)topColor bottomColor:(UIColor *)bottomColor withViewFrame:(CGRect)frame;
+ (CGRect)frameWithString:(NSString *)string inBoundingRect:(CGSize)size attribute:(NSDictionary *)attribute;

+ (void)setAppDelegatePresentingViewControllerWithViewController:(UIViewController *)viewController;


// LOAD VIEW IN APP DELEGATE WINDOW
+ (void)initializeRootViewControllerWithUser:(User *)user window:(UIWindow *)window;
+ (void)initializeSaleInfoViewControllerWithUser:(User *)user shopId:(NSNumber *)shopId window:(UIWindow *)window;
+ (void)initializeItemDetailViewControllerWithUser:(User *)user itemId:(NSNumber *)itemId window:(UIWindow *)window;


// LOAD VIEW IN ANOTHER VIEW
+ (void)presentTabbarViewControllerInView:(UIViewController *)viewController withUser:(User *)user;
+ (void)presentUserPolicyInView:(id)viewController policyType:(NSInteger)policyType;
+ (void)presentLoginViewInView:(UIViewController *)viewController withUser:(User *)user;
+ (void)presentRewardPopUpViewInView:(UIViewController *)viewController shopId:(NSNumber *)shopId shopName:(NSString *)shopName reward:(NSNumber *)reward;

+ (void)presentTutorialInView:(UIViewController *)viewController type:(NSInteger)type;
+ (void)presentBluetoothTutorialInView:(UIViewController *)viewController;

+ (void)presentItemListViewNavInView:(UIViewController *)viewController withUser:(User *)user shopId:(NSNumber *)shopId shopName:(NSString *)shopName withParentPageNumber:(NSInteger)parentPage;

+ (UIView *)getCellResultMessageInView:(UIView *)view messageType:(NSInteger)type;


// DRAW LINE
+ (UIImage *)drawDiagonalCrossLineOnFrame:(CGRect)frame;
+ (UIImage *)drawBorderLineOnFrame:(CGRect)frame byCellRow:(NSInteger)row;


// IMAGE
+ (CGFloat)getMagnifiedImageWidthWithImage:(UIImage *)image height:(CGFloat)height;
+ (CGFloat)getMagnifiedImageHeightWithImage:(UIImage *)image width:(CGFloat)width;
+ (UIImage *)getLikeIconImageWithLiked:(BOOL)liked colorType:(NSString *)color;
+ (UIImage *)getRewardIconImageWithImagePath:(NSString *)imagePath type:(NSInteger)type;


// FRAME
+ (CGFloat)getOriginXNextToFrame:(CGRect)frame;
+ (CGFloat)getOriginYBottomToFrame:(CGRect)frame;

@end
