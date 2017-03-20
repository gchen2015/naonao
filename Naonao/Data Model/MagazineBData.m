//
//  MagazineBData.m
//  Naonao
//
//  Created by Richard Liu on 15/12/9.
//  Copyright © 2015年 深圳市轩腾华兴科技开发有限公司. All rights reserved.
//

#import "MagazineBData.h"

// 版式二杂志内容
@implementation MBContent

- (instancetype)initWithParsData:(NSDictionary *)dict
{
    self.issueId = [dict objectForKeyNotNull:@"issue_id"];
    self.h5_url = [dict objectForKeyNotNull:@"url"];                                 //html5链接
    
    return self;
}

- (NSArray *)parsingDemandList:(NSArray *)array{
    
    NSMutableArray *temp = [[NSMutableArray alloc] initWithCapacity:array.count];
    
    //匹配的需求
    for (NSDictionary *item in array) {
        MagazineBData *mInfo = [[MagazineBData alloc] initWithParsData:item];
        [temp addObject:mInfo];
    }
    
    return temp;
    
}

@end



@implementation MagazineBData

- (instancetype)initWithParsData:(NSDictionary *)dict {
    
    self.productId = [dict objectForKeyNotNull:@"product_id"];
    self.img = [dict objectForKeyNotNull:@"img"];
    self.originalPrice = [dict objectForKeyNotNull:@"product_original_price"];
    self.price = [dict objectForKeyNotNull:@"product_price"];
    self.productImg = [dict objectForKeyNotNull:@"product_img"];
    self.productType = [dict objectForKeyNotNull:@"product_type"];
    self.productName = [dict objectForKeyNotNull:@"product_name"];


    return self;
}

@end

