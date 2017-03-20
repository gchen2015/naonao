//
//  AnswerModeFrame.h
//  Naonao
//
//  Created by 刘敏 on 16/6/3.
//  Copyright © 2016年 深圳市轩腾华兴科技开发有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AnswerMode.h"


@interface AnswerModeFrame : NSObject

@property (nonatomic, strong) AnswerMode *aMode;

/********************** 顶部 *****************************/
@property (nonatomic, assign) CGRect aboveFrame;

@property (nonatomic, assign) CGRect headFrame;         //头像
@property (nonatomic, assign) CGRect nikeFrame;         //昵称
@property (nonatomic, assign) CGRect tipFrame;          //身份标示
@property (nonatomic, assign) CGRect similarFrame;

/********************** 中部 *****************************/
@property (nonatomic, assign) CGRect centerFrame;

@property (nonatomic, assign) CGRect flagLFrame;

@property (nonatomic, assign) CGRect picFrame;

/********************** 推荐的商品 *****************************/
@property (nonatomic, assign) CGRect bottomFrame;

@property (nonatomic, assign) CGRect garyFrame;
@property (nonatomic, assign) CGRect goodsFrame;
@property (nonatomic, assign) CGRect goodsNFrame;
@property (nonatomic, assign) CGRect brandFrame;
@property (nonatomic, assign) CGRect priceFrame;
@property (nonatomic, assign) CGRect cartFrame;


/********************** 评论区 *****************************/
@property (nonatomic, assign) CGRect comFrame;              //评论区
@property (nonatomic, assign) CGRect commentLabelFrame;     //评论详情
@property (nonatomic, assign) CGRect lineViewFrame;         //分割线


/********************** 底部菜单 *****************************/
@property (nonatomic, assign) CGRect toolsFrame;            //默认45
@property (nonatomic, assign) CGRect favLabelFrame;
@property (nonatomic, assign) CGRect commentButtonFrame;


@property (nonatomic, assign) NSUInteger index;

@property (nonatomic, assign) CGFloat rowHeight;            //cell高度

@end
