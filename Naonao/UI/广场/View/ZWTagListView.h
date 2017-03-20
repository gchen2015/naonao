//
//  ZWTagListView.h
//  自定义流式标签
//
//  Created by zhangwei on 15/10/22.
//  Copyright (c) 2015年 zhangwei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZWTagListView : UIView{
    
    CGRect previousFrame ;
    int totalHeight ;
}


// 整个view的背景色
@property(nonatomic, strong) UIColor*GBbackgroundColor;

// 设置单一颜色
@property(nonatomic, strong) UIColor *signalTagColor;

// 标签文本赋值
-(void)setTagWithTagArray:(NSArray*)arr;

@end
