//
//  GoodsInfo.m
//  Naonao
//
//  Created by 刘敏 on 16/3/16.
//  Copyright © 2016年 深圳市轩腾华兴科技开发有限公司. All rights reserved.
//

#import "GoodsInfo.h"
#import "SquareModel.h"

@implementation GoodsInfo

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"like": @"like",
             @"commentArray": @"comments",
             @"commentsNum": @"comments_num",
             @"goodsImg": @"img",
             @"originalPrice": @"original_price",
             @"price": @"price",
             @"bInfo": @"brand_info",
             @"mTitle": @"title",
             @"sizeUrl" : @"size_url",
             @"brandId": @"brand_id",
             @"detailInfo": @"detail_url",
             @"sourceType": @"source_type",
             @"isDown" : @"is_down",
             @"canTry" : @"can_try",
             @"recommandArray": @"recommands",
             @"store" : @"shop"
             };
}

+ (NSValueTransformer *)storeJSONTransformer {
    return [MTLJSONAdapter dictionaryTransformerWithModelClass:[StoreData class]];
}

+ (NSValueTransformer *)commentArrayJSONTransformer {
    return [MTLJSONAdapter arrayTransformerWithModelClass:[CommentInfo class]];
}



+ (NSValueTransformer *)bInfoJSONTransformer {
    return [MTLJSONAdapter dictionaryTransformerWithModelClass:[BrandInfo class]];
}


+ (NSValueTransformer *)recommandArrayJSONTransformer {
    return [MTLJSONAdapter arrayTransformerWithModelClass:[SameModel class]];
}


@end



@implementation BrandInfo

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"en_name": @"en_name",
             @"story": @"story",
             @"ch_name": @"ch_name",
             @"logoUrl": @"logo"
             };
}

- (instancetype)decodeValueForKey:(NSString *)key withCoder:(NSCoder *)coder modelVersion:(NSUInteger)modelVersion {
    return [super decodeValueForKey:key withCoder:coder modelVersion:modelVersion];
}

@end


// 商品详情
@implementation GoodsDetailInfo

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"imgArray": @"imgs",
             @"desc": @"desc"
             };
}

+ (NSValueTransformer *)imgArrayJSONTransformer {
    return [MTLJSONAdapter arrayTransformerWithModelClass:[ImageM class]];
}

@end



@implementation SizeUrlInfo

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"desc": @"desc",
             @"sizeArray": @"imgs"
             };
}

+ (NSValueTransformer *)sizeArrayJSONTransformer {
    return [MTLJSONAdapter arrayTransformerWithModelClass:[ImageM class]];
}


@end


// 图片信息
@implementation ImageM

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"url": @"url",
             @"width": @"width",
             @"height": @"height"
             };
}

@end


@implementation CommentInfo

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"content": @"content",
             @"userId": @"userid",
             @"createTime": @"create_time",
             @"cName": @"name",
             @"avatorUrl": @"avator"
             };
}

//转换UserName
+ (NSValueTransformer *)JSONTransformerForKey:(NSString *)key
{
    if ([key isEqualToString:@"cName"]) {
        return [MTLValueTransformer transformerUsingForwardBlock:^id(id value, BOOL *success, NSError *__autoreleasing *error) {
            NSString *userName = [Units decodeFromPercentEscapeString:value];
            
            return userName;
        }];
        
    }
    
    return nil;
}

- (instancetype)decodeValueForKey:(NSString *)key withCoder:(NSCoder *)coder modelVersion:(NSUInteger)modelVersion {
    return [super decodeValueForKey:key withCoder:coder modelVersion:modelVersion];
}

@end


//订单数据（后台返回）
@implementation OrderData

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"order_id": @"order_id",
             @"order_no": @"order_no"
             };
}

- (instancetype)decodeValueForKey:(NSString *)key withCoder:(NSCoder *)coder modelVersion:(NSUInteger)modelVersion {
    return [super decodeValueForKey:key withCoder:coder modelVersion:modelVersion];
}

@end
