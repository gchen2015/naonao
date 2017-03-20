//
//  DemandDAO.m
//  Naonao
//
//  Created by Richard Liu on 15/12/2.
//  Copyright © 2015年 深圳市轩腾华兴科技开发有限公司. All rights reserved.
//

#import "DemandDAO.h"
#import "RequestModel.h"


@implementation DemandDAO

// 发布需求接口
- (void)requestCreateDemand:(NSDictionary *)dict
               successBlock:(DemandSuccessBlock)successBlock
             setFailedBlock:(DemandFailedBlock)failedBlock
{
    [[RequestModel shareInstance] requestModelWithAPI:URL_UserPublish
                                              getDict:dict
                                         successBlock:successBlock
                                       setFailedBlock:failedBlock];
}


// 获取配置数据
- (void)requestGetConfigsData:(NSDictionary *)dict
                 successBlock:(DemandSuccessBlock)successBlock
               setFailedBlock:(DemandFailedBlock)failedBlock
{
    [[RequestModel shareInstance] requestModelWithAPI:URL_GetConfigs
                                              getDict:dict
                                         successBlock:successBlock
                                       setFailedBlock:failedBlock];
}


@end
