//
//  AppointmentLogic.m
//  Naonao
//
//  Created by 刘敏 on 2016/9/13.
//  Copyright © 2016年 深圳市轩腾华兴科技开发有限公司. All rights reserved.
//

#import "AppointmentLogic.h"
#import "BookModel.h"


@implementation AppointmentLogic


+ (instancetype)sharedInstance
{
    static dispatch_once_t onceToken;
    static AppointmentLogic* instance = nil;
    dispatch_once(&onceToken, ^{
        instance = [[AppointmentLogic alloc] init];
    });
    return instance;
}

// 我的预约
- (void)getMyReservation:(NSDictionary *)dic withCallback:(SquareLogicCommonCallback)results
{
    AppointmentDAO *dao = [[AppointmentDAO alloc] init];
    LogicResult* cb = [[LogicResult alloc] init];
    
    [dao requestGetMyReservation:dic successBlock:^(NSDictionary *result) {
        [cb success];
        cb.mObject = [self pairsData:(NSArray *)result];
        results(cb);
    } setFailedBlock:^(ResponseHeader *result) {
        [cb failure:result];
        results(cb);
    }];
}

- (NSArray *)pairsData:(NSArray *)mArray{
    NSMutableArray *tArray = [NSMutableArray arrayWithCapacity:mArray.count];
    
    for (NSDictionary *item in mArray) {
        FitData *fData = [[FitData alloc] initWithParsData:item];
        [tArray addObject:fData];
    }
    
    return tArray;
}

// 预约日历
- (void)getAppointmentCalendar:(NSDictionary *)dic withCallback:(SquareLogicCommonCallback)results
{
    AppointmentDAO *dao = [[AppointmentDAO alloc] init];
    LogicResult* cb = [[LogicResult alloc] init];
    
    [dao requestGetAppointmentCalendar:dic successBlock:^(NSDictionary *result) {
        [cb success];
        cb.mObject = [MTLJSONAdapter modelOfClass:[BookModel class] fromJSONDictionary:result error:nil];
        results(cb);
    } setFailedBlock:^(ResponseHeader *result) {
        [cb failure:result];
        results(cb);
    }];
}

// 预约日历(上门取货)
- (void)getTakeOrderCalender:(NSDictionary *)dic withCallback:(SquareLogicCommonCallback)results
{
    AppointmentDAO *dao = [[AppointmentDAO alloc] init];
    LogicResult* cb = [[LogicResult alloc] init];
    
    [dao requestGetTakeOrderCalender:dic successBlock:^(NSDictionary *result) {
        [cb success];
        cb.mObject = [MTLJSONAdapter modelOfClass:[BookModel class] fromJSONDictionary:result error:nil];
        results(cb);
    } setFailedBlock:^(ResponseHeader *result) {
        [cb failure:result];
        results(cb);
    }];
}

// 预约试穿
- (void)getAppointmentTry:(NSDictionary *)dic withCallback:(SquareLogicCommonCallback)results
{
    AppointmentDAO *dao = [[AppointmentDAO alloc] init];
    LogicResult* cb = [[LogicResult alloc] init];
    
    [dao requestGetAppointmentTry:dic successBlock:^(NSDictionary *result) {
        [cb success];
        results(cb);
    } setFailedBlock:^(ResponseHeader *result) {
        [cb failure:result];
        results(cb);
    }];
}

// 预约上门取货
- (void)getChicdateTakeOrder:(NSDictionary *)dic withCallback:(SquareLogicCommonCallback)results
{
    AppointmentDAO *dao = [[AppointmentDAO alloc] init];
    LogicResult* cb = [[LogicResult alloc] init];
    
    [dao requestGetChicdateTakeOrder:dic successBlock:^(NSDictionary *result) {
        [cb success];
        results(cb);
    } setFailedBlock:^(ResponseHeader *result) {
        [cb failure:result];
        results(cb);
    }];
}

// 我的预约上门
- (void)getMyChicdateTakeOrder:(NSDictionary *)dic withCallback:(SquareLogicCommonCallback)results
{
    AppointmentDAO *dao = [[AppointmentDAO alloc] init];
    LogicResult* cb = [[LogicResult alloc] init];
    
    [dao requestMyChicdateTakeOrder:dic successBlock:^(NSDictionary *result) {
        [cb success];
        cb.mObject = [self pairsPickUpData:(NSArray *)result];
        results(cb);
    } setFailedBlock:^(ResponseHeader *result) {
        [cb failure:result];
        results(cb);
    }];
}

- (NSArray *)pairsPickUpData:(NSArray *)mArray{
    NSMutableArray *tArray = [NSMutableArray arrayWithCapacity:mArray.count];
    
    for (NSDictionary *item in mArray) {
        PickUpData *fData = [[PickUpData alloc] initWithParsData:item];
        [tArray addObject:fData];
    }
    
    return tArray;
}

@end
