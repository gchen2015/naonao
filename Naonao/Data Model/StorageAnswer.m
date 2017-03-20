//
//  StorageAnswer.m
//  Naonao
//
//  Created by 刘敏 on 16/7/1.
//  Copyright © 2016年 深圳市轩腾华兴科技开发有限公司. All rights reserved.
//

#import "StorageAnswer.h"

@implementation StorageAnswer


@end


@implementation UserAnswer

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"content" : @"content",
             @"mId" : @"id",
             @"orderId" : @"order_id",
             @"createTime" : @"create_time",
             @"orderT" : @"order_title"
             };
}

//转换content
+ (NSValueTransformer *)JSONTransformerForKey:(NSString *)key
{
    if ([key isEqualToString:@"content"] || [key isEqualToString:@"orderT"]) {
        return [MTLValueTransformer transformerUsingForwardBlock:^id(id value, BOOL *success, NSError *__autoreleasing *error) {
            NSString *userName = [Units decodeFromPercentEscapeString:value];
            
            return userName;
        }];
    }
    
    return nil;
}


@end



@implementation MY_C

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"answer" : @"answer",
             @"comment" : @"comment",
             @"order" : @"order"
             };
}

+ (NSValueTransformer *)answerJSONTransformer {
    return [MTLJSONAdapter dictionaryTransformerWithModelClass:[MY_Answer class]];
}

+ (NSValueTransformer *)commentJSONTransformer {
    return [MTLJSONAdapter dictionaryTransformerWithModelClass:[MY_Comment class]];
}

+ (NSValueTransformer *)orderJSONTransformer {
    return [MTLJSONAdapter dictionaryTransformerWithModelClass:[MY_Order class]];
}

@end


@implementation MY_Answer

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"content" : @"content",
             @"mId" : @"id",
             @"userid" : @"userid",
             @"avatar" : @"avatar"
             };
}


//转换content
+ (NSValueTransformer *)JSONTransformerForKey:(NSString *)key
{
    if ([key isEqualToString:@"content"]) {
        return [MTLValueTransformer transformerUsingForwardBlock:^id(id value, BOOL *success, NSError *__autoreleasing *error) {
            NSString *userName = [Units decodeFromPercentEscapeString:value];
            
            return userName;
        }];
    }
    
    return nil;
}

@end


@implementation MY_Comment

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"content" : @"content",
             @"mId" : @"id"
             };
}

//转换content
+ (NSValueTransformer *)JSONTransformerForKey:(NSString *)key
{
    if ([key isEqualToString:@"content"]) {
        return [MTLValueTransformer transformerUsingForwardBlock:^id(id value, BOOL *success, NSError *__autoreleasing *error) {
            NSString *userName = [Units decodeFromPercentEscapeString:value];
            
            return userName;
        }];
    }
    
    return nil;
}

@end

@implementation MY_Order

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"content" : @"content",
             @"mId" : @"id"
             };
}

//转换content
+ (NSValueTransformer *)JSONTransformerForKey:(NSString *)key
{
    if ([key isEqualToString:@"content"]) {
        return [MTLValueTransformer transformerUsingForwardBlock:^id(id value, BOOL *success, NSError *__autoreleasing *error) {
            NSString *userName = [Units decodeFromPercentEscapeString:value];
            
            return userName;
        }];
    }
    
    return nil;
}

@end
