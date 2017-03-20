//
//  ResponseModel.m
//  Naonao
//
//  Created by 刘敏 on 16/4/22.
//  Copyright © 2016年 深圳市轩腾华兴科技开发有限公司. All rights reserved.
//

#import "ResponseModel.h"
#import "ProductModeFrame.h"


@implementation ResponseModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"mId" : @"id",
             @"img" : @"img",
             @"title" : @"title",
             @"createTime" : @"create_time",
             @"category" : @"category"
             };
}


- (instancetype)decodeValueForKey:(NSString *)key withCoder:(NSCoder *)coder modelVersion:(NSUInteger)modelVersion {
    return [super decodeValueForKey:key withCoder:coder modelVersion:modelVersion];
}


@end



