//
//  Units.h
//  Naonao
//
//  Created by Richard Liu on 15/11/23.
//  Copyright © 2015年 深圳市轩腾华兴科技开发有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "STJSONSerialization.h"
#import "NSDictionary+Utility.h"


void AlertWithTitleAndMessage(NSString* title, NSString* message);

void AlertWithTitleAndMessageAndPay(NSString* title, NSString* message, id delegate,
                                    NSString* button1);

void AlertWithTitleAndMessageAndBtton(NSString* title, NSString* message, id delegate,
                                    NSString* button1);

void AlertWithTitleAndMessageAndUnits(NSString* title, NSString* message, id delegate,
                                      NSString* button1, NSString* button2);
void AlertWithTitleAndMessageAndUnitsToTag(NSString* title, NSString* message, id delegate,
                                           NSString* button1, NSString* button2, NSInteger tag);

//图像裁剪
UIImage* ImageWithImageSimple(UIImage *imageA, CGSize newSize);

@interface Units : NSObject

#pragma mark - File

//获取磁盘文件夹
+ (NSString *)docDirectory;
//获取用户文件路径
+ (NSString*)getProfilePath:(NSString *)paths;
//根据路径移除文件
+ (BOOL)removeFileAtPath:(NSString*)path;

//获取当前时间（用于产生随机数）
+ (NSString*)getTimeStrWithDateFormat:(NSString*)format withTime:(NSTimeInterval)time;

+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size;

+ (NSString *)notNilString:(NSString *)string;

// 将时间格式化作为文件的名字
+ (NSString *)formatTimeAsFileName;

//拼接淘宝商品图片
+ (NSString *)TBImage320Thumbnails:(NSString *)urls;

//转换成货币形式
+ (NSString *)currencyStringWithNumber:(NSNumber *)number;

+ (UIViewController*)viewControllerForStoryboardName:(NSString*)storyboardName class:(id)classA;

//图像旋转
+ (UIImage *)image:(UIImage *)image rotation:(UIImageOrientation)orientation;

//是否应该显示版本新特性页面
+ (BOOL)canShowNewFeature;

// URL编码
+ (NSString *)encodeToPercentEscapeString: (NSString *)input;

//解码
+ (NSString *)decodeFromPercentEscapeString: (NSString *)input;

@end
