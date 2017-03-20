//
//  RecommendedDAO.m
//  Naonao
//
//  Created by Richard Liu on 15/11/24.
//  Copyright © 2015年 深圳市轩腾华兴科技开发有限公司. All rights reserved.
//

#import "RecommendedDAO.h"
#import "RequestModel.h"

@implementation RecommendedDAO


// 推荐用户列表
- (void)requestSuggestedList:(NSDictionary *)dict
                successBlock:(RecommendedSuccessBlock)successBlock
              setFailedBlock:(RecommendedFailedBlock)failedBlock
{
    [[RequestModel shareInstance] requestModelWithAPI:URL_GetRecommandList
                                              getDict:dict
                                         successBlock:successBlock
                                       setFailedBlock:failedBlock];
}


// 查看所有的评论
- (void)requestCommentList:(NSDictionary *)dict
              successBlock:(RecommendedSuccessBlock)successBlock
            setFailedBlock:(RecommendedFailedBlock)failedBlock
{
    [[RequestModel shareInstance] requestModelWithAPI:URL_GetCommentList
                                              getDict:dict
                                         successBlock:successBlock
                                       setFailedBlock:failedBlock];
}


// 发表评论
- (void)requestAddComment:(NSDictionary *)dict
               publicDict:(NSDictionary *)publicDict
             successBlock:(RecommendedSuccessBlock)successBlock
           setFailedBlock:(RecommendedFailedBlock)failedBlock
{
    [[RequestModel shareInstance] requestModelWithAPI:URL_GetPublishedComment
                                             postDict:dict
                                           publicDict:publicDict
                                         successBlock:successBlock
                                       setFailedBlock:failedBlock];
}


// 个人中心页面
- (void)requestGetHobbyUserInfo:(NSDictionary *)dict
                   successBlock:(RecommendedSuccessBlock)successBlock
                 setFailedBlock:(RecommendedFailedBlock)failedBlock
{
    [[RequestModel shareInstance] requestModelWithAPI:URL_GetHobbyUserInfo
                                              getDict:dict
                                         successBlock:successBlock
                                       setFailedBlock:failedBlock];
}

// 取消关注
- (void)requestGetHobbyUnfollow:(NSDictionary *)dict
                   successBlock:(RecommendedSuccessBlock)successBlock
                 setFailedBlock:(RecommendedFailedBlock)failedBlock
{
    [[RequestModel shareInstance] requestModelWithAPI:URL_GetHobbyUnfollow
                                              getDict:dict
                                         successBlock:successBlock
                                       setFailedBlock:failedBlock];
}


// 关注用户
- (void)requestGetHobbyFollow:(NSDictionary *)dict
                 successBlock:(RecommendedSuccessBlock)successBlock
               setFailedBlock:(RecommendedFailedBlock)failedBlock
{
    [[RequestModel shareInstance] requestModelWithAPI:URL_GetHobbyFollow
                                              getDict:dict
                                         successBlock:successBlock
                                       setFailedBlock:failedBlock];
}


// 点赞
- (void)requestGetPraise:(NSDictionary *)dict
            successBlock:(RecommendedSuccessBlock)successBlock
          setFailedBlock:(RecommendedFailedBlock)failedBlock
{
    [[RequestModel shareInstance] requestModelWithAPI:URL_UserShowPraise
                                              getDict:dict
                                         successBlock:successBlock
                                       setFailedBlock:failedBlock];
}


// 取消点赞
- (void)requestGetUnPraise:(NSDictionary *)dict
              successBlock:(RecommendedSuccessBlock)successBlock
            setFailedBlock:(RecommendedFailedBlock)failedBlock
{
    [[RequestModel shareInstance] requestModelWithAPI:URL_UserShowUnPraise
                                              getDict:dict
                                         successBlock:successBlock
                                       setFailedBlock:failedBlock];
}



// 发布买家秀
- (void)requestSendCommit:(NSDictionary *)dict
               publicDict:(NSDictionary *)publicDict
             successBlock:(RecommendedSuccessBlock)successBlock
           setFailedBlock:(RecommendedFailedBlock)failedBlock
{
    [[RequestModel shareInstance] requestModelWithAPI:URL_GetShowCommit
                                             postDict:dict
                                           publicDict:publicDict
                                         successBlock:successBlock
                                       setFailedBlock:failedBlock];
}



@end
