//
//  MagazineLogic.m
//  Naonao
//
//  Created by Richard Liu on 15/12/1.
//  Copyright © 2015年 深圳市轩腾华兴科技开发有限公司. All rights reserved.
//

#import "MagazineLogic.h"
#import "MagazineDAO.h"
#import "MagazineInfo.h"
#import "MagazineBData.h"
#import "RecommendedDAO.h"
#import "FavGoodsModel.h"
#import "SearchDAO.h"
#import "SearchGoodsInfo.h"
#import "LoginDAO.h"
#import "RudderModeFrame.h"



@implementation MagazineLogic

+ (instancetype)sharedInstance {
    
    static dispatch_once_t onceToken;
    static MagazineLogic* instance = nil;
    dispatch_once(&onceToken, ^{
        instance = [[MagazineLogic alloc] init];
    });
    return instance;
}

#pragma mark - 读取本地存档数据
// 获取本地挠志信息
- (NSArray *)readHomeBanner;
{
    return [NSKeyedUnarchiver unarchiveObjectWithFile:[Units getProfilePath:kHomeBanner]];
}

// 获取播报资讯
- (NSArray *)getHomeInfoArray
{
    return [NSKeyedUnarchiver unarchiveObjectWithFile:[Units getProfilePath:kHomeInfo]];
}

// 获取播报品牌（缓存）
- (NSArray *)getHomeBrandArray {
    return [NSKeyedUnarchiver unarchiveObjectWithFile:[Units getProfilePath:kHomeBrand]];
}

// 获取播报舵主（缓存）
- (NSArray *)getHomeDuozhuArray
{
    NSArray *array = [NSKeyedUnarchiver unarchiveObjectWithFile:[Units getProfilePath:kHomeDuozhu]];
    
    NSMutableArray *tempA = [NSMutableArray arrayWithCapacity:array.count];
    
    for (STDuozhu *item in array) {
        RudderModeFrame *modeFrame = [[RudderModeFrame alloc] init];
        modeFrame.sModel = item;
        modeFrame.sModel.contract = [NSNumber numberWithBool:YES];
        [tempA addObject:modeFrame];
    }
    
    return tempA;
}


// 获取banner列表
- (void)getBannerList:(NSDictionary *)param withCallback:(MagazineLogicCommonCallback)results {
    MagazineDAO *dao = [[MagazineDAO alloc] init];
    LogicResult* cb = [[LogicResult alloc] init];
    [dao requestBannerList:param successBlock:^(NSDictionary *result) {
        [cb success];
        //传递解析的数据
        NSArray *tempA = [MTLJSONAdapter modelsOfClass:[STBanInfo class] fromJSONArray:(NSArray *)result error:nil];
        cb.mObject = tempA;
        
        if ([self saveHomeBannerToFile:tempA]){
            //储存banner信息
            CLog(@"保存成功");
        }
        
        results(cb);
        
    } setFailedBlock:^(ResponseHeader *result) {
        [cb failure:result];
        results(cb);
    }];
}

// 获取舵主推荐列表
- (void)getRecommandUsers:(NSDictionary *)param withCallback:(MagazineLogicCommonCallback)results{
    MagazineDAO *dao = [[MagazineDAO alloc] init];
    LogicResult* cb = [[LogicResult alloc] init];
    
    [dao requestRecommandUsers:param successBlock:^(NSDictionary *result) {
        [cb success];
        //传递解析的数据
        NSArray *tempA = [MTLJSONAdapter modelsOfClass:[STDuozhu class] fromJSONArray:(NSArray *)result error:nil];
        if ([self saveHomeDuozhuToFile:tempA]) {
            CLog(@"save success");
        }
        
        NSMutableArray *array = [NSMutableArray arrayWithCapacity:tempA.count];
        for (STDuozhu *item in tempA) {
            RudderModeFrame *modeFrame = [[RudderModeFrame alloc] init];
            modeFrame.sModel = item;
            modeFrame.sModel.contract = [NSNumber numberWithBool:YES];
            [array addObject:modeFrame];
        }
        
        cb.mObject = array;
        results(cb);
        
    } setFailedBlock:^(ResponseHeader *result) {
        [cb failure:result];
        results(cb);
    }];
}


//获取杂志列表
- (void)magazineList:(NSDictionary *)param withCallback:(MagazineLogicCommonCallback)results {
    
    MagazineDAO *dao = [[MagazineDAO alloc] init];
    LogicResult* cb = [[LogicResult alloc] init];
    
    [dao requestMagazineList:param successBlock:^(NSDictionary *result) {
        [cb success];
        //传递解析的数据
        cb.mObject = [MTLJSONAdapter modelsOfClass:[MagazineInfo class] fromJSONArray:(NSArray *)result error:nil];
        if ([self saveHomeInfoListToFile:(NSArray *)cb.mObject]){
            CLog(@"save success");
        }
        results(cb);
        
    } setFailedBlock:^(ResponseHeader *result) {
        [cb failure:result];
        results(cb);
    }];
}

//获取品牌详情
- (void)magazineDetails:(NSDictionary *)param
           withCallback:(MagazineLogicCommonCallback)results
{
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithDictionary:param];
    
    MagazineDAO *dao = [[MagazineDAO alloc] init];
    LogicResult* cb = [[LogicResult alloc] init];
    
    [dao requestMagazineContent:dic successBlock:^(NSDictionary *result) {
        
        [cb success];
        cb.mObject = [MTLJSONAdapter modelOfClass:[STBrand class] fromJSONDictionary:result error:nil];
        results(cb);
        
    } setFailedBlock:^(ResponseHeader *result) {
        [cb failure:result];
        results(cb);
    }];
}

//喜欢一个商品
- (void)favorProduct:(NSDictionary *)param withCallback:(MagazineLogicCommonCallback)results
{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithDictionary:param];
    
    if (![UserLogic sharedInstance].user.basic.userId) {
        [theAppDelegate popLoginView];
        return;
    }
    
    MagazineDAO *dao = [[MagazineDAO alloc] init];
    LogicResult* cb = [[LogicResult alloc] init];
    
    [dao requestUserFavorProduct:dic successBlock:^(NSDictionary *result) {
        [cb success];
        results(cb);
    } setFailedBlock:^(ResponseHeader *result) {
        [cb failure:result];
        results(cb);
    }]; 
}

//不喜欢一个商品
- (void)unFavorProduct:(NSDictionary *)param withCallback:(MagazineLogicCommonCallback)results
{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithDictionary:param];
    
    if (![UserLogic sharedInstance].user.basic.userId) {
        [theAppDelegate popLoginView];
        return;
    }
    
    MagazineDAO *dao = [[MagazineDAO alloc] init];
    LogicResult* cb = [[LogicResult alloc] init];
    
    [dao requestUserUnFavorProduct:dic successBlock:^(NSDictionary *result) {
        [cb success];
        results(cb);
    } setFailedBlock:^(ResponseHeader *result) {
        [cb failure:result];
        results(cb);
    }];
}


//用户喜欢的商品列表
- (void)favoriteGoodsList:(NSDictionary *)param withCallback:(MagazineLogicCommonCallback)results
{
    MagazineDAO *dao = [[MagazineDAO alloc] init];
    LogicResult* cb = [[LogicResult alloc] init];
    
    [dao requestUserLikeProducts:param successBlock:^(NSDictionary *result) {
        cb.mObject = [MTLJSONAdapter modelsOfClass:[FavGoodsModel class] fromJSONArray:[result objectForKey:@"products"] error:nil];
        [cb success];
        results(cb);
    } setFailedBlock:^(ResponseHeader *result) {
        [cb failure:result];
        results(cb);
    }];
}


//喜欢专题（播报）
- (void)favorArticle:(NSDictionary *)param withCallback:(MagazineLogicCommonCallback)results
{
    MagazineDAO *dao = [[MagazineDAO alloc] init];
    LogicResult* cb = [[LogicResult alloc] init];
    
    [dao requestLikeArticle:param successBlock:^(NSDictionary *result) {
        [cb success];
        results(cb);
    } setFailedBlock:^(ResponseHeader *result) {
        [cb failure:result];
        results(cb);
    }];
}

//不喜欢专题（播报）
- (void)unFavorArticle:(NSDictionary *)param withCallback:(MagazineLogicCommonCallback)results
{
    MagazineDAO *dao = [[MagazineDAO alloc] init];
    LogicResult* cb = [[LogicResult alloc] init];
    
    [dao requestDislikeArticle:param successBlock:^(NSDictionary *result) {
        [cb success];
        results(cb);
    } setFailedBlock:^(ResponseHeader *result) {
        [cb failure:result];
        results(cb);
    }];
}


//喜欢专题列表（播报）
- (void)favorArticleList:(NSDictionary *)param withCallback:(MagazineLogicCommonCallback)results
{
    MagazineDAO *dao = [[MagazineDAO alloc] init];
    LogicResult* cb = [[LogicResult alloc] init];
    
    [dao requestLikeArticleList:param successBlock:^(NSDictionary *result) {
        [cb success];
        //传递解析的数据
        cb.mObject = [MTLJSONAdapter modelsOfClass:[MagazineInfo class] fromJSONArray:(NSArray *)result error:nil];
        results(cb);
    } setFailedBlock:^(ResponseHeader *result) {
        [cb failure:result];
        results(cb);
    }];
}

// 获取品牌列表（播报）
- (void)getBrandsList:(NSDictionary *)param withCallback:(MagazineLogicCommonCallback)results
{
    MagazineDAO *dao = [[MagazineDAO alloc] init];
    LogicResult* cb = [[LogicResult alloc] init];
    
    [dao requestBrandsList:param successBlock:^(NSDictionary *result) {
        [cb success];
        //传递解析的数据
        cb.mObject = [MTLJSONAdapter modelsOfClass:[STBrand class] fromJSONArray:(NSArray *)result error:nil];
        if ([self saveHomeBrandToFile:(NSArray *)cb.mObject]) {
            CLog(@"save success");
        }
        results(cb);
        
    } setFailedBlock:^(ResponseHeader *result) {
        [cb failure:result];
        results(cb);
    }];
}

// 缓存banner信息
- (BOOL)saveHomeBannerToFile:(NSArray *)array
{
    return [NSKeyedArchiver archiveRootObject:array toFile:[Units getProfilePath:kHomeBanner]];
}

// 缓存播报资讯
- (BOOL)saveHomeInfoListToFile:(NSArray *)array
{
    return [NSKeyedArchiver archiveRootObject:array toFile:[Units getProfilePath:kHomeInfo]];
}


// 播报品牌（缓存）
- (BOOL)saveHomeBrandToFile:(NSArray *)array{
    return [NSKeyedArchiver archiveRootObject:array toFile:[Units getProfilePath:kHomeBrand]];
}

// 播报舵主（缓存）
- (BOOL)saveHomeDuozhuToFile:(NSArray *)array
{
    return [NSKeyedArchiver archiveRootObject:array toFile:[Units getProfilePath:kHomeDuozhu]];
}


@end
