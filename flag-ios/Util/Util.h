//
//  Util.h
//  flag-ios
//
//  Created by Gyuyoung Hwang on 2014. 3. 4..
//
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonDigest.h>

@class URLParameters;

@interface Util : NSObject

// STRING
+ (NSString *)getFileContentWithFileName:(NSString *)fileName;
+ (NSString *)changeStringFirstSpaceToLineBreak:(NSString *)string;
+ (NSString *)addImageParameterInImagePath:(NSString *)url width:(CGFloat)width height:(CGFloat)height;

// TEXT FIELD
+ (void)setHorizontalPaddingWithTextField:(UITextField *)textField;
+ (void)setPlaceholderAttributeWithTextField:(UITextField *)textField placeholderContent:(NSString *)string;


// ENCRYPT
+ (NSString *)encryptPasswordWithPassword:(NSString *)password;

// ALERT
+ (void)showAlertView:(id<UIAlertViewDelegate>)delegate message:(NSString *)message title:(NSString*)title;

@end
