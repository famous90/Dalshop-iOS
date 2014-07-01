//
//  Util.h
//  flag-ios
//
//  Created by Gyuyoung Hwang on 2014. 3. 4..
//
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonDigest.h>
#import <CoreLocation/CoreLocation.h>

@class URLParameters;

@interface Util : NSObject

// STRING
+ (NSString *)getFileContentWithFileName:(NSString *)fileName;
+ (NSString *)changeStringFirstSpaceToLineBreak:(NSString *)string;
+ (NSString *)addImageParameterInImagePath:(NSString *)url width:(CGFloat)width height:(CGFloat)height;
+ (BOOL)isContainedSubString:(NSString *)subString inString:(NSString *)string;


// TEXT FIELD
+ (void)setHorizontalPaddingWithTextField:(UITextField *)textField;
+ (void)setPlaceholderAttributeWithTextField:(UITextField *)textField placeholderContent:(NSString *)string;
+ (void)textFieldHasProblemWithTextField:(UITextField *)textField message:(NSString *)message alertTitle:(NSString *)title;


// ENCRYPT
+ (NSString *)encryptPasswordWithPassword:(NSString *)password;


// ALERT
+ (void)showAlertView:(id<UIAlertViewDelegate>)delegate message:(NSString *)message title:(NSString*)title;


// NOTIFICATION
+ (void)showLocalNotificationAtDate:(NSDate *)date message:(NSString *)message;
+ (void)showLocalNotificationWithUserInfo:(NSDictionary *)userInfo atDate:(NSDate *)date message:(NSString *)message;


// FILE
+ (NSArray *)getListFromPropertyListFile:(NSString *)fileName;


// DISTANCE
+ (NSString *)distanceFromLocation:(CLLocation *)location1 toLocation:(CLLocation *)location2;
+ (BOOL)IsWithInRangeOfErrorDistance:(NSInteger)distance fromLocation:(CLLocation *)fromLocation toLocation:(CLLocation *)toLocation;


// URL
+ (NSMutableDictionary *)dictionaryWithURLParameter:(NSURL *)url;


// NUMBER
+ (BOOL)isCorrectPhoneNumberForm:(NSString *)number;
+ (NSString *)addNationalCodeToNumber:(NSString *)number;

@end
