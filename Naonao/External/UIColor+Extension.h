//
//  UIColor+Extension.h
//  NationalOA
//
//  Created by 刘敏 on 14-9-20.
//  Copyright (c) 2014年 深圳市轩腾华兴科技开发有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UIColor (Extension)

+ (UIColor*) colorWithHex:(NSInteger)hexValue alpha:(CGFloat)alphaValue;
+ (UIColor*) colorWithHex:(NSInteger)hexValue;
+ (NSString *) hexFromUIColor: (UIColor*) color;
+ (UIColor *)getColor:(NSString *)hexColor;

@end
