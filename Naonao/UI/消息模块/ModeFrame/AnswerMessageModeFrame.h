//
//  AnswerMessageModeFrame.h
//  Naonao
//
//  Created by 刘敏 on 16/8/21.
//  Copyright © 2016年 深圳市轩腾华兴科技开发有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "STMessageCare.h"

@interface AnswerMessageModeFrame : NSObject

@property (nonatomic, strong) STMessageCare *pMode;

@property (nonatomic, assign) CGRect nickNameFrame;
@property (nonatomic, assign) CGRect contentFrame;

@property (nonatomic, assign) CGRect commentsFrame;
@property (nonatomic, assign) CGRect lineVFrame;

@property (nonatomic, assign) CGFloat rowHeight;            //cell高度

@end
