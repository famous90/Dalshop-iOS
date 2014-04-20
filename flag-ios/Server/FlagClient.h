//
//  FlagClient.h
//  flag-ios
//
//  Created by Gyuyoung Hwang on 2014. 3. 18..
//
//

#import <Foundation/Foundation.h>

@class ImageDataController;
@class GTLServiceFlagengine;

@interface FlagClient : NSObject

+ (UIImage *)getImageWithImagePath:(NSString *)imagePath;
+ (NSDictionary *)getURLResultWithURL:(NSURL *)url;
+ (void) setImageFromUrl:(NSString*)urlString imageDataController:(ImageDataController *)imageDataController itemId:(NSNumber *)itemId view:(id)view completion:(void (^)(void))completion;

+ (GTLServiceFlagengine *)flagengineService;

@end
