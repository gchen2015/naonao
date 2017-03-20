//
//  STMessagePraise.h
//  Naonao
//
//  Created by 刘敏 on 16/5/10.
//  Copyright © 2016年 深圳市轩腾华兴科技开发有限公司. All rights reserved.
//

#import <Mantle/Mantle.h>
#import "SquareModel.h"

/************************** 消息赞 **************************/
@class STContent;
@interface STMessagePraise : MTLModel<MTLJSONSerializing>

@property (nonatomic, strong) NSNumber* mId;
@property (nonatomic, strong) NSNumber* type;
@property (nonatomic, strong) STContent *content;

@end


@class STMExtra;

@interface STContent : MTLModel<MTLJSONSerializing>

@property (nonatomic, strong) NSNumber* userid;
@property (nonatomic, strong) NSString* name;
@property (nonatomic, strong) NSString* datetime;
@property (nonatomic, strong) NSString* msg;
@property (nonatomic, strong) NSString* avatar;

@property (nonatomic, strong) STMExtra* extraData;

@end



@class STOrder;

@interface STMExtra : MTLModel<MTLJSONSerializing>

@property (nonatomic, strong) NSString* content;
@property (nonatomic, strong) NSNumber* nums;
@property (nonatomic, strong) STOrder* oInfo;

@end


@interface STOrder : MTLModel<MTLJSONSerializing>

@property (nonatomic, strong) SUserInfo *userInfo;
@property (nonatomic, strong) SOrderInfo *orderInfo;

@end

