//
//  RequestModel.h
//  Artery
//
//  Created by 刘敏 on 14-9-15.
//  Copyright (c) 2014年 深圳市轩腾华兴科技开发有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ResponseHeader.h"


typedef void (^RequestModelBlock)(NSDictionary *result);
typedef void (^RequestFailedBlock)(ResponseHeader *resHead);

@interface RequestModel : NSObject

//静态单例
+ (instancetype)shareInstance;

/********************************************** 异步请求 ********************************/
/**
 *  GET请求
 *
 *  @param api             接口名字
 *  @param getDict         GET数据 （字典）
 *  @param completionBlock 成功返回闭包
 *  @param failedBlock     失败返回闭包
 */
- (void)requestModelWithAPI:(NSString *)api
                    getDict:(NSDictionary *)getDict
               successBlock:(RequestModelBlock)successBlock
             setFailedBlock:(RequestFailedBlock)failedBlock;


/**
 *  POST请求
 *
 *  @param api             接口名字
 *  @param postDict        POST数据（字典）
 *  @param publicDict      公共数据（字典）
 *  @param completionBlock 成功返回闭包
 *  @param failedBlock     失败返回闭包
 */
- (void)requestModelWithAPI:(NSString *)api
                   postDict:(id)postDict
                 publicDict:(NSDictionary *)publicDict
               successBlock:(RequestModelBlock)successBlock
             setFailedBlock:(RequestFailedBlock)failedBlock;


@end
