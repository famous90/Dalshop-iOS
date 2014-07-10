//
//  ViewUtil.m
//  flag-ios
//
//  Created by Gyuyoung Hwang on 2014. 2. 18..
//
//

#import "ViewUtil.h"
#import "Util.h"

#import "SWRevealViewController.h"
#import "SaleInfoViewController.h"
#import "ItemDetailViewController.h"
#import "UserPolicyViewController.h"
#import "LoginViewController.h"
#import "CheckInPopUpViewController.h"
#import "FirstTutorialViewController.h"
#import "ItemListViewController.h"

#import "TransitionDelegate.h"
#import "AppDelegate.h"

#import "User.h"
#import "Shop.h"
#import "Item.h"

@implementation ViewUtil

+ (UIStoryboard *)getStoryboard
{
    UIStoryboard *storyboard;
    storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    
    return storyboard;
}

+ (CGFloat)getIOSDeviceScreenHeight
{
    CGSize iOSDeviceScreenSize = [[UIScreen mainScreen] bounds].size;
    return iOSDeviceScreenSize.height;
}

+ (UIImage *)imageWithImage:(UIImage *)image scaledToWidth:(CGFloat)width
{
    CGFloat scaledHeight = width * image.size.height / image.size.width;
    CGSize newSize = CGSizeMake(width, scaledHeight);
    UIGraphicsBeginImageContext( newSize );
    [image drawInRect:CGRectMake(0,0,newSize.width, newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

+ (CAGradientLayer *)gradientVerticalTop:(UIColor *)topColor bottomColor:(UIColor *)bottomColor withViewFrame:(CGRect)frame
{
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = frame;
    gradient.colors = [NSArray arrayWithObjects:(id)[topColor CGColor], (id)[bottomColor CGColor], nil];
    
    return gradient;
}

+ (CGRect)frameWithString:(NSString *)string inBoundingRect:(CGSize)size attribute:(NSDictionary *)attribute
{
    CGRect frame = [string boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:attribute context:nil];
    return frame;
}


// LOAD VIEW IN APP DELEGATE WINDOW
+ (void)initializeRootViewControllerWithUser:(User *)user window:(UIWindow *)window
{
    UIStoryboard *storyboard = [ViewUtil getStoryboard];
    SWRevealViewController *rootViewController = (SWRevealViewController *)[storyboard instantiateViewControllerWithIdentifier:@"RevealView"];
    rootViewController.user = user;
    
    [window setRootViewController:rootViewController];
}

+ (void)initializeSaleInfoViewControllerWithUser:(User *)user shopId:(NSNumber *)shopId window:(UIWindow *)window
{
    UIStoryboard *storyboard = [ViewUtil getStoryboard];
    UINavigationController *navController = (UINavigationController *)[storyboard instantiateViewControllerWithIdentifier:@"SaleInfoViewNav"];
    SaleInfoViewController *initViewController = (SaleInfoViewController *)[navController topViewController];
    initViewController.user = user;
    initViewController.shopId = shopId;
    initViewController.parentPage = INITIALIZE_VIEW_PAGE;
    
    [window setRootViewController:navController];
}

+ (void)initializeItemDetailViewControllerWithUser:(User *)user itemId:(NSNumber *)itemId window:(UIWindow *)window
{
    UIStoryboard *storyboard = [ViewUtil getStoryboard];
    UINavigationController *navController = (UINavigationController *)[storyboard instantiateViewControllerWithIdentifier:@"ItemDetailViewNav"];
    ItemDetailViewController *initViewController = (ItemDetailViewController *)[navController topViewController];
    initViewController.user = user;
    initViewController.item.itemId = itemId;
    initViewController.parentPage = INITIALIZE_VIEW_PAGE;
    
    [window setRootViewController:navController];
}


+ (void)setAppDelegatePresentingViewControllerWithViewController:(UIViewController *)viewController
{
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    delegate.presentingViewController = viewController;
}


// LOAD VIEW IN ANOTHER VIEW
+ (void)presentTabbarViewControllerInView:(UIViewController *)viewController withUser:(User *)user
{
    UIStoryboard *storyboard = [self getStoryboard];
    SWRevealViewController *childViewController = (SWRevealViewController *)[storyboard instantiateViewControllerWithIdentifier:@"RevealView"];
    childViewController.user = user;
    
    [viewController presentViewController:childViewController animated:YES completion:nil];
}

+ (void)presentUserPolicyInView:(id)viewController policyType:(NSInteger)policyType
{
    NSString *policyName = nil;
    NSString *policyFileName = nil;
    
    switch (policyType) {
        case POLICY_FOR_USER_AGREEMENT:{
            
            policyName = @"서비스 이용약관";
            policyFileName = @"user_agreement";
            break;
        }
        case POLICY_FOR_USER_INFO:{
            
            policyName = @"개인정보취급방침";
            policyFileName = @"user_info_policy";
            break;
        }
        default:
            break;
    }
    
    if ([viewController isKindOfClass:[UINavigationController class]]) {
        
    }else if ([viewController isKindOfClass:[UIViewController class]]){
        
        UIStoryboard *storyboard = [self getStoryboard];
        UINavigationController *navController = (UINavigationController *)[storyboard instantiateViewControllerWithIdentifier:@"UserPolicyViewNav"];
        UserPolicyViewController *childViewController = (UserPolicyViewController *)[navController topViewController];
        childViewController.parentPage = JOIN_VIEW_PAGE;
        childViewController.textFileName = policyFileName;
        childViewController.title = policyName;
        
        [viewController presentViewController:navController animated:YES completion:nil];
    }
}

+ (void)presentLoginViewInView:(UIViewController *)viewController withUser:(User *)user
{
    UIStoryboard *storyboard = [self getStoryboard];
    LoginViewController *childViewController = (LoginViewController *)[storyboard instantiateViewControllerWithIdentifier:@"LoginView"];
    
    childViewController.user = user;
    childViewController.parentPage = SLIDE_MENU_PAGE;
    
    [viewController presentViewController:childViewController animated:YES completion:nil];
}

+ (void)presentRewardPopUpViewInView:(UIViewController *)viewController shopId:(NSNumber *)shopId shopName:(NSString *)shopName reward:(NSNumber *)reward
{
    UIStoryboard *storyboard = [ViewUtil getStoryboard];
    CheckInPopUpViewController *popupViewController = (CheckInPopUpViewController *)[storyboard instantiateViewControllerWithIdentifier:@"CheckInPopUpView"];
    [popupViewController setShopId:shopId];
    [popupViewController setShopName:shopName];
    [popupViewController setReward:[reward integerValue]];
    
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    TransitionDelegate *transitionDelegate = delegate.transitionDelegate;
    
    popupViewController.view.backgroundColor = [UIColor colorWithWhite:0 alpha:0.7];
    [popupViewController setTransitioningDelegate:transitionDelegate];
    popupViewController.modalPresentationStyle = UIModalPresentationCustom;
    
    [viewController presentViewController:popupViewController animated:YES completion:nil];
}

+ (void)presentTutorialInView:(UIViewController *)viewController type:(NSInteger)type
{
    if (type == TUTORIAL_REWARD_DESCRIPTION) {
        UIStoryboard *storyboard = [ViewUtil getStoryboard];
        FirstTutorialViewController *tutorialViewController = (FirstTutorialViewController *)[storyboard instantiateViewControllerWithIdentifier:@"FirstTutorialView"];
        
        AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        TransitionDelegate *transitionDelegate = delegate.transitionDelegate;
        
        tutorialViewController.view.backgroundColor = [UIColor colorWithWhite:0 alpha:0.8];
        [tutorialViewController setTransitioningDelegate:transitionDelegate];
        [tutorialViewController setModalPresentationStyle:UIModalPresentationCustom];
        
        [viewController presentViewController:tutorialViewController animated:YES completion:nil];
    }
}

+ (void)presentItemListViewNavInView:(UIViewController *)viewController withUser:(User *)user shopId:(NSNumber *)shopId shopName:(NSString *)shopName withParentPageNumber:(NSInteger)parentPage
{
    UIStoryboard *storyboard = [self getStoryboard];
    UINavigationController *navController = (UINavigationController *)[storyboard instantiateViewControllerWithIdentifier:@"ItemListViewNav"];
    ItemListViewController *childViewController = (ItemListViewController *)[navController topViewController];
    
    [childViewController setUser:user];
    [childViewController.shop setShopId:shopId];
    [childViewController.shop setName:shopName];
    [childViewController setParentPage:parentPage];
    
    [viewController presentViewController:navController animated:YES completion:nil];
}


// DRAW LINE
+ (UIImage *)drawDiagonalCrossLineOnFrame:(CGRect)frame
{
    UIGraphicsBeginImageContext(frame.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetStrokeColorWithColor(context, UIColorFromRGB(BASE_COLOR).CGColor);
    CGContextSetFillColorWithColor(context, [[UIColor whiteColor] CGColor]);
    
    CGContextFillRect(context, frame);
    
    CGContextSetLineWidth(context, 1.0f);
    CGContextMoveToPoint(context, frame.size.width, 0);
    CGContextAddLineToPoint(context, 0, frame.size.height);
    CGContextStrokePath(context);
    
    CGContextSetLineWidth(context, 1.0f);
    CGContextMoveToPoint(context, 0, 0);
    CGContextAddLineToPoint(context, frame.size.width, frame.size.height);
    CGContextStrokePath(context);
    
    UIImage *result = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return result;
}

+ (UIImage *)drawBorderLineOnFrame:(CGRect)frame byCellRow:(NSInteger)row
{
    CGFloat topBorderLineLeftSpace = 0;
    CGFloat topBorderLineRightSpace = 0;
    CGFloat leftBorderLineVerticalSpace = 5.0f;
    CGFloat leftBorderLineWidth = 1.0f;
    
    if (row%3 == 0) {
        topBorderLineLeftSpace = 5.0f;
        leftBorderLineWidth = 0;
    }else if (row%3 == 1) {

    }else if (row%3 == 2){
        topBorderLineRightSpace = 5.0f;
    }
    
    UIGraphicsBeginImageContext(frame.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetStrokeColorWithColor(context, UIColorFromRGB(BASE_COLOR).CGColor);
    CGContextSetFillColorWithColor(context, [[UIColor whiteColor] CGColor]);
    
    CGContextFillRect(context, frame);
    
    // top line
    CGContextSetLineWidth(context, 1.0f);
    CGContextMoveToPoint(context, topBorderLineLeftSpace, 0);
    CGContextAddLineToPoint(context, frame.size.width - topBorderLineRightSpace, 0);
    CGContextStrokePath(context);
    
    // right line
    CGContextSetLineWidth(context, leftBorderLineWidth);
    CGContextMoveToPoint(context, 0, leftBorderLineVerticalSpace);
    CGContextAddLineToPoint(context, 0, frame.size.height - leftBorderLineVerticalSpace);
    CGContextStrokePath(context);
    
    UIImage *result = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return result;
}


// IMAGE
+ (CGFloat)getMagnifiedImageWidthWithImage:(UIImage *)image height:(CGFloat)height
{
    CGFloat width = height * (image.size.width) / (image.size.height);
    return width;
}

+(CGFloat)getMagnifiedImageHeightWithImage:(UIImage *)image width:(CGFloat)width
{
    CGFloat height = width * (image.size.height) / (image.size.width);
    return height;
}

+ (UIImage *)getLikeIconImageWithLiked:(BOOL)liked colorType:(NSString *)color
{
    NSString *iconImageName = @"icon_likeIt";
    if (liked) {
        iconImageName = [iconImageName stringByAppendingString:@"_done"];
    }
    iconImageName = [iconImageName stringByAppendingString:[NSString stringWithFormat:@"_%@", color]];
    
    UIImage *likeIconImage = [UIImage imageNamed:iconImageName];
    
    return likeIconImage;
}

+ (UIImage *)getRewardIconImageWithImagePath:(NSString *)path type:(NSInteger)type
{
    NSString *imagePath = path;
    if (type == REWARD_STATE_BEFORE) {
        imagePath = [imagePath stringByAppendingString:@"_before"];
    }else if (type == REWARD_STATE_DONE){
        imagePath = [imagePath stringByAppendingString:@"_done"];
    }else if (type == REWARD_STATE_DISABLED){
        imagePath = [imagePath stringByAppendingString:@"_disabled"];
    }
    
    UIImage *image = [UIImage imageNamed:imagePath];
    
    return image;
}


// FRAME
+ (CGFloat)getOriginXNextToFrame:(CGRect)frame
{
    CGFloat originX = frame.origin.x + frame.size.width;
    return originX;
}

+ (CGFloat)getOriginYBottomToFrame:(CGRect)frame
{
    CGFloat originY = frame.origin.y + frame.size.height;
    return originY;
}

@end
