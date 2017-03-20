//
//  MenuScrollView.h
//  Naonao
//
//  Created by 刘敏 on 16/6/20.
//  Copyright © 2016年 深圳市轩腾华兴科技开发有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MenuScrollView;

@protocol MenuScrollViewDelegate <NSObject>

- (void)menuScrollView:(MenuScrollView *)menuScrollView
             selectTag:(NSInteger)index
        selectionStage:(NSUInteger)selectionStage;

@end


@interface MenuScrollView : UIScrollView

@property (nonatomic, weak) id<MenuScrollViewDelegate> mDelegate;

- (instancetype)initWithFrame:(CGRect)frame
                     setArray:(NSArray *)mArray
                          tag:(NSUInteger)selectionStage;


- (void)moveToDirection:(DirectionType)direction;

- (void)clearData;


@end
