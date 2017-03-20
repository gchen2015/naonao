//
//  ResponseHeader.m
//  VVShop
//
//  Created by sunlin on 15/5/30.
//  Copyright (c) 2015年 xuantenghuaxing. All rights reserved.
//

#import "ResponseHeader.h"

@implementation ResponseHeader

- (instancetype)initWithParsData:(NSDictionary *)dict
{
    self.status = [dict objectForKeyNotNull:@"status"];
    self.errorInfo = [dict objectForKeyNotNull:@"error_info"];
    
    return self;
}

@end
