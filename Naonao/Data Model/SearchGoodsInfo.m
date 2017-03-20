//
//  SearchGoodsInfo.m
//  Naonao
//
//  Created by Richard Liu on 16/2/25.
//  Copyright © 2016年 深圳市轩腾华兴科技开发有限公司. All rights reserved.
//

#import "SearchGoodsInfo.h"

@implementation SearchGoodsInfo

- (instancetype)initWithParsData:(NSDictionary *)dict
{
    self.desArr = [dict objectForKeyNotNull:@"desc"];
    self.price = [dict objectForKeyNotNull:@"price"];
    self.website = [dict objectForKeyNotNull:@"website"];
    self.pName = [dict objectForKeyNotNull:@"name"];
    self.img_url = [dict objectForKeyNotNull:@"img_url"];
    self.product_id = [dict objectForKeyNotNull:@"product_id"];
    self.body_score = [dict objectForKeyNotNull:@"body_score"];
    self.like_score = [dict objectForKeyNotNull:@"like_score"];
    
    return self;
}

@end
