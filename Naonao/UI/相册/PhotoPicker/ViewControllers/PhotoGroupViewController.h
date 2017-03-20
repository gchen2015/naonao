//
//  PhotoGroupViewController.h
//  Naonao
//
//  Created by 刘敏 on 16/6/28.
//  Copyright © 2016年 深圳市轩腾华兴科技开发有限公司. All rights reserved.
//

#import "STChildViewController.h"

@interface PhotoGroupViewController : STChildViewController

// 每次选择图片的最大数
@property (nonatomic, assign) NSInteger maxCount;

@property (nonatomic, copy) NSArray *groups;

@end
