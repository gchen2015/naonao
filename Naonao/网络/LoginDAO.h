//
//  LoginDAO.h
//  Naonao
//
//  Created by Richard Liu on 15/11/23.
//  Copyright © 2015年 深圳市轩腾华兴科技开发有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ResponseHeader.h"

typedef void (^LoginSuccessBlock)(NSDictionary *result);
typedef void (^LoginFailedBlock)(ResponseHeader *result);

@interface LoginDAO : NSObject

/**
 * （手机号）登录
 *  GET
 *
 *  @param dict
 *  @param successBlock
 *  @param failedBlock
 */
- (void)requestTelephoneLogin:(NSDictionary *)dict
                 successBlock:(LoginSuccessBlock)successBlock
               setFailedBlock:(LoginFailedBlock)failedBlock;


/**
 *  用户注册
 *  GET
 *
 *  @param dict
 *  @param successBlock
 *  @param failedBlock
 */
- (void)requestUserRegister:(NSDictionary *)dict
               successBlock:(LoginSuccessBlock)successBlock
             setFailedBlock:(LoginFailedBlock)failedBlock;


/**
 *  修改用户密码
 *  GET
 *
 *  @param dict
 *  @param successBlock
 *  @param failedBlock
 */
- (void)requestUserUpdatePassword:(NSDictionary *)dict
                     successBlock:(LoginSuccessBlock)successBlock
                   setFailedBlock:(LoginFailedBlock)failedBlock;


/**
 *  获取短信验证码
 *  GET
 *
 *  @param dict
 *  @param successBlock
 *  @param failedBlock
 */
- (void)requestAuthenticationCode:(NSDictionary *)dict
                     successBlock:(LoginSuccessBlock)successBlock
                   setFailedBlock:(LoginFailedBlock)failedBlock;



/**
 *  校验手机号码用户是否已注册
 *  GET
 *
 *  @param dict
 *  @param successBlock
 *  @param failedBlock
 */
- (void)requestPhoneCheckRegister:(NSDictionary *)dict
                     successBlock:(LoginSuccessBlock)successBlock
                   setFailedBlock:(LoginFailedBlock)failedBlock;



/**
 *  短信注册码验证
 *  GET
 *
 *  @param dict
 *  @param successBlock
 *  @param failedBlock
 */
- (void)requestUserCheckcode:(NSDictionary *)dict
                successBlock:(LoginSuccessBlock)successBlock
              setFailedBlock:(LoginFailedBlock)failedBlock;



/**
 *  第三方登录
 *  POST
 *
 *  @param dict
 *  @param successBlock
 *  @param failedBlock
 */
- (void)requestThirdLogin:(NSDictionary *)dict
               publicDict:(NSDictionary *)publicDict
             successBlock:(LoginSuccessBlock)successBlock
           setFailedBlock:(LoginFailedBlock)failedBlock;


/**
 *  获取七牛云token
 *  GET
 *
 *  @param dict
 *  @param successBlock
 *  @param failedBlock
 */
- (void)requestGetQiniuToken:(NSDictionary *)dict
                successBlock:(LoginSuccessBlock)successBlock
              setFailedBlock:(LoginFailedBlock)failedBlock;


/**
 *  修改用户资料
 *  GET
 *
 *  @param dict
 *  @param successBlock
 *  @param failedBlock
 */
- (void)requestModifyUserData:(NSDictionary *)dict
                 successBlock:(LoginSuccessBlock)successBlock
               setFailedBlock:(LoginFailedBlock)failedBlock;


/**
 *  修改用户体型数据
 *  GET
 *
 *  @param dict
 *  @param successBlock
 *  @param failedBlock
 */
- (void)requestSaveBodyParam:(NSDictionary *)dict
                successBlock:(LoginSuccessBlock)successBlock
              setFailedBlock:(LoginFailedBlock)failedBlock;


/**
 *  保存用户身体特征
 *  GET
 *
 *  @param dict
 *  @param successBlock
 *  @param failedBlock
 */
- (void)requestSaveBodyDefect:(NSDictionary *)dict
                 successBlock:(LoginSuccessBlock)successBlock
               setFailedBlock:(LoginFailedBlock)failedBlock;


/**
 *  提交建议
 *  POST
 *
 *  @param dict
 *  @param successBlock
 *  @param failedBlock
 */
- (void)requestSubmitRecommendations:(NSDictionary *)dict
                          publicDict:(NSDictionary *)publicDict
                        successBlock:(LoginSuccessBlock)successBlock
                      setFailedBlock:(LoginFailedBlock)failedBlock;


/**
 *  绑定手机号码
 *  GET
 *
 *  @param dict
 *  @param successBlock
 *  @param failedBlock
 */
- (void)requestBindPhoneNO:(NSDictionary *)dict
              successBlock:(LoginSuccessBlock)successBlock
            setFailedBlock:(LoginFailedBlock)failedBlock;



/**
 *  绑定第三方账号
 *  GET
 *
 *  @param dict
 *  @param successBlock
 *  @param failedBlock
 */
- (void)requestBindThirdParty:(NSDictionary *)dict
                 successBlock:(LoginSuccessBlock)successBlock
               setFailedBlock:(LoginFailedBlock)failedBlock;



/**
 *  查看所有的兴趣标签
 *  GET
 *
 *  @param dict
 *  @param successBlock
 *  @param failedBlock
 */
- (void)requestGetInterestList:(NSDictionary *)dict
                  successBlock:(LoginSuccessBlock)successBlock
                setFailedBlock:(LoginFailedBlock)failedBlock;


/**
 *  查看用户的兴趣标签
 *  GET
 *
 *  @param dict
 *  @param successBlock
 *  @param failedBlock
 */
- (void)requestGetInterest:(NSDictionary *)dict
              successBlock:(LoginSuccessBlock)successBlock
            setFailedBlock:(LoginFailedBlock)failedBlock;


/**
 *  查看用户的身材数据
 *  GET
 *
 *  @param dict
 *  @param successBlock
 *  @param failedBlock
 */
- (void)requestGetBodyParam:(NSDictionary *)dict
               successBlock:(LoginSuccessBlock)successBlock
             setFailedBlock:(LoginFailedBlock)failedBlock;

/**
 *  查看用户的身材数据
 *  GET
 *
 *  @param dict
 *  @param successBlock
 *  @param failedBlock
 */
- (void)requestRestBodyParam:(NSDictionary *)dict
                successBlock:(LoginSuccessBlock)successBlock
              setFailedBlock:(LoginFailedBlock)failedBlock;



/**
 *  查看用户的风格标签
 *  GET
 *
 *  @param dict
 *  @param successBlock
 *  @param failedBlock
 */
- (void)requestGetStyles:(NSDictionary *)dict
            successBlock:(LoginSuccessBlock)successBlock
          setFailedBlock:(LoginFailedBlock)failedBlock;




/**
 *  保存用户的兴趣标签
 *  GET
 *
 *  @param dict
 *  @param successBlock
 *  @param failedBlock
 */
- (void)requestSaveInterest:(NSDictionary *)dict
              successBlock:(LoginSuccessBlock)successBlock
            setFailedBlock:(LoginFailedBlock)failedBlock;


/**
 *  查看用户试穿的商品列表
 *  GET
 *
 *  @param dict
 *  @param successBlock
 *  @param failedBlock
 */
- (void)requestGetTryProducts:(NSDictionary *)dict
                 successBlock:(LoginSuccessBlock)successBlock
               setFailedBlock:(LoginFailedBlock)failedBlock;


/**
 *  获取粉丝列表
 *  GET
 *
 *  @param completionBlock
 *  @param failedBlock
 */
- (void)requestUserFansList:(NSDictionary *)dict
               successBlock:(LoginSuccessBlock)successBlock
             setFailedBlock:(LoginFailedBlock)failedBlock;


/**
 *  获取关注列表
 *  GET
 *
 *  @param completionBlock
 *  @param failedBlock
 */
- (void)requestUserFocusList:(NSDictionary *)dict
                successBlock:(LoginSuccessBlock)successBlock
              setFailedBlock:(LoginFailedBlock)failedBlock;




/**
 *  我的回答列表
 *  GET
 *
 *  @param completionBlock
 *  @param failedBlock
 */
- (void)requestUserAnswersList:(NSDictionary *)dict
                  successBlock:(LoginSuccessBlock)successBlock
                setFailedBlock:(LoginFailedBlock)failedBlock;


/**
 *  我的评论列表
 *  GET
 *
 *  @param completionBlock
 *  @param failedBlock
 */
- (void)requestUserCommentsList:(NSDictionary *)dict
                   successBlock:(LoginSuccessBlock)successBlock
                 setFailedBlock:(LoginFailedBlock)failedBlock;


/**
 *  我的写真
 *  GET
 *
 *  @param completionBlock
 *  @param failedBlock
 */
- (void)requestUserBuyyerShow:(NSDictionary *)dict
                 successBlock:(LoginSuccessBlock)successBlock
               setFailedBlock:(LoginFailedBlock)failedBlock;

@end


