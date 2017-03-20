//
//  MagazineInfo.m
//  Naonao
//
//  Created by Richard Liu on 15/12/1.
//  Copyright © 2015年 深圳市轩腾华兴科技开发有限公司. All rights reserved.
//

#import "MagazineInfo.h"

@implementation MagazineInfo

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"author": @"author",
             @"content": @"content",
             @"imgURL": @"img",
             @"title" : @"title",
             @"mId": @"id",
             @"type": @"type",
             @"isLike" : @"is_like",
             @"publishTime": @"publish_time"
             };
}

- (instancetype)decodeValueForKey:(NSString *)key withCoder:(NSCoder *)coder modelVersion:(NSUInteger)modelVersion {
    return [super decodeValueForKey:key withCoder:coder modelVersion:modelVersion];
}

@end


@implementation MagazineContentInfo

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"productId": @"product_id",
             @"coverUrl": @"img",
             @"type": @"product_type",
             @"productPrice": @"product_price",
             @"like": @"like",
             @"productImg": @"product_img",
             @"desc": @"desc",
             @"productTitle": @"product_name"
             };
}

- (instancetype)decodeValueForKey:(NSString *)key withCoder:(NSCoder *)coder modelVersion:(NSUInteger)modelVersion {
    return [super decodeValueForKey:key withCoder:coder modelVersion:modelVersion];
}

@end




@implementation STBanInfo

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"mId": @"id",
             @"type": @"type",
             @"content": @"content",
             @"bgUrl": @"bg_url",
             @"title": @"title"
             };
}

- (instancetype)decodeValueForKey:(NSString *)key withCoder:(NSCoder *)coder modelVersion:(NSUInteger)modelVersion {
    return [super decodeValueForKey:key withCoder:coder modelVersion:modelVersion];
}

@end


@implementation STDuozhu

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"avatar": @"avatar",
             @"createTime": @"create_time",
             @"isFollow": @"is_follow",
             @"nickname": @"nickname",
             @"userid": @"userid",
             @"extraInfo": @"extra_info",
             @"fans" : @"follower",
             @"follower" : @"following"
             };
}

//转换UserName
+ (NSValueTransformer *)JSONTransformerForKey:(NSString *)key
{
    if ([key isEqualToString:@"nickname"]) {
        return [MTLValueTransformer transformerUsingForwardBlock:^id(id value, BOOL *success, NSError *__autoreleasing *error) {
            NSString *userName = [Units decodeFromPercentEscapeString:value];
            
            return userName;
        }];
        
    }
    
    return nil;
}


+ (NSValueTransformer *)extraInfoJSONTransformer {
    return [MTLJSONAdapter dictionaryTransformerWithModelClass:[ExtraInfo class]];
}


@end

@implementation ExtraInfo

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"background": @"background",
             @"introduce": @"introduce",
             @"job": @"job",
             @"constellation": @"start_sign",
             @"photos": @"photos"
             };
}

- (instancetype)decodeValueForKey:(NSString *)key withCoder:(NSCoder *)coder modelVersion:(NSUInteger)modelVersion {
    return [super decodeValueForKey:key withCoder:coder modelVersion:modelVersion];
}

@end


@implementation STBrand

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"author": @"author",
             @"content": @"content",
             @"imgURL": @"img",
             @"title" : @"title",
             @"mId": @"id",
             @"type": @"type",
             @"isLike" : @"is_like",
             @"publishTime": @"publish_time"             
             };
}

+ (NSValueTransformer *)contentJSONTransformer {
    return [MTLJSONAdapter dictionaryTransformerWithModelClass:[STBrand_Content class]];
}

@end



@implementation STBrand_Content

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"background": @"background",
             @"logo": @"logo",
             @"name": @"name",
             @"story" : @"story",
             @"pickUp": @"pickup",
             @"proArray": @"products",
             @"brandArray": @"imgs"
             };
}


+ (NSValueTransformer *)proArrayJSONTransformer {
    return [MTLJSONAdapter arrayTransformerWithModelClass:[STBrand_Product class]];
}


@end


@implementation STBrand_Product

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"mId": @"id",
             @"price": @"price",
             @"name" : @"name",
             @"imgUrl": @"img"
             };
}

- (instancetype)decodeValueForKey:(NSString *)key withCoder:(NSCoder *)coder modelVersion:(NSUInteger)modelVersion {
    return [super decodeValueForKey:key withCoder:coder modelVersion:modelVersion];
}

@end


@implementation STBrand_C

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"desc": @"desc",
             @"imgUrl": @"img"
             };
}

- (instancetype)decodeValueForKey:(NSString *)key withCoder:(NSCoder *)coder modelVersion:(NSUInteger)modelVersion {
    return [super decodeValueForKey:key withCoder:coder modelVersion:modelVersion];
}

@end



