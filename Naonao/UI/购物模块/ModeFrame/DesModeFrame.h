//
//  DesModeFrame.h
//  Naonao
//
//  Created by 刘敏 on 16/3/18.
//  Copyright © 2016年 深圳市轩腾华兴科技开发有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GoodsInfo.h"

#define M_K    320.0f/129.0f

@interface DesModeFrame : NSObject

@property (nonatomic, strong) GoodsDetailInfo *desInfo;

@property (nonatomic, strong) SizeUrlInfo *sizeInfo;

@property (nonatomic, assign) CGRect leftFrame;
@property (nonatomic, assign) CGRect rightFrame;
@property (nonatomic, assign) CGRect desFrame;
@property (nonatomic, assign) CGRect imageFrame;
@property (nonatomic, assign) CGRect modeFrame;

@property (nonatomic, assign) CGFloat rowHeight;            //cell高度

@end
