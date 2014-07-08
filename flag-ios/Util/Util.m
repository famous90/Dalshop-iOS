//
//  Util.m
//  flag-ios
//
//  Created by Gyuyoung Hwang on 2014. 3. 4..
//
//

#import "Util.h"

#import "URLParameters.h"

@implementation Util


// STRING
+ (NSString *)getFileContentWithFileName:(NSString *)fileName
{
    
    NSString* content;
    NSString* path = [[NSBundle mainBundle] pathForResource:fileName ofType:@"txt"];
    
    if(path)
    {
        content = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:NULL];
    }
    
    return content;
}

+ (NSString *)changeStringFirstSpaceToLineBreak:(NSString *)string
{
    if ([string rangeOfString:@" "].location == NSNotFound) {
    
        return string;
        
    }else{
        
        NSUInteger indexOfSpace = [string rangeOfString:@" "].location;
        NSRange range = NSMakeRange(indexOfSpace, 1);
        NSString *changedString = [string stringByReplacingCharactersInRange:range withString:@"\n"];
        
        return changedString;
    }
}

+ (NSString *)addImageParameterInImagePath:(NSString *)url width:(CGFloat)width height:(CGFloat)height
{
    url = [url stringByAppendingFormat:@"&width=%.0f&height=%.0f", width, height];
    return url;
}

+ (BOOL)isContainedSubString:(NSString *)subString inString:(NSString *)string
{
    NSRange range = NSMakeRange(0, [subString length]);
    NSString *stringWithRange = [string substringWithRange:range];
    
    if ([subString isEqualToString:stringWithRange]) {
        return YES;
    }else return NO;
}

// TEXT FIELD

+ (void)setHorizontalPaddingWithTextField:(UITextField *)textField
{
    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, textField.frame.size.height)];
    
    textField.leftView = paddingView;
    textField.leftViewMode = UITextFieldViewModeAlways;
    
    textField.rightView = paddingView;
    textField.rightViewMode = UITextFieldViewModeAlways;
}

+ (void)setPlaceholderAttributeWithTextField:(UITextField *)textField placeholderContent:(NSString *)string
{
    if ([textField respondsToSelector:@selector(setAttributedPlaceholder:)]) {
        
        UIColor *color = [UIColor colorWithRed:34.0f/255.0f green:173.0f/255.0f blue:167.0f/255.0f alpha:0.3];
        UIFont *font = [UIFont fontWithName:@"helvetica" size:12];
        NSDictionary *placeholderAttribute = [NSDictionary dictionaryWithObjectsAndKeys:color, NSForegroundColorAttributeName, font, NSFontAttributeName,nil];
        
        textField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:string attributes:placeholderAttribute];
        
    } else {
        NSLog(@"Cannot set placeholder text's color, because deployment target is earlier than iOS 6.0");
    }
}

+ (void)textFieldHasProblemWithTextField:(UITextField *)textField message:(NSString *)message alertTitle:(NSString *)title
{
    [self showAlertView:nil message:message title:title];
    [textField becomeFirstResponder];
}


// ENCRYPT

+ (NSString *)encryptPasswordWithPassword:(NSString *)password
{
    const char *str = [password UTF8String];
    unsigned char result[CC_SHA256_DIGEST_LENGTH];
    CC_SHA256(str, (CC_LONG)strlen(str), result);
    
    NSMutableString *ret = [NSMutableString stringWithCapacity:CC_SHA256_DIGEST_LENGTH*2];
    for(int i = 0; i<CC_SHA256_DIGEST_LENGTH ; i++){
        [ret appendFormat:@"%02x", result[i]];
    }
    return ret;
}


// ALERT

+ (void)showAlertView:(id<UIAlertViewDelegate>)delegate message:(NSString *)message title:(NSString*)title
{
    if ( message == nil || [message isKindOfClass:[NSNull class]] )
        return ;
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
													message:message
												   delegate:delegate
										  cancelButtonTitle:@"확인"
										  otherButtonTitles:nil];
    
	[alert show];
}


// NOTIFICATION

+ (void)showLocalNotificationAtDate:(NSDate *)date message:(NSString *)message
{
    UILocalNotification *localNotification = [[UILocalNotification alloc] init];
    if (localNotification) {
        localNotification.fireDate = date;
        localNotification.timeZone = [NSTimeZone defaultTimeZone];
        localNotification.repeatInterval = 0;
        localNotification.alertBody = message;
        [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
    }
}

+ (void)showLocalNotificationWithUserInfo:(NSDictionary *)userInfo atDate:(NSDate *)date message:(NSString *)message
{
    UILocalNotification *localNotification = [[UILocalNotification alloc] init];
    if (localNotification) {
        localNotification.fireDate = date;
        localNotification.timeZone = [NSTimeZone defaultTimeZone];
        localNotification.repeatInterval = 0;
        localNotification.alertBody = message;
        localNotification.userInfo = userInfo;
        [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
    }
}


// FILE
+ (NSArray *)getListFromPropertyListFile:(NSString *)fileName
{
    NSBundle *bundle = [NSBundle mainBundle];
    NSURL *plistURL = [bundle URLForResource:fileName withExtension:@"plist"];
    NSArray *list = [NSArray arrayWithContentsOfURL:plistURL];
    
    return list;
}


// DISTANCE
+ (NSString *)distanceFromLocation:(CLLocation *)location1 toLocation:(CLLocation *)location2
{
    CLLocationDistance metersForDistance = [location1 distanceFromLocation:location2];
    
    if (metersForDistance < 1000.0f) {
        return [NSString stringWithFormat:@"%.0fm", metersForDistance];
    }else{
        return [NSString stringWithFormat:@"%.1fkm", metersForDistance/1000];
    }
}

+ (BOOL)IsWithInRangeOfErrorDistance:(NSInteger)distance fromLocation:(CLLocation *)fromLocation toLocation:(CLLocation *)toLocation
{
    CLLocationDistance theDistance = [fromLocation distanceFromLocation:toLocation];
    
    if (theDistance > distance) {
        return NO;
    }else return YES;
}


// URL
+ (NSMutableDictionary *)dictionaryWithURLParameter:(NSURL *)url
{
    NSString *query = [url query];
    NSArray *pairs = [query componentsSeparatedByString:@"&"];
    NSMutableDictionary *kvPairs = [NSMutableDictionary dictionary];
    
    if ([pairs count]) {
        for (int i=0; i<[pairs count]-1; i++) {
            NSString *pair = [pairs objectAtIndex:i];
            NSArray *bits = [pair componentsSeparatedByString:@"="];
            NSString *key = [[bits objectAtIndex:0] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            NSString *value = [[bits objectAtIndex:1] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            [kvPairs setObject:value forKey:key];
        }
    }
    return kvPairs;
}


// NUMBER
+ (BOOL)isCorrectPhoneNumberForm:(NSString *)number
{
    if ([number isEqual:(id)[NSNull null]]) {
        NSLog(@"phone number null");
        return NO;
    }else if ([number length] == 0){
        NSLog(@"phone number no length");
        return NO;
    }else if ([number length] < 9){
        NSLog(@"phone number too short");
        return NO;
    }else if ([number rangeOfString:@"-"].location != NSNotFound){
        NSLog(@"phone number dash contained");
        return NO;
    }else if ([number characterAtIndex:0] != '0'){
        NSLog(@"phone number not start with 0");
        return NO;
    }
    
    return YES;
}

+ (NSString *)addNationalCodeToNumber:(NSString *)number
{
    NSRange range = NSMakeRange(0, 1);
    NSString *numberWithNationalCode = [number stringByReplacingCharactersInRange:range withString:@"+82"];
    NSLog(@"number with national code %@", numberWithNationalCode);
    
    return numberWithNationalCode;
}


// NAME
+ (NSString *)getRewardButtonTitleWithType:(NSInteger)type reward:(NSInteger)reward
{
    NSString *title;
    
    if (type == REWARD_STATE_BEFORE) {
        title = [NSString stringWithFormat:@"%ld달", (long)reward];
    }else if (type == REWARD_STATE_DISABLED){
        title = @"적립불가";
    }else if (type == REWARD_STATE_DONE){
        title = @"적립완료";
    }
    
    return title;
}



// COLOR
+ (UIColor *)getRewardButtonColorWithType:(NSInteger)type
{
    UIColor *color;
    
    if (type == REWARD_STATE_BEFORE) {
        color = [UIColor whiteColor];
    }else if (type == REWARD_STATE_DISABLED){
        color = [UIColor colorWithWhite:0.4 alpha:1];
    }else if (type == REWARD_STATE_DONE){
        color = [UIColor whiteColor];
    }
    
    return color;
}

+ (UIColor *)getRewardButtonBackgroundColorWithType:(NSInteger)type page:(NSInteger)page
{
    UIColor *color;
    
    if (page == SHOP_LIST_VIEW_PAGE) {
        
        if (type == REWARD_STATE_BEFORE) {
            color = UIColorFromRGBWithAlpha(0xf2b518, 0.7);
        }else if (type == REWARD_STATE_DISABLED){
            color = [UIColor whiteColor];
        }else if (type == REWARD_STATE_DONE){
            color = UIColorFromRGB(0xf2b518);
        }
        
    }else if (page == ITEM_LIST_VIEW_PAGE){
        
        if (type == REWARD_STATE_BEFORE) {
            color = UIColorFromRGBWithAlpha(0xf2b518, 0.7);
        }else if (type == REWARD_STATE_DISABLED){
            color = [UIColor colorWithWhite:0.8 alpha:0.4];
        }else if (type == REWARD_STATE_DONE){
            color = UIColorFromRGBWithAlpha(0xf2b518, 0.7);
        }
        
    }
    
    return color;
}


// INDEXPATH
+ (CGPoint)getPointForTappedObjectWithSender:(id)sender toView:(UIView *)view
{
    CGPoint senderOriginInView = [sender convertPoint:CGPointZero toView:view];
    
    return senderOriginInView;
}

@end
