//
//  ProductModeFrame.h
//  Naonao
//
//  Created by Richard Liu on 16/2/1.
//  Copyright © 2016年 深圳市轩腾华兴科技开发有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SquareModel.h"

@interface ProductModeFrame : NSObject

@property (nonatomic, strong) ProductData *pData;

/********************** 顶部 *****************************/
@property (nonatomic, assign) CGRect aboveFrame;

@property (nonatomic, assign) CGRect headFrame;         //头像
@property (nonatomic, assign) CGRect nikeFrame;         //昵称
@property (nonatomic, assign) CGRect tipFrame;          //身份标示

/********************** 中部 *****************************/
@property (nonatomic, assign) CGRect centerFrame;

@property (nonatomic, assign) CGRect flagLFrame;



/********************** 推荐的商品 *****************************/
@property (nonatomic, assign) CGRect bottomFrame;

@property (nonatomic, assign) CGRect garyFrame;
@property (nonatomic, assign) CGRect goodsFrame;
@property (nonatomic, assign) CGRect goodsNFrame;
@property (nonatomic, assign) CGRect brandFrame;
@property (nonatomic, assign) CGRect priceFrame;

@property (nonatomic, assign) NSUInteger index;

@property (nonatomic, assign) CGFloat rowHeight;            //cell高度

@end
