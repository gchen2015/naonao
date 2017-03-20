//
//  AddressDAO.m
//  Naonao
//
//  Created by 刘敏 on 16/3/16.
//  Copyright © 2016年 深圳市轩腾华兴科技开发有限公司. All rights reserved.
//

#import "AddressDAO.h"
#import "RequestModel.h"

@implementation AddressDAO

// 获取收货地址列表
- (void)requestGetAddressList:(NSDictionary *)dict
                 successBlock:(AddressSuccessBlock)successBlock
               setFailedBlock:(AddressFailedBlock)failedBlock
{
    [[RequestModel shareInstance] requestModelWithAPI:URL_GetAddressList
                                              getDict:dict
                                         successBlock:successBlock
                                       setFailedBlock:failedBlock];
}

// 添加新的地址
- (void)requestAddAddress:(NSDictionary *)dict
               publicDict:(NSDictionary *)publicDict
             successBlock:(AddressSuccessBlock)successBlock
           setFailedBlock:(AddressFailedBlock)failedBlock
{
    [[RequestModel shareInstance] requestModelWithAPI:URL_AddAddress
                                              postDict:dict
                                           publicDict:publicDict
                                         successBlock:successBlock
                                       setFailedBlock:failedBlock];
}

// 删除地址
- (void)requestDeleteAddress:(NSDictionary *)dict
                successBlock:(AddressSuccessBlock)successBlock
              setFailedBlock:(AddressFailedBlock)failedBlock
{
    [[RequestModel shareInstance] requestModelWithAPI:URL_delete_DeleteAddress
                                              getDict:dict
                                         successBlock:successBlock
                                       setFailedBlock:failedBlock];
}


// 更新收货地址
- (void)requestUpdateAddress:(NSDictionary *)dict
                  publicDict:(NSDictionary *)publicDict
                successBlock:(AddressSuccessBlock)successBlock
              setFailedBlock:(AddressFailedBlock)failedBlock
{
    [[RequestModel shareInstance] requestModelWithAPI:URL_UpdateAddress
                                              postDict:dict
                                           publicDict:publicDict
                                         successBlock:successBlock
                                       setFailedBlock:failedBlock];
}


// 设置默认收货地址
- (void)requestSetDefaultAddress:(NSDictionary *)dict
                    successBlock:(AddressSuccessBlock)successBlock
                  setFailedBlock:(AddressFailedBlock)failedBlock
{
    
    [[RequestModel shareInstance] requestModelWithAPI:URL_SetDefaultAddress
                                              getDict:dict
                                         successBlock:successBlock
                                       setFailedBlock:failedBlock];
}


// 设置默认收货地址
- (void)requestGetDefaultAddress:(NSDictionary *)dict
                    successBlock:(AddressSuccessBlock)successBlock
                  setFailedBlock:(AddressFailedBlock)failedBlock
{
    [[RequestModel shareInstance] requestModelWithAPI:URL_GetDefaultAddress
                                              getDict:dict
                                         successBlock:successBlock
                                       setFailedBlock:failedBlock];
}


@end
