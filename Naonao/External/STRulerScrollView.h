//
//  STRulerScrollView.h
//  Naonao
//
//  Created by 刘敏 on 16/6/13.
//  Copyright © 2016年 深圳市轩腾华兴科技开发有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

#define DISTANCELEFTANDRIGHT        (SCREEN_WIDTH - 60.0)/2.0f      // 标尺左右距离
#define DISTANCEVALUE               5.6f                            // 每隔刻度实际长度
#define DISTANCETOPANDBOTTOM        6.4f                            // 标尺上下距离



@interface STRulerScrollView : UIScrollView

@property (nonatomic, assign) NSNumber *rulerAverage;       //每个小刻度的值，最小精度 0.1

@property (nonatomic, assign) NSUInteger startValue;        //标尺的零刻度
@property (nonatomic, assign) NSUInteger rulerCount;        //最大刻度的个数
@property (nonatomic, assign) NSUInteger rulerHeight;
@property (nonatomic, assign) NSUInteger rulerWidth;

@property (nonatomic, assign) CGFloat rulerValue;           //标尺当前的刻度

- (void)drawRuler;

@end
