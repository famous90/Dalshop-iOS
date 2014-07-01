//
//  FlagClient.m
//  flag-ios
//
//  Created by Gyuyoung Hwang on 2014. 3. 18..
//
//


#import "FlagClient.h"

#import "GTLFlagengine.h"
#import "GTMHTTPFetcherLogging.h"

#import "ImageDataController.h"

#import "URLParameters.h"

@implementation FlagClient

// IMAGE
+ (UIImage *)getImageWithImagePath:(NSString *)imagePath
{
    NSError *error;
    NSURL *url = [NSURL URLWithString:imagePath];
    NSData *data = [[NSData alloc] initWithContentsOfURL:url];
    UIImage *image = [[UIImage alloc] initWithData:data];
    
    if (!data) {
        NSLog(@"Image download failed : %@", error.localizedDescription);
        return nil;
    }
    
    return image;
}

+ (void) setImageFromUrl:(NSString*)urlString
     imageDataController:(ImageDataController *)imageDataController
                  itemId:(NSNumber *)itemId
                    view:(id)view
              completion:(void (^)(UIImage *image))completion {
    
    NSDate *startDate = [NSDate date];
    
	dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        UIImage *avatarImage = nil;
        NSURL *url = [NSURL URLWithString:urlString];
        NSData *responseData = [NSData dataWithContentsOfURL:url];
        avatarImage = [UIImage imageWithData:responseData];
        
        if (avatarImage) {
            dispatch_async(dispatch_get_main_queue(), ^{
//                NSLog(@"image width %f height %f", avatarImage.size.width, avatarImage.size.height);
                [imageDataController
                 addImageWithImage:avatarImage withId:itemId];
                completion(avatarImage);
                
                if ([view isKindOfClass:[UICollectionView class]]) {
                    
                    [view reloadData];
                    
                }else if ([view isKindOfClass:[UITableView class]]) {
                    
                    [view reloadData];
                    
                }else if ([view isKindOfClass:[UIView class]]){
                    
                    [view reloadInputViews];
                    
                }
                
                [GAUtil sendGADataLoadTimeWithInterval:[[NSDate date] timeIntervalSinceDate:startDate] actionName:@"get_image" label:nil];
            });
//            dispatch_async(dispatch_get_main_queue(), completion);
        }
        else {
            NSLog(@"-- impossible download: %@", urlString);
        }
	});
}

+ (void)getImageWithImageURL:(NSString *)urlString imageDataController:(ImageDataController *)imageDataController objectId:(NSNumber *)objectId view:(id)view type:(NSInteger)type completion:(void (^)(UIImage *))completion
{
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        
//        UIImage *avatarImage = nil;
//        NSURL *url = [NSURL URLWithString:urlString];
//        NSData *responseData = [NSData dataWithContentsOfURL:url];
//        avatarImage = [UIImage imageWithData:responseData];
//        
//        if (avatarImage) {
//            dispatch_async(dispatch_get_main_queue(), ^{
//                [imageDataController
//                 addImageWithImage:avatarImage withId:objectId];
//                completion(avatarImage);
//                
//                if ([view isKindOfClass:[UICollectionView class]]) {
//                    
//                    [view reloadData];
//                    
//                }else if ([view isKindOfClass:[UITableView class]]) {
//                    
//                    [view reloadData];
//                    
//                }else if ([view isKindOfClass:[UIView class]]){
//                    
//                    [view reloadInputViews];
//                    
//                }
//            });
//        }
//        else {
//            NSLog(@"-- impossible download: %@", urlString);
//        }
//	});
}

+ (void)getImageWithImageURL:(NSString *)imageUrl
         imageDataController:(ImageDataController *)imageData
                    objectId:(NSNumber *)objectId
                  objectType:(NSInteger)type 
                        view:(id)view
                  completion:(void (^)(UIImage *))completion
{
    NSDate *startDate = [NSDate date];
    NSString *imageType;
    if (type == IMAGE_SHOP_LOGO) {
        imageType = @"shop_logo";
    }else if (type == IMAGE_SHOP_EVENT){
        imageType = @"shop_event";
    }else if (type == IMAGE_ITEM){
        imageType = @"item";
    }
    NSString *methodName = @"get_";
    methodName = [methodName stringByAppendingString:imageType];
    
	dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        UIImage *avatarImage = nil;
        NSURL *url = [NSURL URLWithString:imageUrl];
        NSData *responseData = [NSData dataWithContentsOfURL:url];
        avatarImage = [UIImage imageWithData:responseData];
        
        if (avatarImage) {
            dispatch_async(dispatch_get_main_queue(), ^{
                
                if (imageData) {
                    [imageData addImageWithImage:avatarImage withId:objectId];                    
                }
                completion(avatarImage);
                
                if ([view isKindOfClass:[UICollectionView class]]) {
                    
                    [view reloadData];
                    
                }else if ([view isKindOfClass:[UITableView class]]) {
                    
                    [view reloadData];
                    
                }else if ([view isKindOfClass:[UIView class]]){
                    
                    [view reloadInputViews];
                    
                }
                
                [GAUtil sendGADataLoadTimeWithInterval:[[NSDate date] timeIntervalSinceDate:startDate] actionName:methodName label:nil];
            });
            //            dispatch_async(dispatch_get_main_queue(), completion);
        }
        else {
            NSLog(@"-- impossible download: %@", imageUrl);
        }
	});
}


// DATA
+ (NSDictionary *)getURLResultWithURL:(NSURL *)url
{
    NSError *error;
    
    // send request
    NSLog(@"request url %@", url);
    NSData *jsonDataString = [[NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:nil] dataUsingEncoding:NSUTF8StringEncoding];
    
    if (!jsonDataString) {
        NSLog(@"Download failed : %@", error.localizedDescription);
        return nil;
    }
    
    NSDictionary *results = [NSJSONSerialization JSONObjectWithData:jsonDataString options:NSJSONReadingMutableContainers error:&error];
    NSLog(@"data response results : %@", results);
    
    return results;
}

+ (void)getDataResultWithURL:(NSURL *)url methodName:(NSString *)methodName completion:(void (^)(NSDictionary *))completion
{
    NSDate *startTime = [NSDate date];
//    NSString *actionName = @"get_";
//    actionName = [actionName stringByAppendingString:methodName];
//    NSLog(@"ui_action_name %@", actionName);
    
    [[[NSOperationQueue alloc] init] addOperationWithBlock:^{
    
        NSDictionary *results = [self getURLResultWithURL:url];
        
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
           
            NSDate *now = [NSDate date];
            [GAUtil sendGADataLoadTimeWithInterval:[now timeIntervalSinceDate:startTime] actionName:methodName label:nil];
            completion(results);
            
        }];
    }];
}

+ (GTLServiceFlagengine *)flagengineService
{
    static GTLServiceFlagengine *service = nil;
    if (!service) {
        service = [[GTLServiceFlagengine alloc] init];
        
        // Have the service object set tickets to retry temporary error conditions automatically
        service.retryEnabled = YES;
        
        [GTMHTTPFetcher setLoggingEnabled:YES];
    }
    
    return service;
}

@end
