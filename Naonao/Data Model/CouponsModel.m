//
//  CouponsModel.m
//  Naonao
//
//  Created by 刘敏 on 16/5/11.
//  Copyright © 2016年 深圳市轩腾华兴科技开发有限公司. All rights reserved.
//

#import "CouponsModel.h"

@implementation CouponsModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"amount" : @"amount",
             @"mId" : @"id",
             @"endTime" : @"end_time",
             @"startTime" : @"start_time",
             @"type" : @"type"
             };
}

- (instancetype)decodeValueForKey:(NSString *)key withCoder:(NSCoder *)coder modelVersion:(NSUInteger)modelVersion {
    return [super decodeValueForKey:key withCoder:coder modelVersion:modelVersion];
}


@end
