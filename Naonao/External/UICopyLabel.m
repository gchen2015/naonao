//
//  UICopyLabel.m
//  Naonao
//
//  Created by 刘敏 on 2016/10/27.
//  Copyright © 2016年 深圳市轩腾华兴科技开发有限公司. All rights reserved.
//

#import "UICopyLabel.h"

@implementation UICopyLabel

// 绑定事件
- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        [self attachTapHandler];
    }
    
    return self;  
}

- (void)awakeFromNib {
    
    [super awakeFromNib];
    [self attachTapHandler];
}


- (BOOL)canBecomeFirstResponder {
    return YES;
}

// 可以响应的方法
- (BOOL)canPerformAction:(SEL)action withSender:(id)sender {
    return (action == @selector(copy:));
}

// 针对于响应方法的实现
- (void)copy:(id)sender {
    UIPasteboard *pboard = [UIPasteboard generalPasteboard];
    pboard.string = self.text;
}

// UILabel默认是不接收事件的，我们需要自己添加touch事件
- (void)attachTapHandler {
    self.userInteractionEnabled = YES;  //用户交互的总开关
    //长按
    UILongPressGestureRecognizer * longPressGr = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    longPressGr.minimumPressDuration = 0.5;
    [self addGestureRecognizer:longPressGr];
}


- (void)handleTap:(UIGestureRecognizer*) recognizer {
    
    [self becomeFirstResponder];
   
    [[UIMenuController sharedMenuController] setTargetRect:self.frame inView:self.superview];
    [[UIMenuController sharedMenuController] setMenuVisible:YES animated: YES];
}

@end
