//
//  AnswerFirstModeFrame.h
//  Naonao
//
//  Created by 刘敏 on 16/7/24.
//  Copyright © 2016年 深圳市轩腾华兴科技开发有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SquareModel.h"

@interface AnswerFirstModeFrame : NSObject

@property (nonatomic, strong) SquareModel *sModel;

@property (nonatomic, assign) CGRect contentFrame;
@property (nonatomic, assign) CGRect desFrame;
@property (nonatomic, assign) CGRect timeFrame;
@property (nonatomic, assign) CGRect lineFrame;

@property (nonatomic, assign) CGRect answerFrame;
@property (nonatomic, assign) CGRect careFrame;

@property (nonatomic, assign) CGFloat rowHeight;            //cell高度

@end
