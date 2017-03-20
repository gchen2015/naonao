//
//  DemandMenu.m
//  Naonao
//
//  Created by 刘敏 on 16/3/3.
//  Copyright © 2016年 深圳市轩腾华兴科技开发有限公司. All rights reserved.
//

#import "DemandMenu.h"

@implementation DemandMenu

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"sceneArray" : @"scene",
             @"bodyParamsArray" : @"body_params",
             @"categoryArray" : @"category",
             @"styleArray" : @"style",
             @"bodyDefectArray" : @"body_defect",
             @"subCategoryArray" : @"sub_category"
             };
}

+ (NSValueTransformer *)sceneArrayJSONTransformer {
    return [MTLJSONAdapter arrayTransformerWithModelClass:[sceneModel class]];
}

+ (NSValueTransformer *)bodyParamsArrayJSONTransformer {
    return [MTLJSONAdapter arrayTransformerWithModelClass:[bodyParamsModel class]];
}

+ (NSValueTransformer *)categoryArrayJSONTransformer {
    return [MTLJSONAdapter arrayTransformerWithModelClass:[categoryModel class]];
}

+ (NSValueTransformer *)styleArrayJSONTransformer {
    return [MTLJSONAdapter arrayTransformerWithModelClass:[styleModel class]];
}

+ (NSValueTransformer *)bodyDefectArrayJSONTransformer {
    return [MTLJSONAdapter arrayTransformerWithModelClass:[bodyDefectModel class]];
}

+ (NSValueTransformer *)subCategoryArrayJSONTransformer {
    return [MTLJSONAdapter arrayTransformerWithModelClass:[bodyDefectModel class]];
}

@end


@implementation sceneModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"mId" : @"id",
             @"name" : @"name",
             @"image" : @"img",
             @"icon" : @"icon",
             @"styleArray" : @"style"
             };
}

+ (NSValueTransformer *)styleArrayJSONTransformer {
    return [MTLJSONAdapter arrayTransformerWithModelClass:[sceneModel class]];
}


@end




@implementation bodyParamsModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"mId" : @"id",
             @"name" : @"name",
             @"image" : @"img",
             @"icon" : @"icon",
             @"desc" : @"desc"
             };
}

@end



@implementation categoryModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"mId" : @"id",
             @"name" : @"name",
             @"image" : @"img"
             };
}

@end




@implementation styleModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"mId" : @"id",
             @"name" : @"name",
             @"image" : @"img",
             @"icon" : @"icon"
             };
}

@end


@implementation bodyDefectModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"mId" : @"id",
             @"name" : @"name"
             };
}

@end


