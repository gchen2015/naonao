//
//  GoodsOrderCell.m
//  Naonao
//
//  Created by 刘敏 on 16/3/23.
//  Copyright © 2016年 深圳市轩腾华兴科技开发有限公司. All rights reserved.
//

#import "GoodsOrderCell.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface GoodsOrderCell ()

@property (nonatomic, weak) UIImageView *headV;
@property (nonatomic, weak) UILabel *titLabel;
@property (nonatomic, weak) UILabel *skuLabel;
@property (nonatomic, weak) UILabel *priceL;
@property (nonatomic, weak) UILabel *countLabel;

@end

@implementation GoodsOrderCell

+ (GoodsOrderCell *)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"GoodsOrderCell";
    
    GoodsOrderCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[GoodsOrderCell alloc ] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setUpChildView];
    }
    
    return self;
}

- (void)setUpChildView {
    
    UIImageView *headV = [[UIImageView alloc] initWithFrame:CGRectMake(14, 8, 80, 80)];
    _headV = headV;
    //填充方式
    [_headV setContentMode:UIViewContentModeScaleAspectFill];
    _headV.layer.masksToBounds = YES;  //设为NO去试试
    [self.contentView addSubview:_headV];
    
    //标题
    UILabel *titLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _titLabel = titLabel;
    [_titLabel setNumberOfLines:0];
    [_titLabel setFont:[UIFont systemFontOfSize:14.0]];
    [_titLabel setTextColor:LIGHT_BLACK_COLOR];
    [self.contentView addSubview:_titLabel];
    
    //SKU
    UILabel *skuLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _skuLabel = skuLabel;
    [_skuLabel setNumberOfLines:0];
    [_skuLabel setFont:[UIFont systemFontOfSize:13.0]];
    [_skuLabel setTextColor:LIGHT_GARY_COLOR];
    [self.contentView addSubview:_skuLabel];

    //单价
    UILabel *priceL = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-142, CGRectGetMaxY(_headV.frame)-18, 100, 20)];
    _priceL = priceL;
    [_priceL setTextAlignment:NSTextAlignmentRight];
    [_priceL setFont:[UIFont fontWithName:kAkzidenzGroteskBQ size:14.0]];
    [_priceL setTextColor:BLACK_COLOR];
    [self.contentView addSubview:_priceL];
    
    //数量
    UILabel *countLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-54, CGRectGetMaxY(_headV.frame)-17, 40, 20)];
    _countLabel = countLabel;
    [_countLabel setTextAlignment:NSTextAlignmentRight];
    [_countLabel setFont:[UIFont systemFontOfSize:14.0]];
    [_countLabel setTextColor:LIGHT_BLACK_COLOR];
    [self.contentView addSubview:_countLabel];
}

- (void)setCellWithCellInfo:(GoodsOData *)goodsTData
{
    [_headV sd_setImageWithURL:[NSURL URLWithString:[goodsTData.imageURL middleImage]] placeholderImage:[UIImage imageNamed:@"default_image.png"]];
    
    
    [_titLabel setText:goodsTData.proName];
    CGFloat mf = SCREEN_WIDTH - CGRectGetMaxX(_headV.frame)-24;
    CGFloat tH = [_titLabel sizeThatFits:CGSizeMake(mf, MAXFLOAT)].height;
    
    if (tH > 48.0){
        tH = 36.0;
    }
    
    [_titLabel setFrame:CGRectMake(CGRectGetMaxX(_headV.frame)+10, 10, mf, tH)];
    
    
    //SKU
    NSArray *ks = [goodsTData.skuDict allKeys];
    NSArray *ms = [goodsTData.skuDict allValues];
    
    NSMutableString *st = [[NSMutableString alloc] init];
    for (int i = 0; i<ks.count; i++) {
        NSString *s = [NSString stringWithFormat:@"%@：%@     ", [ks objectAtIndex:i], [ms objectAtIndex:i]];
        [st appendString:s];
    }
    
    [_skuLabel setText:st];
    [_skuLabel setFrame:CGRectMake(CGRectGetMaxX(_headV.frame)+10, CGRectGetMaxY(_titLabel.frame)+5, mf, 18)];
    
    //单价
    NSString *price = [NSString stringWithFormat:@"￥%.2f", [goodsTData.price floatValue]];
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:price];
    [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:13.0] range:NSMakeRange(0, 1)];
    [str addAttribute:NSFontAttributeName value:[UIFont fontWithName:kAkzidenzGroteskBQ size:20.0] range:NSMakeRange(1, price.length-4)];
    _priceL.attributedText = str;
    
    //数量
    if ([goodsTData.count integerValue] == 0){
        [_countLabel setText:@"x1"];
    }
    else{
       [_countLabel setText:[NSString stringWithFormat:@"x%@", goodsTData.count]];
    }
}


- (void)setCellWithOrderCellInfo:(SKUOrderModel *)sData
{
    [_headV sd_setImageWithURL:[NSURL URLWithString:[sData.proImg middleImage]] placeholderImage:[UIImage imageNamed:@"default_image.png"]];
    
    [_titLabel setText:sData.proName];
    CGFloat mf = SCREEN_WIDTH - CGRectGetMaxX(_headV.frame)-24;
    CGFloat tH = [_titLabel sizeThatFits:CGSizeMake(mf, MAXFLOAT)].height;
    
    if (tH > 48.0){
        tH = 36.0;
    }
    [_titLabel setFrame:CGRectMake(CGRectGetMaxX(_headV.frame)+10, 10, mf, tH)];
    
    
    //SKU
    NSArray *ks = [sData.skuInfo allKeys];
    NSArray *ms = [sData.skuInfo allValues];
    
    NSMutableString *st = [[NSMutableString alloc] init];
    for (int i = 0; i<ks.count; i++) {
        NSString *s = [NSString stringWithFormat:@"%@：%@     ", [ks objectAtIndex:i], [ms objectAtIndex:i]];
        [st appendString:s];
    }
    
    [_skuLabel setText:st];
    [_skuLabel setFrame:CGRectMake(CGRectGetMaxX(_headV.frame)+10, CGRectGetMaxY(_titLabel.frame)+5, mf, 18)];
    
    //单价
    NSString *price = [NSString stringWithFormat:@"￥%.2f", [sData.price floatValue]];
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:price];
    [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:13.0] range:NSMakeRange(0, 1)];
    [str addAttribute:NSFontAttributeName value:[UIFont fontWithName:kAkzidenzGroteskBQ size:20.0] range:NSMakeRange(1, price.length-4)];
    _priceL.attributedText = str;
    
    //数量
    if ([sData.num integerValue] == 0){
        [_countLabel setText:@"x1"];
    }
    else{
        [_countLabel setText:[NSString stringWithFormat:@"x%@", sData.num]];
    }
}

@end
