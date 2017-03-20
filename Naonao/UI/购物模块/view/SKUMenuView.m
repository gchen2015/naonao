//
//  SKUMenuView.m
//  Naonao
//
//  Created by 刘敏 on 16/3/19.
//  Copyright © 2016年 深圳市轩腾华兴科技开发有限公司. All rights reserved.
//

#import "SKUMenuView.h"
#import "SKUTagView.h"

@interface SKUMenuView ()<SKUTagViewDelegate>

@property (nonatomic, weak) UILabel *titLabel;

@end

@implementation SKUMenuView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setBackgroundColor:[UIColor whiteColor]];
        [self setUpChildView];
    }
    return self;
}

- (void)setUpChildView
{
    UILabel *titLabel = [[UILabel alloc] initWithFrame:CGRectMake(14, 14, 100, 20)];
    _titLabel = titLabel;
    [_titLabel setFont:[UIFont systemFontOfSize:13.0]];
    [_titLabel setTextColor:BLACK_COLOR];
    
    [self addSubview:_titLabel];
}

- (CGFloat)setMenuWithskuMenuData:(skuMenuData *)mData
{
    [_titLabel setText:[NSString stringWithFormat:@"%@：", mData.name]];
    
    //标签数组
    SKUTagView *sView = [[SKUTagView alloc] initWithFrame:CGRectMake(0, 40, SCREEN_WIDTH, 0)];
    CGRect mG = sView.frame;
    sView.delegate = self;
    
    mG.size.height = [sView setTags:mData];
    [sView setFrame:mG];
    [self addSubview:sView];

    
    return CGRectGetMaxY(sView.frame)+1;
}


#pragma mark  SKUTagViewDelegate
//按钮点击后传递的数据
- (void)skuTapped
{
    if (_delegate && [_delegate respondsToSelector:@selector(skuButtonTapped)]) {
        [_delegate skuButtonTapped];
    }
}


@end
