//
//  ShoppingModel.m
//  Naonao
//
//  Created by 刘敏 on 16/3/12.
//  Copyright © 2016年 深圳市轩腾华兴科技开发有限公司. All rights reserved.
//

#import "ShoppingModel.h"
#import "RequestModel.h"

@implementation ShoppingModel

// 获取商品详情
- (void)requestGetGoodsDetails:(NSDictionary *)dict
                  successBlock:(ShoppingSuccessBlock)successBlock
                setFailedBlock:(ShoppingFailedBlock)failedBlock
{
    [[RequestModel shareInstance] requestModelWithAPI:URL_GetGoodsContent
                                              getDict:dict
                                         successBlock:successBlock
                                       setFailedBlock:failedBlock];
}

// 获取商品SKU
- (void)requestGetGoodsSKU:(NSDictionary *)dict
              successBlock:(ShoppingSuccessBlock)successBlock
            setFailedBlock:(ShoppingFailedBlock)failedBlock
{
    [[RequestModel shareInstance] requestModelWithAPI:URL_GetGoodsSKUList
                                              getDict:dict
                                         successBlock:successBlock
                                       setFailedBlock:failedBlock];
}

// 创建订单
- (void)requestCreatePaymentOrders:(NSDictionary *)dict
                      successBlock:(ShoppingSuccessBlock)successBlock
                    setFailedBlock:(ShoppingFailedBlock)failedBlock
{
    [[RequestModel shareInstance] requestModelWithAPI:URL_CreateOrder
                                              getDict:dict
                                         successBlock:successBlock
                                       setFailedBlock:failedBlock];
}

// 获取支付要素
- (void)requestPaymentElements:(NSDictionary *)dict
                  successBlock:(ShoppingSuccessBlock)successBlock
                setFailedBlock:(ShoppingFailedBlock)failedBlock
{
    [[RequestModel shareInstance] requestModelWithAPI:URL_PrePayOrder
                                              getDict:dict
                                         successBlock:successBlock
                                       setFailedBlock:failedBlock];
}


// 获取货物车商品
- (void)requestGetShoppingCart:(NSDictionary *)dict
                  successBlock:(ShoppingSuccessBlock)successBlock
                setFailedBlock:(ShoppingFailedBlock)failedBlock
{
    [[RequestModel shareInstance] requestModelWithAPI:URL_GetShopCart
                                              getDict:dict
                                         successBlock:successBlock
                                       setFailedBlock:failedBlock];
}


// 添加商品进购物车
- (void)requestAddProductShoppingCart:(NSDictionary *)dict
                         successBlock:(ShoppingSuccessBlock)successBlock
                       setFailedBlock:(ShoppingFailedBlock)failedBlock
{
    [[RequestModel shareInstance] requestModelWithAPI:URL_AddItemsInCart
                                              getDict:dict
                                         successBlock:successBlock
                                       setFailedBlock:failedBlock];
}

// 删除购物车中的商品
- (void)requestDeleteProductShoppingCart:(NSDictionary *)dict
                            successBlock:(ShoppingSuccessBlock)successBlock
                          setFailedBlock:(ShoppingFailedBlock)failedBlock
{
    [[RequestModel shareInstance] requestModelWithAPI:URL_DeleteItemsInCart
                                              getDict:dict
                                         successBlock:successBlock
                                       setFailedBlock:failedBlock];
}


// 获取订单列表
- (void)requestGetOrderList:(NSDictionary *)dict
               successBlock:(ShoppingSuccessBlock)successBlock
             setFailedBlock:(ShoppingFailedBlock)failedBlock
{
    [[RequestModel shareInstance] requestModelWithAPI:URL_MineOrderList
                                              getDict:dict
                                         successBlock:successBlock
                                       setFailedBlock:failedBlock];
}


// 获取订单详情
- (void)requestGetOrderDetail:(NSDictionary *)dict
                 successBlock:(ShoppingSuccessBlock)successBlock
               setFailedBlock:(ShoppingFailedBlock)failedBlock
{
    [[RequestModel shareInstance] requestModelWithAPI:URL_OrderDetail
                                               getDict:dict
                                          successBlock:successBlock
                                        setFailedBlock:failedBlock];
    
}


// 取消订单
- (void)requestGetCancelOrder:(NSDictionary *)dict
                 successBlock:(ShoppingSuccessBlock)successBlock
               setFailedBlock:(ShoppingFailedBlock)failedBlock
{
    [[RequestModel shareInstance] requestModelWithAPI:URL_UserCancelOrder
                                              getDict:dict
                                         successBlock:successBlock
                                       setFailedBlock:failedBlock];
}


// 删除订单
- (void)requestGetDeleteOrder:(NSDictionary *)dict
                 successBlock:(ShoppingSuccessBlock)successBlock
               setFailedBlock:(ShoppingFailedBlock)failedBlock
{
    [[RequestModel shareInstance] requestModelWithAPI:URL_UserDeleteOrder
                                              getDict:dict
                                         successBlock:successBlock
                                       setFailedBlock:failedBlock];
}

// 签收订单
- (void)requestSignOrder:(NSDictionary *)dict
            successBlock:(ShoppingSuccessBlock)successBlock
          setFailedBlock:(ShoppingFailedBlock)failedBlock
{
    [[RequestModel shareInstance] requestModelWithAPI:URL_UserSignOrder
                                              getDict:dict
                                         successBlock:successBlock
                                       setFailedBlock:failedBlock];
}



// 关联订单地址
- (void)requestAssociatedOrderAddress:(NSDictionary *)dict
                         successBlock:(ShoppingSuccessBlock)successBlock
                       setFailedBlock:(ShoppingFailedBlock)failedBlock
{
    [[RequestModel shareInstance] requestModelWithAPI:URL_AssociatedOrderAddress
                                              getDict:dict
                                         successBlock:successBlock
                                       setFailedBlock:failedBlock];
}


// 查看物流信息
- (void)requestLogisticsGoodsInfo:(NSDictionary *)dict
                     successBlock:(ShoppingSuccessBlock)successBlock
                   setFailedBlock:(ShoppingFailedBlock)failedBlock
{
    [[RequestModel shareInstance] requestModelWithAPI:URL_GetLogisticsInfo
                                              getDict:dict
                                         successBlock:successBlock
                                       setFailedBlock:failedBlock];
}


// 评价商品（购物完成之后的评价）
- (void)requestproductComment:(id)dict
                   publicDict:(NSDictionary *)publicDict
                 successBlock:(ShoppingSuccessBlock)successBlock
               setFailedBlock:(ShoppingFailedBlock)failedBlock
{
    [[RequestModel shareInstance] requestModelWithAPI:URL_GetPoductComment
                                             postDict:dict
                                           publicDict:publicDict
                                         successBlock:successBlock
                                       setFailedBlock:failedBlock];
}


// 获取商品评价列表
- (void)requestproductCommentsList:(NSDictionary *)dict
                      successBlock:(ShoppingSuccessBlock)successBlock
                    setFailedBlock:(ShoppingFailedBlock)failedBlock
{
    [[RequestModel shareInstance] requestModelWithAPI:URL_GetPCommentsList
                                              getDict:dict
                                         successBlock:successBlock
                                       setFailedBlock:failedBlock];
}



@end
