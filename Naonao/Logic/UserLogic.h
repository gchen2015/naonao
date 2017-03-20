//
//  UserLogic.h
//  Naonao
//
//  Created by Richard Liu on 15/11/23.
//  Copyright © 2015年 深圳市轩腾华兴科技开发有限公司. All rights reserved.
//  账户相关的逻辑处理

#import <Foundation/Foundation.h>
#import "LogicParam.h"
#import "LogicResult.h"

typedef void (^UserLogicCommonCallback)(LogicResult* result);

@interface UserLogic : NSObject

@property (nonatomic, strong) User *user;
@property (nonatomic, strong) UserBody *uBody;

@property (nonatomic, assign) BOOL isPOP;   //完善个人信息页面弹出方式

+ (instancetype)sharedInstance;

// 手机登录
- (void)login:(LoginParam*)param withCallback:(UserLogicCommonCallback)results;

// 第三方登录
- (void)thirdPartyLogin:(ThirdLoginParam *)param withCallback:(UserLogicCommonCallback)results;

// 验证手机号码是否被注册
- (void)whetherPhoneNumberRegistered:(RegisterParam *)param withCallback:(UserLogicCommonCallback)results;

// 获取手机验证码
- (void)getPhoneVerificationCode:(RegisterParam *)param withCallback:(UserLogicCommonCallback)results;

// 验证验证码
- (void)validationPhoneVerificationCode:(RegisterParam *)param withCallback:(UserLogicCommonCallback)results;

// 注册
- (void)registered:(RegisterParam *)param withCallback:(UserLogicCommonCallback)results;

// 修改用户密码
- (void)updatePassword:(RegisterParam *)param withCallback:(UserLogicCommonCallback)results;

// 修改用户资料
- (void)modifyUserData:(NSDictionary *)dict withCallback:(UserLogicCommonCallback)results;

// 保存用户身材数据
- (void)userSaveBodyParamCallback:(UserLogicCommonCallback)results;

//重置身材数据
- (void)userRestBodyParamCallback:(UserLogicCommonCallback)results;

// 修改用户身体特点
- (void)userBodyCharacterCallback:(UserLogicCommonCallback)results;

//上传图片到七牛云
- (void)updateUserHeadImage:(NSData *)imageData withCallback:(UserLogicCommonCallback)results;

/****************************  兴趣圈子 ****************************/
// 兴趣圈子列表
- (void)getInterestCircleList:(UserLogicCommonCallback)results;

// 保存用户选择的兴趣标签
- (void)saveInterestCircleData:(NSDictionary *)dict withCallback:(UserLogicCommonCallback)results;

// 查询用户已经选择的兴趣标签
- (void)queryInterestCircleData:(NSDictionary *)dict withCallback:(UserLogicCommonCallback)results;

// 查询用户身材数据
- (void)queryUserBodyPara:(NSDictionary *)dict withCallback:(UserLogicCommonCallback)results;

// 查询用户风格标签
- (void)queryUserStyles:(NSDictionary *)dict withCallback:(UserLogicCommonCallback)results;

// 提交建议
- (void)submitRecommendations:(NSDictionary *)dict withCallback:(UserLogicCommonCallback)results;

// 绑定手机
- (void)bindPhoneNO:(RegisterParam *)param withCallback:(UserLogicCommonCallback)results;

// 绑定第三方账号
- (void)bindThirdParty:(ThirdLoginParam *)loginParam withCallback:(UserLogicCommonCallback)results;

// 验证手机号
- (void)requestUserCheckcode:(NSDictionary *)dict withCallback:(UserLogicCommonCallback)results;

// 获取粉丝列表
- (void)requestUserFansList:(NSDictionary *)dict withCallback:(UserLogicCommonCallback)results;

// 获取关注列表
- (void)requestUserFocusList:(NSDictionary *)dict withCallback:(UserLogicCommonCallback)results;

// 获取用户的回答
- (void)requestUserAnswersList:(NSDictionary *)dict withCallback:(UserLogicCommonCallback)results;

// 获取用户的评论
- (void)requestUserCommentsList:(NSDictionary *)dict withCallback:(UserLogicCommonCallback)results;

// 我的写真
- (void)requestUserBuyyerShow:(NSDictionary *)dict withCallback:(UserLogicCommonCallback)results;

// 获取个人信息
- (User *)getUser;

// 缓存用户信息到本地
- (BOOL)saveUserToFile:(User*)user;

// 注销时清空用户数据
- (void)cleanDataWhenLogout;

@end
