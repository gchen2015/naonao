//
//  PaymentChannelInfo.m
//  Naonao
//
//  Created by 刘敏 on 16/3/14.
//  Copyright © 2016年 深圳市轩腾华兴科技开发有限公司. All rights reserved.
//

#import "PaymentChannelInfo.h"

@implementation PaymentChannelInfo

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"titS" : @"titS",
             @"imgN" : @"imgN",
             @"isSelected" : @"isSelected",
             @"paymentStatus" : @"paymentStatus"
             };
}


@end



@implementation WithdrawChannelInfo

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"titS" : @"titS",
             @"isSelected" : @"isSelected",
             @"mId" : @"mId"
             };
}

@end
