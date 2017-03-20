//
//  SquareLogic.h
//  Naonao
//
//  Created by 刘敏 on 16/5/31.
//  Copyright © 2016年 深圳市轩腾华兴科技开发有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LogicResult.h"
#import "SquareModel.h"
#import "TagsMode.h"
#import "StorageAnswer.h"

typedef void (^SquareLogicCommonCallback)(LogicResult* result);

@class FilterData;
@interface SquareLogic : NSObject

@property (nonatomic, strong) GoodsMode *gMode;                         //（回答问题）选取的商品
@property (nonatomic, strong) NSMutableArray *selectImages;             //（回答问题）选取的图片
@property (nonatomic, strong) StorageAnswer *sT;

@property (nonatomic, strong) FilterData *fData;

+ (instancetype)sharedInstance;

// 临时存储发布数据
- (void)temporaryStorageAnswerInfo:(StorageAnswer *)sT;

- (NSArray *)readSquareBanner;

- (NSArray *)readSquareList;

//添加图片
- (void)addselectImages:(NSArray *)array;

//获取问答广场
- (void)getSquareList:(NSDictionary *)dict withCallback:(SquareLogicCommonCallback)results;

// 获取机器自动回复的内容
- (void)getPublishRobotAnswerList:(NSDictionary *)dic withCallback:(SquareLogicCommonCallback)results;

// 查看用户答案列表(真实的舵主回复)
- (void)getAnswerList:(NSDictionary *)dic withCallback:(SquareLogicCommonCallback)results;

// 关心问题
- (void)getCareAnswer:(NSDictionary *)dic withCallback:(SquareLogicCommonCallback)results;

// 不关心问题
- (void)getUnCareAnswer:(NSDictionary *)dic withCallback:(SquareLogicCommonCallback)results;

// 通过关键词搜索商品
- (void)searchKeywordWithGoods:(NSDictionary *)param withCallback:(SquareLogicCommonCallback)results;

// 我的问题列表
- (void)getMyOrders:(NSDictionary *)param withCallback:(SquareLogicCommonCallback)results;

// 获取单条问题
- (void)getSquareBasic:(NSDictionary *)dict withCallback:(SquareLogicCommonCallback)results;

// 获取用户答案的评论
- (void)getAnswerComments:(NSDictionary *)param withCallback:(SquareLogicCommonCallback)results;

// 添加答案评论
- (void)addAnswerComment:(NSDictionary *)param withCallback:(SquareLogicCommonCallback)results;

// 用户删除需求
- (void)getDeleteOrder:(NSDictionary *)dict withCallback:(SquareLogicCommonCallback)results;

// 点赞
- (void)getShowPraise:(NSDictionary *)dict withCallback:(SquareLogicCommonCallback)results;

// 取消点赞
- (void)getShowUnPraise:(NSDictionary *)dict withCallback:(SquareLogicCommonCallback)results;

// 删除评论的答案
- (void)deleteAnswerComment:(NSDictionary *)dict withCallback:(SquareLogicCommonCallback)results;

// 获取我收藏的问题列表
- (void)getCareAnswers:(NSDictionary *)dict withCallback:(SquareLogicCommonCallback)results;

// 删除我的回答
- (void)deleteSquareAnswer:(NSDictionary *)dict withCallback:(SquareLogicCommonCallback)results;


@end


@interface FilterData : NSObject

@property (nonatomic, strong) NSNumber* category;    //品类
@property (nonatomic, strong) NSNumber* scene;       //场景
@property (nonatomic, strong) NSNumber* style;       //风格

@end
