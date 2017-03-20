//
//  STUserInfo.m
//  Naonao
//
//  Created by 刘敏 on 16/4/13.
//  Copyright © 2016年 深圳市轩腾华兴科技开发有限公司. All rights reserved.
//

#import "STUserInfo.h"

@implementation STUserInfo

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"collect": @"collect",
             @"portraitUrl": @"url",
             @"userId": @"userid",
             @"userName": @"name",
             @"scoresInfo": @"scores",
             @"isFollow": @"is_follow"
             };
}



+ (NSValueTransformer *)scoresInfoJSONTransformer {
    return [MTLJSONAdapter dictionaryTransformerWithModelClass:[STScores class]];
}


+ (NSValueTransformer *)collectJSONTransformer {
    return [MTLJSONAdapter dictionaryTransformerWithModelClass:[STCollect class]];
}

//转换UserName
+ (NSValueTransformer *)JSONTransformerForKey:(NSString *)key
{
    if ([key isEqualToString:@"userName"]) {
        return [MTLValueTransformer transformerUsingForwardBlock:^id(id value, BOOL *success, NSError *__autoreleasing *error) {
            NSString *userName = [Units decodeFromPercentEscapeString:value];
            
            return userName;
        }];
        
    }
    
    return nil;
}

@end


@implementation STBodyStyle

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"bust": @"bust",
             @"height": @"body_height",
             @"style": @"body_style",
             @"weight": @"body_weight",
             @"waistline": @"waistline",
             @"hipline": @"hipline",
             @"shoes": @"shoes"
             };
}

- (instancetype)decodeValueForKey:(NSString *)key withCoder:(NSCoder *)coder modelVersion:(NSUInteger)modelVersion {
    return [super decodeValueForKey:key withCoder:coder modelVersion:modelVersion];
}

@end


@implementation STScores

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"body": @"body",
             @"style": @"style",
             @"interest": @"interest",
             @"total": @"total"
             };
}

- (instancetype)decodeValueForKey:(NSString *)key withCoder:(NSCoder *)coder modelVersion:(NSUInteger)modelVersion {
    return [super decodeValueForKey:key withCoder:coder modelVersion:modelVersion];
}

@end


@implementation STCollect

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"follower": @"follower",
             @"following": @"following",
             @"like": @"like"
             };
}

- (instancetype)decodeValueForKey:(NSString *)key withCoder:(NSCoder *)coder modelVersion:(NSUInteger)modelVersion {
    return [super decodeValueForKey:key withCoder:coder modelVersion:modelVersion];
}

@end
