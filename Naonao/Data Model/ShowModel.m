//
//  ShowModel.m
//  Naonao
//
//  Created by 刘敏 on 2016/9/30.
//  Copyright © 2016年 深圳市轩腾华兴科技开发有限公司. All rights reserved.
//

#import "ShowModel.h"

@implementation ShowModel

- (instancetype)initWithParsData:(NSDictionary *)dict {
    
    self.imgArray = [dict objectForKeyNotNull:@"imgs"];
    self.orderId = [dict objectForKeyNotNull:@"order_id"];
    self.createTime = [dict objectForKeyNotNull:@"create_time"];
    
    if ([dict objectForKeyNotNull:@"product"]) {
        self.product = [[GoodsOData alloc] initWithParsData:[dict objectForKey:@"product"]];
    }
    
    return self;
}


@end
