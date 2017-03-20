//
//  User.m
//  Naonao
//
//  Created by Richard Liu on 15/11/23.
//  Copyright © 2015年 深圳市轩腾华兴科技开发有限公司. All rights reserved.
//

#import "User.h"

@implementation User  

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"basic": @"basic",
             @"body": @"body_params",
             @"thirdparty": @"thirdparty",
             @"is_reg": @"is_reg"
             };
}


+ (NSValueTransformer *)basicJSONTransformer {
    return [MTLJSONAdapter dictionaryTransformerWithModelClass:[UserBasic class]];
}

+ (NSValueTransformer *)bodyJSONTransformer {
    return [MTLJSONAdapter dictionaryTransformerWithModelClass:[UserBody class]];
}


- (instancetype)decodeValueForKey:(NSString *)key withCoder:(NSCoder *)coder modelVersion:(NSUInteger)modelVersion {
    return [super decodeValueForKey:key withCoder:coder modelVersion:modelVersion];
}

@end


@implementation UserBasic

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"gender": @"gender",
             @"userId": @"userid",
             @"userName": @"name",
             @"token": @"token",
             @"email": @"email",
             @"telephone": @"telephone",
             @"avatarUrl": @"url",
             @"bindingCode": @"binding_code",
             @"contract": @"contract"
             };
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

- (instancetype)decodeValueForKey:(NSString *)key withCoder:(NSCoder *)coder modelVersion:(NSUInteger)modelVersion {
    return [super decodeValueForKey:key withCoder:coder modelVersion:modelVersion];
}

@end



@implementation UserBody


+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"bodyStyle": @"body_style",
             @"height": @"body_height",
             @"weight": @"body_weight",
             @"bust": @"bust",
             @"waistline": @"waistline",
             @"hipline": @"hipline",
             @"shoes": @"shoes",
             @"lifeStage": @"life_stage",
             @"bodydefect": @"body_defect"
             };
}

- (instancetype)decodeValueForKey:(NSString *)key withCoder:(NSCoder *)coder modelVersion:(NSUInteger)modelVersion {
    return [super decodeValueForKey:key withCoder:coder modelVersion:modelVersion];
}

@end


@implementation UserFollow


+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"isFollow": @"is_follow",
             @"userId": @"userid",
             @"nickname": @"nickname",
             @"avatar": @"avatar"
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

- (instancetype)decodeValueForKey:(NSString *)key withCoder:(NSCoder *)coder modelVersion:(NSUInteger)modelVersion {
    return [super decodeValueForKey:key withCoder:coder modelVersion:modelVersion];
}

@end
