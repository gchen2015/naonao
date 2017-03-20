//
//  STShapeViewController.h
//  Naonao
//
//  Created by 刘敏 on 16/6/13.
//  Copyright © 2016年 深圳市轩腾华兴科技开发有限公司. All rights reserved.
//

#import "STChildViewController.h"

@interface STShapeViewController : STChildViewController

@property (weak, nonatomic) IBOutlet UIScrollView *mScrollView;
@property (nonatomic, assign) BOOL isDefect;  //是否已经设置好身材缺陷

@end
