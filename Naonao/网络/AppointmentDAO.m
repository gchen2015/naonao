//
//  AppointmentDAO.m
//  Naonao
//
//  Created by 刘敏 on 2016/9/13.
//  Copyright © 2016年 深圳市轩腾华兴科技开发有限公司. All rights reserved.
//

#import "AppointmentDAO.h"
#import "RequestModel.h"


@implementation AppointmentDAO

// 我的预约
- (void)requestGetMyReservation:(NSDictionary *)dict
                   successBlock:(AppointmentSuccessBlock)successBlock
                 setFailedBlock:(AppointmentFailedBlock)failedBlock
{
    [[RequestModel shareInstance] requestModelWithAPI:URL_ChicdateMyTryDress
                                              getDict:dict
                                         successBlock:successBlock
                                       setFailedBlock:failedBlock];
}

// 预约日历
- (void)requestGetAppointmentCalendar:(NSDictionary *)dict
                         successBlock:(AppointmentSuccessBlock)successBlock
                       setFailedBlock:(AppointmentFailedBlock)failedBlock
{
    [[RequestModel shareInstance] requestModelWithAPI:URL_ChicdateMyTryCalender
                                              getDict:dict
                                         successBlock:successBlock
                                       setFailedBlock:failedBlock];
}


// 预约日历（上门取货）
- (void)requestGetTakeOrderCalender:(NSDictionary *)dict
                       successBlock:(AppointmentSuccessBlock)successBlock
                     setFailedBlock:(AppointmentFailedBlock)failedBlock
{
    [[RequestModel shareInstance] requestModelWithAPI:URL_TakeOrderCalender
                                              getDict:dict
                                         successBlock:successBlock
                                       setFailedBlock:failedBlock];
}

// 预约试穿
- (void)requestGetAppointmentTry:(NSDictionary *)dict
                    successBlock:(AppointmentSuccessBlock)successBlock
                  setFailedBlock:(AppointmentFailedBlock)failedBlock
{
    [[RequestModel shareInstance] requestModelWithAPI:URL_ChicdateTryDress
                                              getDict:dict
                                         successBlock:successBlock
                                       setFailedBlock:failedBlock];
}



// 上门取货
- (void)requestGetChicdateTakeOrder:(NSDictionary *)dict
                       successBlock:(AppointmentSuccessBlock)successBlock
                     setFailedBlock:(AppointmentFailedBlock)failedBlock
{
    [[RequestModel shareInstance] requestModelWithAPI:URL_ChicdateTakeOrder
                                              getDict:dict
                                         successBlock:successBlock
                                       setFailedBlock:failedBlock];
}


// 我的上门取货
- (void)requestMyChicdateTakeOrder:(NSDictionary *)dict
                      successBlock:(AppointmentSuccessBlock)successBlock
                    setFailedBlock:(AppointmentFailedBlock)failedBlock
{
    [[RequestModel shareInstance] requestModelWithAPI:URL_ChicdateMyTakeOrder
                                              getDict:dict
                                         successBlock:successBlock
                                       setFailedBlock:failedBlock];
}

@end
