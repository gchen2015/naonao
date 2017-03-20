//
//  SearchGoodsInfo.h
//  Naonao
//
//  Created by Richard Liu on 16/2/25.
//  Copyright © 2016年 深圳市轩腾华兴科技开发有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SearchGoodsInfo : NSObject

@property (nonatomic, strong) NSArray *desArr;     //标签数组
@property (nonatomic, strong) NSString *price;
@property (nonatomic, strong) NSString *website;
@property (nonatomic, strong) NSString *pName;
@property (nonatomic, strong) NSString *img_url;
@property (nonatomic, strong) NSNumber *product_id;
@property (nonatomic, strong) NSNumber *body_score;
@property (nonatomic, strong) NSNumber *like_score;


- (instancetype)initWithParsData:(NSDictionary *)dict;

@end
