//
//  MessageCenter.m
//  Naonao
//
//  Created by 刘敏 on 16/5/10.
//  Copyright © 2016年 深圳市轩腾华兴科技开发有限公司. All rights reserved.
//

#import "MessageCenter.h"
#import "MessageCenterDAO.h"
#import "STMessagePraise.h"
#import "PraiseMessageModeFrame.h"
#import "AnswerMessageModeFrame.h"


@implementation MessageCenter


+ (instancetype)sharedInstance
{
    static dispatch_once_t onceToken;
    static MessageCenter* instance = nil;
    dispatch_once(&onceToken, ^{
        instance = [[MessageCenter alloc] init];
    });
    return instance;
}

- (void)jumpToMesage
{
    theAppDelegate.tabBarController.selectedIndex = 2;
}

// 赞
- (void)getMessageCenterWithPraise:(NSDictionary *)dict withCallback:(MessageCenterCallback)results
{
    MessageCenterDAO *dao = [[MessageCenterDAO alloc] init];
    LogicResult* cb = [[LogicResult alloc] init];
    
    [dao requestGetPraiseList:dict successBlock:^(NSDictionary *result) {
        [cb success];
        if (result.count > 0) {
            
            NSArray *tA = [MTLJSONAdapter modelsOfClass:[STMessagePraise class] fromJSONArray:(NSArray *)result error:nil];
            NSMutableArray *temp = [NSMutableArray arrayWithCapacity:tA.count];
            
            for (STMessagePraise *mode in tA) {
                PraiseMessageModeFrame *modeFrame = [[PraiseMessageModeFrame alloc] init];
                modeFrame.pMode = mode;
                [temp addObject:modeFrame];
            }
            
            cb.mObject = temp;
        }
        results(cb);
        
    } setFailedBlock:^(ResponseHeader *result) {
        [cb failure:result];
        results(cb);
    }];
}

// 混合消息
- (void)getMessageCenterWithMix:(NSDictionary *)dict withCallback:(MessageCenterCallback)results
{
    MessageCenterDAO *dao = [[MessageCenterDAO alloc] init];
    LogicResult* cb = [[LogicResult alloc] init];
    
    [dao requestGetNotificationMix:dict successBlock:^(NSDictionary *result) {
        [cb success];
        if (result.count > 0) {
            cb.mObject = [self parsingMessageData:(NSArray *)result];
        }
        results(cb);
        
    } setFailedBlock:^(ResponseHeader *result) {
        [cb failure:result];
        results(cb);
    }];
}


- (NSArray *)parsingMessageData:(NSArray *)array {
    NSMutableArray *tempA = [NSMutableArray arrayWithCapacity:array.count];
    
    for (NSDictionary *item in array) {
        
        NSUInteger type = [[item objectForKey:@"type"] integerValue];
        
        switch (type) {
            case MSG_TYPE_SYS:
            {
                // 系统通知
                SYSMessage *pMode = [MTLJSONAdapter modelOfClass:[SYSMessage class] fromJSONDictionary:item error:nil];
                [tempA addObject:pMode];
            }
                break;
                
            case MSG_TYPE_ANSWER:{
                // 回答了提问
                AnswerMessageModeFrame *modeFrame = [[AnswerMessageModeFrame alloc] init];
                modeFrame.pMode = [MTLJSONAdapter modelOfClass:[STMessageCare class] fromJSONDictionary:item error:nil];
                [tempA addObject:modeFrame];
            }
                break;
                
            case MSG_TYPE_CARE:
            {
                // 关心了问题
                AnswerMessageModeFrame *modeFrame = [[AnswerMessageModeFrame alloc] init];
                modeFrame.pMode = [MTLJSONAdapter modelOfClass:[STMessageCare class] fromJSONDictionary:item error:nil];
                [tempA addObject:modeFrame];
            }
                break;
                
            case MSG_TYPE_ANSWER_COMMENT:
            {
                //答案的评论
                PraiseMessageModeFrame *modeFrame = [[PraiseMessageModeFrame alloc] init];
                modeFrame.pMode = [MTLJSONAdapter modelOfClass:[STMessagePraise class] fromJSONDictionary:item error:nil];
                [tempA addObject:modeFrame];
            }
                
                break;
                
            default:
                break;
        }
    }
    
    return tempA;
}


// 读取消息回执
- (void)getMessageCenterWithReadMessage:(NSDictionary *)dict withCallback:(MessageCenterCallback)results
{
    MessageCenterDAO *dao = [[MessageCenterDAO alloc] init];
    LogicResult* cb = [[LogicResult alloc] init];
    
    [dao requestGetReadNotification:dict successBlock:^(NSDictionary *result) {
        [cb success];
        results(cb);
        
    } setFailedBlock:^(ResponseHeader *result) {
        [cb failure:result];
        results(cb);
    }];
}

// 查看未读消息数目
- (void)getMessageCenterWithUnReadMessage:(NSDictionary *)dict withCallback:(MessageCenterCallback)results
{
    MessageCenterDAO *dao = [[MessageCenterDAO alloc] init];
    LogicResult* cb = [[LogicResult alloc] init];
    
    [dao requestUnReadMsgNotification:dict successBlock:^(NSDictionary *result) {
        [cb success];
        if (result.count > 0) {
            cb.mObject = [MTLJSONAdapter modelOfClass:[MixMode class] fromJSONDictionary:result error:nil];
        }
        results(cb);
        
    } setFailedBlock:^(ResponseHeader *result) {
        [cb failure:result];
        results(cb);
    }];
}

// 获取答案评论消息
- (void)getAnswerCommentNotification:(NSDictionary *)dict withCallback:(MessageCenterCallback)results
{
    MessageCenterDAO *dao = [[MessageCenterDAO alloc] init];
    LogicResult* cb = [[LogicResult alloc] init];
    
    [dao requestAnswerCommentNotification:dict successBlock:^(NSDictionary *result) {
        [cb success];
        if (result.count > 0) {
//            cb.mObject = [MTLJSONAdapter modelsOfClass:[STMModel class] fromJSONArray:(NSArray *)result error:nil];
        }
        results(cb);
        
    } setFailedBlock:^(ResponseHeader *result) {
        [cb failure:result];
        results(cb);
    }];
    
}

@end
