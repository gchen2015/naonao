//
//  MagazineBData.h
//  Naonao
//
//  Created by Richard Liu on 15/12/9.
//  Copyright © 2015年 深圳市轩腾华兴科技开发有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

// 版式二杂志内容
@interface MBContent : NSObject

@property (nonatomic, strong) NSString *h5_url;        //html5链接
@property (nonatomic, strong) NSNumber *issueId;       //杂志ID

- (instancetype)initWithParsData:(NSDictionary *)dict;

@end



@interface MagazineBData : NSObject

@property (nonatomic, strong) NSNumber *productId;   //商品ID
@property (nonatomic, strong) NSString *img;

@property (nonatomic, strong) NSNumber *originalPrice;
@property (nonatomic, strong) NSNumber *price;

@property (nonatomic, strong) NSString *productImg;

@property (nonatomic, strong) NSNumber *productType;    //商品类型
@property (nonatomic, strong) NSString *productName;



- (instancetype)initWithParsData:(NSDictionary *)dict;

@end


