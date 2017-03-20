//
//  TimeUtil.h
//  Shitan
//
//  Created by 刘敏 on 14-9-13.
//  Copyright (c) 2014年 深圳市轩腾华兴科技开发有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TimeUtil : NSObject

//将(2003-10-15 10:30)日期格式化（刚刚、x分钟前）
+ (NSString *)getFormattedTimeWithDate:(NSString *)dates;

//将(2003-10-15 10:30:32)日期格式化（刚刚、x分钟前）
+ (NSString *)getFormattedDateWithDate:(NSString *)dates;

//将毫秒数转格式化（刚刚、x分钟前）
+ (NSString *)turningMillisecondsForDate:(long long)second;

//日期转换(NSDate 转 NSString)
+ (NSString *)convertStringFromDate:(NSDate*)uiDate;

//把秒数转换回时间格式
+ (NSString *)timeFormatted:(NSInteger)totalSeconds;

//判断时间戳是否在过去、或者未来（过去为YES，未来为NO）
+ (BOOL)determineWhetherTimestamp:(NSString *)dates;

//判断时间戳是否在过去、或者未来（过去为YES，未来为NO）
+ (BOOL)longlongsecordWhetherTimestamp:(long long)interval;

//将NSDate转化成可读时间
+ (NSString *)turningStringForDate:(NSDate *)uiDate;

//获取未来某个日期是星期几
+ (NSString *)featureWeekdayWithDate:(NSString *)featureDate;

@end
