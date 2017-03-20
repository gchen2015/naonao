//
//  STJSONSerialization.m
//  Shitan
//
//  Created by 刘敏 on 15/1/9.
//  Copyright (c) 2015年 深圳市轩腾华兴科技开发有限公司. All rights reserved.
//

#import "STJSONSerialization.h"

@implementation STJSONSerialization

+ (id)JSONObjectWithData:(NSData *)data {
    
    if (data) {
        NSError *error = nil;
        
        id jsonObject = [NSJSONSerialization JSONObjectWithData:data
                                                       options:NSJSONReadingAllowFragments
                                                         error:&error];
        
        if (jsonObject != nil && error == nil){
            return jsonObject;
        }
        else{
            // 解析错误
            return nil;
        }
    }
    return nil;
}



+ (NSString *)toJSONData:(id)data
{
    if (data) {
        NSError *error = nil;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:data
                                                           options:NSJSONWritingPrettyPrinted
                                                             error:&error];
        
        if ([jsonData length] > 0 && error == nil){
            NSString *jsonString = [[NSString alloc] initWithData:jsonData
                                                         encoding:NSUTF8StringEncoding];
            return jsonString;
        }
        else{
            return nil;
        }
    }
    return nil;
}


@end
