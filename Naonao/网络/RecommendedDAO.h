//
//  RecommendedDAO.h
//  Naonao
//
//  Created by Richard Liu on 15/11/24.
//  Copyright © 2015年 深圳市轩腾华兴科技开发有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ResponseHeader.h"

typedef void (^RecommendedSuccessBlock)(NSDictionary *result);
typedef void (^RecommendedFailedBlock)(ResponseHeader *result);


@interface RecommendedDAO : NSObject


/**
 *  推荐用户列表
 *  GET
 *
 *  @param dict
 *  @param successBlock
 *  @param failedBlock
 */
- (void)requestSuggestedList:(NSDictionary *)dict
                successBlock:(RecommendedSuccessBlock)successBlock
              setFailedBlock:(RecommendedFailedBlock)failedBlock;



/**
 *  查看所有的评论
 *  GET
 *
 *  @param dict
 *  @param successBlock
 *  @param failedBlock
 */
- (void)requestCommentList:(NSDictionary *)dict
              successBlock:(RecommendedSuccessBlock)successBlock
            setFailedBlock:(RecommendedFailedBlock)failedBlock;


/**
 *  添加评论
 *  POST
 *
 *  @param dict
 *  @param successBlock
 *  @param failedBlock
 */
- (void)requestAddComment:(NSDictionary *)dict
               publicDict:(NSDictionary *)publicDict
             successBlock:(RecommendedSuccessBlock)successBlock
           setFailedBlock:(RecommendedFailedBlock)failedBlock;


/**
 *  个人中心页面
 *  GET
 *
 *  @param dict
 *  @param successBlock
 *  @param failedBlock
 */
- (void)requestGetHobbyUserInfo:(NSDictionary *)dict
                   successBlock:(RecommendedSuccessBlock)successBlock
                 setFailedBlock:(RecommendedFailedBlock)failedBlock;


/**
 *  取消关注
 *  GET
 *
 *  @param dict
 *  @param successBlock
 *  @param failedBlock
 */
- (void)requestGetHobbyUnfollow:(NSDictionary *)dict
                   successBlock:(RecommendedSuccessBlock)successBlock
                 setFailedBlock:(RecommendedFailedBlock)failedBlock;



/**
 *  关注用户
 *  GET
 *
 *  @param dict
 *  @param successBlock
 *  @param failedBlock
 */
- (void)requestGetHobbyFollow:(NSDictionary *)dict
                 successBlock:(RecommendedSuccessBlock)successBlock
               setFailedBlock:(RecommendedFailedBlock)failedBlock;



/**
 *  点赞
 *  GET
 *
 *  @param dict
 *  @param successBlock
 *  @param failedBlock
 */
- (void)requestGetPraise:(NSDictionary *)dict
            successBlock:(RecommendedSuccessBlock)successBlock
          setFailedBlock:(RecommendedFailedBlock)failedBlock;


/**
 *  取消点赞
 *  GET
 *
 *  @param dict
 *  @param successBlock
 *  @param failedBlock
 */
- (void)requestGetUnPraise:(NSDictionary *)dict
              successBlock:(RecommendedSuccessBlock)successBlock
            setFailedBlock:(RecommendedFailedBlock)failedBlock;


/**
 *  发布买家秀
 *  POST
 *
 *  @param dict
 *  @param successBlock
 *  @param failedBlock
 */
- (void)requestSendCommit:(NSDictionary *)dict
               publicDict:(NSDictionary *)publicDict
             successBlock:(RecommendedSuccessBlock)successBlock
           setFailedBlock:(RecommendedFailedBlock)failedBlock;

@end
