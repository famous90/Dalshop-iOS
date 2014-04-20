//
//  ActivityIndicatorView.m
//  flag-ios
//
//  Created by Gyuyoung Hwang on 2014. 3. 31..
//
//

#import "ActivityIndicatorView.h"

@implementation ActivityIndicatorView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

+ (ActivityIndicatorView *)startActivityIndicatorInParentView:(UIView *)parentView
{
    ActivityIndicatorView *activityIndicatorView = [[[UINib nibWithNibName:@"ActivityIndicatorView" bundle:nil] instantiateWithOwner:nil options:nil] objectAtIndex:0];
    
    [parentView addSubview:activityIndicatorView];
    activityIndicatorView.frame = parentView.frame;
    [activityIndicatorView setAlpha:0.0f];
    
    [UIView animateWithDuration:.3f animations:^(){
        [activityIndicatorView setAlpha:1.0f];
    } completion:^(BOOL finished){}];
    
    return activityIndicatorView;
}

- (void)stopActivityIndicator
{
    [UIView animateWithDuration:.3f animations:^(){
        
        [self setAlpha:0.0f];
        
    }completion:^(BOOL finished){
        
        [self removeFromSuperview];
        
    }];
}

//- (void)setActivityIndicatorText

@end
