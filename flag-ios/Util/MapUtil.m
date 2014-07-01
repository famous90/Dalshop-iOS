//
//  MapUtil.m
//  flag-ios
//
//  Created by Gyuyoung Hwang on 2014. 3. 11..
//
//

#import "MapUtil.h"

@implementation MapUtil

+ (BOOL)currentLocation:(CLLocation *)currentLocation getOutOfPreviousLocation:(CLLocation *)previousLocation withBoundRadius:(NSInteger)radius
{
    CLLocationDistance distance = [currentLocation distanceFromLocation:previousLocation];
    
    if (distance > radius) {
        return YES;
    }else return NO;
}


+ (BOOL)isPositionOutOfBounderyAtPreviousPosition:(CLLocation *)previousPosition WithChangedPosition:(CLLocation *)changedPosition
{
    CLLocationDistance distance = [changedPosition distanceFromLocation:previousPosition];
    
    if (distance > FLAG_LIST_RADIUS) {
        return YES;
    }else return NO;
}

+ (NSString *)getMapMarkerImageWithCategory:(NSInteger)shopType
{
    NSString *markerImageName;
    
    switch (shopType) {
        case TANKERS:
            markerImageName = @"tankers";
            break;
            
        case CLOTHES:
            markerImageName = @"clothes";
            break;
            
        case SHOES:
            markerImageName = @"shoes";
            break;
            
        case COSMETIC:
            markerImageName = @"cosmetic";
            break;
            
        case ACCESSARY:
            markerImageName = @"accessary";
            break;
            
        case ELECTRONIC_APPLIANCE:
            markerImageName = @"appliance";
            break;
            
        case ETC:
            markerImageName = @"etc";
            break;
            
        case BEAUTY:
            markerImageName = @"beauty";
            break;
            
        case RETAIL:
            markerImageName = @"retail";
            break;
            
        default:
            markerImageName = nil;
            break;
    }
    
    return markerImageName;
}

+ (NSString *)getMapMarkerImageFileNameWithCategory:(NSInteger)shopType status:(NSInteger)status
{
    NSString *imageFileNameAffix;
    NSString *imageFileNameSuffix = [self getMapMarkerImageWithCategory:shopType];
    
    switch (status) {
        case BASE:
            imageFileNameAffix = @"";
            break;
            
        case REWARDED:
            imageFileNameAffix = @"_scanned";
            break;
            
        case SELECTED:
            imageFileNameAffix = @"_selected";
            break;
            
        default:
            imageFileNameAffix = nil;
            break;
    }
    
    NSString *imageFileName = @"pin";
    imageFileName = [imageFileName stringByAppendingFormat:@"_%@%@", imageFileNameSuffix, imageFileNameAffix];
    
    return imageFileName;
}

+ (CLLocation *)getProximateCheckInSpotFromLocation:(CLLocation *)location
{
    CLLocation *checkInSpot1 = [[CLLocation alloc] initWithLatitude:LATITUDE_CHECKIN_SPOT_HONG longitude:LONGITUDE_CHECKIN_SPOT_HONG];
    CLLocation *checkInSpot2 = [[CLLocation alloc] initWithLatitude:LATITUDE_CHECKIN_SPOT_AP longitude:LONGITUDE_CHECKIN_SPOT_AP];
    
    NSArray *spots = [[NSArray alloc] initWithObjects:checkInSpot1, checkInSpot2, nil];
    NSInteger proximateSpotIndex = 0;
    NSInteger proximateDistance = INT32_MAX;
    
    for(int i=0; i<[spots count];i++){
        
        CLLocation *spot = (CLLocation *)[spots objectAtIndex:i];
        CLLocationDistance distance = [spot distanceFromLocation:location];
        
        if (distance < proximateDistance) {
            proximateSpotIndex = i;
            proximateDistance = distance;
        }
    }
    
    return [spots objectAtIndex:proximateSpotIndex];
}

//+ (NSString *)changeMapMarkerImageWithImageFileName:(NSString *)fileName fromStatus:(NSInteger)previousStatus toStatus:(NSInteger)pastStatus
//{
//    NSString *previousFileName = [fileName mutableCopy];
//    NSString *pastFileNamePrefix = nil;
//    NSInteger previousPrefixIndex = 0;
//    
//    if (previousStatus == BASE) {
//        
//        previousPrefixIndex = 7;
//        
//    }else if (previousStatus == REWARDED){
//        
//        previousPrefixIndex = 9;
//        
//    }else if (previousStatus == SELECTED){
//        
//        previousPrefixIndex = 9;
//        
//    }
//    
//    if (pastStatus == BASE) {
//        
//        pastFileNamePrefix = @"pin_red";
//        
//    }else if (pastStatus == REWARDED){
//        
//        pastFileNamePrefix = @"pin_black";
//        
//    }else if (pastStatus == SELECTED){
//        
//        pastFileNamePrefix = @"pin_green";
//        
//    }
//    
//    NSString *pastFileName = [previousFileName stringByReplacingCharactersInRange:NSMakeRange(0, previousPrefixIndex) withString:pastFileNamePrefix];
//    
//    return pastFileName;
//}

@end
