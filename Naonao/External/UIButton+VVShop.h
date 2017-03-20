//
//  UIButton+VVShop.h
//  VVShop
//
//  Created by sunlin on 15/6/1.
//  Copyright (c) 2015年 xuantenghuaxing. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UIButton(VVShop)

/**
 * 定义按钮 normal，disable 态的颜色，以及圆角
 */
- (void)makeVVShopButtonAppearance;

- (void)makeNaoNaoButtonAppearance;

/**
 * 设置按钮背景图片，根据 insets 进行拉伸
 */
- (void)setBackgroundImage:(UIImage*)image capInsets:(UIEdgeInsets)insets;

- (void)setBackgroundImage:(UIImage*)image capInsets:(UIEdgeInsets)insets forState:(UIControlState)state;


- (void)setButtonEnabledNoAnimation:(BOOL)enabled;

/**
 * 自定义手写字体的按钮
 */
- (void)customHandwrittingAppearanceWithTitle:(NSString*)title;

@end
