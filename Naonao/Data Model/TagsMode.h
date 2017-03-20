//
//  TagsMode.h
//  Naonao
//
//  Created by 刘敏 on 16/6/3.
//  Copyright © 2016年 深圳市轩腾华兴科技开发有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Mantle/Mantle.h>

@interface TagsMode : NSObject

@property (nonatomic, strong) NSArray *categoryArr;      //品类
@property (nonatomic, strong) NSArray *tagsArr;          //标签数组

- (instancetype)initWithParsData:(NSDictionary *)dict;

@end


@interface GoodsMode : MTLModel<MTLJSONSerializing>

@property (nonatomic, strong) NSString *img;
@property (nonatomic, strong) NSNumber *originalPrice;
@property (nonatomic, strong) NSNumber *mId;
@property (nonatomic, strong) NSNumber *price;
@property (nonatomic, strong) NSNumber *sourceType;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *brand;
@property (nonatomic, strong) NSArray *tags;

@end