//
//  NSString+File.h
//  CoreCategory
//
//  Created by 成林 on 15/4/6.
//  Copyright (c) 2015年 沐汐. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (File)

// document根文件夹
+ (NSString *)documentFolder;

// caches根文件夹
+ (NSString *)cachesFolder;

// 生成子文件夹
- (NSString *)createSubFolder:(NSString *)subFolder;


@end
