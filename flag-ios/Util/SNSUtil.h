//
//  SNSUtil.h
//  Dalshop
//
//  Created by Hwang Gyuyoung on 2014. 5. 14..
//
//

#import <Foundation/Foundation.h>


@interface SNSUtil : NSObject

+ (void)makeKakaoTalkLinkToKakaoTalkLinkObjects:(NSMutableDictionary *)kakaoTalkLinkObjects message:(NSString *)message imageURL:(NSString *)imageUrl imageWidth:(int)width Height:(int)height execParameter:(NSDictionary *)param;
+ (void)sendKakaoTalkLinkByKakaoTalkLinkObjects:(NSMutableDictionary *)kakaoTalkLinkObjects;
@end
