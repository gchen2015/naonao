//
//  ICDPopupMenu.h
//  cloudoor
//
//  Created by wenky on 15/11/7.
//  Copyright (c) 2015年 Cloudoor Technology Co.,Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef NS_ENUM(NSUInteger, ICDPopupMenuArrowPosition) {
    ICDPopupMenuArrowPositionTopLeft,
    ICDPopupMenuArrowPositionTopRight,
    ICDPopupMenuArrowPositionTopCenter,
    
    ICDPopupMenuArrowPositionBottomLeft,
    ICDPopupMenuArrowPositionBottomRight,
    ICDPopupMenuArrowPositionBottomCenter,
    
    ICDPopupMenuArrowPositionLeftTop,
    ICDPopupMenuArrowPositionLeftBottom,
    ICDPopupMenuArrowPositionLeftCenter,
    
    ICDPopupMenuArrowPositionRightTop,
    ICDPopupMenuArrowPositionRightBottom,
    ICDPopupMenuArrowPositionRightCenter,
};

@interface ICDPopupMenuItem : NSObject

@property (nonatomic, copy) NSString *title;

@property (nonatomic, copy) NSString *imageName;

- (instancetype)initWithTitle:(NSString *)title imageName:(NSString *)imageName;

@end

@class ICDPopupMenu;
typedef void(^ICDPopupMenuActionHandler)(ICDPopupMenu *view, NSUInteger index);

@interface ICDPopupMenu : UIView

@property (nonatomic, copy) NSArray *itemArray;             //array of ICDPopupMenuItem

@property (nonatomic, strong) UIColor *tintColor;

@property (nonatomic, copy) ICDPopupMenuActionHandler actionHandler;

//初始化方法，size为Menu大小，包括箭头
- (instancetype)initWithMenuSize:(CGSize)size;

//从导航栏左按钮或右按钮下方弹出
- (void)showFromNavigationBarButtonItem:(UIBarButtonItem *)barButtonItem;

//从某个控件（startView）对应位置弹出
- (void)showFromStartView:(UIView *)startView arrowPositon:(ICDPopupMenuArrowPosition)position;

//从某个点弹出，inView为此点所在View
- (void)showFromStartPoint:(CGPoint)startPoint inView:(UIView *)inView arrowPositon:(ICDPopupMenuArrowPosition)position;

@end