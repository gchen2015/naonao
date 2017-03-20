//
//  UserLogic.m
//  Naonao
//
//  Created by Richard Liu on 15/11/23.
//  Copyright © 2015年 深圳市轩腾华兴科技开发有限公司. All rights reserved.
//

#import "UserLogic.h"
#import "NSString+Hash.h"
#import "LoginDAO.h"
#import "JPUSHService.h"
#import <UMSocialCore/UMSocialCore.h>
#import <SDWebImage/SDImageCache.h>
#import "InterestModel.h"
#import "QiniuSDK.h"
#import "DemandMenu.h"
#import "STUserInfo.h"
#import "StorageAnswer.h"
#import "ShowModel.h"


@interface UserLogic ()

@end

@implementation UserLogic

+ (instancetype)sharedInstance {
    
    static dispatch_once_t onceToken;
    static UserLogic* instance = nil;
    dispatch_once(&onceToken, ^{
        instance = [[UserLogic alloc] init];
    });
    return instance;
}

- (id)init {
    if (self = [super init]) {
        //获取用户信息
        _user = [NSKeyedUnarchiver unarchiveObjectWithFile:[Units getProfilePath:kProfileName]];
        _uBody = [[UserBody alloc] init];
    }
    return self;
}

- (User *)getUser {
    return _user;
}

//密码加密
- (NSString *)md5Password:(NSString*)password {
    return [[kPKey stringByAppendingString:password] md5String];
}


//登录的相关逻辑
- (void)login:(LoginParam*)param withCallback:(UserLogicCommonCallback)results
{
    LoginDAO *dao = [[LoginDAO alloc] init];
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithCapacity:2];
    [dict setObject:param.phone forKey:@"telephone"];
    [dict setObject:[self md5Password:param.password] forKey:@"password"];

    LogicResult* cb = [[LogicResult alloc] init];
    [dao requestTelephoneLogin:dict successBlock:^(NSDictionary *result) {
        [cb success];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"FIRST_LAODMAGAZINELIST"];
    
        User *user = [MTLJSONAdapter modelOfClass:[User class] fromJSONDictionary:result error:nil];
        if ([self saveUserToFile:user]) {
            CLog(@"保存成功");
        }

        //设置别名（账号）
        [JPUSHService setAlias:[user.basic.userId stringValue] callbackSelector:@selector(tagsAliasCallback:tags:alias:) object:self];
        results(cb);
        
    } setFailedBlock:^(ResponseHeader *result) {
        [cb failure:result];
        results(cb);
    }];
}

//第三方登录
- (void)thirdPartyLogin:(ThirdLoginParam *)param withCallback:(UserLogicCommonCallback)results {
    
    LoginDAO *dao = [[LoginDAO alloc] init];
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithCapacity:4];
    [dict setObject:param.nickname forKey:@"nickname"];
    [dict setObject:param.profileUrl forKey:@"avatar"];
    [dict setObject:param.openid forKey:@"openid"];
    [dict setObject:param.gender forKey:@"gender"];
    
    
    if (param.unionid) {
        [dict setObject:param.unionid forKey:@"unionid"];
    }
    
    //type （1为微信登录，2为QQ登录，3为微博登录）
    [dict setObject:[NSNumber numberWithInteger:param.loginType] forKey:@"type"];
    LogicResult* cb = [[LogicResult alloc] init];
    
    [dao requestThirdLogin:dict publicDict:nil successBlock:^(NSDictionary *result) {
        [cb success];
        
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"FIRST_LAODMAGAZINELIST"];
        User *user = [MTLJSONAdapter modelOfClass:[User class] fromJSONDictionary:result error:nil];
        if ([self saveUserToFile:user]) {
            CLog(@"保存成功");
        }

        //设置别名（账号）
        [JPUSHService setAlias:[user.basic.userId stringValue] callbackSelector:@selector(tagsAliasCallback:tags:alias:) object:self];
        results(cb);
        
    } setFailedBlock:^(ResponseHeader *result) {
        [cb failure:result];
        results(cb);
    }];
}

// 验证手机号码是否被注册
- (void)whetherPhoneNumberRegistered:(RegisterParam *)param withCallback:(UserLogicCommonCallback)results
{
    LoginDAO *dao = [[LoginDAO alloc] init];
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithCapacity:1];
    [dict setObject:param.telephone forKey:@"telephone"];

    LogicResult* cb = [[LogicResult alloc] init];
    
    [dao requestPhoneCheckRegister:dict successBlock:^(NSDictionary *result) {
        [cb success];
        cb.mObject = [result objectForKeyNotNull:@"registered"];
        results(cb);
    } setFailedBlock:^(ResponseHeader *result) {
        [cb failure:result];
        results(cb);
    }];

}


// 获取手机验证码
- (void)getPhoneVerificationCode:(RegisterParam *)param withCallback:(UserLogicCommonCallback)results {
    LoginDAO *dao = [[LoginDAO alloc] init];
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithCapacity:1];
    [dict setObject:param.telephone forKey:@"telephone"];
    
    LogicResult* cb = [[LogicResult alloc] init];
    
    [dao requestAuthenticationCode:dict successBlock:^(NSDictionary *result) {
        [cb success];
        results(cb);
    } setFailedBlock:^(ResponseHeader *result) {
        [cb failure:result];
        results(cb);
    }];

}

// 验证验证码
- (void)validationPhoneVerificationCode:(RegisterParam *)param withCallback:(UserLogicCommonCallback)results {
    LoginDAO *dao = [[LoginDAO alloc] init];
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithCapacity:2];
    [dict setObject:param.telephone forKey:@"telephone"];
    [dict setObject:param.authcode forKey:@"authcode"];
    
    
    LogicResult* cb = [[LogicResult alloc] init];
    
    [dao requestUserCheckcode:dict successBlock:^(NSDictionary *result) {
        [cb success];
        results(cb);
    } setFailedBlock:^(ResponseHeader *result) {
        [cb failure:result];
        results(cb);
    }];

}

// 注册
- (void)registered:(RegisterParam *)param withCallback:(UserLogicCommonCallback)results {
    LoginDAO *dao = [[LoginDAO alloc] init];
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithCapacity:3];
    [dict setObject:param.telephone forKey:@"telephone"];
    [dict setObject:param.nickname forKey:@"nickname"];
    [dict setObject:[self md5Password:param.password] forKey:@"password"];
    
    LogicResult* cb = [[LogicResult alloc] init];
    
    [dao requestUserRegister:dict successBlock:^(NSDictionary *result) {
        [cb success];
        results(cb);
        
    } setFailedBlock:^(ResponseHeader *result) {
        [cb failure:result];
        results(cb);
    }];
}


// 修改用户密码
- (void)updatePassword:(RegisterParam *)param withCallback:(UserLogicCommonCallback)results
{
    LoginDAO *dao = [[LoginDAO alloc] init];
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithCapacity:3];
    [dict setObject:param.telephone forKey:@"telephone"];
    [dict setObject:param.authcode forKey:@"code"];
    [dict setObject:[self md5Password:param.password] forKey:@"password"];
    
    LogicResult* cb = [[LogicResult alloc] init];
    
    [dao requestUserUpdatePassword:dict successBlock:^(NSDictionary *result) {
        [cb success];
        results(cb);
        
    } setFailedBlock:^(ResponseHeader *result) {
        [cb failure:result];
        results(cb);
    }];
}


//上传图片到七牛云
- (void)updateUserHeadImage:(NSData *)imageData withCallback:(UserLogicCommonCallback)results
{
    LoginDAO *dao = [[LoginDAO alloc] init];
    LogicResult* cb = [[LogicResult alloc] init];
    
    [dao requestGetQiniuToken:nil successBlock:^(NSDictionary *result) {
        NSString *token = [result objectForKeyNotNull:@"token"];
        NSString *preF = [result objectForKeyNotNull:@"prefix"];
        if (token) {
            QNUploadManager *upManager = [[QNUploadManager alloc] init];
            [upManager putData:imageData key:nil token:token
                      complete: ^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
                          NSString *imageS = [NSString stringWithFormat:@"%@/%@", preF, resp[@"key"]];
                          cb.mObject = imageS;
                          results(cb);
                          
                      } option:nil];
        }
        else
        {
            [cb failure:nil];
            results(cb);
        }
            

    } setFailedBlock:^(ResponseHeader *result) {
        [cb failure:result];
        results(cb);
    }];
}

//保存个人资料
- (void)modifyUserData:(NSDictionary *)dict withCallback:(UserLogicCommonCallback)results
{
    LoginDAO *dao = [[LoginDAO alloc] init];
    LogicResult* cb = [[LogicResult alloc] init];
    
    [dao requestModifyUserData:dict successBlock:^(NSDictionary *result) {
        
        [cb success];
        results(cb);
        
        User *user = [self getUser];
        
        //昵称
        if ([dict objectForKeyNotNull:@"nickname"])
        {
            user.basic.userName = [Units decodeFromPercentEscapeString:[dict objectForKey:@"nickname"]];
        }
        
        //性别
        if ([dict objectForKeyNotNull:@"gender"])
        {
            user.basic.gender = [dict objectForKeyNotNull:@"gender"];
        }
        
        
        if ([dict objectForKeyNotNull:@"url"])
        {
            user.basic.avatarUrl = [dict objectForKey:@"url"];
        }

        if ([self saveUserToFile:user]) {
            CLog(@"保存成功");
        }
        
        
    } setFailedBlock:^(ResponseHeader *result) {
        [cb failure:result];
        results(cb);
    }];
}


// 保存用户身材数据
- (void)userSaveBodyParamCallback:(UserLogicCommonCallback)results
{
    LoginDAO *dao = [[LoginDAO alloc] init];
    LogicResult* cb = [[LogicResult alloc] init];
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithCapacity:0];
    //身高
    [dict setObject:_uBody.height forKey:@"height"];
    //体重
    [dict setObject:_uBody.weight forKey:@"weight"];
    //胸围
    [dict setObject:_uBody.bust forKey:@"bust"];
    //腰围
    [dict setObject:_uBody.waistline forKey:@"waistline"];
    //臀围
    [dict setObject:_uBody.hipline forKey:@"hipline"];
    //鞋码
    [dict setObject:_uBody.shoes forKey:@"shoes"];
    //身材类型
    [dict setObject:_uBody.bodyStyle forKey:@"body_style"];
    //人生阶段
    [dict setObject:_uBody.lifeStage forKey:@"life_stage"];
    
    
    [dao requestSaveBodyParam:dict successBlock:^(NSDictionary *result) {
        
        [cb success];
        results(cb);
        
        User *user = [self getUser];
        user.body = _uBody;
        
        if ([self saveUserToFile:user]) {
            CLog(@"保存成功");
        }
        
    } setFailedBlock:^(ResponseHeader *result) {
        [cb failure:result];
        results(cb);
    }];
}


// 保存用户身体特点
- (void)userBodyCharacterCallback:(UserLogicCommonCallback)results
{
    LoginDAO *dao = [[LoginDAO alloc] init];
    LogicResult* cb = [[LogicResult alloc] init];
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithCapacity:0];
    [dict setObject:[_uBody.bodydefect componentsJoinedByString:@"|"] forKey:@"bodydefect"];
    
    
    [dao requestSaveBodyDefect:dict successBlock:^(NSDictionary *result) {
        [cb success];
        results(cb);
        
        User *user = [self getUser];
        user.body.bodydefect = _uBody.bodydefect;
        
        if ([self saveUserToFile:user]) {
            CLog(@"保存成功");
        }
        
    } setFailedBlock:^(ResponseHeader *result) {
        [cb failure:result];
        results(cb);
    }];
}


//兴趣圈子列表
- (void)getInterestCircleList:(UserLogicCommonCallback)results
{
    LoginDAO *dao = [[LoginDAO alloc] init];
    LogicResult* cb = [[LogicResult alloc] init];
    
    [dao requestGetInterestList:nil successBlock:^(NSDictionary *result) {
        [cb success];
        cb.mObject = [MTLJSONAdapter modelsOfClass:[InterestModel class] fromJSONArray:(NSArray *)result error:nil];
        results(cb);
    } setFailedBlock:^(ResponseHeader *result) {
        [cb failure:result];
        results(cb);
    }];
}

//保存用户选择的兴趣标签
- (void)saveInterestCircleData:(NSDictionary *)dict withCallback:(UserLogicCommonCallback)results
{
    LoginDAO *dao = [[LoginDAO alloc] init];
    LogicResult* cb = [[LogicResult alloc] init];
    
    
    [dao requestSaveInterest:dict successBlock:^(NSDictionary *result) {
        [cb success];
        results(cb);
    } setFailedBlock:^(ResponseHeader *result) {
        [cb failure:result];
        results(cb);
    }];
}

//查询用户的兴趣标签
- (void)queryInterestCircleData:(NSDictionary *)dict withCallback:(UserLogicCommonCallback)results
{
    LoginDAO *dao = [[LoginDAO alloc] init];
    LogicResult* cb = [[LogicResult alloc] init];
    
    [dao requestGetInterest:dict successBlock:^(NSDictionary *result) {
        [cb success];
        cb.mObject = [MTLJSONAdapter modelsOfClass:[InterestModel class] fromJSONArray:(NSArray *)result error:nil];
        results(cb);
    } setFailedBlock:^(ResponseHeader *result) {
        [cb failure:result];
        results(cb);
    }];
}



// 查询用户身材数据
- (void)queryUserBodyPara:(NSDictionary *)dict withCallback:(UserLogicCommonCallback)results
{
    LoginDAO *dao = [[LoginDAO alloc] init];
    LogicResult* cb = [[LogicResult alloc] init];
    
    [dao requestGetBodyParam:dict successBlock:^(NSDictionary *result) {
        [cb success];
        cb.mObject = [MTLJSONAdapter modelOfClass:[STBodyStyle class] fromJSONDictionary:result error:nil];
        results(cb);
    } setFailedBlock:^(ResponseHeader *result) {
        [cb failure:result];
        results(cb);
    }];
}



//重置身材数据
- (void)userRestBodyParamCallback:(UserLogicCommonCallback)results
{
    LoginDAO *dao = [[LoginDAO alloc] init];
    LogicResult* cb = [[LogicResult alloc] init];
    
    [dao requestRestBodyParam:nil successBlock:^(NSDictionary *result) {

        User *user = [self getUser];
        user.body = nil;
        if ([self saveUserToFile:user]) {
            CLog(@"保存成功");
        }
        
        [cb success];
        results(cb);
        
    } setFailedBlock:^(ResponseHeader *result) {
        [cb failure:result];
        results(cb);
    }];
}


// 查询用户风格标签
- (void)queryUserStyles:(NSDictionary *)dict withCallback:(UserLogicCommonCallback)results
{
    LoginDAO *dao = [[LoginDAO alloc] init];
    LogicResult* cb = [[LogicResult alloc] init];
    
    [dao requestGetStyles:dict successBlock:^(NSDictionary *result) {
        [cb success];
        cb.mObject = (NSArray *)result;
        results(cb);
    } setFailedBlock:^(ResponseHeader *result) {
        [cb failure:result];
        results(cb);
    }];
}


// 提交建议
- (void)submitRecommendations:(NSDictionary *)dict withCallback:(UserLogicCommonCallback)results {
    LoginDAO *dao = [[LoginDAO alloc] init];
    LogicResult* cb = [[LogicResult alloc] init];

    [dao requestSubmitRecommendations:dict publicDict:nil successBlock:^(NSDictionary *result) {
        [cb success];
        results(cb);
    } setFailedBlock:^(ResponseHeader *result) {
        [cb failure:result];
        results(cb);
    }];
}

// 绑定手机
- (void)bindPhoneNO:(RegisterParam *)param withCallback:(UserLogicCommonCallback)results
{
    LoginDAO *dao = [[LoginDAO alloc] init];
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithCapacity:2];
    [dict setObject:param.telephone forKey:@"telephone"];
    [dict setObject:[self md5Password:param.password] forKey:@"password"];
    
    LogicResult* cb = [[LogicResult alloc] init];
    [dao requestBindPhoneNO:dict successBlock:^(NSDictionary *result) {
        
        User *user = [self getUser];
        user.basic.telephone = param.telephone;
        if ([self saveUserToFile:user]) {
            CLog(@"保存成功");
        }
        
        [cb success];
        results(cb);
    } setFailedBlock:^(ResponseHeader *result) {
        [cb failure:result];
        results(cb);
    }];
}

// 验证手机号
- (void)requestUserCheckcode:(NSDictionary *)dict withCallback:(UserLogicCommonCallback)results
{
    LoginDAO *dao = [[LoginDAO alloc] init];
    
    LogicResult* cb = [[LogicResult alloc] init];
    [dao requestUserCheckcode:dict successBlock:^(NSDictionary *result) {
        [cb success];
        results(cb);
    } setFailedBlock:^(ResponseHeader *result) {
        [cb failure:result];
        results(cb);
    }];
}


// 绑定第三方账号
- (void)bindThirdParty:(ThirdLoginParam *)loginParam withCallback:(UserLogicCommonCallback)results
{
    LoginDAO *dao = [[LoginDAO alloc] init];
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithCapacity:3];
    [dic setObject:loginParam.openid forKey:@"openid"];
    [dic setObject:[NSNumber numberWithInteger:loginParam.loginType] forKey:@"type"];
    
    
    if (loginParam.loginType == KLoginWX) {
        [dic setObject:loginParam.unionid forKey:@"unionid"];
    }
    
    
    LogicResult* cb = [[LogicResult alloc] init];
    [dao requestBindThirdParty:dic successBlock:^(NSDictionary *result) {
        User *user = [self getUser];
        
        NSMutableArray *mArray = [[NSMutableArray alloc] initWithCapacity:0];
        [mArray addObject:[NSString stringWithFormat:@"%ld", (long)loginParam.loginType]];
        
        if ([user.thirdparty count] > 0) {
            [mArray addObjectsFromArray:user.thirdparty];
        }
        
        user.thirdparty = mArray;
        
        if ([self saveUserToFile:user]) {
            CLog(@"保存成功");
        }
        
        [cb success];
        results(cb);
    } setFailedBlock:^(ResponseHeader *result) {
        [cb failure:result];
        results(cb);
    }];

}

// 获取粉丝列表
- (void)requestUserFansList:(NSDictionary *)dict withCallback:(UserLogicCommonCallback)results{
    LoginDAO *dao = [[LoginDAO alloc] init];
    LogicResult* cb = [[LogicResult alloc] init];
    
    
    [dao requestUserFansList:dict successBlock:^(NSDictionary *result) {
        [cb success];
        cb.mObject = [MTLJSONAdapter modelsOfClass:[UserFollow class] fromJSONArray:[result objectForKey:@"list"] error:nil];
        results(cb);
    } setFailedBlock:^(ResponseHeader *result) {
        [cb failure:result];
        results(cb);
    }];
}

// 获取关注列表
- (void)requestUserFocusList:(NSDictionary *)dict withCallback:(UserLogicCommonCallback)results{
    LoginDAO *dao = [[LoginDAO alloc] init];
    LogicResult* cb = [[LogicResult alloc] init];
    
    [dao requestUserFocusList:dict successBlock:^(NSDictionary *result) {
        [cb success];
        cb.mObject = [MTLJSONAdapter modelsOfClass:[UserFollow class] fromJSONArray:[result objectForKey:@"list"] error:nil];
        results(cb);
    } setFailedBlock:^(ResponseHeader *result) {
        [cb failure:result];
        results(cb);
    }];
}


// 获取用户的回答
- (void)requestUserAnswersList:(NSDictionary *)dict withCallback:(UserLogicCommonCallback)results
{
    LoginDAO *dao = [[LoginDAO alloc] init];
    LogicResult* cb = [[LogicResult alloc] init];
    
    [dao requestUserAnswersList:dict successBlock:^(NSDictionary *result) {
        [cb success];
        cb.mObject = [MTLJSONAdapter modelsOfClass:[UserAnswer class] fromJSONArray:(NSArray *)result error:nil];
        results(cb);
    } setFailedBlock:^(ResponseHeader *result) {
        [cb failure:result];
        results(cb);
    }];
}

// 获取用户的评论
- (void)requestUserCommentsList:(NSDictionary *)dict withCallback:(UserLogicCommonCallback)results
{
    LoginDAO *dao = [[LoginDAO alloc] init];
    LogicResult* cb = [[LogicResult alloc] init];
    
    [dao requestUserCommentsList:dict successBlock:^(NSDictionary *result) {
        [cb success];
        cb.mObject = [MTLJSONAdapter modelsOfClass:[MY_C class] fromJSONArray:(NSArray *)result error:nil];
        results(cb);
    } setFailedBlock:^(ResponseHeader *result) {
        [cb failure:result];
        results(cb);
    }];
}


// 我的写真
- (void)requestUserBuyyerShow:(NSDictionary *)dict withCallback:(UserLogicCommonCallback)results {
    LoginDAO *dao = [[LoginDAO alloc] init];
    LogicResult* cb = [[LogicResult alloc] init];
    
    [dao requestUserBuyyerShow:dict successBlock:^(NSDictionary *result) {
        [cb success];
        cb.mObject = [self pairsBuyyerShow:(NSArray *)result];
        results(cb);
    } setFailedBlock:^(ResponseHeader *result) {
        [cb failure:result];
        results(cb);
    }];
}

- (NSArray *)pairsBuyyerShow:(NSArray *)temA{
    
    NSMutableArray *proA = [NSMutableArray arrayWithCapacity:temA.count];
    
    for (NSDictionary *dic in temA) {
        ShowModel *sModel = [[ShowModel alloc] initWithParsData:dic];
        [proA addObject:sModel];
    }
    
    return proA;
}



//注册别名回调
- (void)tagsAliasCallback:(int)iResCode tags:(NSSet *)tags alias:(NSString *)alias {
    if(iResCode == 0)
    {
        CLog(@"别名设置成功");
    }
}

//保存用户信息
- (BOOL)saveUserToFile:(User*)user {
    _user = user;
    return [NSKeyedArchiver archiveRootObject:_user toFile:[Units getProfilePath:kProfileName]];
}


//注销时清空用户数据
- (void)cleanDataWhenLogout {
    [self removeUserFile];
    
    //清空缓存数据
    [[SDImageCache sharedImageCache] clearDiskOnCompletion:^{
        CLog(@"清理完毕");
    }];
}


//删除profile文件
- (BOOL)removeUserFile {
    BOOL suc = [Units removeFileAtPath:[Units getProfilePath:kProfileName]];
    if (suc) {
        _user = nil;
    }
    return suc;
}


@end
