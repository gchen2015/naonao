//
//  ShoppingLogic.h
//  Naonao
//
//  Created by 刘敏 on 16/3/12.
//  Copyright © 2016年 深圳市轩腾华兴科技开发有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GoodsInfo.h"
#import "SKUData.h"
#import "GoodsOData.h"
#import "AddressInfo.h"


typedef void (^ShoppingLogicCommonCallback)(LogicResult* result);

@interface ShoppingLogic : NSObject

@property (nonatomic, assign) EnterSKUType m_type;              //进入渠道

@property (nonatomic, strong) OrderData *orderData;             //生成的订单信息（订单编号、订单ID）
@property (nonatomic, strong) SKUData *skuData;                 //SKU列表

@property (nonatomic, strong) NSMutableDictionary *tempDict;    //存储临时的商品SKU（记录选择的商品）
@property (nonatomic, strong) NSMutableArray *orderArray;       //订单信息

@property (nonatomic, strong) AddressInfo *defaulAddress;

@property (nonatomic, strong) NSNumber *re_userId;              //推荐人的UserID;
@property (nonatomic, strong) StoreData *store;                 //商家信息

+ (instancetype)sharedInstance;

// 缓存默认地址
- (BOOL)saveDefaulAddress:(AddressInfo *)mInfo;

// 获取默认地址
- (AddressInfo *)getDefaulAddress;

// 读取支付方式
- (NSArray *)laodConfigListWithPayment;

//添加临时SKU数据
- (void)addSomethingWithDict:(NSDictionary *)dict;

//封装存储临时订单数据
- (void)encapsulationTemporaryOrderData:(NSUInteger)count skuDesData:(skuDesData *)pdata;

// 添加商品到购物车
- (void)addProductShoppingCart:(NSDictionary *)param withCallback:(ShoppingLogicCommonCallback)results;

// 获取购物车内商品
- (void)getShopCartList:(NSDictionary *)dict withCallback:(ShoppingLogicCommonCallback)results;

// 删除购物车中的商品
- (void)getDeleteCart:(NSDictionary *)dict withCallback:(ShoppingLogicCommonCallback)results;

// 获取商品详情
- (void)getGoodsContent:(NSDictionary *)param withCallback:(ShoppingLogicCommonCallback)results;

// 获取商品的SKU
- (void)getGoodsSKU:(NSDictionary *)param withCallback:(ShoppingLogicCommonCallback)results;

// 获取商品评论列表
- (void)getProductCommentsList:(NSDictionary *)param withCallback:(ShoppingLogicCommonCallback)results;

// 生成订单
- (void)getOrder:(NSDictionary *)param withCallback:(ShoppingLogicCommonCallback)results;

// 生成支付要素
- (void)getGeneratePreparePaymentOrder:(NSDictionary *)param withCallback:(ShoppingLogicCommonCallback)results;

// 获取优惠券列表
- (void)getCouponList:(NSDictionary *)param withCallback:(ShoppingLogicCommonCallback)results;

// 获取可用的优惠券个数
- (void)getAvailableCouponCount:(NSDictionary *)param withCallback:(ShoppingLogicCommonCallback)results;

// 使用优惠券
- (void)useCoupon:(NSDictionary *)param withCallback:(ShoppingLogicCommonCallback)results;

// 给用户发送优惠券
- (void)sendCoupon:(NSDictionary *)param;

// 获取订单列表
- (void)getOrderList:(NSDictionary *)param withCallback:(ShoppingLogicCommonCallback)results;

// 获取订单详情
- (void)getOrderDetails:(NSDictionary *)param withCallback:(ShoppingLogicCommonCallback)results;

// 获取收货地址列表
- (void)getAddressList:(NSDictionary *)param withCallback:(ShoppingLogicCommonCallback)results;

// 更新收货地址
- (void)updateAddress:(NSDictionary *)param withCallback:(ShoppingLogicCommonCallback)results;

// 添加新的地址
- (void)addAddress:(NSDictionary *)param withCallback:(ShoppingLogicCommonCallback)results;

// 删除收货地址
- (void)deleteAddress:(NSDictionary *)param withCallback:(ShoppingLogicCommonCallback)results;

// 设置默认收货地址
- (void)SetDefaultAddress:(NSDictionary *)param withCallback:(ShoppingLogicCommonCallback)results;

// 取消订单
- (void)cancelOrder:(NSDictionary *)param withCallback:(ShoppingLogicCommonCallback)results;

// 删除订单
- (void)deleteOrder:(NSDictionary *)param withCallback:(ShoppingLogicCommonCallback)results;

//签收订单
- (void)signOrder:(NSDictionary *)param withCallback:(ShoppingLogicCommonCallback)results;

// 查看物流
- (void)lookLogisticsInfo:(NSDictionary *)param withCallback:(ShoppingLogicCommonCallback)results;

// 关联订单地址
- (void)associatedOrderAddress:(NSDictionary *)param withCallback:(ShoppingLogicCommonCallback)results;

// 评价商品（购物完成之后的评价）
- (void)productComment:(id)param withCallback:(ShoppingLogicCommonCallback)results;

// 扫一扫领取优惠券
- (void)getScanQRCode:(NSDictionary *)dic withCallback:(ShoppingLogicCommonCallback)results;

// 获取默认地址
- (void)requestDefaulAddress;

//清空临时订单数据
- (void)clearGoodsData;

// 注销时清空用户数据
- (BOOL)cleanDataWhenLogout;

@end
