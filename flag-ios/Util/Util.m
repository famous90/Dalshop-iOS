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
+ (void)showAlertView:(id<UIAlertViewDelegate>)delegate message:(NSString *)message title:(NSString *)title
{
    if ( message == nil || [message isKindOfClass:[NSNull class]] )
        return ;
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
													message:message
												   delegate:delegate
										  cancelButtonTitle:title
										  otherButtonTitles:nil];
    
	[alert show];
}

@end
