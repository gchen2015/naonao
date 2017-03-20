//
//  KICropImageView.h
//  Artery
//
//  Created by 刘敏 on 15/1/10.
//  Copyright (c) 2015年 深圳市轩腾华兴科技开发有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIImage+KIAdditions.h"

@interface KICropImageView : UIView <UIScrollViewDelegate> {
    @private
    UIImageView         *_imageView;
    UIImage             *_image;
    UIEdgeInsets        _imageInset;
    CGSize              _cropSize;
}

@property (nonatomic, strong) UIScrollView *scrollView;

- (void)setImage:(UIImage *)image;

//设置裁剪区域大小
- (void)setCropSize:(CGSize)size;

//裁剪图片
- (UIImage *)cropImage;

/*****更新缩放系数****/
- (void)updateZoomScale;

/*****照片填充****/
- (void)photoFilling;

@end
