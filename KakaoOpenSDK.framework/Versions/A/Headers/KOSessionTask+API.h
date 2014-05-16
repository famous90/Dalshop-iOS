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
 @header KOSessionTask+API.h
 인증된 session 정보를 바탕으로 각종 API를 호출한다.
 */

/*!
 인증된 session 정보를 바탕으로 각종 API를 호출한다.
 */
@interface KOSessionTask (API)

/*!
 @abstract KOStoryPostPermission 스토리 포스팅 공개 범위
 @constant KOStoryPostPermissionPublic 전체공개
 @constant KOStoryPostPermissionFriend 친구공개
 */
typedef NS_ENUM(NSInteger, KOStoryPostPermission) {
    KOStoryPostPermissionPublic = 0,
    KOStoryPostPermissionFriend
};

/*!
 @abstract 현재 로그인된 사용자의 카카오톡 프로필 정보를 얻는다.
 @param completionHandler 카카오톡 프로필 정보를 얻어 처리하는 핸들러.
 @discussion
 */
+ (instancetype)talkProfileTaskWithCompletionHandler:(KOSessionTaskCompletionHandler)completionHandler;

/*!
 @abstract 현재 로그인된 사용자의 카카오스토리 프로필 정보를 얻는다.
 @param completionHandler 스토리 프로필 정보를 얻어 처리하는 핸들러.
 @discussion
 */
+ (instancetype)storyProfileTaskWithCompletionHandler:(KOSessionTaskCompletionHandler)completionHandler;

/*!
 @abstract 현재 로그인된 사용자에 대한 정보를 얻는다.
 @param completionHandler 사용자 정보를 얻어 처리하는 핸들러.
 @discussion
 */
+ (instancetype)meTaskWithCompletionHandler:(KOSessionTaskCompletionHandler)completionHandler;

/*!
 @abstract 현재 로그인된 사용자의 속성(Property)를 설정한다.
 @param properties 갱신할 사용자 정보
 @param completionHandler 요청 완료시 실행될 handler
 */
+ (instancetype)profileUpdateTaskWithProperties:(NSDictionary*)properties
                              completionHandler:(void(^)(BOOL success, NSError* error))completionHandler;

/*!
 @abstract 카카오 서비스와 앱을 연동한다. (가입)
 @param properties 가입시 함께 설정할 사용자 정보
 @param completionHandler 요청 완료시 실행될 handler
 */
+ (instancetype)signupTaskWithProperties:(NSDictionary*)properties
                       completionHandler:(void(^)(BOOL success, NSError* error))completionHandler;

/*!
 @abstract 카카오 서비스와 앱 연동을 해제한다. (탈퇴)
 @param completionHandler 요청 완료시 실행될 handler
 */
+ (instancetype)unlinkTaskWithCompletionHandler:(void(^)(BOOL success, NSError* error))completionHandler;

/*!
 @abstract 로컬 이미지 파일을 story에 업로드합니다.
 @param image
 */
+ (instancetype)storyImageUploadTaskWithImage:(UIImage*)image completionHandler:(KOSessionTaskCompletionHandler)completionHandler;

/*!
 @abstract 로컬 이미지 파일을 데이타 형식으로 story에 업로드합니다.
 @param image
 */
+ (instancetype)storyImageUploadTaskWithImageData:(NSData*)imageData completionHandler:(KOSessionTaskCompletionHandler)completionHandler;

/*!
 @abstract 카카오 스토리에 POST한다.
 @param content 내용
 @param imageUrl 이미지 url ( uploadStoryImage 후 리턴되는 url 을 설정 )
 @param androidExecParam 안드로이드 앱연결 링크에 추가할 파라미터 설정
 @param iosExecParam iOS 앱연결 링크에 추가할 파라미터 설정
 @param completionHandler 요청 완료시 실행될 handler
 */
+ (instancetype)storyPostTaskWithContent:(NSString*)content
                              permission:(KOStoryPostPermission)permission
                                imageUrl:(NSString*)imageUrl
                        androidExecParam:(NSDictionary*)androidExecParam
                            iosExecParam:(NSDictionary*)iosExecParam
                       completionHandler:(void(^)(BOOL success, NSError* error))completionHandler;

@end
