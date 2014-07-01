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
@class URLParameters;

@interface FlagClient : NSObject

// IMAGE
+ (UIImage *)getImageWithImagePath:(NSString *)imagePath;
+ (void) setImageFromUrl:(NSString*)urlString imageDataController:(ImageDataController *)imageDataController itemId:(NSNumber *)itemId view:(id)view completion:(void (^)(UIImage *image))completion;
+ (void) getImageWithImageURL:(NSString*)urlString imageDataController:(ImageDataController *)imageDataController objectId:(NSNumber *)objectId view:(id)view type:(NSInteger)type completion:(void (^)(UIImage *image))completion;
+ (void)getImageWithImageURL:(NSString *)imageUrl imageDataController:(ImageDataController *)imageData objectId:(NSNumber *)objectId objectType:(NSInteger)type view:(id)view completion:(void (^)(UIImage *image))completion;


// DATA
+ (NSDictionary *)getURLResultWithURL:(NSURL *)url;
+ (void)getDataResultWithURL:(NSURL *)url methodName:(NSString *)methodName completion:(void (^)(NSDictionary *results))completion;

+ (GTLServiceFlagengine *)flagengineService;

@end
