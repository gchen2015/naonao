//
//  WithdrawModel.h
//  Naonao
//
//  Created by 刘敏 on 16/5/16.
//  Copyright © 2016年 深圳市轩腾华兴科技开发有限公司. All rights reserved.
//

#import <Mantle/Mantle.h>

@interface WithdrawModel : MTLModel<MTLJSONSerializing>

@property (nonatomic, strong) NSNumber *free;           //可提现金额
@property (nonatomic, strong) NSNumber *total;          //返现总金额
@property (nonatomic, strong) NSNumber *follow_wx;      //是否关注了微信公众号

@property (nonatomic, strong) NSArray *records;

@end


@class WithdrawProduct;

@interface WithdrawRecord : MTLModel<MTLJSONSerializing>

@property (nonatomic, strong) NSNumber *amount;
@property (nonatomic, strong) NSNumber *count;
@property (nonatomic, strong) NSNumber *today_pay;

@property (nonatomic, strong) WithdrawProduct *product;

@end



@interface WithdrawProduct: MTLModel<MTLJSONSerializing>

@property (nonatomic, strong) NSString *productTitle;
@property (nonatomic, strong) NSString *productImg;
@property (nonatomic, strong) NSNumber *productId;

@end



@class WShowTimeline;

@interface WithdrawTimeline : MTLModel<MTLJSONSerializing>

@property (nonatomic, strong) NSArray *payList;
@property (nonatomic, strong) WShowTimeline *showTime;

@end



@interface WPayTimeline : MTLModel<MTLJSONSerializing>

@property (nonatomic, strong) NSNumber *amount;
@property (nonatomic, strong) NSString *payTime;

@end


@interface WShowTimeline : MTLModel<MTLJSONSerializing>

@property (nonatomic, strong) NSString *createTime;

@end

@interface STWRecord : MTLModel<MTLJSONSerializing>

@property (nonatomic, strong) NSNumber *amount;
@property (nonatomic, strong) NSNumber *mId;
@property (nonatomic, strong) NSNumber *channel;    //提现方式

@property (nonatomic, strong) NSString *createTime;

@end

