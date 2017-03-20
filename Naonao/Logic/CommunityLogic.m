//
//  CommunityLogic.m
//  Naonao
//
//  Created by 刘敏 on 16/4/4.
//  Copyright © 2016年 深圳市轩腾华兴科技开发有限公司. All rights reserved.
//

#import "CommunityLogic.h"
#import "RecommendedDAO.h"
#import "DynamicInfo.h"
#import "CommentsModelFrame.h"
#import "STUserInfo.h"
#import "LoginDAO.h"
#import "QiniuSDK.h"



@implementation CommunityLogic


+ (instancetype)sharedInstance
{
    static dispatch_once_t onceToken;
    static CommunityLogic* instance = nil;
    dispatch_once(&onceToken, ^{
        instance = [[CommunityLogic alloc] init];
    });
    return instance;
}

- (void)setProID:(NSNumber *)proID
{
    _proID = proID;
}

//获取推荐用户列表
- (void)getRecommandList:(NSDictionary *)dict withCallback:(CommunityLogicCommonCallback)results
{
    RecommendedDAO *dao = [[RecommendedDAO alloc] init];
    LogicResult* cb = [[LogicResult alloc] init];
    
    [dao requestSuggestedList:dict successBlock:^(NSDictionary *result) {
        [cb success];
        if (result.count > 0) {
            cb.mObject = [self pairsDynamicList:(NSArray *)result];
        }
        
        results(cb);
    } setFailedBlock:^(ResponseHeader *result) {
        [cb failure:result];
        results(cb);
    }];
}


- (NSArray *)pairsDynamicList:(NSArray *)tA
{
    NSMutableArray *pA = [NSMutableArray arrayWithCapacity:tA.count];
    
    for (NSDictionary *item in tA) {
//        DynamicInfo *dInfo = [[DynamicInfo alloc] initWithParsData:item];
//        
//        DynamicModelFrame *dModel = [[DynamicModelFrame alloc] init];
//        dModel.dInfo = dInfo;
//        [pA addObject:dModel];
    }
    
    return pA;
}


//关注好友
- (void)getAttentionUserInfo:(NSDictionary *)dict withCallback:(CommunityLogicCommonCallback)results
{
    RecommendedDAO *dao = [[RecommendedDAO alloc] init];
    LogicResult* cb = [[LogicResult alloc] init];
    
    [dao requestGetHobbyFollow:dict successBlock:^(NSDictionary *result) {
        [cb success];
        results(cb);
    } setFailedBlock:^(ResponseHeader *result) {
        [cb failure:result];
        results(cb);
    }];
}

//取消关注好友
- (void)getUnAttentionUserInfo:(NSDictionary *)dict withCallback:(CommunityLogicCommonCallback)results
{
    RecommendedDAO *dao = [[RecommendedDAO alloc] init];
    LogicResult* cb = [[LogicResult alloc] init];
    
    [dao requestGetHobbyUnfollow:dict successBlock:^(NSDictionary *result) {
        [cb success];
        results(cb);
    } setFailedBlock:^(ResponseHeader *result) {
        [cb failure:result];
        results(cb);
    }];
}


//获取评论列表
- (void)getCommentsList:(NSDictionary *)dict withCallback:(CommunityLogicCommonCallback)results
{
    RecommendedDAO *dao = [[RecommendedDAO alloc] init];
    LogicResult* cb = [[LogicResult alloc] init];
    
    [dao requestCommentList:dict successBlock:^(NSDictionary *result) {
        [cb success];
        
        if (result.count <= 0) {
            results(cb);
            return ;
        }

        NSArray *tA = [MTLJSONAdapter modelsOfClass:[STCommentData class] fromJSONArray:[result objectForKey:@"list"] error:nil];
        NSMutableArray *temp = [NSMutableArray arrayWithCapacity:tA.count];
        
        for (int i = 0; i<tA.count; i++) {
            CommentsModelFrame *cModel = [[CommentsModelFrame alloc] init];
            cModel.authorID = [dict objectForKey:@"hobby_userid"];          //商品发布者
            cModel.tData = [tA objectAtIndex:i];
            
            [temp addObject:cModel];
        }
        
        cb.mObject = temp;
        results(cb);
        
    } setFailedBlock:^(ResponseHeader *result) {
        [cb failure:result];
        results(cb);
    }];
}


//发表评论
- (void)sendComments:(NSDictionary *)dict withCallback:(CommunityLogicCommonCallback)results
{
    RecommendedDAO *dao = [[RecommendedDAO alloc] init];
    LogicResult* cb = [[LogicResult alloc] init];
    
    [dao requestAddComment:dict publicDict:nil successBlock:^(NSDictionary *result) {
        [cb success];
        results(cb);
    } setFailedBlock:^(ResponseHeader *result) {
        [cb failure:result];
        results(cb);
    }];
}


//获取个人中心
- (void)getUserInfo:(NSDictionary *)dict withCallback:(CommunityLogicCommonCallback)results
{
    RecommendedDAO *dao = [[RecommendedDAO alloc] init];
    LogicResult* cb = [[LogicResult alloc] init];
    
    [dao requestGetHobbyUserInfo:dict successBlock:^(NSDictionary *result) {
        [cb success];
        cb.mObject = [MTLJSONAdapter modelOfClass:[STUserInfo class] fromJSONDictionary:result error:nil];
        results(cb);
    } setFailedBlock:^(ResponseHeader *result) {
        [cb failure:result];
        results(cb);
    }];
}


//点赞
- (void)getShowPraise:(NSDictionary *)dict withCallback:(CommunityLogicCommonCallback)results
{
    RecommendedDAO *dao = [[RecommendedDAO alloc] init];
    LogicResult* cb = [[LogicResult alloc] init];
    
    [dao requestGetPraise:dict successBlock:^(NSDictionary *result) {
        [cb success];
        results(cb);
    } setFailedBlock:^(ResponseHeader *result) {
        [cb failure:result];
        results(cb);
    }];

}

//取消点赞
- (void)getShowUnPraise:(NSDictionary *)dict withCallback:(CommunityLogicCommonCallback)results
{
    RecommendedDAO *dao = [[RecommendedDAO alloc] init];
    LogicResult* cb = [[LogicResult alloc] init];
    
    [dao requestGetUnPraise:dict successBlock:^(NSDictionary *result) {
        [cb success];
        results(cb);
    } setFailedBlock:^(ResponseHeader *result) {
        [cb failure:result];
        results(cb);
    }];
}


//上传图片到七牛云
- (void)uploadPicturesToQiniu:(NSData *)imageData withCallback:(UserLogicCommonCallback)results
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
                          NSLog(@"上传的图片信息：%@", resp);
                          
                          if ([resp[@"hash"] length] < 1) {
                              [cb failure:nil];
                              results(cb);
                              [theAppDelegate.window makeToast:@"文件上传失败"];
                          }
                          
                          
                          NSString *imageS = [NSString stringWithFormat:@"%@/%@", preF, resp[@"hash"]];
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

//发布买家秀
- (void)sendBuyersShow:(NSDictionary *)dict withCallback:(CommunityLogicCommonCallback)results
{
    RecommendedDAO *dao = [[RecommendedDAO alloc] init];
    LogicResult* cb = [[LogicResult alloc] init];
    
    [dao requestSendCommit:dict publicDict:nil successBlock:^(NSDictionary *result) {
        [cb success];
        results(cb);
    } setFailedBlock:^(ResponseHeader *result) {
        [cb failure:result];
        results(cb);
    }];
}



@end
