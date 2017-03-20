//
//  SKUData.h
//  Naonao
//
//  Created by 刘敏 on 16/3/19.
//  Copyright © 2016年 深圳市轩腾华兴科技开发有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SKUData : NSObject

@property (nonatomic, strong) NSNumber *productId;
@property (nonatomic, strong) NSString *imgUrl;
@property (nonatomic, strong) NSNumber *originalPrice;
@property (nonatomic, strong) NSNumber *price;
@property (nonatomic, strong) NSString *prodName;

@property (nonatomic, strong) NSArray *disArray;        //菜单
@property (nonatomic, strong) NSArray *skuList;         //SKU

- (instancetype)initWithParsData:(NSDictionary *)dict;

@end


@interface skuMenuData : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSArray *skuArray;

- (instancetype)initWithParsData:(NSDictionary *)dict;

@end


@interface skuDesData : NSObject

@property (nonatomic, strong) NSNumber *stock;
@property (nonatomic, strong) NSNumber *price;
@property (nonatomic, strong) NSNumber *skuId;
@property (nonatomic, strong) NSDictionary *skuInfo;

@property (nonatomic, strong) NSNumber *source_uid;   //推荐者ID

- (instancetype)initWithParsData:(NSDictionary *)dict;

@end
