//
//  PhotoViewController.h
//  Artery
//
//  Created by RichardLiu on 15/4/10.
//  Copyright (c) 2015年 刘 敏. All rights reserved.
//

#import "STChildViewController.h"

@class STPhotoPickerGroup;

@interface PhotoViewController : STChildViewController

// 每次选择图片的最大数
@property (nonatomic, assign) NSInteger maxCount;
@property (nonatomic, strong) STPhotoPickerGroup *pickerGroup;



@end
