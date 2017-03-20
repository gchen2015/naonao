//
//  ChestScrollView.m
//  Naonao
//
//  Created by 刘敏 on 16/6/16.
//  Copyright © 2016年 深圳市轩腾华兴科技开发有限公司. All rights reserved.
//

#import "ChestScrollView.h"

@implementation ChestScrollView

- (void)setRulerValue:(CGFloat)rulerValue{
    _rulerValue = rulerValue;
}

- (void)drawRuler
{
    CGMutablePathRef pathRef = CGPathCreateMutable();
    
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.strokeColor = [UIColor grayColor].CGColor;          // 边缘线的颜色
    shapeLayer.fillColor = [UIColor clearColor].CGColor;           // 闭环填充的颜色
    shapeLayer.lineWidth = 1.f;                                    // 线条宽度
    shapeLayer.lineCap = kCALineCapButt;                           // 边缘线的类型
    
    
    for (int i = 0; i <= self.rulerCount; i++) {
        UILabel *rule = [[UILabel alloc] init];
        [rule setFont:[UIFont systemFontOfSize:12.0]];
        rule.textColor = LIGHT_BLACK_COLOR;
        rule.text = [NSString stringWithFormat:@"%@", _dataArray[i]];
        
        CGSize textSize = [rule.text sizeWithAttributes:@{ NSFontAttributeName : rule.font }];

        CGPathMoveToPoint(pathRef, NULL, DISTANCE_LEFTANDRIGHT + DISTANCE_VALUE * i , DISTANCE_TOPANDBOTTOM+ textSize.height+5);
        CGPathAddLineToPoint(pathRef, NULL, DISTANCE_LEFTANDRIGHT + DISTANCE_VALUE * i, self.rulerHeight - DISTANCE_TOPANDBOTTOM);
        rule.frame = CGRectMake(DISTANCE_LEFTANDRIGHT + DISTANCE_VALUE * i - textSize.width / 2, 5, 0, 0);
        [rule sizeToFit];
        [self addSubview:rule];
    }
    
    shapeLayer.path = pathRef;
    
    [self.layer addSublayer:shapeLayer];
    
    self.frame = CGRectMake(0, 0, self.rulerWidth, self.rulerHeight);
    
    self.contentOffset = CGPointMake(DISTANCE_VALUE * (self.rulerValue / [self.rulerAverage floatValue]) - self.rulerWidth / 2.f + DISTANCE_LEFTANDRIGHT, 0);
    self.contentSize = CGSizeMake(self.rulerCount * DISTANCE_VALUE + DISTANCE_LEFTANDRIGHT * 2.f, self.rulerHeight);
}


@end
