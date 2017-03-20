//
//  WithdrawLogic.h
//  Naonao
//
//  Created by 刘敏 on 16/5/16.
//  Copyright © 2016年 深圳市轩腾华兴科技开发有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LogicResult.h"


typedef void (^WithdrawLogicCallback)(LogicResult* result);


@interface WithdrawLogic : NSObject

@property (nonatomic, strong) NSNumber *amount;    //可提现金额

+ (instancetype)sharedInstance;

//读取返现方式
- (NSArray *)laodConfigListWithPayment;

// 获取我的钱包
- (void)getMyWallet:(NSDictionary *)dict withCallback:(WithdrawLogicCallback)results;

// 提现记录
- (void)getWithdrawRecords:(NSDictionary *)dict withCallback:(WithdrawLogicCallback)results;

// 提现申请
- (void)getApplyWithdraw:(NSDictionary *)dict withCallback:(WithdrawLogicCallback)results;

// 提现详情
- (void)getWithdrawDetails:(NSDictionary *)dict withCallback:(WithdrawLogicCallback)results;

// 单个商品返现明细
- (void)getGoodsWithdrawDetails:(NSDictionary *)dict withCallback:(WithdrawLogicCallback)results;



@end

