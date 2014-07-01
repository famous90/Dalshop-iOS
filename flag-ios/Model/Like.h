//
//  Like.h
//  Dalshop
//
//  Created by Hwang Gyuyoung on 2014. 6. 11..
//
//

#import <Foundation/Foundation.h>

@interface Like : NSObject

@property (nonatomic, strong) NSNumber *objectId;
@property (nonatomic, strong) NSDate *createdAt;
@property (nonatomic, strong) NSDate *updatedAt;

- (id)initWithCoreData:(id)data type:(NSInteger)type;

@end
