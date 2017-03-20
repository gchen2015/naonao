//
//  STRuler.h
//  Naonao
//
//  Created by 刘敏 on 16/6/13.
//  Copyright © 2016年 深圳市轩腾华兴科技开发有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "STRulerScrollView.h"

@protocol STRulerDelegate <NSObject>

//可选实现
@optional
- (void)ruler:(STRulerScrollView *)rulerScrollView;

@end


@interface STRuler : UIView<UIScrollViewDelegate>

@property (nonatomic, weak) id<STRulerDelegate> deletate;
@property (nonatomic, strong) STRulerScrollView *rulerScrollView;

/**
 *  展示标尺
 *
 *  @param startValue       起始刻度
 *  @param count            10个小刻度为一个大刻度，大刻度的数量
 *  @param average          每个小刻度的值，最小精度 0.1
 *  @param currentValue     直尺初始化的刻度值
 */
- (void)showRulerScrollViewWithStartCount:(NSUInteger)startValue
                                    count:(NSUInteger)count
                                  average:(NSNumber *)average
                             currentValue:(CGFloat)currentValue;


@end
