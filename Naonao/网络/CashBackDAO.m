//
//  CashBackDAO.m
//  Naonao
//
//  Created by 刘敏 on 16/5/16.
//  Copyright © 2016年 深圳市轩腾华兴科技开发有限公司. All rights reserved.
//

#import "CashBackDAO.h"
#import "RequestModel.h"

@implementation CashBackDAO

// 获取我的钱包
- (void)requestGetMyWallet:(NSDictionary *)dict
              successBlock:(CashBackSuccessBlock)successBlock
            setFailedBlock:(CashBackFailedBlock)failedBlock
{
    [[RequestModel shareInstance] requestModelWithAPI:URL_GetMyWallet
                                              getDict:dict
                                         successBlock:successBlock
                                       setFailedBlock:failedBlock];
}



// 提现记录
- (void)requestGetWithdrawalRecords:(NSDictionary *)dict
                       successBlock:(CashBackSuccessBlock)successBlock
                     setFailedBlock:(CashBackFailedBlock)failedBlock
{
    [[RequestModel shareInstance] requestModelWithAPI:URL_GetWithdrawalRecords
                                              getDict:dict
                                         successBlock:successBlock
                                       setFailedBlock:failedBlock];
}


// 提现申请
- (void)requestGetApplyWithdrawal:(NSDictionary *)dict
                     successBlock:(CashBackSuccessBlock)successBlock
                   setFailedBlock:(CashBackFailedBlock)failedBlock
{
    [[RequestModel shareInstance] requestModelWithAPI:URL_ApplyWithdrawal
                                              getDict:dict
                                         successBlock:successBlock
                                       setFailedBlock:failedBlock];
}


// 提现详情
- (void)requestGetWithdrawalDetails:(NSDictionary *)dict
                       successBlock:(CashBackSuccessBlock)successBlock
                     setFailedBlock:(CashBackFailedBlock)failedBlock
{
    [[RequestModel shareInstance] requestModelWithAPI:URL_WithdrawalDetails
                                              getDict:dict
                                         successBlock:successBlock
                                       setFailedBlock:failedBlock];
}


// 单个商品返现明细
- (void)requestGetGoodsCashbackDetails:(NSDictionary *)dict
                          successBlock:(CashBackSuccessBlock)successBlock
                        setFailedBlock:(CashBackFailedBlock)failedBlock
{
    [[RequestModel shareInstance] requestModelWithAPI:URL_GoodsCashbackDetails
                                              getDict:dict
                                         successBlock:successBlock
                                       setFailedBlock:failedBlock];
}



@end
