//
//  AppointmentLogic.h
//  Naonao
//
//  Created by 刘敏 on 2016/9/13.
//  Copyright © 2016年 深圳市轩腾华兴科技开发有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppointmentDAO.h"

typedef void (^SquareLogicCommonCallback)(LogicResult* result);

@interface AppointmentLogic : NSObject


+ (instancetype)sharedInstance;

// 我的预约
- (void)getMyReservation:(NSDictionary *)dic withCallback:(SquareLogicCommonCallback)results;

// 预约日历
- (void)getAppointmentCalendar:(NSDictionary *)dic withCallback:(SquareLogicCommonCallback)results;

// 预约日历(上门取货)
- (void)getTakeOrderCalender:(NSDictionary *)dic withCallback:(SquareLogicCommonCallback)results;

// 预约试穿
- (void)getAppointmentTry:(NSDictionary *)dic withCallback:(SquareLogicCommonCallback)results;

// 预约上门取货
- (void)getChicdateTakeOrder:(NSDictionary *)dic withCallback:(SquareLogicCommonCallback)results;

// 我的预约上门
- (void)getMyChicdateTakeOrder:(NSDictionary *)dic withCallback:(SquareLogicCommonCallback)results;

@end



