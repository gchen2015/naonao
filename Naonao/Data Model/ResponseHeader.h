//
//  ResponseHeader.h
//  VVShop
//
//  Created by sunlin on 15/5/30.
//  Copyright (c) 2015年 xuantenghuaxing. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ResponseHeader : NSObject

@property (nonatomic, strong) NSNumber* status;
@property (nonatomic, copy) NSString* errorInfo;

- (instancetype)initWithParsData:(NSDictionary *)dict;

@end
