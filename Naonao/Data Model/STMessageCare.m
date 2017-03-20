//
//  STMessageCare.m
//  Naonao
//
//  Created by 刘敏 on 16/8/21.
//  Copyright © 2016年 深圳市轩腾华兴科技开发有限公司. All rights reserved.
//

#import "STMessageCare.h"

@implementation STMessageCare

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"mId" : @"id",
             @"type" : @"type",
             @"content" : @"content"
             };
}


+ (NSValueTransformer *)contentJSONTransformer {
    return [MTLJSONAdapter dictionaryTransformerWithModelClass:[SKContent class]];
}

@end


@implementation SKContent

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"userid" : @"userid",
             @"name" : @"name",
             @"datetime" : @"datetime",
             @"msg" : @"msg",
             @"avatar" : @"avatar",
             @"question" : @"question"
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


+ (NSValueTransformer *)questionJSONTransformer {
    return [MTLJSONAdapter dictionaryTransformerWithModelClass:[SKQuestion class]];
}

@end


@implementation SKQuestion

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



@implementation SYSMessage

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"mId" : @"id",
             @"type" : @"type",
             @"content" : @"content"
             };
}


+ (NSValueTransformer *)contentJSONTransformer {
    return [MTLJSONAdapter dictionaryTransformerWithModelClass:[SYSContent class]];
}
@end


@implementation SYSContent

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"userid" : @"userid",
             @"msg" : @"msg",
             @"datetime" : @"datetime",
             };
}

@end
