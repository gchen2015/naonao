//
//  STMessagePraise.m
//  Naonao
//
//  Created by 刘敏 on 16/5/10.
//  Copyright © 2016年 深圳市轩腾华兴科技开发有限公司. All rights reserved.
//

#import "STMessagePraise.h"

@implementation STMessagePraise

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"mId" : @"id",
             @"type" : @"type",
             @"content" : @"content"
             };
}


+ (NSValueTransformer *)contentJSONTransformer {
    return [MTLJSONAdapter dictionaryTransformerWithModelClass:[STContent class]];
}

@end



@implementation STContent

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"userid" : @"userid",
             @"name" : @"name",
             @"datetime" : @"datetime",
             @"msg" : @"msg",
             @"avatar" : @"avatar",
             @"extraData" : @"extra"
             };
}

//转换UserName
+ (NSValueTransformer *)JSONTransformerForKey:(NSString *)key
{
    if ([key isEqualToString:@"name"] || [key isEqualToString:@"msg"]) {
        return [MTLValueTransformer transformerUsingForwardBlock:^id(id value, BOOL *success, NSError *__autoreleasing *error) {
            NSString *userName = [Units decodeFromPercentEscapeString:value];
            
            return userName;
        }];
        
    }
    
    return nil;
}


+ (NSValueTransformer *)extraDataJSONTransformer {
    return [MTLJSONAdapter dictionaryTransformerWithModelClass:[STMExtra class]];
}

@end



@implementation STMExtra

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"content" : @"content",
             @"nums" : @"nums",
             @"oInfo" : @"order_info"
             };
}

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

+ (NSValueTransformer *)oInfoJSONTransformer {
    return [MTLJSONAdapter dictionaryTransformerWithModelClass:[STOrder class]];
}

@end



@implementation STOrder

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"userInfo" : @"userinfo",
             @"orderInfo" : @"orderinfo"
             };
}


+ (NSValueTransformer *)userInfoJSONTransformer {
    return [MTLJSONAdapter dictionaryTransformerWithModelClass:[SUserInfo class]];
}


+ (NSValueTransformer *)orderInfoJSONTransformer {
    return [MTLJSONAdapter dictionaryTransformerWithModelClass:[SOrderInfo class]];
}

@end


