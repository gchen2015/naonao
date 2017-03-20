//
//  PGoodsView.m
//  Naonao
//
//  Created by 刘敏 on 16/6/1.
//  Copyright © 2016年 深圳市轩腾华兴科技开发有限公司. All rights reserved.
//

#import "PGoodsView.h"
#import <SDWebImage/UIImageView+WebCache.h>


@interface PGoodsView ()

@property (nonatomic, weak) UIImageView *bgView;
@property (nonatomic, weak) UIImageView *goodV;

@property (nonatomic, weak) UILabel *nameL;
@property (nonatomic, weak) UILabel *priceL;
@property (nonatomic, weak) UILabel *brandL;
@property (nonatomic, weak) UIImageView *buyV;

@end

@implementation PGoodsView


- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        [self setUpChildView];
    }
    return self;
}

- (void)setUpChildView {
    
    UIImageView *bgView = [[UIImageView alloc] init];
    _bgView = bgView;
    [_bgView setImage:[UIImage imageNamed:@"dotted_line_bg.png"]];
    [self addSubview:_bgView];
    _bgView.userInteractionEnabled = YES;
    
    //添加点击事件
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageActiondo:)];
    [_bgView addGestureRecognizer:tapGesture];
    [self addSubview:_bgView];
    
    
    UIImageView *goodV = [[UIImageView alloc] init];
    _goodV = goodV;
    //图片填充方式
    [_goodV setContentMode:UIViewContentModeScaleAspectFill];
    _goodV.layer.masksToBounds = YES;
    [self addSubview:_goodV];
    
    
    UILabel *nameL = [[UILabel alloc] init];
    _nameL = nameL;
    [_nameL setFont:[UIFont systemFontOfSize:15.0]];
    [_nameL setTextColor:[UIColor blackColor]];
    [self addSubview:_nameL];
    
    
    UILabel *brandL = [[UILabel alloc] init];
    _brandL = brandL;
    [_brandL setFont:[UIFont systemFontOfSize:13.0]];
    [_brandL setTextColor:BLACK_COLOR];
    [self addSubview:_brandL];

    
    
    UILabel *priceL = [[UILabel alloc] init];
    _priceL = priceL;
    [_priceL setFont:[UIFont boldSystemFontOfSize:17.0]];
    [_priceL setTextColor:[UIColor blackColor]];
    [self addSubview:_priceL];
}


- (void)setProFrame:(ProductModeFrame *)proFrame
{
    _proFrame = proFrame;
    
    _bgView.frame = _proFrame.garyFrame;
    _goodV.frame = _proFrame.goodsFrame;
    _nameL.frame = _proFrame.goodsNFrame;
    _brandL.frame = _proFrame.brandFrame;
    _priceL.frame = _proFrame.priceFrame;
    
    [self setChildViewData];
}


- (void)setAnFrame:(AnswerModeFrame *)anFrame
{
    _anFrame = anFrame;
    
    _bgView.frame = _anFrame.garyFrame;
    _goodV.frame = _anFrame.goodsFrame;
    _nameL.frame = _anFrame.goodsNFrame;
    
    _brandL.frame = _anFrame.brandFrame;
    _priceL.frame = _anFrame.priceFrame;
    
    [self setAnViewData];
}


- (void)setChildViewData
{
    [_goodV sd_setImageWithURL:[NSURL URLWithString:[_proFrame.pData.imgurl middleImage]] placeholderImage:[UIImage imageNamed:@"default_image.png"]];
    [_nameL setText:_proFrame.pData.wrapTitle];
    //货币显示形式
    [_priceL setText:[Units currencyStringWithNumber:_proFrame.pData.price]];
    
}


- (void)setAnViewData{
    [_goodV sd_setImageWithURL:[NSURL URLWithString:[_anFrame.aMode.proData.img middleImage]] placeholderImage:[UIImage imageNamed:@"default_image.png"]];
    [_nameL setText:_anFrame.aMode.proData.title];
    [_brandL setText:_anFrame.aMode.proData.brand];
    //货币显示形式
    [_priceL setText:[Units currencyStringWithNumber:_anFrame.aMode.proData.price]];
}



- (void)imageActiondo:(UITapGestureRecognizer *)tapGesture
{
    //判断是否登录
    if (![UserLogic sharedInstance].user.basic.userId) {
        [theAppDelegate popLoginView];
        return;
    }

    if (_delegate && [_delegate respondsToSelector:@selector(pGoodsView:buttonWithIndex:)]) {
        if(_proFrame)
        {
            [_delegate pGoodsView:self buttonWithIndex:_proFrame.index];
        }
        else if (_anFrame)
        {
            [_delegate pGoodsView:self buttonWithIndex:_anFrame.index];
        }
    }
}

@end
