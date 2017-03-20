//
//  TimeUtil.m
//  Shitan
//
//  Created by 刘敏 on 14-9-13.
//  Copyright (c) 2014年 深圳市轩腾华兴科技开发有限公司. All rights reserved.
//

#import "TimeUtil.h"
#import "math.h"


@implementation TimeUtil

//将日期格式化（刚刚、x分钟前）
+ (NSString *)getFormattedTimeWithDate:(NSString *)dates
{
    //将时间转成秒
    long long interval = [self getTimeWithShortDate:dates];
    
    return [[self class] turningMillisecondsForDate:interval];

}


+ (NSString *)getFormattedDateWithDate:(NSString *)dates
{
    //将时间转成秒
    long long interval = [self getTimeWithDate:dates];
    
    return [[self class] turningMillisecondsForDate:interval];
    
}

//将毫秒数转格式化（刚刚、x分钟前）
+ (NSString *)turningMillisecondsForDate:(long long)second
{ 
    //转化成NSDate
    NSDate * date = [NSDate dateWithTimeIntervalSince1970:second];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSInteger unitFlags = NSCalendarUnitMonth | NSCalendarUnitDay|NSCalendarUnitYear|NSCalendarUnitHour|NSCalendarUnitMinute|NSCalendarUnitSecond|NSCalendarUnitWeekOfMonth|NSCalendarUnitWeekday;
    NSDateComponents * component=[calendar components:unitFlags fromDate:date];
    
    NSUInteger year = [component year];
    NSUInteger month = [component month];
    NSUInteger day = [component day];
    
    NSUInteger hour = [component hour];
    NSUInteger minute = [component minute];
    
    NSDate * today = [NSDate date];
    component = [calendar components:unitFlags fromDate:today];
    
    NSUInteger t_year = [component year];
    
    NSString *string = nil;
    
    long long now = [today timeIntervalSince1970];
    
    long distance = now - second;
    
    if(distance < 60)
    {
        string = @"刚刚";
    }
    else if(distance < 60*60)
    {
        string = [NSString stringWithFormat:@"%ld分钟前", distance/60];
    }
    else if(distance < 60*60*24)
    {
        string = [NSString stringWithFormat:@"%ld小时前", distance/60/60];
    }
    else if(distance < 60*60*24*7)
    {
        string = [NSString stringWithFormat:@"%ld天前", distance/60/60/24];
    }
    else if(year == t_year)
    {
        string=[NSString stringWithFormat:@"%02lu-%02lu %lu:%02lu", (unsigned long)month, (unsigned long)day, (unsigned long)hour, (unsigned long)minute];
    }
    else
    {
        string=[NSString stringWithFormat:@"%lu-%lu-%lu", (unsigned long)year, (unsigned long)month, (unsigned long)day];
    }
    
    return string;

}


//日期转换(NSDate 转 NSString)
+ (NSString *)convertStringFromDate:(NSDate*)uiDate
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //zzz表示时区，zzz可以删除，这样返回的日期字符将不包含时区信息。
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    NSString *destDateString = [dateFormatter stringFromDate:uiDate];
    
    return destDateString;
}

//把秒数转换回时间格式
+ (NSString *)timeFormatted:(NSInteger)totalSeconds
{
    NSInteger seconds = totalSeconds % 60;
    NSInteger minutes = (totalSeconds / 60) % 60;
    NSInteger hours = totalSeconds / 3600;
    
    if (hours > 0) {
        return [NSString stringWithFormat:@"%02ld:%02ld:%02ld",(long)hours, (long)minutes, (long)seconds];
    }
    
    return [NSString stringWithFormat:@"%02ld分%02ld秒", (long)minutes, (long)seconds];
}


//将日期转成秒
+ (long long)getTimeWithShortDate:(NSString *)dateS
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat: @"yyyy-MM-dd HH:mm"];
    NSDate *destDate= [dateFormatter dateFromString:dateS];
    
    NSTimeInterval interv = [destDate timeIntervalSince1970];
    
    return interv;
}


//将日期转成秒
+ (long long)getTimeWithDate:(NSString *)dateS
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat: @"yyyy-MM-dd HH:mm:ss"];
    NSDate *destDate= [dateFormatter dateFromString:dateS];
    
    NSTimeInterval interv = [destDate timeIntervalSince1970];
    
    return interv;
}


//判断时间戳是否在过去、或者未来（过去为YES，未来为NO）
+ (BOOL)determineWhetherTimestamp:(NSString *)dates
{
    //将时间转成秒
    long long interval = [self getTimeWithShortDate:dates];
    
    //转化成NSDate
    NSDate * date = [NSDate dateWithTimeIntervalSince1970:interval];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSInteger unitFlags = NSCalendarUnitMonth | NSCalendarUnitDay|NSCalendarUnitYear|NSCalendarUnitHour|NSCalendarUnitMinute|NSCalendarUnitSecond|NSCalendarUnitWeekOfMonth|NSCalendarUnitWeekday;
    NSDateComponents * component=[calendar components:unitFlags fromDate:date];
    
    NSDate * today = [NSDate date];
    component = [calendar components:unitFlags fromDate:today];
    
    long long now = [today timeIntervalSince1970];
    
    long distance = now - interval;
    
    if (distance >= 0) {
        return YES;
    }
    else
        return NO;
}

+ (BOOL)longlongsecordWhetherTimestamp:(long long)interval
{
    //转化成NSDate
    NSDate * date = [NSDate dateWithTimeIntervalSince1970:interval];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSInteger unitFlags = NSCalendarUnitMonth | NSCalendarUnitDay|NSCalendarUnitYear|NSCalendarUnitHour|NSCalendarUnitMinute|NSCalendarUnitSecond|NSCalendarUnitWeekOfMonth|NSCalendarUnitWeekday;
    NSDateComponents * component=[calendar components:unitFlags fromDate:date];
    
    NSDate * today = [NSDate date];
    component = [calendar components:unitFlags fromDate:today];
    
    long long now = [today timeIntervalSince1970];
    
    long distance = now - interval;
    
    if (distance >= 0) {
        return YES;
    }
    else
        return NO;
}


//将NSDate转化成可读时间
+ (NSString *)turningStringForDate:(NSDate *)uiDate {
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //zzz表示时区，zzz可以删除，这样返回的日期字符将不包含时区信息。
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    
    NSString *destDateString = [dateFormatter stringFromDate:uiDate];
    
    return destDateString;
}

// 获取当前是星期几
+ (NSInteger)getNowWeekday {
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    NSInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday |
    NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    NSDate *now = [NSDate date];
    
    // 话说在真机上需要设置区域，才能正确获取本地日期，天朝代码:zh_CN
    calendar.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    comps = [calendar components:unitFlags fromDate:now];
    
    return [comps weekday];
}

/**
 *  获取未来某个日期是星期几
 *  注意：featureDate 传递过来的格式 必须 和 formatter.dateFormat 一致，否则endDate可能为nil
 *
 */
+ (NSString *)featureWeekdayWithDate:(NSString *)featureDate{
    // 创建 格式 对象
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    // 设置 日期 格式 可以根据自己的需求 随时调整， 否则计算的结果可能为 nil
    formatter.dateFormat = @"yyyy-MM-dd";
    // 将字符串日期 转换为 NSDate 类型
    NSDate *inputDate = [formatter dateFromString:featureDate];
    
    
    NSArray *weekdays = [NSArray arrayWithObjects: [NSNull null], @"周日", @"周一", @"周二", @"周三", @"周四", @"周五", @"周六", nil];
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSTimeZone *timeZone = [[NSTimeZone alloc] initWithName:@"Asia/Shanghai"];
    [calendar setTimeZone: timeZone];
    
    NSCalendarUnit calendarUnit = NSCalendarUnitWeekday;
    NSDateComponents *theComponents = [calendar components:calendarUnit fromDate:inputDate];
    
    return [weekdays objectAtIndex:theComponents.weekday];
}


/**
 *  计算2个日期相差天数
 *  startDate   起始日期
 *  endDate     截至日期
 */
+ (NSInteger)daysFromDate:(NSDate *)startDate toDate:(NSDate *)endDate {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    // 话说在真机上需要设置区域，才能正确获取本地日期，天朝代码:zh_CN
    dateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    //得到相差秒数
    NSTimeInterval time = [endDate timeIntervalSinceDate:startDate];
    
    int days = ((int)time)/(3600*24);
    int hours = ((int)time)%(3600*24)/3600;
    int minute = ((int)time)%(3600*24)/3600/60;
    
    if (days <= 0 && hours <= 0&&minute<= 0) {
        CLog(@"0天0小时0分钟");
        return days +7;
    }
    else
    {
        CLog(@"%@",[[NSString alloc] initWithFormat:@"%i天%i小时%i分钟", days, hours, minute]);
        // 之所以要 + 1，是因为 此处的days 计算的结果 不包含当天 和 最后一天\
        （如星期一 和 星期四，计算机 算的结果就是2天（星期二和星期三），日常算，星期一——星期四相差3天，所以需要+1）\
        对于时分 没有进行计算 可以忽略不计
        return days + 1;
    }
}

@end
