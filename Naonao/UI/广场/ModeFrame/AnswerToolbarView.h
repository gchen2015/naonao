//
//  AnswerToolbarView.h
//  Naonao
//
//  Created by 刘敏 on 16/6/30.
//  Copyright © 2016年 深圳市轩腾华兴科技开发有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AnswerModeFrame.h"

@class AnswerToolbarView;

@protocol AnswerToolbarViewDelegate <NSObject>

@optional

//进入评论列表
- (void)answerToolsbarView:(AnswerToolbarView *)answerToolsbarView answerMode:(AnswerMode *)aMode index:(NSUInteger)mRow;

@end


@interface AnswerToolbarView : UIView

@property (nonatomic, strong) AnswerModeFrame *anFrame;
@property (nonatomic, weak) id <AnswerToolbarViewDelegate>delegate;

@end
