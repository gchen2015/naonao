//
//  NSDictionary+Utility.m
//  WGoodL
//
//  Created by apple on 14-5-2.
//  Copyright (c) 2014年 刘 敏. All rights reserved.
//

#import "NSDictionary+Utility.h"

@implementation NSDictionary (Utility)

// in case of [NSNull null] values a nil is returned ...
- (id)objectForKeyNotNull:(id)key {
    id object = [self objectForKey:key];
    if (object == [NSNull null])
        return nil;
    
    return object;
}


- (NSArray *)allObjects {
    NSArray *keys = [self allKeys];
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:[keys count]];
    for (int i=0; i<[keys count]; i++) {
        id key = [keys objectAtIndex:i];
        id obj = [self objectForKey:key];
        [array addObject:obj];
    }
    return array;
}

@end
