//
//  GoodsOData.m
//  Naonao
//
//  Created by 刘敏 on 16/3/22.
//  Copyright © 2016年 深圳市轩腾华兴科技开发有限公司. All rights reserved.
//  商品订单数据

#import "GoodsOData.h"

@implementation GoodsOData

//解析购物车数据
- (instancetype)initWithParsData:(NSDictionary *)dict
{
    self.count = [dict objectForKeyNotNull:@"num"];         //数量
    self.skuTag = [dict objectForKeyNotNull:@"sku_id"];     //SKU Id
    
    self.imageURL = [dict objectForKeyNotNull:@"img"];
    self.skuDict = [dict objectForKeyNotNull:@"sku"];
    self.proName = [dict objectForKeyNotNull:@"name"];
    self.price = [dict objectForKeyNotNull:@"price"];
    
    self.stock = [dict objectForKeyNotNull:@"stock"];
    self.proId = [dict objectForKeyNotNull:@"product_id"];
    
    self.source_uid = [dict objectForKeyNotNull:@"source_uid"];
    
    if ([dict objectForKeyNotNull:@"shop"]) {
        self.store = [MTLJSONAdapter modelOfClass:[StoreData class] fromJSONDictionary:[dict objectForKeyNotNull:@"shop"] error:nil];
    }

    return self;
}

@end



@implementation StoreData

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"mId" : @"id",
             @"logo" : @"logo",
             @"name" : @"name",
             @"canTry" : @"can_try",
             @"address" : @"address"
             };
}

@end



@implementation CartData

- (instancetype)initWithParsData:(NSDictionary *)dict
{
    self.total = [dict objectForKeyNotNull:@"total"];
    self.goodsArray = [self parsingCartList:[dict objectForKeyNotNull:@"list"]];
    
    return self;
}


- (NSArray *)parsingCartList:(NSArray *)array{
    
    NSMutableArray *temp = [[NSMutableArray alloc] initWithCapacity:array.count];
    
    //匹配的需求
    for (NSDictionary *item in array) {
        GoodsOData *mInfo = [[GoodsOData alloc] initWithParsData:item];
        [temp addObject:mInfo];
    }
    
    return temp;
    
}

@end


@implementation OrderModel

- (instancetype)initWithParsData:(NSDictionary *)dict
{
    //订单编号
    self.orderNo = [dict objectForKeyNotNull:@"order_no"];
    
    //订单ID
    self.orderId = [dict objectForKeyNotNull:@"order_id"];
    
    //订单状态
    self.orderStatus = [dict objectForKeyNotNull:@"status"];
    
    //订单创建时间
    self.createTime = [dict objectForKeyNotNull:@"create_time"];
    
    //订单金额
    self.totalPrice = [dict objectForKeyNotNull:@"total_price"];
    
    self.skuList = [self parsingSkuList:[dict objectForKeyNotNull:@"sku_list"]];
    
    self.type = [dict objectForKeyNotNull:@"type"];
    
    return self;
}


- (NSArray *)parsingSkuList:(NSArray *)array{
    
    if (array.count == 0) {
        return nil;
    }
    
    NSMutableArray *temp = [[NSMutableArray alloc] initWithCapacity:array.count];
    
    //匹配的需求
    for (NSDictionary *item in array) {
        SKUOrderModel *mInfo = [[SKUOrderModel alloc] initWithParsData:item];
        [temp addObject:mInfo];
    }
    
    return temp;
    
}

@end


@implementation SKUOrderModel

- (instancetype)initWithParsData:(NSDictionary *)dict
{
    self.proImg = [dict objectForKeyNotNull:@"img"];
    self.num = [dict objectForKeyNotNull:@"num"];
    self.proName = [dict objectForKeyNotNull:@"name"];
    self.price = [dict objectForKeyNotNull:@"price"];
    self.productId = [dict objectForKeyNotNull:@"product_id"];
    
    self.skuInfo = [dict objectForKeyNotNull:@"sku"];
    
    if ([dict objectForKeyNotNull:@"shop"]) {
        self.store = [MTLJSONAdapter modelOfClass:[StoreData class] fromJSONDictionary:[dict objectForKeyNotNull:@"shop"] error:nil];
    }
    return self;
}


@end


@implementation  OrderDetails


- (instancetype)initWithParsData:(NSDictionary *)dict
{
    self.status = [dict objectForKeyNotNull:@"status"];
    self.total_price = [dict objectForKeyNotNull:@"total_price"];
    
    self.deliveryInfo = [[DeliveryInfo alloc] initWithParsData:[dict objectForKeyNotNull:@"delivery_info"]];
    
    self.sign_time = [dict objectForKeyNotNull:@"sign_time"];

    self.cancel_time = [dict objectForKeyNotNull:@"cancel_time"];
    self.create_time = [dict objectForKeyNotNull:@"create_time"];
    self.order_no = [dict objectForKeyNotNull:@"order_no"];
    self.pay_time = [dict objectForKeyNotNull:@"pay_time"];
    self.order_id = [dict objectForKeyNotNull:@"order_id"];
    self.remain_sec = [dict objectForKeyNotNull:@"remain_sec"];
    self.tax_amount = [dict objectForKeyNotNull:@"tax_amount"];
    self.delivery_amount = [dict objectForKeyNotNull:@"delivery_amount"];
    self.type = [dict objectForKeyNotNull:@"type"];
    
    self.skuList = [self parsingSkuList:[dict objectForKeyNotNull:@"sku_list"]];
    
    return self;
}


- (NSArray *)parsingSkuList:(NSArray *)array{
    
    if (array.count == 0) {
        return nil;
    }
    
    NSMutableArray *temp = [[NSMutableArray alloc] initWithCapacity:array.count];
    
    //匹配的需求
    for (NSDictionary *item in array) {
        SKUOrderModel *mInfo = [[SKUOrderModel alloc] initWithParsData:item];
        [temp addObject:mInfo];
    }
    
    return temp;
    
}

@end


@implementation  DeliveryInfo

- (instancetype)initWithParsData:(NSDictionary *)dict
{
    self.receiver_telephone = [dict objectForKeyNotNull:@"receiver_telephone"];
    self.receiver_addr = [dict objectForKeyNotNull:@"receiver_addr"];
    self.receiver_name = [dict objectForKeyNotNull:@"receiver_name"];
    
    return self;
}

@end

