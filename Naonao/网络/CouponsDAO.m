//
//  CouponsDAO.m
//  Naonao
//
//  Created by 刘敏 on 16/3/16.
//  Copyright © 2016年 深圳市轩腾华兴科技开发有限公司. All rights reserved.
//

#import "CouponsDAO.h"
#import "RequestModel.h"

@implementation CouponsDAO


// 获取优惠券
- (void)requestGetCouponList:(NSDictionary *)dict
                successBlock:(CouponsSuccessBlock)successBlock
              setFailedBlock:(CouponsFailedBlock)failedBlock
{
    [[RequestModel shareInstance] requestModelWithAPI:URL_GetCouponList
                                              getDict:dict
                                         successBlock:successBlock
                                       setFailedBlock:failedBlock];
}


// 用户可用优惠券的个数
- (void)requestGetCouponCount:(NSDictionary *)dict
                 successBlock:(CouponsSuccessBlock)successBlock
               setFailedBlock:(CouponsFailedBlock)failedBlock
{
    [[RequestModel shareInstance] requestModelWithAPI:URL_GetCouponCount
                                              getDict:dict
                                         successBlock:successBlock
                                       setFailedBlock:failedBlock];
}


// 使用优惠券
- (void)requestUseCoupon:(NSDictionary *)dict
            successBlock:(CouponsSuccessBlock)successBlock
          setFailedBlock:(CouponsFailedBlock)failedBlock
{
    [[RequestModel shareInstance] requestModelWithAPI:URL_UseCoupon
                                              getDict:dict
                                         successBlock:successBlock
                                       setFailedBlock:failedBlock];
}


// 发送优惠券
- (void)requestSendCoupon:(NSDictionary *)dict
             successBlock:(CouponsSuccessBlock)successBlock
           setFailedBlock:(CouponsFailedBlock)failedBlock
{
    [[RequestModel shareInstance] requestModelWithAPI:URL_SendCoupon
                                              getDict:dict
                                         successBlock:successBlock
                                       setFailedBlock:failedBlock];
}

// 领取优惠券（扫一扫）
- (void)requestScanQRCodeCoupon:(NSDictionary *)dict
                   successBlock:(CouponsSuccessBlock)successBlock
                 setFailedBlock:(CouponsFailedBlock)failedBlock
{
    [[RequestModel shareInstance] requestModelWithAPI:URL_BindCoupon
                                              getDict:dict
                                         successBlock:successBlock
                                       setFailedBlock:failedBlock];
}


@end
