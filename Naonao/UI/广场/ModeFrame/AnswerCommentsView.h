//
//  AnswerCommentsView.h
//  Naonao
//
//  Created by 刘敏 on 16/6/30.
//  Copyright © 2016年 深圳市轩腾华兴科技开发有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AnswerModeFrame.h"


@class AnswerCommentsView;

@protocol  AnswerCommentsViewDelegate <NSObject>

@optional

// 点击用户昵称
- (void)answerCommentsView:(AnswerCommentsView *)answerCommentsView WithUserId:(NSNumber *)userId;

//进入评论列表
- (void)answerCommentsView:(AnswerCommentsView *)answerCommentsView answerMode:(AnswerMode *)aMode index:(NSUInteger)mRow;

@end


@interface AnswerCommentsView : UIView

@property (nonatomic, strong) AnswerModeFrame *anFrame;
@property (nonatomic, weak) id<AnswerCommentsViewDelegate> delegate;

@end
