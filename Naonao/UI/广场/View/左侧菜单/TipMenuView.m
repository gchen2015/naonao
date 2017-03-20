//
//  TipMenuView.m
//  Naonao
//
//  Created by 刘敏 on 16/7/27.
//  Copyright © 2016年 深圳市轩腾华兴科技开发有限公司. All rights reserved.
//

#import "TipMenuView.h"
#import "TipView.h"

@interface TipMenuView ()

@property (nonatomic, weak) UILabel *titLabel;
@property (nonatomic, weak) TipView *sView;
@end


@implementation TipMenuView

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
    UILabel *titLabel = [[UILabel alloc] initWithFrame:CGRectMake(22, 14, 100, 20)];
    _titLabel = titLabel;
    [_titLabel setFont:[UIFont systemFontOfSize:16.0]];
    [_titLabel setTextColor:BLACK_COLOR];
    
    [self addSubview:_titLabel];
}


- (CGFloat)setMenuWithskuMenuData:(NSArray *)array titleN:(NSString *)titS tag:(NSUInteger)index
{
    [_titLabel setText:titS];
    
    //标签数组
    TipView *sView = [[TipView alloc] initWithFrame:CGRectMake(0, 40, CGRectGetWidth(self.frame), 0)];
    _sView = sView;
    CGRect mG = _sView.frame;
    _sView.index = index;
    
    mG.size.height = [_sView setTags:array];
    [_sView setFrame:mG];
    [self addSubview:_sView];
    
    return CGRectGetMaxY(_sView.frame)+1;
}


//还原（重置）
- (void)reductionMenuView{
    [_sView reductionTipView];
}

@end
