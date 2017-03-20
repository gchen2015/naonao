//
//  FavGoodsModel.m
//  Naonao
//
//  Created by Richard Liu on 15/12/29.
//  Copyright © 2015年 深圳市轩腾华兴科技开发有限公司. All rights reserved.
//

#import "FavGoodsModel.h"

@implementation FavGoodsModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"productId" : @"product_id",
             @"imgUrl" : @"product_img",
             @"productName" : @"product_name",
             @"productPrice" : @"product_price"
             };
}

@end


@implementation FavTopicModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"mId" : @"id",
             @"magazineCover" : @"magazine_cover",
             @"title" : @"title"
             };
}

@end


@implementation questionModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"answerA" : @"answerA",
             @"answerB" : @"answerB",
             @"answerC" : @"answerC",
             @"answerD" : @"answerD",
             @"question" : @"question"
             };
}

@end