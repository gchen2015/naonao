//
//  UIScrollView+EmptyDataSet.h
//  Naonao
//
//  Created by 刘敏 on 16/3/30.
//  Copyright © 2016年 深圳市轩腾华兴科技开发有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DZNEmptyDataSetSource;
@protocol DZNEmptyDataSetDelegate;

@interface UIScrollView (EmptyDataSet)

@property (nonatomic, weak) IBOutlet id <DZNEmptyDataSetSource> emptyDataSetSource;
@property (nonatomic, weak) IBOutlet id <DZNEmptyDataSetDelegate> emptyDataSetDelegate;

@property (nonatomic, readonly, getter = isEmptyDataSetVisible) BOOL emptyDataSetVisible;

//重载
- (void)reloadEmptyDataSet;

@end


@protocol DZNEmptyDataSetSource <NSObject>
@optional

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView;

- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView;

- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView;

- (UIColor *)imageTintColorForEmptyDataSet:(UIScrollView *)scrollView;

- (CAAnimation *) imageAnimationForEmptyDataSet:(UIScrollView *) scrollView;

- (NSAttributedString *)buttonTitleForEmptyDataSet:(UIScrollView *)scrollView forState:(UIControlState)state;

- (UIImage *)buttonImageForEmptyDataSet:(UIScrollView *)scrollView forState:(UIControlState)state;

- (UIImage *)buttonBackgroundImageForEmptyDataSet:(UIScrollView *)scrollView forState:(UIControlState)state;

- (UIColor *)backgroundColorForEmptyDataSet:(UIScrollView *)scrollView;

- (UIView *)customViewForEmptyDataSet:(UIScrollView *)scrollView;

- (CGPoint)offsetForEmptyDataSet:(UIScrollView *)scrollView DEPRECATED_MSG_ATTRIBUTE("Use -verticalOffsetForEmptyDataSet:");
- (CGFloat)verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView;

- (CGFloat)spaceHeightForEmptyDataSet:(UIScrollView *)scrollView;

@end



@protocol DZNEmptyDataSetDelegate <NSObject>
@optional

- (BOOL)emptyDataSetShouldFadeIn:(UIScrollView *)scrollView;

- (BOOL)emptyDataSetShouldDisplay:(UIScrollView *)scrollView;

- (BOOL)emptyDataSetShouldAllowTouch:(UIScrollView *)scrollView;

- (BOOL)emptyDataSetShouldAllowScroll:(UIScrollView *)scrollView;

- (BOOL)emptyDataSetShouldAnimateImageView:(UIScrollView *)scrollView;

- (void)emptyDataSetDidTapView:(UIScrollView *)scrollView DEPRECATED_MSG_ATTRIBUTE("Use emptyDataSet:didTapView:");

- (void)emptyDataSetDidTapButton:(UIScrollView *)scrollView DEPRECATED_MSG_ATTRIBUTE("Use emptyDataSet:didTapButton:");

- (void)emptyDataSet:(UIScrollView *)scrollView didTapView:(UIView *)view;

- (void)emptyDataSet:(UIScrollView *)scrollView didTapButton:(UIButton *)button;

- (void)emptyDataSetWillAppear:(UIScrollView *)scrollView;

- (void)emptyDataSetDidAppear:(UIScrollView *)scrollView;

- (void)emptyDataSetWillDisappear:(UIScrollView *)scrollView;

- (void)emptyDataSetDidDisappear:(UIScrollView *)scrollView;

@end
