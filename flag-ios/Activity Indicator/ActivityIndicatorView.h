//
//  ActivityIndicatorView.h
//  flag-ios
//
//  Created by Gyuyoung Hwang on 2014. 3. 31..
//
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface ActivityIndicatorView : UIView

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

+ (ActivityIndicatorView *)startActivityIndicatorInParentView:(UIView *)parentView;
- (void)stopActivityIndicator;

@end
