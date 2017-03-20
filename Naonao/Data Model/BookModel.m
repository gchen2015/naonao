//
//  BookModel.m
//  Naonao
//
//  Created by 刘敏 on 2016/9/14.
//  Copyright © 2016年 深圳市轩腾华兴科技开发有限公司. All rights reserved.
//

#import "BookModel.h"

@implementation BookModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"address" : @"address",
             @"calender" : @"calender"
             };
}

+ (NSValueTransformer *)addressJSONTransformer {
    return [MTLJSONAdapter dictionaryTransformerWithModelClass:[FitAddress class]];
}

+ (NSValueTransformer *)calenderJSONTransformer {
    return [MTLJSONAdapter arrayTransformerWithModelClass:[BookCalender class]];
}

@end



@implementation BookCalender

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"mId" : @"id",
             @"free" : @"free",
             @"time" : @"time"
             };
}

- (instancetype)decodeValueForKey:(NSString *)key withCoder:(NSCoder *)coder modelVersion:(NSUInteger)modelVersion {
    return [super decodeValueForKey:key withCoder:coder modelVersion:modelVersion];
}


@end


@implementation FitData

- (instancetype)initWithParsData:(NSDictionary *)dict {
    
    self.mId = [dict objectForKeyNotNull:@"id"];
    self.status = [dict objectForKeyNotNull:@"status"];
    self.reserveTime = [dict objectForKeyNotNull:@"reserve_time"];
    
    self.skuData = [[SKUOrderModel alloc] initWithParsData:[dict objectForKeyNotNull:@"sku_info"]];
    self.address = [MTLJSONAdapter modelOfClass:[FitAddress class] fromJSONDictionary:[dict objectForKeyNotNull:@"address"] error:nil];
    
    
    return self;
}


@end


@implementation FitAddress

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"name" : @"name",
             @"address" : @"address",
             @"telephone" : @"telephone",
             @"latitude" : @"latitude",
             @"longitude" : @"longitude"
             };  
}

- (instancetype)decodeValueForKey:(NSString *)key withCoder:(NSCoder *)coder modelVersion:(NSUInteger)modelVersion {
    return [super decodeValueForKey:key withCoder:coder modelVersion:modelVersion];
}

@end


@implementation PickUpData

- (instancetype)initWithParsData:(NSDictionary *)dict {
    
    self.mId = [dict objectForKeyNotNull:@"id"];
    self.status = [dict objectForKeyNotNull:@"status"];
    self.reserveTime = [dict objectForKeyNotNull:@"reserve_time"];
    
    self.skuArray = [self pairsData:[dict objectForKeyNotNull:@"sku_info"]];
    self.address = [MTLJSONAdapter modelOfClass:[FitAddress class] fromJSONDictionary:[dict objectForKeyNotNull:@"address"] error:nil];
    
    
    return self;
}

- (NSArray *)pairsData:(NSArray *)mArray{
    NSMutableArray *tArray = [NSMutableArray arrayWithCapacity:mArray.count];
    
    for (NSDictionary *item in mArray) {
        SKUOrderModel *fData = [[SKUOrderModel alloc] initWithParsData:item];
        [tArray addObject:fData];
    }
    
    return tArray;
    
}


@end

