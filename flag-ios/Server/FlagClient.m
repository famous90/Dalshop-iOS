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

@implementation FlagClient

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

+ (NSDictionary *)getURLResultWithURL:(NSURL *)url
{
    NSError *error;
    
    // send request
    NSLog(@"request url %@", url);
    NSData *jsonDataString = [[NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:nil] dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *results = [NSJSONSerialization JSONObjectWithData:jsonDataString options:NSJSONReadingMutableContainers error:&error];
    NSLog(@"data response results : %@", results);
    
    if (!jsonDataString) {
        NSLog(@"Download failed : %@", error.localizedDescription);
        return nil;
    }
    
    return results;
}

+ (void) setImageFromUrl:(NSString*)urlString
     imageDataController:(ImageDataController *)imageDataController
                  itemId:(NSNumber *)itemId
                    view:(id)view
              completion:(void (^)(void))completion {
    
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
                
                if ([view isKindOfClass:[UICollectionView class]]) {
                    
                    [view reloadData];
                    
                }else if ([view isKindOfClass:[UITableView class]]) {
                    
                    [view reloadData];
                    
                }else if ([view isKindOfClass:[UIView class]]){
                    
                    [view reloadInputViews];
                    
                }
            });
            dispatch_async(dispatch_get_main_queue(), completion);
        }
        else {
            NSLog(@"-- impossible download: %@", urlString);
        }
	});
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
