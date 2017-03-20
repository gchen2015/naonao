//
//  NSDictionary+Utility.h
//  WGoodL
//
//  Created by apple on 14-5-2.
//  Copyright (c) 2014年 刘 敏. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (Utility)

- (id)objectForKeyNotNull:(id)key;

- (NSArray *)allObjects;

@end
