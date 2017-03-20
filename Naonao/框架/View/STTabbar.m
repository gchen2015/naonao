//
//  STTabbar.m
//  Naonao
//
//  Created by 刘敏 on 16/5/31.
//  Copyright © 2016年 深圳市轩腾华兴科技开发有限公司. All rights reserved.
//

#import "STTabbar.h"
#import "STPublishButton.h"

@interface STTabBar ()

@property (nonatomic,strong) STPublishButton *plusBtn;

@end

@implementation STTabBar

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        STPublishButton *button = [STPublishButton publishButton];
        _plusBtn = button;
        [_plusBtn addTarget:self action:@selector(click:) forControlEvents:(UIControlEventTouchUpInside)];
        [self addSubview:_plusBtn];
        
    }
    return self;
}


- (void)layoutSubviews{
    [super layoutSubviews];
    
    CGFloat barWidth = SCREEN_WIDTH;
    CGFloat barHeight = self.frame.size.height;
    
    CGFloat buttonW = barWidth / 5;
    CGFloat buttonH = barHeight - 2;
    CGFloat buttonY = 1;
    
    NSInteger buttonIndex = 0;
    
    self.plusBtn.center = CGPointMake(barWidth/2, barHeight/2);
    
    for (UIView *view in self.subviews) {
        NSString *viewClass = NSStringFromClass([view class]);
        if (![viewClass isEqualToString:@"UITabBarButton"]) continue;
        
        CGFloat buttonX = buttonIndex * buttonW;
        if (buttonIndex >= 2) { // 右边2个按钮
            buttonX += buttonW;
        }
        
        view.frame = CGRectMake(buttonX, buttonY, buttonW, buttonH);
        buttonIndex ++;
    }
}


- (void)click:(UIButton *)button {
    self.clickBlock();
}

@end
