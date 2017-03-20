//
//  BookModel.h
//  Naonao
//
//  Created by 刘敏 on 2016/9/14.
//  Copyright © 2016年 深圳市轩腾华兴科技开发有限公司. All rights reserved.
//

#import <Mantle/Mantle.h>
#import "GoodsOData.h"


@class FitAddress;

@interface BookModel : MTLModel<MTLJSONSerializing>

@property (nonatomic, strong) FitAddress *address;
@property (nonatomic, strong) NSArray *calender;

@end


@interface BookCalender: MTLModel<MTLJSONSerializing>

@property (nonatomic, strong) NSNumber *mId;
@property (nonatomic, strong) NSNumber *free;

@property (nonatomic, strong) NSString *time;

@end


@class FitAddress;
@interface FitData : NSObject

@property (nonatomic, strong) NSNumber *status;
@property (nonatomic, strong) NSNumber *mId;

@property (nonatomic, strong) NSString *reserveTime;

@property (nonatomic, strong) SKUOrderModel *skuData;
@property (nonatomic, strong) FitAddress *address;

- (instancetype)initWithParsData:(NSDictionary *)dict;

@end


@interface FitAddress : MTLModel<MTLJSONSerializing>

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *address;
@property (nonatomic, strong) NSString *telephone;

@property (nonatomic, strong) NSNumber *latitude;
@property (nonatomic, strong) NSNumber *longitude;

@end


@interface PickUpData : NSObject

@property (nonatomic, strong) NSNumber *status;
@property (nonatomic, strong) NSNumber *mId;

@property (nonatomic, strong) NSString *reserveTime;

@property (nonatomic, strong) NSArray *skuArray;
@property (nonatomic, strong) FitAddress *address;

- (instancetype)initWithParsData:(NSDictionary *)dict;

@end



