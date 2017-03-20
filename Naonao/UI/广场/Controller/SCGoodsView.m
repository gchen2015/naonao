//
//  SCGoodsView.m
//  Naonao
//
//  Created by 刘敏 on 16/6/24.
//  Copyright © 2016年 深圳市轩腾华兴科技开发有限公司. All rights reserved.
//

#import "SCGoodsView.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface SCGoodsView ()

@property (nonatomic, weak) UIImageView *headV;
@property (nonatomic, weak) UILabel *titLabel;
@property (nonatomic, weak) UILabel *priceL;

@property (nonatomic, weak) UIButton *deleteBtn;

@end


@implementation SCGoodsView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        //圆角
        self.layer.cornerRadius = 4; //设置那个圆角的有多圆
        self.layer.masksToBounds = YES;  //设为NO去试试
        self.layer.borderColor = [UIColor whiteColor].CGColor;
        self.layer.borderWidth = 0.4;
        
        [self setBackgroundColor:[UIColor whiteColor]];
        [self setUpChildView];
    }
    return self;
    
}

- (void)setUpChildView {
    
    UIImageView *headV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 64, 64)];
    _headV = headV;
    //填充方式
    [_headV setContentMode:UIViewContentModeScaleAspectFill];
    _headV.layer.masksToBounds = YES;
    [self addSubview:_headV];
    
    
    UILabel *titLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_headV.frame)+8, 8, CGRectGetWidth(self.frame) - 20 - 64, 20)];
    _titLabel = titLabel;
    [_titLabel setFont:[UIFont systemFontOfSize:14.0]];
    [_titLabel setTextColor:BLACK_COLOR];
    [self addSubview:_titLabel];
    
    
    UILabel *priceL = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_headV.frame)+8, 40, CGRectGetWidth(self.frame) - 20 - 64, 20)];
    _priceL = priceL;
    [_priceL setFont:[UIFont boldSystemFontOfSize:18.0]];
    [_priceL setTextColor:[UIColor blackColor]];
    [self addSubview:_priceL];
    
    UIButton *deleteBtn = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.frame) - 32, 0, 32, 29)];
    _deleteBtn = deleteBtn;
    [_deleteBtn setBackgroundImage:[UIImage imageNamed:@"close_arc.png"] forState:UIControlStateNormal];
    [_deleteBtn addTarget:self action:@selector(deleteBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_deleteBtn];
}


- (void)setMode:(GoodsMode *)mode {
    [_headV sd_setImageWithURL:[NSURL URLWithString:mode.img] placeholderImage:[UIImage imageNamed:@"default_image.png"]];
    [_titLabel setText:mode.title];
    [_priceL setText:[Units currencyStringWithNumber:mode.price]];
}

- (void)deleteBtnClick {
    AlertWithTitleAndMessageAndUnits(@"移除提示", @"放弃推荐这款商品？", self, @"确认", nil);
}


#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        if (_delegate && [_delegate respondsToSelector:@selector(goodsViewDisappear)]) {
            [_delegate goodsViewDisappear];
        }
    }
}

@end
