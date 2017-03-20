//
//  ShoppingLogic.m
//  Naonao
//
//  Created by 刘敏 on 16/3/12.
//  Copyright © 2016年 深圳市轩腾华兴科技开发有限公司. All rights reserved.
//

#import "ShoppingLogic.h"
#import "PaymentChannelInfo.h"
#import "ShoppingModel.h"
#import "CouponsDAO.h"
#import "GoodsInfo.h"
#import "SKUData.h"
#import "AddressDAO.h"
#import "AddressInfo.h"
#import "CouponsModel.h"
#import "CommentsModelFrame.h"

@implementation ShoppingLogic

+ (instancetype)sharedInstance {
    
    static dispatch_once_t onceToken;
    static ShoppingLogic* instance = nil;
    dispatch_once(&onceToken, ^{
        instance = [[ShoppingLogic alloc] init];
    });
    return instance;
}

- (instancetype)init
{
    if (self = [super init]) {
        
        if (!_tempDict) {
            _tempDict = [[NSMutableDictionary alloc] init];
        }
        
        if (!_orderArray) {
            _orderArray = [NSMutableArray array];
        }
        
        //获取用户默认地址
        _defaulAddress = [NSKeyedUnarchiver unarchiveObjectWithFile:[Units getProfilePath:kDefaultAddress]];
    }
    
    return self;
}

- (void)setRe_userId:(NSNumber *)re_userId
{
    _re_userId = re_userId;
}

// 获取默认地址
- (AddressInfo *)getDefaulAddress
{
    return _defaulAddress;
}

// 缓存默认地址
- (BOOL)saveDefaulAddress:(AddressInfo *)mInfo
{
    _defaulAddress = mInfo;
    return [NSKeyedArchiver archiveRootObject:_defaulAddress toFile:[Units getProfilePath:kDefaultAddress]];
}


//读取支付方式
- (NSArray *)laodConfigListWithPayment
{
    //读取
    NSString* filePath = [[NSBundle mainBundle] pathForResource:kConfigName ofType:@"plist"];
    NSArray *jsonArray = [[NSDictionary dictionaryWithContentsOfFile:filePath] objectForKey:@"payment"];
    NSArray* paymentArray =  [MTLJSONAdapter modelsOfClass:[PaymentChannelInfo class]
                                             fromJSONArray:jsonArray
                                                     error:nil];

    return paymentArray;
}

//设置进入SKU入口（加入购物车、直接购买）
- (void)setM_type:(EnterSKUType)m_type
{
    _m_type = m_type;
}

//添加临时SKU数据
- (void)addSomethingWithDict:(NSDictionary *)dict
{
    [_tempDict addEntriesFromDictionary:dict];
}

//封装存储临时订单数据
- (void)encapsulationTemporaryOrderData:(NSUInteger)count skuDesData:(skuDesData *)pdata
{
    if (!pdata) {
        return;
    }
    
    GoodsOData *goodsTData = [[GoodsOData alloc] init];
    
    //SKU信息
    goodsTData.skuDict = _tempDict;
    //商品数量
    goodsTData.count = [NSNumber numberWithInteger:count];
    //SKU编号
    goodsTData.skuTag = pdata.skuId;
    goodsTData.source_uid = pdata.source_uid;
    goodsTData.stock = pdata.stock;
    
    //商品名称
    goodsTData.proName = _skuData.prodName;
    
    //商品价格(以SKU价格为准)
    goodsTData.price = pdata.price;
    //商品图片
    goodsTData.imageURL = _skuData.imgUrl;
    
    //店铺信息
    goodsTData.store = _store;
    
    //加入购物车
    if (_m_type == KSKU_Cart)
    {
        //调用加入购物车请求
        
    }
    else if(_m_type == KSKU_Order)
    {
        [_orderArray addObject:goodsTData];
    }
    
}

// 添加商品到购物车
- (void)addProductShoppingCart:(NSDictionary *)param withCallback:(ShoppingLogicCommonCallback)results
{
    ShoppingModel *dao = [[ShoppingModel alloc] init];
    LogicResult* cb = [[LogicResult alloc] init];
    
    [dao requestAddProductShoppingCart:param successBlock:^(NSDictionary *result) {
        [cb success];
        results(cb);
        
    } setFailedBlock:^(ResponseHeader *result) {
        [cb failure:result];
        results(cb);
    }];
}


// 获取购物车内商品
- (void)getShopCartList:(NSDictionary *)dict withCallback:(ShoppingLogicCommonCallback)results
{
    ShoppingModel *dao = [[ShoppingModel alloc] init];
    LogicResult* cb = [[LogicResult alloc] init];
    
    [dao requestGetShoppingCart:dict successBlock:^(NSDictionary *result) {
        
        [cb success];
        
        if (result.count > 0) {
            cb.mObject = [[CartData alloc] initWithParsData:result];
        }
        
        results(cb);

    } setFailedBlock:^(ResponseHeader *result) {
        [cb failure:result];
        results(cb);
    }];
}

// 删除购物车中的商品
- (void)getDeleteCart:(NSDictionary *)dict withCallback:(ShoppingLogicCommonCallback)results
{
    ShoppingModel *dao = [[ShoppingModel alloc] init];
    LogicResult* cb = [[LogicResult alloc] init];
    [dao requestDeleteProductShoppingCart:dict successBlock:^(NSDictionary *result) {
        [cb success];
        results(cb);
        
    } setFailedBlock:^(ResponseHeader *result) {
        [cb failure:result];
        results(cb);
    }];
}

// 获取商品详情
- (void)getGoodsContent:(NSDictionary *)param withCallback:(ShoppingLogicCommonCallback)results
{
    ShoppingModel *dao = [[ShoppingModel alloc] init];
    LogicResult* cb = [[LogicResult alloc] init];
    
    [dao requestGetGoodsDetails:param successBlock:^(NSDictionary *result) {
        [cb success];
        cb.mObject = [MTLJSONAdapter modelOfClass:[GoodsInfo class] fromJSONDictionary:result error:nil];
        results(cb);
        
    } setFailedBlock:^(ResponseHeader *result) {
        [cb failure:result];
        results(cb);
    }];
}

// 获取商品的SKU
- (void)getGoodsSKU:(NSDictionary *)param withCallback:(ShoppingLogicCommonCallback)results
{
    ShoppingModel *dao = [[ShoppingModel alloc] init];
    LogicResult* cb = [[LogicResult alloc] init];
    
    [dao requestGetGoodsSKU:param successBlock:^(NSDictionary *result) {
        _skuData = [[SKUData alloc] initWithParsData:result];
        [cb success];
        results(cb);
        
    } setFailedBlock:^(ResponseHeader *result) {
        [cb failure:result];
        results(cb);
    }];
    
}

// 获取商品评论列表
- (void)getProductCommentsList:(NSDictionary *)param withCallback:(ShoppingLogicCommonCallback)results
{
    ShoppingModel *dao = [[ShoppingModel alloc] init];
    LogicResult* cb = [[LogicResult alloc] init];
    
    [dao requestproductCommentsList:param successBlock:^(NSDictionary *result) {
        
        NSArray *tA = [MTLJSONAdapter modelsOfClass:[CommentInfo class] fromJSONArray:(NSArray *)result error:nil];
        NSMutableArray *temp = [NSMutableArray arrayWithCapacity:tA.count];
        
        for (int i = 0; i<tA.count; i++) {
            CommentsProductFrame *cModel = [[CommentsProductFrame alloc] init];
            cModel.tData = [tA objectAtIndex:i];
            
            [temp addObject:cModel];
        }
        
        cb.mObject = temp;
        [cb success];
        results(cb);
        
    } setFailedBlock:^(ResponseHeader *result) {
        [cb failure:result];
        results(cb);
    }];
}

// 生成订单
- (void)getOrder:(NSDictionary *)param withCallback:(ShoppingLogicCommonCallback)results
{
    ShoppingModel *dao = [[ShoppingModel alloc] init];
    LogicResult* cb = [[LogicResult alloc] init];
    
    [dao requestCreatePaymentOrders:param successBlock:^(NSDictionary *result) {
        [cb success];
        _orderData = [MTLJSONAdapter modelOfClass:[OrderData class] fromJSONDictionary:result error:nil];
        results(cb);
        
    } setFailedBlock:^(ResponseHeader *result) {
        [cb failure:result];
        results(cb);
    }];
}


// 生成支付要素
- (void)getGeneratePreparePaymentOrder:(NSDictionary *)param withCallback:(ShoppingLogicCommonCallback)results
{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithDictionary:param];
    [dict setObject:_orderData.order_id forKey:@"orderid"];
    
    ShoppingModel *dao = [[ShoppingModel alloc] init];
    LogicResult* cb = [[LogicResult alloc] init];
    
    [dao requestPaymentElements:dict successBlock:^(NSDictionary *result) {
        [cb success];
        cb.mObject = (id)result;
        results(cb);
        
    } setFailedBlock:^(ResponseHeader *result) {
        [cb failure:result];
        results(cb);
    }];
}

// 获取优惠券列表
- (void)getCouponList:(NSDictionary *)param withCallback:(ShoppingLogicCommonCallback)results
{
    CouponsDAO *dao = [[CouponsDAO alloc] init];
    LogicResult* cb = [[LogicResult alloc] init];
    
    [dao requestGetCouponList:param successBlock:^(NSDictionary *result) {
        [cb success];
        cb.mObject = [MTLJSONAdapter modelsOfClass:[CouponsModel class] fromJSONArray:(NSArray *)result error:nil];
        results(cb);
        
    } setFailedBlock:^(ResponseHeader *result) {
        [cb failure:result];
        results(cb);
        
    }];
}

//获取可用的优惠券个数
- (void)getAvailableCouponCount:(NSDictionary *)param withCallback:(ShoppingLogicCommonCallback)results
{
    CouponsDAO *dao = [[CouponsDAO alloc] init];
    LogicResult* cb = [[LogicResult alloc] init];
    
    [dao requestGetCouponCount:param successBlock:^(NSDictionary *result) {
        [cb success];
        cb.mObject = result;
        results(cb);
        
    } setFailedBlock:^(ResponseHeader *result) {
        [cb failure:result];
        results(cb);
        
    }];
}

//使用优惠券
- (void)useCoupon:(NSDictionary *)param withCallback:(ShoppingLogicCommonCallback)results
{
    CouponsDAO *dao = [[CouponsDAO alloc] init];
    LogicResult* cb = [[LogicResult alloc] init];
    
    [dao requestUseCoupon:param successBlock:^(NSDictionary *result) {
        [cb success];
        results(cb);
        
    } setFailedBlock:^(ResponseHeader *result) {
        [cb failure:result];
        results(cb);
        
    }];
}


//给用户发送优惠券
- (void)sendCoupon:(NSDictionary *)param;
{
    CouponsDAO *dao = [[CouponsDAO alloc] init];
    [dao requestSendCoupon:param successBlock:^(NSDictionary *result) {
        [theAppDelegate.window makeToast:@"已领取50元优惠券，请到我的优惠券中查看"];
    } setFailedBlock:^(ResponseHeader *result) {

    }];
}


// 获取订单列表
- (void)getOrderList:(NSDictionary *)param withCallback:(ShoppingLogicCommonCallback)results
{
    ShoppingModel *dao = [[ShoppingModel alloc] init];
    LogicResult* cb = [[LogicResult alloc] init];
    
    [dao requestGetOrderList:param successBlock:^(NSDictionary *result) {
        [cb success];
        cb.mObject = [self parsingOrderList:(NSArray *)result];
        results(cb);
        
    } setFailedBlock:^(ResponseHeader *result) {
        [cb failure:result];
        results(cb);
    }];
}

//解析订单数据
- (NSArray *)parsingOrderList:(NSArray *)tArray
{
    NSMutableArray *tempA = [[NSMutableArray alloc] initWithCapacity:tArray.count];
    for (NSDictionary *item in tArray) {
        OrderModel *model = [[OrderModel alloc] initWithParsData:item];
        
        [tempA addObject:model];
    }
    
    return tempA;
}

// 获取收货地址列表
- (void)getAddressList:(NSDictionary *)param withCallback:(ShoppingLogicCommonCallback)results
{
    AddressDAO *dao = [[AddressDAO alloc] init];
    LogicResult* cb = [[LogicResult alloc] init];
    
    [dao requestGetAddressList:param successBlock:^(NSDictionary *result) {
        [cb success];
        cb.mObject = [MTLJSONAdapter modelsOfClass:[AddressInfo class] fromJSONArray:(NSArray *)result error:nil];
        results(cb);
        
    } setFailedBlock:^(ResponseHeader *result) {
        [cb failure:result];
        results(cb);
    }];
}


// 获取订单详情
- (void)getOrderDetails:(NSDictionary *)param withCallback:(ShoppingLogicCommonCallback)results
{
    ShoppingModel *dao = [[ShoppingModel alloc] init];
    LogicResult* cb = [[LogicResult alloc] init];
    
    [dao requestGetOrderDetail:param successBlock:^(NSDictionary *result) {
        [cb success];
        cb.mObject = [[OrderDetails alloc] initWithParsData:result];
        results(cb);
        
    } setFailedBlock:^(ResponseHeader *result) {
        [cb failure:result];
        results(cb);
    }];
}


// 更新收货地址
- (void)updateAddress:(NSDictionary *)param withCallback:(ShoppingLogicCommonCallback)results
{
    AddressDAO *dao = [[AddressDAO alloc] init];
    LogicResult* cb = [[LogicResult alloc] init];
    
    [dao requestUpdateAddress:param publicDict:nil successBlock:^(NSDictionary *result) {
        [cb success];
        results(cb);
    } setFailedBlock:^(ResponseHeader *result) {
        [cb failure:result];
        results(cb);
    }];
}

// 添加新的地址
- (void)addAddress:(NSDictionary *)param withCallback:(ShoppingLogicCommonCallback)results
{
    AddressDAO *dao = [[AddressDAO alloc] init];
    LogicResult* cb = [[LogicResult alloc] init];

    [dao requestAddAddress:param publicDict:nil successBlock:^(NSDictionary *result) {
        [cb success];
        cb.mObject = result;
        results(cb);
    } setFailedBlock:^(ResponseHeader *result) {
        [cb failure:result];
        results(cb);
    }];
}

// 删除收货地址
- (void)deleteAddress:(NSDictionary *)param withCallback:(ShoppingLogicCommonCallback)results
{
    AddressDAO *dao = [[AddressDAO alloc] init];
    LogicResult* cb = [[LogicResult alloc] init];
    
    [dao requestDeleteAddress:param successBlock:^(NSDictionary *result) {
        [cb success];
        results(cb);
    } setFailedBlock:^(ResponseHeader *result) {
        [cb failure:result];
        results(cb);
    }];
}

// 设置默认收货地址
- (void)SetDefaultAddress:(NSDictionary *)param withCallback:(ShoppingLogicCommonCallback)results
{
    AddressDAO *dao = [[AddressDAO alloc] init];
    LogicResult* cb = [[LogicResult alloc] init];
    
    [dao requestSetDefaultAddress:param successBlock:^(NSDictionary *result) {
        [cb success];
        results(cb);
    } setFailedBlock:^(ResponseHeader *result) {
        [cb failure:result];
        results(cb);
    }];
}


// 取消订单
- (void)cancelOrder:(NSDictionary *)param withCallback:(ShoppingLogicCommonCallback)results
{
    ShoppingModel *dao = [[ShoppingModel alloc] init];
    LogicResult* cb = [[LogicResult alloc] init];
    
    [dao requestGetCancelOrder:param successBlock:^(NSDictionary *result) {
        [cb success];
        results(cb);
        
    } setFailedBlock:^(ResponseHeader *result) {
        [cb failure:result];
        results(cb);
    }];

}

// 删除订单
- (void)deleteOrder:(NSDictionary *)param withCallback:(ShoppingLogicCommonCallback)results
{
    ShoppingModel *dao = [[ShoppingModel alloc] init];
    LogicResult* cb = [[LogicResult alloc] init];
    
    [dao requestGetDeleteOrder:param successBlock:^(NSDictionary *result) {
        [cb success];
        results(cb);
        
    } setFailedBlock:^(ResponseHeader *result) {
        [cb failure:result];
        results(cb);
    }];

}

//签收订单
- (void)signOrder:(NSDictionary *)param withCallback:(ShoppingLogicCommonCallback)results
{
    ShoppingModel *dao = [[ShoppingModel alloc] init];
    LogicResult* cb = [[LogicResult alloc] init];
    
    [dao requestSignOrder:param successBlock:^(NSDictionary *result) {
        [cb success];
        results(cb);
        
    } setFailedBlock:^(ResponseHeader *result) {
        [cb failure:result];
        results(cb);
    }];
}



// 关联订单地址
- (void)associatedOrderAddress:(NSDictionary *)param withCallback:(ShoppingLogicCommonCallback)results
{
    ShoppingModel *dao = [[ShoppingModel alloc] init];
    LogicResult* cb = [[LogicResult alloc] init];
    
    [dao requestAssociatedOrderAddress:param successBlock:^(NSDictionary *result) {
        [cb success];
        results(cb);
        
    } setFailedBlock:^(ResponseHeader *result) {
        [cb failure:result];
        results(cb);
    }];
}

//查看物流
- (void)lookLogisticsInfo:(NSDictionary *)param withCallback:(ShoppingLogicCommonCallback)results
{
    ShoppingModel *dao = [[ShoppingModel alloc] init];
    LogicResult* cb = [[LogicResult alloc] init];
    
    [dao requestLogisticsGoodsInfo:param successBlock:^(NSDictionary *result) {
        [cb success];
        
        cb.mObject = [MTLJSONAdapter modelOfClass:[CourierInfo class] fromJSONDictionary:result error:nil];
        results(cb);
        
    } setFailedBlock:^(ResponseHeader *result) {
        [cb failure:result];
        results(cb);
    }];
}

// 评价商品（购物完成之后的评价）
- (void)productComment:(id)param withCallback:(ShoppingLogicCommonCallback)results
{
    ShoppingModel *dao = [[ShoppingModel alloc] init];
    LogicResult* cb = [[LogicResult alloc] init];
    
    [dao requestproductComment:param publicDict:nil successBlock:^(NSDictionary *result) {
        [cb success];
        results(cb);
    } setFailedBlock:^(ResponseHeader *result) {
        [cb failure:result];
        results(cb);
    }];
    
}


// 获取默认地址
- (void)requestDefaulAddress
{
    AddressDAO *dao = [[AddressDAO alloc] init];
    LogicResult* cb = [[LogicResult alloc] init];
    
    [dao requestGetDefaultAddress:nil successBlock:^(NSDictionary *result) {
        [cb success];
        AddressInfo *aInfo = [MTLJSONAdapter modelOfClass:[AddressInfo class] fromJSONDictionary:result error:nil];
        [self saveDefaulAddress:aInfo];

    } setFailedBlock:^(ResponseHeader *result) {
        [cb failure:result];
    }];
}

// 扫一扫领取优惠券
- (void)getScanQRCode:(NSDictionary *)dict withCallback:(ShoppingLogicCommonCallback)results
{
    CouponsDAO *dao = [[CouponsDAO alloc] init];
    LogicResult* cb = [[LogicResult alloc] init];
    
    [dao requestScanQRCodeCoupon:dict successBlock:^(NSDictionary *result) {
        [cb success];
        results(cb);
    } setFailedBlock:^(ResponseHeader *result) {
        [cb failure:result];
        results(cb);
    }];

}



//清空临时订单数据
- (void)clearGoodsData
{
    [_orderArray removeAllObjects];
    
    //清除订单号（订单编号、id）
    _orderData = nil;
    _store = nil;
    _re_userId = nil;
}

// 注销时清空用户默认地址
- (BOOL)cleanDataWhenLogout
{
    BOOL suc = [Units removeFileAtPath:[Units getProfilePath:kDefaultAddress]];
    if (suc) {
        _defaulAddress = nil;
    }
    return suc;
}

@end
