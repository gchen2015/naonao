//
//  STPhotoPickerGroup.h
//  Naonao
//
//  Created by 刘敏 on 16/6/26.
//  Copyright © 2016年 深圳市轩腾华兴科技开发有限公司. All rights reserved.
//


#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>

@interface STPhotoPickerGroup : NSObject

// 组名
@property (nonatomic, copy) NSString *groupName;

// 缩略图
@property (nonatomic, strong) UIImage *thumbImage;

// 组里面的图片个数
@property (nonatomic, assign) NSInteger assetsCount;

// 类型 : Saved Photos...
@property (nonatomic, copy) NSString *type;

@property (nonatomic, strong) ALAssetsGroup *group;


@end
