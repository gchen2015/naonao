//
//  DemandLogic.h
//  Naonao
//
//  Created by Richard Liu on 15/12/2.
//  Copyright © 2015年 深圳市轩腾华兴科技开发有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LogicParam.h"
#import "LogicResult.h"
#import "Requirement.h"
#import "DemandMenu.h"


typedef void (^DemandLogicCommonCallback)(LogicResult* result);

@interface DemandLogic : NSObject {
    Requirement* _publishRequirement;
}

@property (nonatomic, strong) DemandMenu *demandMenu;   //配置文件

@property (nonatomic, strong) NSArray *categoryArray;   //品类
@property (nonatomic, strong) NSArray *sceneArray;      //场景
@property (nonatomic, strong) NSArray *styleArray;      //风格



+ (instancetype)sharedInstance;

// 买家发布需求
- (Requirement*)getRequirementToPublish;

// 发布需求
- (void)publishRequirement:(Requirement *)requirement withCallback:(DemandLogicCommonCallback)results;

// 获取配置数据
- (void)getConfigsData;

// 缓存信息到本地
- (BOOL)saveDemandMenuToFile:(DemandMenu*)demandMenu;

// 清除发布数据（取消发布和发布成功都应该清除发布数据）
- (void)cleanRequirement;

@end
