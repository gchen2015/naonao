//
//  WithdrawModel.m
//  Naonao
//
//  Created by 刘敏 on 16/5/16.
//  Copyright © 2016年 深圳市轩腾华兴科技开发有限公司. All rights reserved.
//

#import "WithdrawModel.h"

@implementation WithdrawModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"free" : @"free",
             @"total" : @"total",
             @"follow_wx" : @"follow_wx",
             @"records" : @"records"
             };
}


+ (NSValueTransformer *)recordsJSONTransformer {
    return [MTLJSONAdapter arrayTransformerWithModelClass:[WithdrawRecord class]];
}


@end


@implementation WithdrawRecord

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"amount" : @"amount",
             @"count" : @"count",
             @"today_pay" : @"today_pay",
             @"product" : @"product"
             };
}

+ (NSValueTransformer *)productJSONTransformer {
    return [MTLJSONAdapter dictionaryTransformerWithModelClass:[WithdrawProduct class]];
}

@end



@implementation WithdrawProduct

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"productTitle" : @"product_title",
             @"productImg" : @"product_img",
             @"productId" : @"product_id"
             };
}

@end





@implementation WithdrawTimeline

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"payList" : @"pay",
             @"showTime" : @"show"
             };
}

+ (NSValueTransformer *)payListJSONTransformer {
    return [MTLJSONAdapter arrayTransformerWithModelClass:[WPayTimeline class]];
}


@end



@implementation WPayTimeline

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"amount" : @"amount",
             @"payTime" : @"pay_time"
             };
}

@end


@implementation WShowTimeline

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"createTime" : @"create_time"
             };
}

@end



@implementation STWRecord


+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"amount" : @"amount",
             @"mId" : @"id",
             @"channel" : @"channel",
             @"createTime" : @"create_time"
             };
}

@end


