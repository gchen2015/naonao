//
//  AppointmentDAO.h
//  Naonao
//
//  Created by 刘敏 on 2016/9/13.
//  Copyright © 2016年 深圳市轩腾华兴科技开发有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ResponseHeader.h"

typedef void (^AppointmentSuccessBlock)(NSDictionary *result);
typedef void (^AppointmentFailedBlock)(ResponseHeader *result);


@interface AppointmentDAO : NSObject

/**
 *  我的预约
 *  GET
 *
 *  @param dict
 *  @param successBlock
 *  @param failedBlock
 */
- (void)requestGetMyReservation:(NSDictionary *)dict
                   successBlock:(AppointmentSuccessBlock)successBlock
                 setFailedBlock:(AppointmentFailedBlock)failedBlock;

/**
 *  预约日历
 *  GET
 *
 *  @param dict
 *  @param successBlock
 *  @param failedBlock
 */
- (void)requestGetAppointmentCalendar:(NSDictionary *)dict
                         successBlock:(AppointmentSuccessBlock)successBlock
                       setFailedBlock:(AppointmentFailedBlock)failedBlock;



/**
 *  预约日历（上门取货）
 *  GET
 *
 *  @param dict
 *  @param successBlock
 *  @param failedBlock
 */
- (void)requestGetTakeOrderCalender:(NSDictionary *)dict
                       successBlock:(AppointmentSuccessBlock)successBlock
                     setFailedBlock:(AppointmentFailedBlock)failedBlock;



/**
 *  预约试穿
 *  GET
 *
 *  @param dict
 *  @param successBlock
 *  @param failedBlock
 */
- (void)requestGetAppointmentTry:(NSDictionary *)dict
                    successBlock:(AppointmentSuccessBlock)successBlock
                  setFailedBlock:(AppointmentFailedBlock)failedBlock;


/**
 *  上门取货
 *  GET
 *
 *  @param dict
 *  @param successBlock
 *  @param failedBlock
 */
- (void)requestGetChicdateTakeOrder:(NSDictionary *)dict
                       successBlock:(AppointmentSuccessBlock)successBlock
                     setFailedBlock:(AppointmentFailedBlock)failedBlock;


/**
 *  我的上门取货
 *  GET
 *
 *  @param dict
 *  @param successBlock
 *  @param failedBlock
 */
- (void)requestMyChicdateTakeOrder:(NSDictionary *)dict
                      successBlock:(AppointmentSuccessBlock)successBlock
                    setFailedBlock:(AppointmentFailedBlock)failedBlock;

@end
