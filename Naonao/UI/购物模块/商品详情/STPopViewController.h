//
//  STPopViewController.h
//  Naonao
//
//  Created by 刘敏 on 16/3/18.
//  Copyright © 2016年 深圳市轩腾华兴科技开发有限公司. All rights reserved.
//

#import "STChildViewController.h"
#import "GoodsCategoryView.h"

@interface STPopViewController : UIViewController

// 弹出的view
@property(nonatomic, strong) GoodsCategoryView * popView;

// rootview
@property(nonatomic, strong) UIView * rootView;

// rootVC
@property(nonatomic, strong) UIViewController * rootVC;

// 初始化 rootVC:根VC， popView:弹出的view
- (void)createPopVCWithRootVC:(UIViewController *)rootVC andPopView:(GoodsCategoryView *)popView;

@end
