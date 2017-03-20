//
//  STMessageCare.h
//  Naonao
//
//  Created by 刘敏 on 16/8/21.
//  Copyright © 2016年 深圳市轩腾华兴科技开发有限公司. All rights reserved.
//

#import <Mantle/Mantle.h>
#import "SquareModel.h"

@class SKContent;
@interface STMessageCare : MTLModel<MTLJSONSerializing>

@property (nonatomic, strong) NSNumber* mId;
@property (nonatomic, strong) NSNumber* type;
@property (nonatomic, strong) SKContent *content;

@end


@class SKQuestion;

@interface SKContent : MTLModel<MTLJSONSerializing>

@property (nonatomic, strong) NSNumber* userid;
@property (nonatomic, strong) NSString* name;
@property (nonatomic, strong) NSString* datetime;
@property (nonatomic, strong) NSString* msg;
@property (nonatomic, strong) NSString* avatar;

@property (nonatomic, strong) SKQuestion* question;

@end


@interface SKQuestion : MTLModel<MTLJSONSerializing>

@property (nonatomic, strong) SUserInfo *userInfo;
@property (nonatomic, strong) SOrderInfo *orderInfo;

@end


@class SYSContent;
@interface SYSMessage : MTLModel<MTLJSONSerializing>

@property (nonatomic, strong) NSNumber* mId;
@property (nonatomic, strong) NSNumber* type;
@property (nonatomic, strong) SYSContent *content;


@end


@interface SYSContent : MTLModel<MTLJSONSerializing>

@property (nonatomic, strong) NSNumber* userid;
@property (nonatomic, strong) NSString* msg;
@property (nonatomic, strong) NSString* datetime;

@end

