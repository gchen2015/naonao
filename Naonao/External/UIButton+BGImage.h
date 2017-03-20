//
//  UIButton+BGImage.h
//  Naonao
//
//  Created by Richard Liu on 15/11/30.
//  Copyright © 2015年 深圳市轩腾华兴科技开发有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (BGImage)

// 设置按钮的背景
- (void)setBackgroundImage:(NSString *) imageN setSelectedBackgroundImage:(NSString *) selImageN;

// 设置按钮的背景
- (void)setBackgroundImage:(NSString *) imageN setDisabledBackgroundImage:(NSString *) selImageN;

// 设置按钮的背景
- (void)setImage:(NSString *) imageN setSelectedImage:(NSString *) selImageN;

@end
