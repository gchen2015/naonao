//
//  ChestRuler.m
//  Naonao
//
//  Created by 刘敏 on 16/6/16.
//  Copyright © 2016年 深圳市轩腾华兴科技开发有限公司. All rights reserved.
//

#import "ChestRuler.h"

@implementation ChestRuler

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        _scrollView = [self scrollView];
        _scrollView.rulerHeight = frame.size.height;
        _scrollView.rulerWidth = frame.size.width;
        
    }
    return self;
}


- (void)showRulerScrollViewWithCount:(NSUInteger)count
                           dataArray:(NSArray *)dataArray
                             average:(NSNumber *)average
                        currentValue:(CGFloat)currentValue{
    
    _scrollView.rulerAverage = average;
    _scrollView.rulerCount = count;
    _scrollView.rulerValue = currentValue;
    _scrollView.dataArray = dataArray;
    
    //绘制标尺
    [_scrollView drawRuler];
    
    [self addSubview:_scrollView];
    [self drawRacAndLine];
}

- (ChestScrollView *)scrollView {
    ChestScrollView * scrollView = [[ChestScrollView alloc] init];
    scrollView.delegate = self;
    scrollView.showsHorizontalScrollIndicator = NO;
    return scrollView;
}


#pragma mark - ScrollView Delegate
- (void)scrollViewDidScroll:(ChestScrollView *)scrollView {
    CGFloat offSetX = scrollView.contentOffset.x + self.frame.size.width / 2 - DISTANCE_LEFTANDRIGHT;
    CGFloat ruleValue = (offSetX / DISTANCE_VALUE) * [scrollView.rulerAverage floatValue];
    
    if (ruleValue < 0.f) {
        return;
    }
    else if (ruleValue > scrollView.rulerCount * [scrollView.rulerAverage floatValue]) {
        return;
    }
    
    if (_deletate && [_deletate respondsToSelector:@selector(chestRuler:)]) {
        scrollView.rulerValue = ruleValue;
        [_deletate chestRuler:scrollView];
    }
}

- (void)scrollViewDidEndDecelerating:(ChestScrollView *)scrollView {
    [self animationRebound:scrollView];
}

- (void)scrollViewDidEndDragging:(ChestScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    [self animationRebound:scrollView];
}

- (void)animationRebound:(ChestScrollView *)scrollView {
    CGFloat offSetX = scrollView.contentOffset.x + self.frame.size.width / 2 - DISTANCE_LEFTANDRIGHT;
    CGFloat oX = (offSetX / DISTANCE_VALUE) * [scrollView.rulerAverage floatValue];
    
    if ([self valueIsInteger:scrollView.rulerAverage]) {
        oX = [self notRounding:oX afterPoint:0];
    }
    else {
        oX = [self notRounding:oX afterPoint:1];
    }
    
    CGFloat offX = (oX / ([scrollView.rulerAverage floatValue])) * DISTANCE_VALUE + DISTANCE_LEFTANDRIGHT - self.frame.size.width / 2;
    [UIView animateWithDuration:.2f animations:^{
        scrollView.contentOffset = CGPointMake(offX, 0);
    }];
}


- (void)drawRacAndLine {
    
    // 渐变
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = self.bounds;
    
    gradient.colors = @[(id)[[UIColor whiteColor] colorWithAlphaComponent:1.f].CGColor,
                        (id)[[UIColor whiteColor] colorWithAlphaComponent:0.0f].CGColor,
                        (id)[[UIColor whiteColor] colorWithAlphaComponent:1.f].CGColor];
    
    gradient.locations = @[[NSNumber numberWithFloat:0.0f],
                           [NSNumber numberWithFloat:0.3f]];
    
    gradient.startPoint = CGPointMake(0, .5);
    gradient.endPoint = CGPointMake(1, .5);
    
    
    //俩边渐变效果
    [self.layer addSublayer:gradient];
}


#pragma mark - tool method
- (CGFloat)notRounding:(CGFloat)price afterPoint:(NSInteger)position {
    NSDecimalNumberHandler*roundingBehavior = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:NSRoundPlain scale:position raiseOnExactness:NO raiseOnOverflow:NO raiseOnUnderflow:NO raiseOnDivideByZero:NO];
    NSDecimalNumber*ouncesDecimal;
    NSDecimalNumber*roundedOunces;
    ouncesDecimal = [[NSDecimalNumber alloc]initWithFloat:price];
    roundedOunces = [ouncesDecimal decimalNumberByRoundingAccordingToBehavior:roundingBehavior];
    
    return [roundedOunces floatValue];
}

- (BOOL)valueIsInteger:(NSNumber *)number {
    NSString *value = [NSString stringWithFormat:@"%f",[number floatValue]];
    if (value != nil) {
        NSString *valueEnd = [[value componentsSeparatedByString:@"."] objectAtIndex:1];
        NSString *temp = nil;
        for(int i =0; i < [valueEnd length]; i++)
        {
            temp = [valueEnd substringWithRange:NSMakeRange(i, 1)];
            if (![temp isEqualToString:@"0"]) {
                return NO;
            }
        }
    }
    return YES;
}



@end
