//
//  NSString+ImageURL.h
//  Naonao
//
//  Created by 刘敏 on 16/6/29.
//  Copyright © 2016年 深圳市轩腾华兴科技开发有限公司. All rights reserved.
//  用户出处理七牛云的图片链接，主要实现功能：裁剪、压缩、格式转换

#import <Foundation/Foundation.h>

@interface NSString (ImageURL)


// 原图格式转换，转换成web
- (NSString *)originalImageTurnWebp;

// 原图格式转换，转换成web并且压缩，压缩率80%
- (NSString *)compressionOriginalImageTurnWebp;

// 头像压缩
- (NSString *)smallHead;

// 转成中图
- (NSString *)middleImage;

@end
