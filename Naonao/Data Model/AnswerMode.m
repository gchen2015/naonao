//
//  AnswerMode.m
//  Naonao
//
//  Created by 刘敏 on 16/6/3.
//  Copyright © 2016年 深圳市轩腾华兴科技开发有限公司. All rights reserved.
//

#import "AnswerMode.h"

@implementation AnswerMode

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"content" : @"content",
             @"proData" : @"product",
             @"userInfo" : @"user",
             @"links" : @"links",
             @"comments" : @"comments",
             @"answerId" : @"answer_id",
             @"isLike" : @"is_like",
             @"likeCount" : @"like_cnt",
             @"match_score" : @"match_score"
             };
}


+ (NSValueTransformer *)JSONTransformerForKey:(NSString *)key
{
    if ([key isEqualToString:@"content"]) {
        return [MTLValueTransformer transformerUsingForwardBlock:^id(id value, BOOL *success, NSError *__autoreleasing *error) {
            NSString *content = [Units decodeFromPercentEscapeString:value];
            
            return content;
        }];
        
    }
    
    return nil;
}

+ (NSValueTransformer *)proDataJSONTransformer {
    return [MTLJSONAdapter dictionaryTransformerWithModelClass:[GoodsMode class]];
}

+ (NSValueTransformer *)userInfoJSONTransformer {
    return [MTLJSONAdapter dictionaryTransformerWithModelClass:[AnUserInfo class]];
}

+ (NSValueTransformer *)commentsJSONTransformer {
    return [MTLJSONAdapter dictionaryTransformerWithModelClass:[STCommentInfo class]];
}

@end


@implementation AnUserInfo 

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"userId" : @"userid",
             @"isContract" : @"contract",
             @"isFollow" : @"is_follow",
             @"nickname" : @"name",
             @"avatar" : @"url"
             };
}

- (instancetype)decodeValueForKey:(NSString *)key withCoder:(NSCoder *)coder modelVersion:(NSUInteger)modelVersion {
    return [super decodeValueForKey:key withCoder:coder modelVersion:modelVersion];
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

@end




@implementation STCommentInfo

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"total" : @"total",
             @"commentList" : @"list"
             };
}

+ (NSValueTransformer *)commentListJSONTransformer {
    return [MTLJSONAdapter arrayTransformerWithModelClass:[STCommentData class]];
}

@end




@implementation STCommentData

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"content": @"content",
             @"userId": @"userid",
             @"nickName": @"nickname",
             @"avatorUrl": @"avatar",
             @"at_userId": @"at_userid",
             @"at_nickName": @"at_nickname",
             @"at_avatorUrl": @"at_avatar",
             @"createTime": @"create_time",
             @"commentId": @"comment_id"
             };
}

- (instancetype)decodeValueForKey:(NSString *)key withCoder:(NSCoder *)coder modelVersion:(NSUInteger)modelVersion {
    return [super decodeValueForKey:key withCoder:coder modelVersion:modelVersion];
}


//转换UserName
+ (NSValueTransformer *)JSONTransformerForKey:(NSString *)key
{
    if ([key isEqualToString:@"nickName"] || [key isEqualToString:@"at_nickName"] || [key isEqualToString:@"content"]) {
        return [MTLValueTransformer transformerUsingForwardBlock:^id(id value, BOOL *success, NSError *__autoreleasing *error) {
            NSString *userName = [Units decodeFromPercentEscapeString:value];
            
            return userName;
        }];
        
    }
    
    return nil;
}


@end
