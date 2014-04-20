//
//  MapUtil.h
//  flag-ios
//
//  Created by Gyuyoung Hwang on 2014. 3. 11..
//
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface MapUtil : NSObject

+ (BOOL)currentLocation:(CLLocation *)currentLocation getOutOfPreviousLocation:(CLLocation *)previousLocation withBoundRadius:(NSInteger)radius;
+ (BOOL)isPositionOutOfBounderyAtPreviousPosition:(CLLocation *)previousPosition WithChangedPosition:(CLLocation *)changedPosition;
+ (NSString *)getMapMarkerImageWithCategory:(NSInteger)shopType;
+ (NSString *)getMapMarkerImageFileNameWithCategory:(NSInteger)shopType status:(NSInteger)status;
//+ (NSString *)changeMapMarkerImageWithImageFileName:(NSString *)fileName fromStatus:(NSInteger)previousStatus toStatus:(NSInteger)pastStatus;

@end
