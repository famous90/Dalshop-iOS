//
//  SNSUtil.m
//  Dalshop
//
//  Created by Hwang Gyuyoung on 2014. 5. 14..
//
//

#import "SNSUtil.h"

#import <KakaoOpenSDK/KakaoOpenSDK.h>
#import "Util.h"

@implementation SNSUtil

+ (void)makeKakaoTalkLinkToKakaoTalkLinkObjects:(NSMutableDictionary *)kakaoTalkLinkObjects message:(NSString *)message imageURL:(NSString *)imageUrl imageWidth:(int)width Height:(int)height execParameter:(NSDictionary *)param
{
    // label
    KakaoTalkLinkObject *label = [KakaoTalkLinkObject createLabel:message];
    [kakaoTalkLinkObjects setObject:label forKey:@"label"];
    
    
    // image
    KakaoTalkLinkObject *image = [KakaoTalkLinkObject createImage:imageUrl width:width height:height];
    [kakaoTalkLinkObjects setObject:image forKey:@"image"];
    
    
    // button
    KakaoTalkLinkAction *androidAppAction = [KakaoTalkLinkAction createAppAction:KakaoTalkLinkActionOSPlatformAndroid devicetype:KakaoTalkLinkActionDeviceTypePhone execparam:param];
    KakaoTalkLinkAction *iphoneAppAction = [KakaoTalkLinkAction createAppAction:KakaoTalkLinkActionOSPlatformIOS devicetype:KakaoTalkLinkActionDeviceTypePhone execparam:param];
    KakaoTalkLinkObject *button = [KakaoTalkLinkObject createAppButton:@"달shop" actions:@[androidAppAction, iphoneAppAction]];
    [kakaoTalkLinkObjects setObject:button forKey:@"button"];
}

+ (void)sendKakaoTalkLinkByKakaoTalkLinkObjects:(NSMutableDictionary *)kakaoTalkLinkObjects
{
    if ([kakaoTalkLinkObjects count] < 1) {
        [Util showAlertView:nil message:NSLocalizedString(@"Check KakaoTalk", @"Check KakaoTalk") title:NSLocalizedString(@"KakaoTalk Link Error", @"KakaoTalk Link Error")];
        return;
    }
    
    if ([KOAppCall canOpenKakaoTalkAppLink]) {
        [KOAppCall openKakaoTalkAppLink:[kakaoTalkLinkObjects allValues]];
    }
}

@end
