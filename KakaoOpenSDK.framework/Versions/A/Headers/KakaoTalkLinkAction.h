/**
 * Copyright 2014 Kakao Corp.
 *
 * Redistribution and modification in source or binary forms are not permitted without specific prior written permission.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *    http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

/*!
 @header KakaoTalkLinkAction.h
 링크/버튼 객체를 생성할 시에 필요한 Action객체 <br>
 즉 카카오링크가 생성한 링크/버튼을 클릭할 시에 이루어질 Action에 대한 정의를 담고 있다.
 */
#import <Foundation/Foundation.h>

/*!
 @abstract KakaoTalkLinkActionPlatformType 카카오톡 링크 Action 의 os type
 @constant KakaoTalkLinkActionOSPlatformAndroid 안드로이드
 @constant KakaoTalkLinkActionOSPlatformIOS iOS
 */
typedef NS_ENUM(NSInteger, KakaoTalkLinkActionOSPlatform) {
    KakaoTalkLinkActionOSPlatformAndroid = 0,
    KakaoTalkLinkActionOSPlatformIOS
};

/*!
 @abstract KakaoTalkLinkActionDeviceType 카카오톡 링크 Action 의 디바이스 종류
 @constant KakaoTalkLinkActionDeviceTypePhone 폰
 @constant KakaoTalkLinkActionDeviceTypePad 패드
 */
typedef NS_ENUM(NSInteger, KakaoTalkLinkActionDeviceType) {
    KakaoTalkLinkActionDeviceTypePhone = 0,
    KakaoTalkLinkActionDeviceTypePad
};

/*!
 링크/버튼 객체를 생성할 시에 필요한 Action객체 <br>
 즉 카카오링크가 생성한 링크/버튼을 클릭할 시에 이루어질 Action에 대한 정의를 담고 있다.
 */
@interface KakaoTalkLinkAction : NSObject

@property (nonatomic, readonly) NSString *type;
@property (nonatomic, readonly) NSString *URL;
@property (nonatomic, readonly) NSString *OS;
@property (nonatomic, readonly) NSString *devicetype;
@property (nonatomic, readonly) NSString *execparam;

+ (KakaoTalkLinkAction*)createWebAction;

/*!
 @abstract 웹용 Action을 생성한다.
 @param url 웹 url
*/
+ (KakaoTalkLinkAction*)createWebAction:(NSString*)url;

//+ (KakaoTalkLinkAction*)createAppAction;

/*!
 @abstract 앱용 Action을 생성한다.
 @param os 단말의 OS Platform. KakaoTalkLinkActionOSPlatform enum 참조.
 @param devicetype 단말의 종류. KakaoTalkLinkActionDeviceType enum 참조.
 @param execparam 애플리케이션 구동 url 의 parameter
 */
+ (KakaoTalkLinkAction*)createAppAction:(KakaoTalkLinkActionOSPlatform)os
                             devicetype:(KakaoTalkLinkActionDeviceType)devicetype
                              execparam:(NSDictionary*)execparam;

@end