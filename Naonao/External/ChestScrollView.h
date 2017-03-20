//
//  ChestScrollView.h
//  Naonao
//
//  Created by 刘敏 on 16/6/16.
//  Copyright © 2016年 深圳市轩腾华兴科技开发有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

#define DISTANCE_LEFTANDRIGHT        130.f               // 标尺左右距离
#define DISTANCE_VALUE               50.f                // 每隔刻度实际长度
#define DISTANCE_TOPANDBOTTOM        6.4f                // 标尺上下距离


@interface ChestScrollView : UIScrollView

@property (nonatomic, assign) NSNumber *rulerAverage;       //每个小刻度的值，最小精度 0.1

@property (nonatomic, assign) NSUInteger rulerCount;        //所有的刻度数
@property (nonatomic, assign) NSUInteger rulerHeight;
@property (nonatomic, assign) NSUInteger rulerWidth;

@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic, assign) CGFloat rulerValue;           //标尺当前的刻度

- (void)drawRuler;

@end
