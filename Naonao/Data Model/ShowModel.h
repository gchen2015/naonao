//
//  ShowModel.h
//  Naonao
//
//  Created by 刘敏 on 2016/9/30.
//  Copyright © 2016年 深圳市轩腾华兴科技开发有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GoodsOData.h"


@interface ShowModel : NSObject

@property (nonatomic, strong) NSArray *imgArray;         //题主的问题ID
@property (nonatomic, strong) GoodsOData *product;       //商品

@property (nonatomic, strong) NSNumber *orderId;
@property (nonatomic, strong) NSString *createTime;            //图片链接

- (instancetype)initWithParsData:(NSDictionary *)dict;

@end
