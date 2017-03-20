//
//  ShoppingModel.h
//  Naonao
//
//  Created by 刘敏 on 16/3/12.
//  Copyright © 2016年 深圳市轩腾华兴科技开发有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ResponseHeader.h"

typedef void (^ShoppingSuccessBlock)(NSDictionary *result);
typedef void (^ShoppingFailedBlock)(ResponseHeader *result);

@interface ShoppingModel : NSObject

/**
 *  获取商品详情
 *  GET
 *
 *  @param dict
 *  @param successBlock
 *  @param failedBlock
 */
- (void)requestGetGoodsDetails:(NSDictionary *)dict
                  successBlock:(ShoppingSuccessBlock)successBlock
                setFailedBlock:(ShoppingFailedBlock)failedBlock;

/**
 *  获取商品SKU
 *  GET
 *
 *  @param dict
 *  @param successBlock
 *  @param failedBlock
 */
- (void)requestGetGoodsSKU:(NSDictionary *)dict
              successBlock:(ShoppingSuccessBlock)successBlock
            setFailedBlock:(ShoppingFailedBlock)failedBlock;

/**
 *  创建订单
 *  GET
 *
 *  @param dict
 *  @param successBlock
 *  @param failedBlock
 */
- (void)requestCreatePaymentOrders:(NSDictionary *)dict
                      successBlock:(ShoppingSuccessBlock)successBlock
                    setFailedBlock:(ShoppingFailedBlock)failedBlock;

/**
 *  获取支付要素
 *  GET
 *
 *  @param dict
 *  @param successBlock
 *  @param failedBlock
 */
- (void)requestPaymentElements:(NSDictionary *)dict
                  successBlock:(ShoppingSuccessBlock)successBlock
                setFailedBlock:(ShoppingFailedBlock)failedBlock;


/**
 *  获取货物车商品
 *  GET
 *
 *  @param dict
 *  @param successBlock
 *  @param failedBlock
 */
- (void)requestGetShoppingCart:(NSDictionary *)dict
                  successBlock:(ShoppingSuccessBlock)successBlock
                setFailedBlock:(ShoppingFailedBlock)failedBlock;


/**
 *  添加商品进购物车
 *  GET
 *
 *  @param dict
 *  @param successBlock
 *  @param failedBlock
 */
- (void)requestAddProductShoppingCart:(NSDictionary *)dict
                         successBlock:(ShoppingSuccessBlock)successBlock
                       setFailedBlock:(ShoppingFailedBlock)failedBlock;


/**
 *  删除购物车中的商品
 *  GET
 *
 *  @param dict
 *  @param successBlock
 *  @param failedBlock
 */
- (void)requestDeleteProductShoppingCart:(NSDictionary *)dict
                            successBlock:(ShoppingSuccessBlock)successBlock
                          setFailedBlock:(ShoppingFailedBlock)failedBlock;


/**
 *  获取订单列表
 *  GET
 *
 *  @param dict
 *  @param successBlock
 *  @param failedBlock
 */
- (void)requestGetOrderList:(NSDictionary *)dict
               successBlock:(ShoppingSuccessBlock)successBlock
             setFailedBlock:(ShoppingFailedBlock)failedBlock;

/**
 *  获取订单详情
 *  GET
 *
 *  @param dict
 *  @param successBlock
 *  @param failedBlock
 */
- (void)requestGetOrderDetail:(NSDictionary *)dict
                 successBlock:(ShoppingSuccessBlock)successBlock
               setFailedBlock:(ShoppingFailedBlock)failedBlock;



/**
 *  取消订单
 *  GET
 *
 *  @param dict
 *  @param successBlock
 *  @param failedBlock
 */
- (void)requestGetCancelOrder:(NSDictionary *)dict
                 successBlock:(ShoppingSuccessBlock)successBlock
               setFailedBlock:(ShoppingFailedBlock)failedBlock;

/**
 *  删除订单
 *  GET
 *
 *  @param dict
 *  @param successBlock
 *  @param failedBlock
 */
- (void)requestGetDeleteOrder:(NSDictionary *)dict
                 successBlock:(ShoppingSuccessBlock)successBlock
               setFailedBlock:(ShoppingFailedBlock)failedBlock;

/**
 *  签收订单
 *  GET
 *
 *  @param dict
 *  @param successBlock
 *  @param failedBlock
 */
- (void)requestSignOrder:(NSDictionary *)dict
            successBlock:(ShoppingSuccessBlock)successBlock
          setFailedBlock:(ShoppingFailedBlock)failedBlock;

/**
 *  关联订单地址
 *  GET
 *
 *  @param dict
 *  @param successBlock
 *  @param failedBlock
 */
- (void)requestAssociatedOrderAddress:(NSDictionary *)dict
                         successBlock:(ShoppingSuccessBlock)successBlock
                       setFailedBlock:(ShoppingFailedBlock)failedBlock;

/**
 *  查看物流信息
 *  GET
 *
 *  @param dict
 *  @param successBlock
 *  @param failedBlock
 */
- (void)requestLogisticsGoodsInfo:(NSDictionary *)dict
                     successBlock:(ShoppingSuccessBlock)successBlock
                   setFailedBlock:(ShoppingFailedBlock)failedBlock;

/**
 *  评价商品（购物完成之后的评价）
 *  POST
 *
 *  @param dict
 *  @param successBlock
 *  @param failedBlock
 */
- (void)requestproductComment:(id)dict
                   publicDict:(NSDictionary *)publicDict
                 successBlock:(ShoppingSuccessBlock)successBlock
               setFailedBlock:(ShoppingFailedBlock)failedBlock;


/**
 *  获取商品评价列表
 *  GET
 *
 *  @param dict
 *  @param successBlock
 *  @param failedBlock
 */
- (void)requestproductCommentsList:(NSDictionary *)dict
                      successBlock:(ShoppingSuccessBlock)successBlock
                    setFailedBlock:(ShoppingFailedBlock)failedBlock;

@end
