//
//  LogicResult.m
//  VVShop
//
//  Created by sunlin on 15/5/30.
//  Copyright (c) 2015年 xuantenghuaxing. All rights reserved.
//

#import "LogicResult.h"
#import "ResponseHeader.h"

@implementation LogicResult

//成功
- (void)success
{
    self.stateDes = @"成功";
    self.statusCode = KLogicStatusSuccess;
}

//失败
- (void)failure:(ResponseHeader *)reHeader
{
    if (reHeader) {
        
        self.statusCode = KLogicProcessFailure;

        //token失效
        if([reHeader.status integerValue] == kProtocolCodeInvalidToken)
        {
            self.stateDes = @"登录状态已过期，请重新登录";
        }
        else{
            self.stateDes = reHeader.errorInfo;
        }
    }
    else
    {
        self.stateDes = @"网络连接失败";
        self.statusCode = KLoginNetworkFailure;
    }
}


@end
