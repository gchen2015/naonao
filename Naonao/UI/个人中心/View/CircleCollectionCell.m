//
//  CircleCollectionCell.m
//  MeeBra
//
//  Created by Richard Liu on 15/9/17.
//  Copyright © 2015年 广州杉川投资管理有限公司. All rights reserved.
//

#import "CircleCollectionCell.h"
#import <SDWebImage/UIImageView+WebCache.h>


@interface CircleCollectionCell ()

@property (nonatomic, weak) UIImageView *imageV;
@property (nonatomic, weak) UILabel *nameL;
@property (nonatomic, weak) UILabel *priceL;

@end

@implementation CircleCollectionCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self setBackgroundColor:[UIColor whiteColor]];
        [self initView];
    }
    return self;
}


- (void)initView
{
    CGFloat m_unit = (SCREEN_WIDTH-15*3)/2;
    
    UIImageView *imageV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, m_unit, m_unit)];
    _imageV = imageV;
    //填充方式
    [_imageV setContentMode:UIViewContentModeScaleAspectFill];
    _imageV.layer.masksToBounds = YES;
    [self addSubview:_imageV];
    
    UIImageView *markV = [[UIImageView alloc] initWithFrame:CGRectMake(0, m_unit-16, m_unit, 16)];
    [markV setImage:[UIImage imageNamed:@"gradient_mask.png"]];
    [self addSubview:markV];
    
    
    UILabel *priceL = [[UILabel alloc] initWithFrame:CGRectMake(10, m_unit-16, CGRectGetMaxX(_imageV.frame) - 20, 16)];
    _priceL = priceL;
    [_priceL setTextColor:[UIColor whiteColor]];
    [_priceL setFont:[UIFont systemFontOfSize:11.0]];
    [_priceL setTextAlignment:NSTextAlignmentRight];
    [self addSubview:_priceL];
    
    
    UILabel *nameL = [[UILabel alloc] initWithFrame:CGRectZero];
    _nameL = nameL;
    _nameL.lineBreakMode = NSLineBreakByWordWrapping;
    _nameL.numberOfLines = 0;
    [_nameL setTextColor:BLACK_COLOR];
    [_nameL setFont:[UIFont systemFontOfSize:12.0]];
    _nameL.frame = CGRectMake(0, CGRectGetMaxY(_imageV.frame), CGRectGetMaxX(_imageV.frame), 35);
    [self addSubview:_nameL];
}


//解析数据
- (void)initWithParsData:(FavGoodsModel *)cInfo
{
    NSString *imageURL = nil;
    
    if ([cInfo.imgUrl hasPrefix:@"http://gd3.alicdn.com/"]) {
        imageURL = [Units TBImage320Thumbnails:cInfo.imgUrl];
    }
    else
        imageURL = [cInfo.imgUrl middleImage];

    [_imageV sd_setImageWithURL:[NSURL URLWithString:imageURL]];
    [_nameL setText:cInfo.productName];
    

    [_priceL setText:[NSString stringWithFormat:@"￥%@", cInfo.productPrice]];
}

- (void)initWithCellBrandsInfo:(STBrand_Product *)cInfo
{
    NSString *imageURL = nil;
    
    if ([cInfo.imgUrl hasPrefix:@"http://gd3.alicdn.com/"]) {
        imageURL = [Units TBImage320Thumbnails:cInfo.imgUrl];
    }
    else
        imageURL = [cInfo.imgUrl middleImage];
    
    [_imageV sd_setImageWithURL:[NSURL URLWithString:imageURL]];
    [_nameL setText:cInfo.name];
    [_priceL setText:[NSString stringWithFormat:@"￥%@", cInfo.price]];
}

@end
