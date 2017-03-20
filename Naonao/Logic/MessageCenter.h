//
//  MessageCenter.h
//  Naonao
//
//  Created by 刘敏 on 16/5/10.
//  Copyright © 2016年 深圳市轩腾华兴科技开发有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LogicResult.h"


typedef void (^MessageCenterCallback)(LogicResult* result);


@interface MessageCenter : NSObject


+ (instancetype)sharedInstance;

- (void)jumpToMesage;

// 赞
- (void)getMessageCenterWithPraise:(NSDictionary *)dict withCallback:(MessageCenterCallback)results;

// 混合消息
- (void)getMessageCenterWithMix:(NSDictionary *)dict withCallback:(MessageCenterCallback)results;

// 读取消息回执
- (void)getMessageCenterWithReadMessage:(NSDictionary *)dict withCallback:(MessageCenterCallback)results;

// 查看未读消息数目
- (void)getMessageCenterWithUnReadMessage:(NSDictionary *)dict withCallback:(MessageCenterCallback)results;

// 获取答案评论消息
- (void)getAnswerCommentNotification:(NSDictionary *)dict withCallback:(MessageCenterCallback)results;

@end
