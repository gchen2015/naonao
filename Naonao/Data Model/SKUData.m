//
//  SKUData.m
//  Naonao
//
//  Created by 刘敏 on 16/3/19.
//  Copyright © 2016年 深圳市轩腾华兴科技开发有限公司. All rights reserved.
//

#import "SKUData.h"

@implementation SKUData

- (instancetype)initWithParsData:(NSDictionary *)dict
{
    self.productId = [dict objectForKeyNotNull:@"product_id"];
    self.imgUrl = [dict objectForKeyNotNull:@"img"];
    self.originalPrice = [dict objectForKeyNotNull:@"original_price"];
    self.price = [dict objectForKeyNotNull:@"price"];
    self.prodName = [dict objectForKeyNotNull:@"name"];
    //菜单
    self.disArray = [self pairsDisArray:[dict objectForKeyNotNull:@"sku_display"]];
    //SKU列表
    self.skuList = [self pairsskuDesDataList:[dict objectForKeyNotNull:@"sku_list"]];
    
    
    return self;
}

- (NSArray *)pairsDisArray:(NSArray *)tArray
{
    NSMutableArray *tempA = [[NSMutableArray alloc] initWithCapacity:tArray.count];
    for (NSDictionary *item in tArray) {
        skuMenuData *pdata = [[skuMenuData alloc] initWithParsData:item];
        [tempA addObject:pdata];
    }
    
    return tempA;
}

- (NSArray *)pairsskuDesDataList:(NSArray *)tArray
{
    NSMutableArray *tempA = [[NSMutableArray alloc] initWithCapacity:tArray.count];
    for (NSDictionary *item in tArray) {
        skuDesData *pdata = [[skuDesData alloc] initWithParsData:item];
        [tempA addObject:pdata];
    }
    
    return tempA;
}



@end

@implementation skuMenuData

- (instancetype)initWithParsData:(NSDictionary *)dict
{
    self.name = [dict objectForKeyNotNull:@"name"];
    self.skuArray = [dict objectForKeyNotNull:@"value"];

    return self;
}

@end


@implementation skuDesData

- (instancetype)initWithParsData:(NSDictionary *)dict
{
    self.stock = [dict objectForKeyNotNull:@"stock"];
    self.price = [dict objectForKeyNotNull:@"price"];
    self.skuId = [dict objectForKeyNotNull:@"sku_id"];
    self.skuInfo = [dict objectForKeyNotNull:@"sku_info"];
    
    return self;
}

@end
