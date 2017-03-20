//
//  AddressDAO.h
//  Naonao
//
//  Created by 刘敏 on 16/3/16.
//  Copyright © 2016年 深圳市轩腾华兴科技开发有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ResponseHeader.h"

typedef void (^AddressSuccessBlock)(NSDictionary *result);
typedef void (^AddressFailedBlock)(ResponseHeader *result);

@interface AddressDAO : NSObject

/**
 *  获取收货地址列表
 *  GET
 *
 *  @param dict
 *  @param successBlock
 *  @param failedBlock
 */
- (void)requestGetAddressList:(NSDictionary *)dict
                 successBlock:(AddressSuccessBlock)successBlock
               setFailedBlock:(AddressFailedBlock)failedBlock;



/**
 *  添加新的地址
 *  POST
 *
 *  @param dict
 *  @param successBlock
 *  @param failedBlock
 */
- (void)requestAddAddress:(NSDictionary *)dict
               publicDict:(NSDictionary *)publicDict
             successBlock:(AddressSuccessBlock)successBlock
           setFailedBlock:(AddressFailedBlock)failedBlock;


/**
 *  删除地址
 *  GET
 *
 *  @param dict
 *  @param successBlock
 *  @param failedBlock
 */
- (void)requestDeleteAddress:(NSDictionary *)dict
             successBlock:(AddressSuccessBlock)successBlock
           setFailedBlock:(AddressFailedBlock)failedBlock;


/**
*  更新收货地址
*  POST
*
*  @param dict
*  @param successBlock
*  @param failedBlock
*/
- (void)requestUpdateAddress:(NSDictionary *)dict
                  publicDict:(NSDictionary *)publicDict
                successBlock:(AddressSuccessBlock)successBlock
              setFailedBlock:(AddressFailedBlock)failedBlock;



/**
 *  设置默认收货地址
 *  GET
 *
 *  @param dict
 *  @param successBlock
 *  @param failedBlock
 */
- (void)requestSetDefaultAddress:(NSDictionary *)dict
                    successBlock:(AddressSuccessBlock)successBlock
                  setFailedBlock:(AddressFailedBlock)failedBlock;


/**
 *  设置默认收货地址
 *  GET
 *
 *  @param dict
 *  @param successBlock
 *  @param failedBlock
 */
- (void)requestGetDefaultAddress:(NSDictionary *)dict
                    successBlock:(AddressSuccessBlock)successBlock
                  setFailedBlock:(AddressFailedBlock)failedBlock;


@end
