//
//  SearchDAO.m
//  Naonao
//
//  Created by Richard Liu on 16/2/23.
//  Copyright © 2016年 深圳市轩腾华兴科技开发有限公司. All rights reserved.
//

#import "SearchDAO.h"
#import "RequestModel.h"


@implementation SearchDAO


// 根据标签搜索商品
- (void)requestSearchTagsWithProduct:(NSDictionary *)dict
                        successBlock:(SearchSuccessBlock)successBlock
                      setFailedBlock:(SearchFailedBlock)failedBlock
{
    
    [[RequestModel shareInstance] requestModelWithAPI:URL_SearchTagsWithProduct
                                              getDict:dict
                                         successBlock:successBlock
                                       setFailedBlock:failedBlock];
}


@end
