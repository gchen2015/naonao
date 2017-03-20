//
//  GoodsNameCell.m
//  Naonao
//
//  Created by 刘敏 on 16/3/17.
//  Copyright © 2016年 深圳市轩腾华兴科技开发有限公司. All rights reserved.
//

#import "GoodsNameCell.h"

@interface GoodsNameCell ()

@property (nonatomic, weak) UILabel *titLabel;
@property (nonatomic, weak) UILabel *priceLabel;        //价格
@property (nonatomic, weak) UILabel *oPriceLabel;       //原价

@end

@implementation GoodsNameCell

+ (GoodsNameCell *)cellWithTableView:(UITableView *)tableView{
    static NSString *ID = @"GoodsNameCell";
    
    GoodsNameCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[GoodsNameCell alloc ] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
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

- (void)setUpChildView
{
    
    UILabel *titLabel = [[UILabel alloc] initWithFrame:CGRectMake(14, 20, SCREEN_WIDTH-28, 20)];
    _titLabel = titLabel;
    [_titLabel setTextAlignment:NSTextAlignmentCenter];
    [_titLabel setFont:[UIFont systemFontOfSize:16.0]];
    [_titLabel setTextColor:[UIColor colorWithHex:0x595757 alpha:0.9]];
    [self.contentView addSubview:_titLabel];
    
    //价格
    UILabel *priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(14, 50, SCREEN_WIDTH-28, 20)];
    _priceLabel = priceLabel;
    [_priceLabel setTextAlignment:NSTextAlignmentCenter];
    [_priceLabel setTextColor:PINK_COLOR];
    [_priceLabel setFont:[UIFont systemFontOfSize:17.0]];
    [self.contentView addSubview:_priceLabel];
    
    //原价
    UILabel *oPriceLabel = [[UILabel alloc] initWithFrame:CGRectMake(14, 75, SCREEN_WIDTH-28, 20)];
    _oPriceLabel = oPriceLabel;
    [_oPriceLabel setTextAlignment:NSTextAlignmentCenter];
    [self.contentView addSubview:_oPriceLabel];
    
    UILabel *lineV = [[UILabel alloc] initWithFrame:CGRectMake(14, 114.5, SCREEN_WIDTH-28, 0.5)];
    [lineV setBackgroundColor:[UIColor colorWithWhite:0.8 alpha:1]];
    [self.contentView addSubview:lineV];
}

- (void)setCellWithCellInfo:(GoodsInfo *)mInfo
{
    [_titLabel setText:mInfo.mTitle];
    [_priceLabel setText:[NSString stringWithFormat:@"￥%@", mInfo.price]];

    NSAttributedString *attrStr = [[NSAttributedString alloc]initWithString:[NSString stringWithFormat:@"￥%@", mInfo.originalPrice]
                                  attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13.0],
                                               NSForegroundColorAttributeName:[UIColor colorWithWhite:0.8 alpha:1],
                                               NSStrikethroughStyleAttributeName:@(NSUnderlineStyleSingle|NSUnderlinePatternSolid),
                                               NSStrikethroughColorAttributeName:[UIColor colorWithWhite:0.76 alpha:1]}];
    
    _oPriceLabel.attributedText = attrStr;
    
}


@end
