//
//  STMessageTabView.h
//  Naonao
//
//  Created by 刘敏 on 16/8/18.
//  Copyright © 2016年 深圳市轩腾华兴科技开发有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol STMessageTabViewDelegate <NSObject>

@optional

// 选择index回调
- (void)selectedIndex:(NSInteger)index;

@end

@interface STMessageTabView : UIView

// 选择回调
@property (nonatomic, weak) id<STMessageTabViewDelegate> delegate;

@property (nonatomic, strong) NSMutableArray *buttonsArray;
@property (nonatomic, strong) UIImageView *lineImageView;

// 数据源
@property (nonatomic, strong) NSArray *dataArray;

// 字体非选中时颜色
@property (nonatomic, strong) UIColor *textNomalColor;

// 字体选中时颜色
@property (nonatomic, strong) UIColor *textSelectedColor;

// 横线颜色
@property (nonatomic, strong) UIColor *lineColor;

// 字体大小
@property (nonatomic, assign) CGFloat titleFont;

// 标题数组、标题字体大小
- (instancetype)initWithFrame:(CGRect)frame withDataArray:(NSArray *)dataArray withFont:(CGFloat)font;

// 手动选择
- (void)selectIndex:(NSInteger)index;

@end
