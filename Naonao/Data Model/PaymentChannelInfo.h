//
//  PaymentChannelInfo.h
//  Naonao
//
//  Created by 刘敏 on 16/3/14.
//  Copyright © 2016年 深圳市轩腾华兴科技开发有限公司. All rights reserved.
//

#import "MTLModel.h"

@interface PaymentChannelInfo : MTLModel<MTLJSONSerializing>

@property (nonatomic, strong) NSString* titS;           //名称
@property (nonatomic, strong) NSString* imgN;           //图片
@property (nonatomic, strong) NSNumber* isSelected;     //选中
@property (nonatomic, strong) NSNumber* paymentStatus;  //支付方式

@end


@interface WithdrawChannelInfo : MTLModel<MTLJSONSerializing>

@property (nonatomic, strong) NSNumber* titS;           //名称
@property (nonatomic, strong) NSNumber* isSelected;     //选中
@property (nonatomic, strong) NSNumber* mId;            //支付方式

@end
