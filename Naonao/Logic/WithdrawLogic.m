//
//  WithdrawLogic.m
//  Naonao
//
//  Created by 刘敏 on 16/5/16.
//  Copyright © 2016年 深圳市轩腾华兴科技开发有限公司. All rights reserved.
//

#import "WithdrawLogic.h"
#import "CashBackDAO.h"
#import "WithdrawModel.h"
#import "PaymentChannelInfo.h"


@implementation WithdrawLogic


+ (instancetype)sharedInstance
{
    static dispatch_once_t onceToken;
    static WithdrawLogic* instance = nil;
    dispatch_once(&onceToken, ^{
        instance = [[WithdrawLogic alloc] init];
    });
    return instance;
}


//读取返现方式
- (NSArray *)laodConfigListWithPayment
{
    //读取
    NSString* filePath = [[NSBundle mainBundle] pathForResource:kConfigName ofType:@"plist"];
    NSArray *jsonArray = [[NSDictionary dictionaryWithContentsOfFile:filePath] objectForKey:@"withdraw"];
    NSArray* paymentArray =  [MTLJSONAdapter modelsOfClass:[WithdrawChannelInfo class]
                                             fromJSONArray:jsonArray
                                                     error:nil];
    
    return paymentArray;
}

// 获取我的钱包
- (void)getMyWallet:(NSDictionary *)dict withCallback:(WithdrawLogicCallback)results
{
    CashBackDAO *dao = [[CashBackDAO alloc] init];
    LogicResult* cb = [[LogicResult alloc] init];
    
    [dao requestGetMyWallet:dict successBlock:^(NSDictionary *result) {
        [cb success];
        if (result.count > 0) {
            cb.mObject = [MTLJSONAdapter modelOfClass:[WithdrawModel class] fromJSONDictionary:result error:nil];
        }
        results(cb);
    } setFailedBlock:^(ResponseHeader *result) {
        [cb failure:result];
        results(cb);
    }];
    
}

// 提现记录
- (void)getWithdrawRecords:(NSDictionary *)dict withCallback:(WithdrawLogicCallback)results
{
    CashBackDAO *dao = [[CashBackDAO alloc] init];
    LogicResult* cb = [[LogicResult alloc] init];
    
    [dao requestGetWithdrawalRecords:dict successBlock:^(NSDictionary *result) {
        [cb success];
        if (result.count > 0) {
            cb.mObject = [MTLJSONAdapter modelsOfClass:[STWRecord class] fromJSONArray:(NSArray *)result error:nil];
        }
        results(cb);
        
    } setFailedBlock:^(ResponseHeader *result) {
        [cb failure:result];
        results(cb);
    }];
}

// 提现申请
- (void)getApplyWithdraw:(NSDictionary *)dict withCallback:(WithdrawLogicCallback)results
{
    CashBackDAO *dao = [[CashBackDAO alloc] init];
    LogicResult* cb = [[LogicResult alloc] init];
    
    [dao requestGetApplyWithdrawal:dict successBlock:^(NSDictionary *result) {
        [cb success];
        results(cb);
        
        
    } setFailedBlock:^(ResponseHeader *result) {
        [cb failure:result];
        results(cb);
    }];
}

// 提现详情
- (void)getWithdrawDetails:(NSDictionary *)dict withCallback:(WithdrawLogicCallback)results
{
    CashBackDAO *dao = [[CashBackDAO alloc] init];
    LogicResult* cb = [[LogicResult alloc] init];
    
    [dao requestGetWithdrawalDetails:dict successBlock:^(NSDictionary *result) {
        
    } setFailedBlock:^(ResponseHeader *result) {
        [cb failure:result];
        results(cb);
    }];
}

// 单个商品返现明细
- (void)getGoodsWithdrawDetails:(NSDictionary *)dict withCallback:(WithdrawLogicCallback)results
{
    CashBackDAO *dao = [[CashBackDAO alloc] init];
    LogicResult* cb = [[LogicResult alloc] init];
    
    [dao requestGetGoodsCashbackDetails:dict successBlock:^(NSDictionary *result) {
        [cb success];
        if (result.count > 0) {
            cb.mObject = [MTLJSONAdapter modelOfClass:[WithdrawTimeline class] fromJSONDictionary:result error:nil];
        }
        results(cb);
        
    } setFailedBlock:^(ResponseHeader *result) {
        [cb failure:result];
        results(cb);
    }];
}

@end
