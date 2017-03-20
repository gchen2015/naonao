//
//  SHLUILabel.h
//  Naonao
//
//  Created by Richard Liu on 16/2/1.
//  Copyright © 2016年 深圳市轩腾华兴科技开发有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface SHLUILabel : UILabel

@property (nonatomic, assign) CGFloat characterSpacing;     //字间距
@property (nonatomic, assign) CGFloat linesSpacing;         //行间距
@property (nonatomic, assign) CGFloat paragraphSpacing;     //段间距


/*
 *绘制前获取label高度
 */
- (int)getAttributedStringHeightWidthValue:(int)width;

@end
