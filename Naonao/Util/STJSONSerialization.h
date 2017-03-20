//
//  STJSONSerialization.h
//  Shitan
//
//  Created by 刘敏 on 15/1/9.
//  Copyright (c) 2015年 深圳市轩腾华兴科技开发有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface STJSONSerialization : NSJSONSerialization

//JSON数据解析（解析成NSArray或NSDictionary）
+ (id)JSONObjectWithData:(NSData *)data;

//JSON数据封装（将NSArray或NSDictionary封装成JSON）
+ (NSString *)toJSONData:(id)data;

@end
