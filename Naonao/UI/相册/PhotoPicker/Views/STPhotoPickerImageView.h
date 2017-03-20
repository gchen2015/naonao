//
//  STPhotoPickerImageView.h
//  Naonao
//
//  Created by 刘敏 on 16/6/23.
//  Copyright © 2016年 深圳市轩腾华兴科技开发有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@class STPhotoPickerImageView;

@protocol STPhotoPickerImageViewDelegate <NSObject>

- (void)pickImageView:(STPhotoPickerImageView *)pickImageView selectTapped:(NSIndexPath *)indexPath;

@end

@interface STPhotoPickerImageView : UIImageView

@property (nonatomic, weak) id<STPhotoPickerImageViewDelegate> delegate;

// 是否有蒙版层
@property (nonatomic, assign, getter=isMaskViewFlag) BOOL maskViewFlag;

// 蒙版层的颜色,默认白色
@property (nonatomic, strong) UIColor *maskViewColor;

// 蒙版的透明度,默认 0.5
@property (nonatomic, assign) CGFloat maskViewAlpha;

// 是否有右上角打钩的按钮
@property (nonatomic, assign) BOOL animationRightTick;

// 点击照片是否有动画
@property (assign, nonatomic) BOOL isClickHaveAnimation;

@property (strong, nonatomic) NSIndexPath *indexPath;


@end
