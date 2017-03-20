//
//  DemandLogic.m
//  Naonao
//
//  Created by Richard Liu on 15/12/2.
//  Copyright © 2015年 深圳市轩腾华兴科技开发有限公司. All rights reserved.
//

#import "DemandLogic.h"
#import "MTLModel.h"
#import "DemandDAO.h"
#import "SquareModel.h"

@interface DemandLogic ()

@end


@implementation DemandLogic

+ (instancetype)sharedInstance {
    
    static dispatch_once_t onceToken;
    static DemandLogic* instance = nil;
    dispatch_once(&onceToken, ^{
        instance = [[DemandLogic alloc] init];
    });
    return instance;
}

- (id)init {
    if (self = [super init]) {
        //获取DemandMenu（获取系统数据）
        _demandMenu = [NSKeyedUnarchiver unarchiveObjectWithFile:[Units getProfilePath:kDemandMenu]];
        
        //读取本地配置文件（本地数据）
        NSString *path = [[NSBundle mainBundle] pathForResource:kRequirements ofType:@"plist"];
        
        //品类
        _categoryArray = [MTLJSONAdapter modelsOfClass:[sceneModel class]
                                         fromJSONArray:[[[NSDictionary alloc] initWithContentsOfFile:path] objectForKey:@"category"]
                                                 error:nil];
        //场景
        _sceneArray = [MTLJSONAdapter modelsOfClass:[sceneModel class]
                                      fromJSONArray:[[[NSDictionary alloc] initWithContentsOfFile:path] objectForKey:@"scene"]
                                              error:nil];
        
        //风格
        _styleArray = [MTLJSONAdapter modelsOfClass:[sceneModel class]
                                      fromJSONArray:[[[NSDictionary alloc] initWithContentsOfFile:path] objectForKey:@"style"]
                                              error:nil];
        
        
        //初始化
        _publishRequirement = [[Requirement alloc] init];
    }
    return self;
}


- (DemandMenu *)getDemandMenu
{
    return _demandMenu;
}

// 买家发布需求
- (Requirement*)getRequirementToPublish {
    return _publishRequirement;
}

- (void)setRequirementToPublish:(Requirement*)requirement {
    _publishRequirement = requirement;
}


// 发布需求
- (void)publishRequirement:(Requirement *)requirement withCallback:(DemandLogicCommonCallback)results
{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithCapacity:0];
    //发布的内容
    [dic setObject:requirement.desc forKey:@"content"];
    [dic setObject:requirement.sceneID forKey:@"scene"];
    [dic setObject:requirement.styleID forKey:@"style"];
    [dic setObject:requirement.categoryID forKey:@"category"];
    

    DemandDAO *dao = [[DemandDAO alloc] init];
    LogicResult* cb = [[LogicResult alloc] init];
    
    [dao requestCreateDemand:dic successBlock:^(NSDictionary *result) {
        [cb success];
        results(cb);
        [self cleanRequirement];
        
    } setFailedBlock:^(ResponseHeader *result) {
        [cb failure:result];
        results(cb);
    }];
}


// 获取发布需求的相关数据
- (void)getConfigsData{
    
    if (![UserLogic sharedInstance].user.basic.userId) {
        [theAppDelegate popLoginView];
        return;
    }
    
    DemandDAO *dao = [[DemandDAO alloc] init];
    [dao requestGetConfigsData:nil successBlock:^(NSDictionary *result) {
        DemandMenu *demandMenu = [MTLJSONAdapter modelOfClass:[DemandMenu class] fromJSONDictionary:result error:nil];
        
        if ([self saveDemandMenuToFile:demandMenu]) {
            CLog(@"数据保存成功");
        }
        
    } setFailedBlock:^(ResponseHeader *result) {
        
    }];
}


// 缓存配置信息到本地
- (BOOL)saveDemandMenuToFile:(DemandMenu*)demandMenu
{
    _demandMenu = demandMenu;
    return [NSKeyedArchiver archiveRootObject:_demandMenu toFile:[Units getProfilePath:kDemandMenu]];
}


//清除发布数据（取消发布和发布成功都应该清除发布数据）
- (void)cleanRequirement
{
    _publishRequirement.categoryID = nil;
    _publishRequirement.sceneID = nil;
    _publishRequirement.styleID = nil;
    _publishRequirement.desc = nil;
}

@end
