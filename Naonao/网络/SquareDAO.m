//
//  SquareDAO.m
//  Naonao
//
//  Created by 刘敏 on 16/5/31.
//  Copyright © 2016年 深圳市轩腾华兴科技开发有限公司. All rights reserved.
//

#import "SquareDAO.h"
#import "RequestModel.h"

@implementation SquareDAO


// 问答广场
- (void)requestGetPublishSquare:(NSDictionary *)dict
                   successBlock:(SquareSuccessBlock)successBlock
                 setFailedBlock:(SquareFailedBlock)failedBlock
{
    [[RequestModel shareInstance] requestModelWithAPI:URL_PublishSquare
                                              getDict:dict
                                         successBlock:successBlock
                                       setFailedBlock:failedBlock];
}

//获取单个问题
- (void)requestGetPublishBasic:(NSDictionary *)dict
                  successBlock:(SquareSuccessBlock)successBlock
                setFailedBlock:(SquareFailedBlock)failedBlock
{
    [[RequestModel shareInstance] requestModelWithAPI:URL_PublishOrderBasic
                                              getDict:dict
                                         successBlock:successBlock
                                       setFailedBlock:failedBlock];
}



// 自动回应的答案列表
- (void)requestGetPublishRobotAnswer:(NSDictionary *)dict
                        successBlock:(SquareSuccessBlock)successBlock
                      setFailedBlock:(SquareFailedBlock)failedBlock
{
    [[RequestModel shareInstance] requestModelWithAPI:URL_PublishRobotAnswer
                                              getDict:dict
                                         successBlock:successBlock
                                       setFailedBlock:failedBlock];
}

// 查看用户答案列表
- (void)requestGetPublishAnswer:(NSDictionary *)dict
                   successBlock:(SquareSuccessBlock)successBlock
                 setFailedBlock:(SquareFailedBlock)failedBlock
{
    [[RequestModel shareInstance] requestModelWithAPI:URL_PublishAnswer
                                              getDict:dict
                                         successBlock:successBlock
                                       setFailedBlock:failedBlock];
}


// 关心广场上的问题
- (void)requestGetPublishCareAnswer:(NSDictionary *)dict
                       successBlock:(SquareSuccessBlock)successBlock
                     setFailedBlock:(SquareFailedBlock)failedBlock
{
    [[RequestModel shareInstance] requestModelWithAPI:URL_PublishCareAnswer
                                              getDict:dict
                                         successBlock:successBlock
                                       setFailedBlock:failedBlock];
}

// 取消关心广场上的问题
- (void)requestGetPublishUncareAnswer:(NSDictionary *)dict
                         successBlock:(SquareSuccessBlock)successBlock
                       setFailedBlock:(SquareFailedBlock)failedBlock
{
    [[RequestModel shareInstance] requestModelWithAPI:URL_PublishUncareAnswer
                                              getDict:dict
                                         successBlock:successBlock
                                       setFailedBlock:failedBlock];
}

// 添加答案
- (void)requestGetPublishAddAnswer:(NSDictionary *)dict
                        publicDict:(NSDictionary *)publicDict
                      successBlock:(SquareSuccessBlock)successBlock
                    setFailedBlock:(SquareFailedBlock)failedBlock
{
    [[RequestModel shareInstance] requestModelWithAPI:URL_PublishAddAnswer
                                             postDict:dict
                                           publicDict:publicDict
                                         successBlock:successBlock
                                       setFailedBlock:failedBlock];
}


// 我的问题列表
- (void)requestGetPublishMyOrders:(NSDictionary *)dict
                     successBlock:(SquareSuccessBlock)successBlock
                   setFailedBlock:(SquareFailedBlock)failedBlock
{
     [[RequestModel shareInstance] requestModelWithAPI:URL_PublishMyOrders
                                               getDict:dict
                                          successBlock:successBlock
                                        setFailedBlock:failedBlock];
}


// 删除自己发布的提问
- (void)requestDeleteOrder:(NSDictionary *)dict
              successBlock:(SquareSuccessBlock)successBlock
            setFailedBlock:(SquareFailedBlock)failedBlock
{
    [[RequestModel shareInstance] requestModelWithAPI:URL_PublishDeleteOrder
                                              getDict:dict
                                         successBlock:successBlock
                                       setFailedBlock:failedBlock];
}

// 查看答案的评论列表
- (void)requestAnswerComments:(NSDictionary *)dict
                 successBlock:(SquareSuccessBlock)successBlock
               setFailedBlock:(SquareFailedBlock)failedBlock
{
    [[RequestModel shareInstance] requestModelWithAPI:URL_GetAnswerComments
                                              getDict:dict
                                         successBlock:successBlock
                                       setFailedBlock:failedBlock];
}


// 添加答案的评论
- (void)requestAddComments:(NSDictionary *)dict
                publicDict:(NSDictionary *)publicDict
              successBlock:(SquareSuccessBlock)successBlock
            setFailedBlock:(SquareFailedBlock)failedBlock
{
    [[RequestModel shareInstance] requestModelWithAPI:URL_AddAnswerComments
                                             postDict:dict
                                           publicDict:publicDict
                                         successBlock:successBlock
                                       setFailedBlock:failedBlock];
}

// 点赞
- (void)requestGetPraise:(NSDictionary *)dict
            successBlock:(SquareSuccessBlock)successBlock
          setFailedBlock:(SquareFailedBlock)failedBlock
{
    [[RequestModel shareInstance] requestModelWithAPI:URL_LikeAnswer
                                              getDict:dict
                                         successBlock:successBlock
                                       setFailedBlock:failedBlock];
}


// 取消点赞
- (void)requestGetUnPraise:(NSDictionary *)dict
              successBlock:(SquareSuccessBlock)successBlock
            setFailedBlock:(SquareFailedBlock)failedBlock
{
    [[RequestModel shareInstance] requestModelWithAPI:URL_UnlikeAnswer
                                              getDict:dict
                                         successBlock:successBlock
                                       setFailedBlock:failedBlock];
}


// 删除评论答案
- (void)requestDeleteAnswerComment:(NSDictionary *)dict
                      successBlock:(SquareSuccessBlock)successBlock
                    setFailedBlock:(SquareFailedBlock)failedBlock
{
    [[RequestModel shareInstance] requestModelWithAPI:URL_DeleteAnswerComment
                                              getDict:dict
                                         successBlock:successBlock
                                       setFailedBlock:failedBlock];
}

// 获取我收藏的问题
- (void)requestCareOrdersAnswer:(NSDictionary *)dict
                   successBlock:(SquareSuccessBlock)successBlock
                 setFailedBlock:(SquareFailedBlock)failedBlock
{
    [[RequestModel shareInstance] requestModelWithAPI:URL_PublishCareOrders
                                              getDict:dict
                                         successBlock:successBlock
                                       setFailedBlock:failedBlock];
}

// 删除我的回答（广场）
- (void)requestUserSquareDelAnswer:(NSDictionary *)dict
                      successBlock:(SquareSuccessBlock)successBlock
                    setFailedBlock:(SquareFailedBlock)failedBlock
{
    [[RequestModel shareInstance] requestModelWithAPI:URL_SquareDelAnswer
                                              getDict:dict
                                         successBlock:successBlock
                                       setFailedBlock:failedBlock];
}


@end
