//
//  CashBackDAO.h
//  Naonao
//
//  Created by 刘敏 on 16/5/16.
//  Copyright © 2016年 深圳市轩腾华兴科技开发有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ResponseHeader.h"

typedef void (^CashBackSuccessBlock)(NSDictionary *result);
typedef void (^CashBackFailedBlock)(ResponseHeader *result);


@interface CashBackDAO : NSObject


/**
 *  获取我的钱包
 *  GET
 *
 *  @param dict
 *  @param successBlock
 *  @param failedBlock
 */
- (void)requestGetMyWallet:(NSDictionary *)dict
              successBlock:(CashBackSuccessBlock)successBlock
            setFailedBlock:(CashBackFailedBlock)failedBlock;



/**
 *  提现记录
 *  GET
 *
 *  @param dict
 *  @param successBlock
 *  @param failedBlock
 */
- (void)requestGetWithdrawalRecords:(NSDictionary *)dict
                       successBlock:(CashBackSuccessBlock)successBlock
                     setFailedBlock:(CashBackFailedBlock)failedBlock;

/**
 *  提现申请
 *  GET
 *
 *  @param dict
 *  @param successBlock
 *  @param failedBlock
 */
- (void)requestGetApplyWithdrawal:(NSDictionary *)dict
                     successBlock:(CashBackSuccessBlock)successBlock
                   setFailedBlock:(CashBackFailedBlock)failedBlock;


/**
 *  提现详情
 *  GET
 *
 *  @param dict
 *  @param successBlock
 *  @param failedBlock
 */
- (void)requestGetWithdrawalDetails:(NSDictionary *)dict
                       successBlock:(CashBackSuccessBlock)successBlock
                     setFailedBlock:(CashBackFailedBlock)failedBlock;


/**
 *  单个商品返现明细
 *  GET
 *
 *  @param dict
 *  @param successBlock
 *  @param failedBlock
 */
- (void)requestGetGoodsCashbackDetails:(NSDictionary *)dict
                          successBlock:(CashBackSuccessBlock)successBlock
                        setFailedBlock:(CashBackFailedBlock)failedBlock;


@end
