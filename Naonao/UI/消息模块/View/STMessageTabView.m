//
//  STMessageTabView.m
//  Naonao
//
//  Created by 刘敏 on 16/8/18.
//  Copyright © 2016年 深圳市轩腾华兴科技开发有限公司. All rights reserved.
//

#import "STMessageTabView.h"
#import "JSBadgeView.h"

@implementation STMessageTabView

- (instancetype)initWithFrame:(CGRect)frame withDataArray:(NSArray *)dataArray withFont:(CGFloat)font {
    
    self = [super initWithFrame:frame];
    if (self) {
        self.frame = frame;
        self.backgroundColor = [UIColor whiteColor];
        
        _buttonsArray = [[NSMutableArray alloc] init];
        _dataArray = dataArray;
        _titleFont = font;
        
        //默认
        self.textNomalColor    = BLACK_COLOR;
        self.textSelectedColor = PINK_COLOR;
        self.lineColor         = PINK_COLOR;
        
        [self addSubSegmentView];
    }
    return self;
}

- (void)addSubSegmentView {
    float width = self.frame.size.width / _dataArray.count;
    
    for (int i = 0 ; i < _dataArray.count ; i++) {
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(i * width, 0, width, self.frame.size.height)];
        button.tag = i+1;
        button.backgroundColor = [UIColor clearColor];
        [button setTitle:[_dataArray objectAtIndex:i] forState:UIControlStateNormal];
        [button setTitleColor:self.textNomalColor forState:UIControlStateNormal];
        [button setTitleColor:self.textSelectedColor forState:UIControlStateSelected];
        button.titleLabel.font = [UIFont systemFontOfSize:_titleFont];
        
        [button addTarget:self action:@selector(tapAction:) forControlEvents:UIControlEventTouchUpInside];
        //默认第一个选中
        if (i == 0) {
            button.selected = YES;
        }
        else{
            button.selected = NO;
        }
        
        JSBadgeView *badgeView = [[JSBadgeView alloc] initWithParentView:button alignment:JSBadgeViewAlignmentCenter];
        [badgeView setBadgeTextFont:[UIFont systemFontOfSize:10.0]];
        //2、如果显示的位置不对，可以自己调整，超爽啊！
        badgeView.badgePositionAdjustment = CGPointMake(-15, 10);
        
        badgeView.badgeOverlayColor = [UIColor clearColor];
        badgeView.badgeStrokeColor = [UIColor clearColor];
        badgeView.badgeShadowColor = [UIColor clearColor];
        badgeView.badgeTextColor = [UIColor whiteColor];
        
        [self updateBadgeView:badgeView  enable:0];
        
        [self.buttonsArray addObject:button];
        [self addSubview:button];
    }
    
    self.lineImageView = [[UIImageView alloc] initWithFrame:CGRectMake(25, self.frame.size.height-4, 30, 4)];
    self.lineImageView.backgroundColor = _lineColor;
    [self addSubview:self.lineImageView];
}

- (void)tapAction:(id)sender{
    UIButton *button = (UIButton *)sender;
    [UIView animateWithDuration:0.2 animations:^{
        self.lineImageView.frame = CGRectMake(button.frame.origin.x + 25, self.frame.size.height-4, 30, 4);
    }];
    for (UIButton *subButton in self.buttonsArray) {
        if (button == subButton) {
            subButton.selected = YES;
        }
        else{
            subButton.selected = NO;
        }
    }
    if ([self.delegate respondsToSelector:@selector(selectedIndex:)]) {
        [self.delegate selectedIndex:button.tag -1];
    }
}


- (void)selectIndex:(NSInteger)index
{
    for (UIButton *subButton in self.buttonsArray) {
        if (index != subButton.tag) {
            subButton.selected = NO;
        }
        else{
            subButton.selected = YES;
            [UIView animateWithDuration:0.2 animations:^{
                self.lineImageView.frame = CGRectMake(subButton.frame.origin.x + 25, self.frame.size.height-4, 30, 4);
            }];
        }
    }
}

#pragma mark -- set
- (void)setLineColor:(UIColor *)lineColor{
    if (_lineColor != lineColor) {
        self.lineImageView.backgroundColor = lineColor;
        _lineColor = lineColor;
    }
}

- (void)setTextNomalColor:(UIColor *)textNomalColor{
    if (_textNomalColor != textNomalColor) {
        for (UIButton *subButton in self.buttonsArray){
            [subButton setTitleColor:textNomalColor forState:UIControlStateNormal];
        }
        _textNomalColor = textNomalColor;
    }
}

- (void)setTextSelectedColor:(UIColor *)textSelectedColor{
    if (_textSelectedColor != textSelectedColor) {
        for (UIButton *subButton in self.buttonsArray){
            [subButton setTitleColor:textSelectedColor forState:UIControlStateSelected];
        }
        _textSelectedColor = textSelectedColor;
    }
}

- (void)setTitleFont:(CGFloat)titleFont{
    if (_titleFont != titleFont) {
        for (UIButton *subButton in self.buttonsArray){
            subButton.titleLabel.font = [UIFont systemFontOfSize:titleFont] ;
        }
        _titleFont = titleFont;
    }
}

- (void)updateBadgeView:(JSBadgeView *)badgeView enable:(NSInteger)count {
    if (count > 0) {
        [badgeView setBadgeText:[NSString stringWithFormat:@"%ld", (long)count]];
    }
    else {
        [badgeView setBadgeText:nil];
    }
}

@end
