//
//  ViewUtil.m
//  flag-ios
//
//  Created by Gyuyoung Hwang on 2014. 2. 18..
//
//

#import "ViewUtil.h"

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

@end
