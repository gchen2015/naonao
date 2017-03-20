//
//  ChestRuler.h
//  Naonao
//
//  Created by 刘敏 on 16/6/16.
//  Copyright © 2016年 深圳市轩腾华兴科技开发有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChestScrollView.h"


@protocol ChestRulerDelegate <NSObject>

//可选实现
@optional

- (void)chestRuler:(ChestScrollView *)rulerScrollView;

@end


@interface ChestRuler : UIView<UIScrollViewDelegate>

@property (nonatomic, weak) id<ChestRulerDelegate> deletate;
@property (nonatomic, strong) ChestScrollView *scrollView;

/**
 *  展示标尺
 *
 *  @param count            10个小刻度为一个大刻度，大刻度的数量
 *  @param average          每个小刻度的值，最小精度 0.1
 *  @param currentValue     直尺初始化的刻度值
 */
- (void)showRulerScrollViewWithCount:(NSUInteger)count
                           dataArray:(NSArray *)dataArray
                             average:(NSNumber *)average
                        currentValue:(CGFloat)currentValue;


@end
