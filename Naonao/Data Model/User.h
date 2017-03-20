//
//  User.h
//  Naonao
//
//  Created by Richard Liu on 15/11/23.
//  Copyright © 2015年 深圳市轩腾华兴科技开发有限公司. All rights reserved.
//

#import "Mantle.h"

@class UserBasic;
@class UserBody;

@interface User : MTLModel<MTLJSONSerializing>

@property (nonatomic, strong) UserBasic *basic;
@property (nonatomic, strong) UserBody *body;
@property (nonatomic, strong) NSArray *thirdparty;              //已经绑定的账号来源
@property (nonatomic, strong) NSNumber *is_reg;

@end

@interface UserBasic : MTLModel<MTLJSONSerializing>

@property (nonatomic, strong) NSString* gender;                   //性别
@property (nonatomic, strong) NSNumber* userId;                   //账户ID
@property (nonatomic, strong) NSString* userName;                 //用户名

@property (nonatomic, strong) NSString* token;
@property (nonatomic, strong) NSString* email;                    //邮箱
@property (nonatomic, strong) NSString* telephone;
@property (nonatomic, strong) NSString* avatarUrl;                //头像

@property (nonatomic, strong) NSNumber* contract;                 //contract true舵主， false普通用户
@property (nonatomic, strong) NSString* bindingCode;              //推广码

@end



@interface UserBody : MTLModel<MTLJSONSerializing>

//身材参数
@property (nonatomic, strong) NSString* bodyStyle;              //体形
@property (nonatomic, strong) NSNumber* height;                 //身高
@property (nonatomic, strong) NSNumber* weight;                 //体重
@property (nonatomic, strong) NSString* bust;                   //胸围
@property (nonatomic, strong) NSNumber* waistline;              //腰围
@property (nonatomic, strong) NSNumber* hipline;                //臀围
@property (nonatomic, strong) NSNumber* shoes;                  //鞋子尺码

@property (nonatomic, strong) NSString* lifeStage;              //人生阶段
@property (nonatomic, strong) NSArray* bodydefect;              //身体特点

@end


@interface UserFollow: MTLModel<MTLJSONSerializing>

@property (nonatomic, strong) NSNumber* isFollow;                 
@property (nonatomic, strong) NSNumber* userId;                   //账户ID
@property (nonatomic, strong) NSString* nickname;                 //用户名
@property (nonatomic, strong) NSString* avatar;                   //头像

@end

