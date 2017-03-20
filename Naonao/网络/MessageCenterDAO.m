//
//  MessageCenterDAO.m
//  Naonao
//
//  Created by 刘敏 on 16/5/10.
//  Copyright © 2016年 深圳市轩腾华兴科技开发有限公司. All rights reserved.
//

#import "MessageCenterDAO.h"
#import "RequestModel.h"

@implementation MessageCenterDAO



// 点赞列表
- (void)requestGetPraiseList:(NSDictionary *)dict
                successBlock:(MessageCenterSuccessBlock)successBlock
              setFailedBlock:(MessageCenterFailedBlock)failedBlock
{
    [[RequestModel shareInstance] requestModelWithAPI:URL_GetNotificationPraise
                                              getDict:dict
                                         successBlock:successBlock
                                       setFailedBlock:failedBlock];
}


//获取通知（混合）
- (void)requestGetNotificationMix:(NSDictionary *)dict
                     successBlock:(MessageCenterSuccessBlock)successBlock
                   setFailedBlock:(MessageCenterFailedBlock)failedBlock
{
    [[RequestModel shareInstance] requestModelWithAPI:URL_GetNotificationMix
                                              getDict:dict
                                         successBlock:successBlock
                                       setFailedBlock:failedBlock];
}

//读取消息回执
- (void)requestGetReadNotification:(NSDictionary *)dict
                      successBlock:(MessageCenterSuccessBlock)successBlock
                    setFailedBlock:(MessageCenterFailedBlock)failedBlock
{
    [[RequestModel shareInstance] requestModelWithAPI:URL_ReadNotification
                                              getDict:dict
                                         successBlock:successBlock
                                       setFailedBlock:failedBlock];
}

//查看未读消息数目
- (void)requestUnReadMsgNotification:(NSDictionary *)dict
                        successBlock:(MessageCenterSuccessBlock)successBlock
                      setFailedBlock:(MessageCenterFailedBlock)failedBlock
{
    [[RequestModel shareInstance] requestModelWithAPI:URL_UnReadMsgNotification
                                              getDict:dict
                                         successBlock:successBlock
                                       setFailedBlock:failedBlock];
}


//获取答案评论消息
- (void)requestAnswerCommentNotification:(NSDictionary *)dict
                            successBlock:(MessageCenterSuccessBlock)successBlock
                          setFailedBlock:(MessageCenterFailedBlock)failedBlock
{
    [[RequestModel shareInstance] requestModelWithAPI:URL_NotAnswerComment
                                              getDict:dict
                                         successBlock:successBlock
                                       setFailedBlock:failedBlock];
}


@end
