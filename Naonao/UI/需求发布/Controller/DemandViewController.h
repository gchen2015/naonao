//
//  DemandViewController.h
//  Naonao
//
//  Created by 刘敏 on 16/6/15.
//  Copyright © 2016年 深圳市轩腾华兴科技开发有限公司. All rights reserved.
//

#import "STChildViewController.h"

typedef NS_ENUM(NSInteger, TagSelectionStage) {
    kTagSelectionStateCategory = 0,         // 品类
    kTagSelectionStateScene,                // 场景
    kTagSelectionStageStyle,                // 风格
};

@interface DemandViewController : STChildViewController

@end
