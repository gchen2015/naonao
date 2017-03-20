//
//  MagazineLogic.h
//  Naonao
//
//  Created by Richard Liu on 15/12/1.
//  Copyright © 2015年 深圳市轩腾华兴科技开发有限公司. All rights reserved.
//  处理挠志的相关逻辑

#import <Foundation/Foundation.h>
#import "LogicParam.h"
#import "LogicResult.h"


typedef void (^MagazineLogicCommonCallback)(LogicResult* result);

@interface MagazineLogic : NSObject


+ (instancetype)sharedInstance;

// 获取播报广告信息（缓存）
- (NSArray *)readHomeBanner;

// 获取播报资讯（缓存）
- (NSArray *)getHomeInfoArray;

// 获取播报品牌（缓存）
- (NSArray *)getHomeBrandArray;

// 获取播报舵主（缓存）
- (NSArray *)getHomeDuozhuArray;

// 获取banner列表
- (void)getBannerList:(NSDictionary *)param withCallback:(MagazineLogicCommonCallback)results;

// 获取舵主推荐列表
- (void)getRecommandUsers:(NSDictionary *)param withCallback:(MagazineLogicCommonCallback)results;

//获取杂志列表
- (void)magazineList:(NSDictionary *)param withCallback:(MagazineLogicCommonCallback)results;

//获取品牌详情
- (void)magazineDetails:(NSDictionary *)param withCallback:(MagazineLogicCommonCallback)results;

//喜欢一个单品
- (void)favorProduct:(NSDictionary *)param withCallback:(MagazineLogicCommonCallback)results;

//不喜欢一个单品
- (void)unFavorProduct:(NSDictionary *)param withCallback:(MagazineLogicCommonCallback)results;

//喜欢的单品列表
- (void)favoriteGoodsList:(NSDictionary *)param withCallback:(MagazineLogicCommonCallback)results;

//不喜欢专题（播报）
- (void)unFavorArticle:(NSDictionary *)param withCallback:(MagazineLogicCommonCallback)results;

//喜欢专题（播报）
- (void)favorArticle:(NSDictionary *)param withCallback:(MagazineLogicCommonCallback)results;

//喜欢专题列表（播报）
- (void)favorArticleList:(NSDictionary *)param withCallback:(MagazineLogicCommonCallback)results;

// 获取品牌列表（播报）
- (void)getBrandsList:(NSDictionary *)param withCallback:(MagazineLogicCommonCallback)results;


@end
