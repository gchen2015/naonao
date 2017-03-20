//
//  DemandDAO.h
//  Naonao
//
//  Created by Richard Liu on 15/12/2.
//  Copyright © 2015年 深圳市轩腾华兴科技开发有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ResponseHeader.h"

typedef void (^DemandSuccessBlock)(NSDictionary *result);
typedef void (^DemandFailedBlock)(ResponseHeader *result);


@interface DemandDAO : NSObject


/**
 *  发布需求接口
 *  GET
 *
 *  @param dict
 *  @param successBlock
 *  @param failedBlock
 */
- (void)requestCreateDemand:(NSDictionary *)dict
               successBlock:(DemandSuccessBlock)successBlock
             setFailedBlock:(DemandFailedBlock)failedBlock;

/**
 *  获取配置数据
 *  GET
 *
 *  @param dict
 *  @param successBlock
 *  @param failedBlock
 */
- (void)requestGetConfigsData:(NSDictionary *)dict
                 successBlock:(DemandSuccessBlock)successBlock
               setFailedBlock:(DemandFailedBlock)failedBlock;

@end


