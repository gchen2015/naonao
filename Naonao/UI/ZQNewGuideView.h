//
//  ZQNewGuideView.h
//  新手引导
//
//  Created by zhang on 16/5/21.
//  Copyright © 2016年 zqdreamer. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ClickedShowRectBlock)();


typedef NS_ENUM(NSInteger, ZQNewGuideViewMode) {
    ZQNewGuideViewModeRect,             //矩形
    ZQNewGuideViewModeRoundRect,        //圆角矩形
    ZQNewGuideViewModeOval              //椭圆
};


@interface ZQNewGuideView : UIView

/***  透明区域frame*/
@property (assign, nonatomic) CGRect showRect;

/***  透明范围全部显示*/
@property (assign, nonatomic) BOOL fullShow;

/***  是否显示提示*/
@property (assign, nonatomic) BOOL showMark;

/***  引导背景蒙层的颜色*/
@property (strong, nonatomic) UIColor *guideColor;

/***  透明区域范围*/
@property (assign, nonatomic) ZQNewGuideViewMode model;

/***  点击透明区域的处理*/
@property (copy, nonatomic) ClickedShowRectBlock clickedShowRectBlock;

/***  描述文本图片*/
@property (strong, nonatomic) UIImage *textImage;

/***  描述文本图片的frame*/
@property (assign, nonatomic) CGRect textImageFrame;

@end
