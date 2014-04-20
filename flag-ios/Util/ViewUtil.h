//
//  ViewUtil.h
//  flag-ios
//
//  Created by Gyuyoung Hwang on 2014. 2. 18..
//
//

#import <Foundation/Foundation.h>

@interface ViewUtil : NSObject

+ (UIStoryboard *)getStoryboard;
+ (CGFloat)getIOSDeviceScreenHeight;
+ (UIImage *)imageWithImage:(UIImage *)image scaledToWidth:(CGFloat)width;

@end
