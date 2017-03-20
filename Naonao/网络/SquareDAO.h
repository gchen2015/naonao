//
//  SquareDAO.h
//  Naonao
//
//  Created by 刘敏 on 16/5/31.
//  Copyright © 2016年 深圳市轩腾华兴科技开发有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ResponseHeader.h"

typedef void (^SquareSuccessBlock)(NSDictionary *result);
typedef void (^SquareFailedBlock)(ResponseHeader *result);

@interface SquareDAO : NSObject


/**
 *  问答广场
 *  GET
 *
 *  @param dict
 *  @param successBlock
 *  @param failedBlock
 */
- (void)requestGetPublishSquare:(NSDictionary *)dict
                   successBlock:(SquareSuccessBlock)successBlock
                 setFailedBlock:(SquareFailedBlock)failedBlock;


/**
 *  获取单个问题
 *  GET
 *
 *  @param dict
 *  @param successBlock
 *  @param failedBlock
 */
- (void)requestGetPublishBasic:(NSDictionary *)dict
                  successBlock:(SquareSuccessBlock)successBlock
                setFailedBlock:(SquareFailedBlock)failedBlock;


/**
 *  自动回应的答案列表
 *  GET
 *
 *  @param dict
 *  @param successBlock
 *  @param failedBlock
 */
- (void)requestGetPublishRobotAnswer:(NSDictionary *)dict
                        successBlock:(SquareSuccessBlock)successBlock
                      setFailedBlock:(SquareFailedBlock)failedBlock;



/**
 *  查看用户答案列表
 *  GET
 *
 *  @param dict
 *  @param successBlock
 *  @param failedBlock
 */
- (void)requestGetPublishAnswer:(NSDictionary *)dict
                   successBlock:(SquareSuccessBlock)successBlock
                 setFailedBlock:(SquareFailedBlock)failedBlock;



/**
 *  关心广场上的问题
 *  GET
 *
 *  @param dict
 *  @param successBlock
 *  @param failedBlock
 */
- (void)requestGetPublishCareAnswer:(NSDictionary *)dict
                       successBlock:(SquareSuccessBlock)successBlock
                     setFailedBlock:(SquareFailedBlock)failedBlock;


/**
 *  取消关心广场上的问题
 *  GET
 *
 *  @param dict
 *  @param successBlock
 *  @param failedBlock
 */
- (void)requestGetPublishUncareAnswer:(NSDictionary *)dict
                         successBlock:(SquareSuccessBlock)successBlock
                       setFailedBlock:(SquareFailedBlock)failedBlock;


/**
 *  添加答案
 *  POST
 *
 *  @param dict
 *  @param successBlock
 *  @param failedBlock
 */
- (void)requestGetPublishAddAnswer:(NSDictionary *)dict
                        publicDict:(NSDictionary *)publicDict
                      successBlock:(SquareSuccessBlock)successBlock
                    setFailedBlock:(SquareFailedBlock)failedBlock;



/**
 *  我的问题列表
 *  GET
 *
 *  @param dict
 *  @param successBlock
 *  @param failedBlock
 */
- (void)requestGetPublishMyOrders:(NSDictionary *)dict
                     successBlock:(SquareSuccessBlock)successBlock
                   setFailedBlock:(SquareFailedBlock)failedBlock;

/**
 *  删除自己发布的提问
 *  GET
 *
 *  @param dict
 *  @param successBlock
 *  @param failedBlock
 */
- (void)requestDeleteOrder:(NSDictionary *)dict
              successBlock:(SquareSuccessBlock)successBlock
            setFailedBlock:(SquareFailedBlock)failedBlock;


/**
 *  查看答案的评论列表
 *  GET
 *
 *  @param dict
 *  @param successBlock
 *  @param failedBlock
 */
- (void)requestAnswerComments:(NSDictionary *)dict
                 successBlock:(SquareSuccessBlock)successBlock
               setFailedBlock:(SquareFailedBlock)failedBlock;

/**
 *  添加答案的评论
 *  POST
 *
 *  @param dict
 *  @param successBlock
 *  @param failedBlock
 */
- (void)requestAddComments:(NSDictionary *)dict
                publicDict:(NSDictionary *)publicDict
              successBlock:(SquareSuccessBlock)successBlock
            setFailedBlock:(SquareFailedBlock)failedBlock;


/**
 *  点赞
 *  GET
 *
 *  @param dict
 *  @param successBlock
 *  @param failedBlock
 */
- (void)requestGetPraise:(NSDictionary *)dict
            successBlock:(SquareSuccessBlock)successBlock
          setFailedBlock:(SquareFailedBlock)failedBlock;


/**
 *  取消点赞
 *  GET
 *
 *  @param dict
 *  @param successBlock
 *  @param failedBlock
 */
- (void)requestGetUnPraise:(NSDictionary *)dict
              successBlock:(SquareSuccessBlock)successBlock
            setFailedBlock:(SquareFailedBlock)failedBlock;


/**
 *  删除评论答案
 *  GET
 *
 *  @param dict
 *  @param successBlock
 *  @param failedBlock
 */
- (void)requestDeleteAnswerComment:(NSDictionary *)dict
                      successBlock:(SquareSuccessBlock)successBlock
                    setFailedBlock:(SquareFailedBlock)failedBlock;

/**
 *  删除评论答案
 *  GET
 *
 *  @param dict
 *  @param successBlock
 *  @param failedBlock
 */
- (void)requestCareOrdersAnswer:(NSDictionary *)dict
                   successBlock:(SquareSuccessBlock)successBlock
                 setFailedBlock:(SquareFailedBlock)failedBlock;

/**
 *  删除我的回答（广场）
 *  GET
 *
 *  @param completionBlock
 *  @param failedBlock
 */
- (void)requestUserSquareDelAnswer:(NSDictionary *)dict
                      successBlock:(SquareSuccessBlock)successBlock
                    setFailedBlock:(SquareFailedBlock)failedBlock;




@end
