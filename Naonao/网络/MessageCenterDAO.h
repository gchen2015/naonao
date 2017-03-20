//
//  MessageCenterDAO.h
//  Naonao
//
//  Created by 刘敏 on 16/5/10.
//  Copyright © 2016年 深圳市轩腾华兴科技开发有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ResponseHeader.h"

typedef void (^MessageCenterSuccessBlock)(NSDictionary *result);
typedef void (^MessageCenterFailedBlock)(ResponseHeader *result);


@interface MessageCenterDAO : NSObject


/**
 *  点赞列表
 *  GET
 *
 *  @param dict
 *  @param successBlock
 *  @param failedBlock
 */
- (void)requestGetPraiseList:(NSDictionary *)dict
                successBlock:(MessageCenterSuccessBlock)successBlock
              setFailedBlock:(MessageCenterFailedBlock)failedBlock;


/**
 *  获取通知
 *  GET
 *
 *  @param dict
 *  @param successBlock
 *  @param failedBlock
 */
- (void)requestGetNotificationMix:(NSDictionary *)dict
                     successBlock:(MessageCenterSuccessBlock)successBlock
                   setFailedBlock:(MessageCenterFailedBlock)failedBlock;


/**
 *  读取消息回执
 *  GET
 *
 *  @param dict
 *  @param successBlock
 *  @param failedBlock
 */
- (void)requestGetReadNotification:(NSDictionary *)dict
                      successBlock:(MessageCenterSuccessBlock)successBlock
                    setFailedBlock:(MessageCenterFailedBlock)failedBlock;


/**
 *  查看未读消息数目
 *  GET
 *
 *  @param dict
 *  @param successBlock
 *  @param failedBlock
 */
- (void)requestUnReadMsgNotification:(NSDictionary *)dict
                        successBlock:(MessageCenterSuccessBlock)successBlock
                      setFailedBlock:(MessageCenterFailedBlock)failedBlock;


/**
 *  获取答案评论消息
 *  GET
 *
 *  @param dict
 *  @param successBlock
 *  @param failedBlock
 */
- (void)requestAnswerCommentNotification:(NSDictionary *)dict
                            successBlock:(MessageCenterSuccessBlock)successBlock
                          setFailedBlock:(MessageCenterFailedBlock)failedBlock;


@end
