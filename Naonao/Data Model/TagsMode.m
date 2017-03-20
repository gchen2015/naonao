//
//  TagsMode.m
//  Naonao
//
//  Created by 刘敏 on 16/6/3.
//  Copyright © 2016年 深圳市轩腾华兴科技开发有限公司. All rights reserved.
//

#import "TagsMode.h"

@implementation TagsMode

- (instancetype)initWithParsData:(NSDictionary *)dict
{
    self.categoryArr = [dict objectForKeyNotNull:@"category"];
    self.tagsArr = [dict objectForKeyNotNull:@"tags"];
    
    return self;
}

@end



@implementation GoodsMode

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"img" : @"img",
             @"originalPrice" : @"original_price",
             @"mId" : @"id",
             @"price" : @"price",
             @"sourceType" : @"source_type",
             @"title" : @"title",
             @"brand" : @"brand",
             @"tags" : @"tags"
             };
}

- (instancetype)decodeValueForKey:(NSString *)key withCoder:(NSCoder *)coder modelVersion:(NSUInteger)modelVersion {
    return [super decodeValueForKey:key withCoder:coder modelVersion:modelVersion];
}


@end