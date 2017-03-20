//
//  LogicParam.h
//  Naonao
//
//  Created by Richard Liu on 15/11/23.
//  Copyright © 2015年 深圳市轩腾华兴科技开发有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Requirement;

@interface LogicParam : NSObject

@end

/************* 登录 ********/
@interface LoginParam : LogicParam

@property (nonatomic, copy) NSString* phone;
@property (nonatomic, copy) NSString* password;

@end


/************* 第三方登录 ********/
@interface ThirdLoginParam : LogicParam

@property (nonatomic, copy) NSString* nickname;
@property (nonatomic, copy) NSString* profileUrl;
@property (nonatomic, copy) NSString* openid;
@property (nonatomic, copy) NSString* gender;

@property (nonatomic, copy) NSString* access_token;     //微信登录专有
@property (nonatomic, copy) NSString* unionid;          //微信登录专有

@property (nonatomic, assign) ThirdLoginType loginType;

@end


/************* 注册 ********/
@interface RegisterParam : LogicParam

@property (nonatomic, copy) NSString* telephone;
@property (nonatomic, copy) NSString* password;
@property (nonatomic, copy) NSString* nickname;
@property (nonatomic, copy) NSString* email;
@property (nonatomic, strong) NSNumber* type;
@property (nonatomic, copy) NSString *authcode;

@end

/************* 找回密码 ********/
@interface ResetPasswordParam : LogicParam

@property (nonatomic, copy) NSString* telephone;
@property (nonatomic, copy) NSString* authCode;
@property (nonatomic, copy) NSString* password;

@end

