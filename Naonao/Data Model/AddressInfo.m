//
//  AddressInfo.m
//  Naonao
//
//  Created by 刘敏 on 16/3/28.
//  Copyright © 2016年 深圳市轩腾华兴科技开发有限公司. All rights reserved.
//

#import "AddressInfo.h"

@implementation AddressInfo

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"address" : @"address",
             @"province" : @"province",
             @"city" : @"city",
             @"country" : @"country",
             @"addressId" : @"id",
             @"isDefault" : @"is_default",
             @"zipcode" : @"zipcode",
             @"telephone" : @"telephone",
             @"name" : @"name",
             @"isSelected" : @"isSelected"
             };
}

@end


@implementation CourierInfo

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"deliverTime" : @"deliver_time",
             @"expressNo" : @"express_no",
             @"expressType" : @"express_type",
             @"deliveryId" : @"delivery_id",
             @"deliveryStatus" : @"delivery_status",
             @"expressCode" : @"express_code",
             @"logis" : @"detail"
             };

}


+ (NSValueTransformer *)logisJSONTransformer {
    return [MTLJSONAdapter dictionaryTransformerWithModelClass:[LogisticsInfo class]];
}

@end



@implementation LogisticsInfo

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"state" : @"State",
             @"logisticCode" : @"LogisticCode",
             @"shipperCode" : @"ShipperCode",
             @"businessID" : @"EBusinessID",
             @"success" : @"Success",
             @"stationArray" : @"Traces"
             };
}

+ (NSValueTransformer *)stationArrayJSONTransformer {
    return [MTLJSONAdapter arrayTransformerWithModelClass:[AcceptStation class]];
}

@end


@implementation AcceptStation

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"time" : @"AcceptTime",
             @"station" : @"AcceptStation",
             @"remark" : @"Remark"
             };
}

@end
