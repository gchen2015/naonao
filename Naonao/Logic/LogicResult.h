//
//  LogicResult.h
//  VVShop
//
//  Created by sunlin on 15/5/30.
//  Copyright (c) 2015年 xuantenghuaxing. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ResponseHeader;

@interface LogicResult : NSObject

@property (nonatomic, strong) NSString* stateDes;           //结果说明
@property (nonatomic, assign) NSUInteger statusCode;        //状态码

@property (nonatomic, strong) id mObject;                   //储存解析之后的数据
@property (nonatomic, strong) id otherObject;               //储存解析之后的数据

//成功
- (void)success;

//失败
- (void)failure:(ResponseHeader *)reHeader;

@end

