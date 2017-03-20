//
//  LoginDAO.m
//  Naonao
//
//  Created by Richard Liu on 15/11/23.
//  Copyright © 2015年 深圳市轩腾华兴科技开发有限公司. All rights reserved.
//

#import "LoginDAO.h"
#import "RequestModel.h"

@implementation LoginDAO

//（手机号）登录
- (void)requestTelephoneLogin:(NSDictionary *)dict
                 successBlock:(LoginSuccessBlock)successBlock
               setFailedBlock:(LoginFailedBlock)failedBlock
{
    [[RequestModel shareInstance] requestModelWithAPI:URL_UserLogin
                                              getDict:dict
                                      successBlock:successBlock
                                       setFailedBlock:failedBlock];
}


// 用户注册
- (void)requestUserRegister:(NSDictionary *)dict
               successBlock:(LoginSuccessBlock)successBlock
             setFailedBlock:(LoginFailedBlock)failedBlock
{
    [[RequestModel shareInstance] requestModelWithAPI:URL_UserRegister
                                              getDict:dict
                                         successBlock:successBlock
                                       setFailedBlock:failedBlock];
}

//修改用户密码
- (void)requestUserUpdatePassword:(NSDictionary *)dict
                     successBlock:(LoginSuccessBlock)successBlock
                   setFailedBlock:(LoginFailedBlock)failedBlock
{
    [[RequestModel shareInstance] requestModelWithAPI:URL_UserUpdatePassword
                                              getDict:dict
                                         successBlock:successBlock
                                       setFailedBlock:failedBlock];
}

// 获取短信验证码
- (void)requestAuthenticationCode:(NSDictionary *)dict
                     successBlock:(LoginSuccessBlock)successBlock
                   setFailedBlock:(LoginFailedBlock)failedBlock
{
    
    [[RequestModel shareInstance] requestModelWithAPI:URL_AuthenticationCode
                                              getDict:dict
                                         successBlock:successBlock
                                       setFailedBlock:failedBlock];
}

// 校验手机号码用户是否已注册
- (void)requestPhoneCheckRegister:(NSDictionary *)dict
                     successBlock:(LoginSuccessBlock)successBlock
                   setFailedBlock:(LoginFailedBlock)failedBlock
{
    [[RequestModel shareInstance] requestModelWithAPI:URL_UserPhoneCheckRegister
                                              getDict:dict
                                         successBlock:successBlock
                                       setFailedBlock:failedBlock];
    
}


// 短信注册码验证
- (void)requestUserCheckcode:(NSDictionary *)dict
                successBlock:(LoginSuccessBlock)successBlock
              setFailedBlock:(LoginFailedBlock)failedBlock
{
    [[RequestModel shareInstance] requestModelWithAPI:URL_UserCheckcode
                                              getDict:dict
                                         successBlock:successBlock
                                       setFailedBlock:failedBlock];
}


// 第三方登录
- (void)requestThirdLogin:(NSDictionary *)dict
               publicDict:(NSDictionary *)publicDict
             successBlock:(LoginSuccessBlock)successBlock
           setFailedBlock:(LoginFailedBlock)failedBlock
{
    [[RequestModel shareInstance] requestModelWithAPI:URL_ThirdLogin
                                             postDict:dict
                                           publicDict:publicDict
                                         successBlock:successBlock
                                       setFailedBlock:failedBlock];
}



// 获取七牛云token
- (void)requestGetQiniuToken:(NSDictionary *)dict
                successBlock:(LoginSuccessBlock)successBlock
              setFailedBlock:(LoginFailedBlock)failedBlock
{
    [[RequestModel shareInstance] requestModelWithAPI:URL_GetQiniuToken
                                              getDict:dict
                                         successBlock:successBlock
                                       setFailedBlock:failedBlock];
}


// 修改用户资料
- (void)requestModifyUserData:(NSDictionary *)dict
                 successBlock:(LoginSuccessBlock)successBlock
               setFailedBlock:(LoginFailedBlock)failedBlock
{
    [[RequestModel shareInstance] requestModelWithAPI:URL_UserModify
                                              getDict:dict
                                         successBlock:successBlock
                                       setFailedBlock:failedBlock];
}

// 修改用户体型数据
- (void)requestSaveBodyParam:(NSDictionary *)dict
                successBlock:(LoginSuccessBlock)successBlock
              setFailedBlock:(LoginFailedBlock)failedBlock
{
    [[RequestModel shareInstance] requestModelWithAPI:URL_SaveBodyParam
                                              getDict:dict
                                         successBlock:successBlock
                                       setFailedBlock:failedBlock];
}


// 保存用户身材特征
- (void)requestSaveBodyDefect:(NSDictionary *)dict
                 successBlock:(LoginSuccessBlock)successBlock
               setFailedBlock:(LoginFailedBlock)failedBlock
{
    [[RequestModel shareInstance] requestModelWithAPI:URL_SaveBodyDefect
                                               getDict:dict
                                          successBlock:successBlock
                                        setFailedBlock:failedBlock];
}

// 重置身材数据
- (void)requestRestBodyParam:(NSDictionary *)dict
                successBlock:(LoginSuccessBlock)successBlock
              setFailedBlock:(LoginFailedBlock)failedBlock
{
    [[RequestModel shareInstance] requestModelWithAPI:URL_RestBodyParams
                                              getDict:dict
                                         successBlock:successBlock
                                       setFailedBlock:failedBlock];
}




// 提交建议
- (void)requestSubmitRecommendations:(NSDictionary *)dict
                          publicDict:(NSDictionary *)publicDict
                        successBlock:(LoginSuccessBlock)successBlock
                      setFailedBlock:(LoginFailedBlock)failedBlock
{
    [[RequestModel shareInstance] requestModelWithAPI:URL_SaveSuggest
                                             postDict:dict
                                           publicDict:publicDict
                                         successBlock:successBlock
                                       setFailedBlock:failedBlock];
}

// 绑定手机号码
- (void)requestBindPhoneNO:(NSDictionary *)dict
              successBlock:(LoginSuccessBlock)successBlock
            setFailedBlock:(LoginFailedBlock)failedBlock
{
    [[RequestModel shareInstance] requestModelWithAPI:URL_UserBindTelephone
                                              getDict:dict
                                         successBlock:successBlock
                                       setFailedBlock:failedBlock];
}

// 绑定第三方账号
- (void)requestBindThirdParty:(NSDictionary *)dict
                 successBlock:(LoginSuccessBlock)successBlock
               setFailedBlock:(LoginFailedBlock)failedBlock
{
    [[RequestModel shareInstance] requestModelWithAPI:URL_UserBindOpenID
                                              getDict:dict
                                         successBlock:successBlock
                                       setFailedBlock:failedBlock];
}

// 获取所有兴趣标签
- (void)requestGetInterestList:(NSDictionary *)dict
                  successBlock:(LoginSuccessBlock)successBlock
                setFailedBlock:(LoginFailedBlock)failedBlock
{
    [[RequestModel shareInstance] requestModelWithAPI:URL_GetInterestList
                                              getDict:dict
                                         successBlock:successBlock
                                       setFailedBlock:failedBlock];
}


// 查看用户的兴趣标签
- (void)requestGetInterest:(NSDictionary *)dict
              successBlock:(LoginSuccessBlock)successBlock
            setFailedBlock:(LoginFailedBlock)failedBlock
{
    [[RequestModel shareInstance] requestModelWithAPI:URL_GetInterest
                                              getDict:dict
                                         successBlock:successBlock
                                       setFailedBlock:failedBlock];
}



// 查看用户的身材数据
- (void)requestGetBodyParam:(NSDictionary *)dict
               successBlock:(LoginSuccessBlock)successBlock
             setFailedBlock:(LoginFailedBlock)failedBlock
{
    [[RequestModel shareInstance] requestModelWithAPI:URL_GetBodyParam
                                              getDict:dict
                                         successBlock:successBlock
                                       setFailedBlock:failedBlock];
}



// 查看用户的风格标签
- (void)requestGetStyles:(NSDictionary *)dict
            successBlock:(LoginSuccessBlock)successBlock
          setFailedBlock:(LoginFailedBlock)failedBlock
{
    [[RequestModel shareInstance] requestModelWithAPI:URL_GetUserStyles
                                              getDict:dict
                                         successBlock:successBlock
                                       setFailedBlock:failedBlock];
}



// 保存用户的兴趣标签
- (void)requestSaveInterest:(NSDictionary *)dict
               successBlock:(LoginSuccessBlock)successBlock
             setFailedBlock:(LoginFailedBlock)failedBlock
{
    [[RequestModel shareInstance] requestModelWithAPI:URL_GetSaveInterest
                                              getDict:dict
                                         successBlock:successBlock
                                       setFailedBlock:failedBlock];
}



// 查看用户试穿的商品列表
- (void)requestGetTryProducts:(NSDictionary *)dict
                 successBlock:(LoginSuccessBlock)successBlock
               setFailedBlock:(LoginFailedBlock)failedBlock
{
    [[RequestModel shareInstance] requestModelWithAPI:URL_GetTryProducts
                                              getDict:dict
                                         successBlock:successBlock
                                       setFailedBlock:failedBlock];
}


// 获取粉丝列表
- (void)requestUserFansList:(NSDictionary *)dict
               successBlock:(LoginSuccessBlock)successBlock
             setFailedBlock:(LoginFailedBlock)failedBlock
{
    [[RequestModel shareInstance] requestModelWithAPI:URL_UserFollower
                                              getDict:dict
                                         successBlock:successBlock
                                       setFailedBlock:failedBlock];
}


// 获取关注列表
- (void)requestUserFocusList:(NSDictionary *)dict
                successBlock:(LoginSuccessBlock)successBlock
              setFailedBlock:(LoginFailedBlock)failedBlock
{
    [[RequestModel shareInstance] requestModelWithAPI:URL_UserFollowing
                                              getDict:dict
                                         successBlock:successBlock
                                       setFailedBlock:failedBlock];
}


// 我的回答列表
- (void)requestUserAnswersList:(NSDictionary *)dict
                  successBlock:(LoginSuccessBlock)successBlock
                setFailedBlock:(LoginFailedBlock)failedBlock
{
    [[RequestModel shareInstance] requestModelWithAPI:URL_UserAnswers
                                              getDict:dict
                                         successBlock:successBlock
                                       setFailedBlock:failedBlock];
}


// 我的评论列表
- (void)requestUserCommentsList:(NSDictionary *)dict
                   successBlock:(LoginSuccessBlock)successBlock
                 setFailedBlock:(LoginFailedBlock)failedBlock
{
    [[RequestModel shareInstance] requestModelWithAPI:URL_UserComments
                                              getDict:dict
                                         successBlock:successBlock
                                       setFailedBlock:failedBlock];
}


// 我的写真
- (void)requestUserBuyyerShow:(NSDictionary *)dict
                 successBlock:(LoginSuccessBlock)successBlock
               setFailedBlock:(LoginFailedBlock)failedBlock
{
    [[RequestModel shareInstance] requestModelWithAPI:URL_BuyyerShow
                                              getDict:dict
                                         successBlock:successBlock
                                       setFailedBlock:failedBlock];
}


@end
