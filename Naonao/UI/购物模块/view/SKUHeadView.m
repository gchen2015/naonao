//
//  SKUHeadView.m
//  Naonao
//
//  Created by 刘敏 on 16/3/19.
//  Copyright © 2016年 深圳市轩腾华兴科技开发有限公司. All rights reserved.
//

#import "SKUHeadView.h"
#import "SKUData.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "ShoppingLogic.h"

@interface SKUHeadView ()

@property (nonatomic, weak) UILabel *priceL;        //价格
@property (nonatomic, weak) UILabel *nameL;         //商品名称
@property (nonatomic, weak) UILabel *inventoryL;    //库存

@end

@implementation SKUHeadView

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
    SKUData *mData = [ShoppingLogic sharedInstance].skuData;
    
    UIImageView *headV = [[UIImageView alloc] initWithFrame:CGRectMake(14, 15, 92, 92)];
    _headV = headV;
    //填充方式
    [_headV setContentMode:UIViewContentModeScaleAspectFill];
    _headV.layer.masksToBounds = YES;  //设为NO去试试

    [_headV sd_setImageWithURL:[NSURL URLWithString:[mData.imgUrl middleImage]] placeholderImage:[UIImage imageNamed:@"default_image.png"]];
    [self addSubview:_headV];
    
    
    CGSize size = [[Units currencyStringWithNumber:mData.price] sizeWithAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:18.0]}];
    
    //价格
    UILabel *priceL = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_headV.frame)+7, 26, size.width, 20)];
    _priceL = priceL;
    [_priceL setTextColor:BLACK_COLOR];
    [_priceL setFont:[UIFont fontWithName:kAkzidenzGroteskBQ size:15.0]];
    
    NSString *st = [NSString stringWithFormat:@"￥%.2f", [mData.price floatValue]];
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:st];
    [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15.0] range:NSMakeRange(0, 1)];
    [str addAttribute:NSFontAttributeName value:[UIFont fontWithName:kAkzidenzGroteskBQ size:28.0] range:NSMakeRange(1, st.length-4)];
    _priceL.attributedText = str;
    [self addSubview:_priceL];

    
    //商品名称
    UILabel* nameL = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_headV.frame)+10, CGRectGetMaxY(_priceL.frame)+10, SCREEN_WIDTH - CGRectGetMaxX(_headV.frame)-14, 18)];
    _nameL = nameL;
    [_nameL setTextColor:[UIColor grayColor]];
    [_nameL setFont:[UIFont systemFontOfSize:12.0]];
    [_nameL setTextColor:LIGHT_GARY_COLOR];
    [_nameL setText:mData.prodName];
    [self addSubview:_nameL];
    
    //库存
    UILabel *inventoryL = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_headV.frame)+10, CGRectGetMaxY(_headV.frame)-14, SCREEN_WIDTH - CGRectGetMaxX(_headV.frame)-14, 14)];
    _inventoryL = inventoryL;
    [_inventoryL setTextColor:[UIColor grayColor]];
    [_inventoryL setFont:[UIFont systemFontOfSize:14.0]];
    [_inventoryL setTextColor:BLACK_COLOR];
    [_inventoryL setText:@"库存100件"];
    [self addSubview:_inventoryL];

    
    UILabel *lineV = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.frame)-0.5, SCREEN_WIDTH, 0.5)];
    [lineV setBackgroundColor:LINE_COLOR];
    [self addSubview:lineV];
}

//更新UI
- (void)updateUIMessage:(skuDesData *)pdata
{
    NSString *st = [NSString stringWithFormat:@"￥%.2f", [pdata.price floatValue]];
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:st];
    [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15.0] range:NSMakeRange(0, 1)];
    [str addAttribute:NSFontAttributeName value:[UIFont fontWithName:kAkzidenzGroteskBQ size:28.0] range:NSMakeRange(1, st.length-4)];
    _priceL.attributedText = str;
    
    [_inventoryL setText:[NSString stringWithFormat:@"库存%@件", pdata.stock]];
}

@end
