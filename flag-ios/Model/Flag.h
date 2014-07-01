//
//  Flag.h
//  flag-ios
//
//  Created by Gyuyoung Hwang on 2014. 2. 5..
//
//

#import <Foundation/Foundation.h>

@interface Flag : NSObject

@property (nonatomic, strong) NSNumber *flagId;
@property (nonatomic, strong) NSNumber *lat;
@property (nonatomic, strong) NSNumber *lon;
@property (nonatomic, assign) NSTimeInterval createdAt;
@property (nonatomic, strong) NSNumber *shopId;
@property (nonatomic, strong) NSString *shopName;
@property (nonatomic, assign) NSInteger shopType;
@property (nonatomic, strong) NSDate *lastScanTime;
    
- (id)initWithData:(id)data;
- (id)initWithCoreData:(id)data;
- (NSDate *)getCreatedAtByNSDate;
- (void)setCreatedAtWithDate:(NSDate *)date;
- (BOOL)canFlagBeCheckedIn;

@end
