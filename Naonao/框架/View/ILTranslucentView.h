//
//  ILTranslucentView.h
//  Naonao
//
//  Created by Richard Liu on 16/1/12.
//  Copyright © 2016年 深圳市轩腾华兴科技开发有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ILTranslucentView : UIView

@property (nonatomic) BOOL translucent;                         //do you want blur effect? (default: YES)
@property (nonatomic) CGFloat translucentAlpha;                 //alpha of translucent  effect (default: 1)
@property (nonatomic) UIBarStyle translucentStyle;              //blur style, Default or Black
@property (nonatomic, strong) UIColor *translucentTintColor;    //tint color of blur, [UIColor clearColor] is default


@end
