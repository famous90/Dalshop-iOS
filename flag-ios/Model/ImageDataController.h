//
//  ImageDataController.h
//  flag-ios
//
//  Created by Gyuyoung Hwang on 2014. 2. 20..
//
//

#import "DataController.h"

@interface ImageDataController : DataController

- (void)addImageWithImage:(UIImage *)image withId:(NSNumber *)objectId;
- (UIImage *)imageInListWithId:(NSNumber *)objectId;
- (BOOL)imageExistWithId:(NSNumber *)objectId;

@end
