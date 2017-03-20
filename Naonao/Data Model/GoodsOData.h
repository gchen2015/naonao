//
//  GoodsOData.h
//  Naonao
//
//  Created by 刘敏 on 16/3/22.
//  Copyright © 2016年 深圳市轩腾华兴科技开发有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>


@class StoreData;

@interface GoodsOData : NSObject

@property (nonatomic, strong) NSNumber *count;          //商品数量
@property (nonatomic, strong) NSNumber *skuTag;         //SKU编号
@property (nonatomic, strong) NSNumber *stock;          //库存
@property (nonatomic, strong) NSNumber *proId;          //商品ID

@property (nonatomic, strong) NSString *imageURL;       //商品图片

@property (nonatomic, strong) NSDictionary *skuDict;    //SKU信息
@property (nonatomic, strong) NSString *proName;        //商品名称
@property (nonatomic, strong) NSNumber *price;          //商品价格

@property (nonatomic, strong) NSNumber *source_uid;     //推荐者的UserID

@property (nonatomic, strong) StoreData *store;


- (instancetype)initWithParsData:(NSDictionary *)dict;

@end



@interface StoreData : MTLModel<MTLJSONSerializing>

@property (nonatomic, strong) NSNumber *mId;          //ID
@property (nonatomic, strong) NSNumber *canTry;       //是否支持到店

@property (nonatomic, strong) NSString *logo;         //店铺Logo
@property (nonatomic, strong) NSString *name;         //店铺名称
@property (nonatomic, strong) NSString *address; 

@end



@interface CartData : NSObject

@property (nonatomic, strong) NSArray *goodsArray;
@property (nonatomic, strong) NSNumber *total;

- (instancetype)initWithParsData:(NSDictionary *)dict;

@end



@interface OrderModel : NSObject

@property (nonatomic, strong) NSString *orderNo;        //订单编号
@property (nonatomic, strong) NSNumber *orderId;        //订单ID
@property (nonatomic, strong) NSNumber *orderStatus;    //订单状态
@property (nonatomic, strong) NSArray *skuList;
@property (nonatomic, strong) NSNumber *type;

@property (nonatomic, strong) NSString *createTime;     //订单创建时间
@property (nonatomic, strong) NSNumber *totalPrice;     //订单金额

- (instancetype)initWithParsData:(NSDictionary *)dict;

@end


@interface SKUOrderModel : NSObject

@property (nonatomic, strong) NSString *proImg;             //图片地址
@property (nonatomic, strong) NSNumber *num;                //数量
@property (nonatomic, strong) NSNumber *productId;

@property (nonatomic, strong) NSString *proName;            //商品名称
@property (nonatomic, strong) NSNumber *price;              //单价
@property (nonatomic, strong) NSDictionary *skuInfo;        //SKU信息

@property (nonatomic, strong) StoreData *store;

- (instancetype)initWithParsData:(NSDictionary *)dict;

@end


// 订单详情
@class DeliveryInfo;
@interface OrderDetails : NSObject

@property (nonatomic, strong) NSNumber *status;             //订单状态
@property (nonatomic, strong) NSNumber *total_price;

@property (nonatomic, strong) DeliveryInfo *deliveryInfo;   //收货地址镜像

@property (nonatomic, strong) NSString *sign_time;
@property (nonatomic, strong) NSString *cancel_time;
@property (nonatomic, strong) NSString *create_time;
@property (nonatomic, strong) NSString *order_no;
@property (nonatomic, strong) NSString *pay_time;

@property (nonatomic, strong) NSNumber *order_id;
@property (nonatomic, strong) NSNumber *type;
@property (nonatomic, strong) NSNumber *remain_sec;         //剩余时间
@property (nonatomic, strong) NSNumber *tax_amount;
@property (nonatomic, strong) NSNumber *delivery_amount;    //快递费用

@property (nonatomic, strong) NSArray *skuList;


- (instancetype)initWithParsData:(NSDictionary *)dict;

@end


@interface DeliveryInfo : NSObject

@property (nonatomic, strong) NSString *receiver_telephone;
@property (nonatomic, strong) NSString *receiver_addr;
@property (nonatomic, strong) NSString *receiver_name;

- (instancetype)initWithParsData:(NSDictionary *)dict;

@end
