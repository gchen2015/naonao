//
//  SearchDAO.h
//  Naonao
//
//  Created by Richard Liu on 16/2/23.
//  Copyright © 2016年 深圳市轩腾华兴科技开发有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ResponseHeader.h"

typedef void (^SearchSuccessBlock)(NSDictionary *result);
typedef void (^SearchFailedBlock)(ResponseHeader *result);


@interface SearchDAO : NSObject


/**
 *  根据标签搜索商品
 *  GET
 *
 *  @param dict
 *  @param successBlock
 *  @param failedBlock
 */
- (void)requestSearchTagsWithProduct:(NSDictionary *)dict
                        successBlock:(SearchSuccessBlock)successBlock
                      setFailedBlock:(SearchFailedBlock)failedBlock;

@end
