//
//  STSameModeView.m
//  Naonao
//
//  Created by 刘敏 on 16/4/29.
//  Copyright © 2016年 深圳市轩腾华兴科技开发有限公司. All rights reserved.
//

#import "STSameModeView.h"
#import <SDWebImage/UIImageView+WebCache.h>


@interface STSameModeView ()

@property (nonatomic, weak) UIImageView *picV;
@property (nonatomic, weak) UILabel *titL;          //商品名称
@property (nonatomic, weak) UILabel *priceL;        //当前价格
@property (nonatomic, weak) UILabel *orpriceL;      //原价

@property (nonatomic, weak) SameModel *sMode;

@end


@implementation STSameModeView


- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setUpChildView];
        self.userInteractionEnabled = YES;
    }
    return self;
}

- (void)setUpChildView
{
    UIImageView *picV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.width)];
    _picV = picV;
    //图片填充方式
    [_picV setContentMode:UIViewContentModeScaleAspectFill];
    _picV.layer.masksToBounds = YES;
    [self addSubview:_picV];
    
    UILabel *titL = [[UILabel alloc] initWithFrame:CGRectMake(0, self.width+8, self.width, 20)];
    _titL = titL;
    [_titL setFont:[UIFont systemFontOfSize:13.0]];
    [_titL setTextColor:BLACK_COLOR];
    [_titL setTextAlignment:NSTextAlignmentCenter];
    [self addSubview:_titL];
    
    UILabel *priceL = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_titL.frame)+5, self.width/2-3, 16)];
    _priceL = priceL;
    [_priceL setFont:[UIFont systemFontOfSize:13.0]];
    [_priceL setTextColor:PINK_COLOR];
    [_priceL setTextAlignment:NSTextAlignmentRight];
    [self addSubview:_priceL];
    
    UILabel *orpriceL = [[UILabel alloc] initWithFrame:CGRectMake(self.width/2+3, CGRectGetMaxY(_titL.frame)+5, self.width/2-3, 16)];
    _orpriceL = orpriceL;
    [_orpriceL setFont:[UIFont systemFontOfSize:11.0]];
    [_orpriceL setTextColor:LIGHT_BLACK_COLOR];
    [_orpriceL setTextAlignment:NSTextAlignmentLeft];
    [self addSubview:_orpriceL];
    
    
    //添加点击事件
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(Actiondo:)];
    
    [self addGestureRecognizer:tapGesture];
    
}


- (void)setInfo:(SameModel *)sMode
{
    
    _sMode = sMode;
    
    [_picV sd_setImageWithURL:[NSURL URLWithString:[sMode.imgurl middleImage]] placeholderImage:[UIImage imageNamed:@"default_image.png"]];
    [_titL setText:sMode.title];
    [_priceL setText:[NSString stringWithFormat:@"￥%@", sMode.price]];
    
    NSAttributedString *attrStr = [[NSAttributedString alloc]initWithString:[NSString stringWithFormat:@"￥%@", sMode.originalPrice]
                                                                 attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:11.0],
                                                                              NSForegroundColorAttributeName:LIGHT_BLACK_COLOR,
                                                                              NSStrikethroughStyleAttributeName:@(NSUnderlineStyleSingle|NSUnderlinePatternSolid),
                                                                              NSStrikethroughColorAttributeName:LIGHT_BLACK_COLOR}];
    
    _orpriceL.attributedText = attrStr;
}

//clickBlock赋值
- (void)sameModeViewClick:(STSameModeViewClickBlock)block
{
    self.clickBlock = block;
}

- (void)Actiondo:(id)sender{
    if (self.clickBlock != nil) {
        self.clickBlock(_sMode);
    }
}

@end
