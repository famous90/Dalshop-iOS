//
//  ImageDataController.m
//  flag-ios
//
//  Created by Gyuyoung Hwang on 2014. 2. 20..
//
//

#import "ImageDataController.h"

@implementation ImageDataController

- (void)addImageWithImage:(UIImage *)image withId:(NSNumber *)objectId
{
    if (![self imageExistWithId:objectId]) {
        NSDictionary *imageData = [[NSDictionary alloc] initWithObjectsAndKeys:image, @"image", objectId, @"id", nil];
        [self.masterData addObject:imageData];
    }
}

- (UIImage *)imageInListWithId:(NSNumber *)objectId
{
    for(NSDictionary *object in self.masterData){
        if ([[object valueForKey:@"id"] isEqual:objectId]) {
            return [object objectForKey:@"image"];
        }
    }
    return nil;
}

- (BOOL)imageExistWithId:(NSNumber *)objectId
{
    for(NSDictionary *object in self.masterData){
        if ([[object valueForKey:@"id"] isEqual:objectId]) {
            return YES;
        }
    }
    return NO;
}

@end
