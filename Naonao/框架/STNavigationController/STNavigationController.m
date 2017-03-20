//
//  STNavigationController.m
//  Shitan
//  Created by Richard Liu 15/6/29.
//  Copyright (c) 2015年 深圳市轩腾华兴科技开发有限公司. All rights reserved.

#import "STNavigationController.h"

@implementation STNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // 使导航条有效
    [self setNavigationBarHidden:NO];
    // 隐藏导航条，但由于导航条有效，系统的返回按钮页有效，所以可以使用系统的右滑返回手势。
    [self.navigationBar setHidden:YES];
}

// 是否可右滑返回
- (void)navigationCanDragBack:(BOOL)canDragBack
{
    self.interactivePopGestureRecognizer.enabled = canDragBack;
}

@end
