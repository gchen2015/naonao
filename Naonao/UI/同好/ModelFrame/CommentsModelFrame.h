//
//  CommentsModelFrame.h
//  Naonao
//
//  Created by 刘敏 on 16/4/7.
//  Copyright © 2016年 深圳市轩腾华兴科技开发有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DynamicInfo.h"
#import "GoodsInfo.h"
#import "AnswerMode.h"


// 同好中的评论
@interface CommentsModelFrame : NSObject

@property (nonatomic, strong) NSNumber *authorID;           //商品发布者
@property (nonatomic, strong) STCommentData *tData;


@property (nonatomic, assign) CGRect headVFrame;            //头像
@property (nonatomic, assign) CGRect nameLabelFrame;        //用户昵称
@property (nonatomic, assign) CGRect timeFrame;

@property (nonatomic, assign) CGRect contentFrame;          //评论内容


@property (nonatomic, assign) CGFloat rowHeight;            //cell高度

@end


// 商品详情中的评论
@interface CommentsProductFrame : NSObject

@property (nonatomic, strong) CommentInfo *tData;

@property (nonatomic, assign) CGRect headVFrame;            //头像
@property (nonatomic, assign) CGRect nameLabelFrame;        //用户昵称
@property (nonatomic, assign) CGRect timeFrame;
@property (nonatomic, assign) CGRect contentFrame;          //评论内容

@property (nonatomic, assign) CGFloat rowHeight;            //cell高度

@end