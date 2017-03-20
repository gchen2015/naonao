//
//  BuyyerShowCell.m
//  Naonao
//
//  Created by 刘敏 on 2016/9/30.
//  Copyright © 2016年 深圳市轩腾华兴科技开发有限公司. All rights reserved.
//

#import "BuyyerShowCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import <SDWebImage/UIButton+WebCache.h>

@interface BuyyerShowCell ()

@property (nonatomic, weak) UIImageView *bgView;
@property (nonatomic, weak) UIImageView *goodV;

@property (nonatomic, weak) UILabel *nameL;
@property (nonatomic, weak) UILabel *priceL;

@end

@implementation BuyyerShowCell

+ (BuyyerShowCell *)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"BuyyerShowCell";
    
    BuyyerShowCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[BuyyerShowCell alloc ] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
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

- (void)setUpChildView{
    UIImageView *bgView = [[UIImageView alloc] initWithFrame:CGRectMake(14, 10, SCREEN_WIDTH-28, 60)];
    _bgView = bgView;
    [_bgView setImage:[UIImage imageNamed:@"dotted_line_bg.png"]];
    [self addSubview:_bgView];
    _bgView.userInteractionEnabled = YES;
    
    //添加点击事件
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageActiondo:)];
    [_bgView addGestureRecognizer:tapGesture];
    [self addSubview:_bgView];
    
    
    UIImageView *goodV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 60, 60)];
    _goodV = goodV;
    //图片填充方式
    [_goodV setContentMode:UIViewContentModeScaleAspectFill];
    _goodV.layer.masksToBounds = YES;
    [_bgView addSubview:_goodV];
    
    
    UILabel *nameL = [[UILabel alloc] initWithFrame:CGRectMake(70, 2, _bgView.width - 80, 16)];
    _nameL = nameL;
    [_nameL setFont:[UIFont systemFontOfSize:13.0]];
    [_nameL setTextColor:BLACK_COLOR];
    [_bgView addSubview:_nameL];
    

    UILabel *priceL = [[UILabel alloc] initWithFrame:CGRectMake(70, 38, _bgView.width - 80, 24)];
    _priceL = priceL;
    [_priceL setFont:[UIFont fontWithName:kAkzidenzGroteskBQ size:16.0]];
    [_priceL setTextColor:PINK_COLOR];
    [_bgView addSubview:_priceL];

}


- (void)setCellWithCellInfo:(ShowModel *)mInfo
{
    [_goodV sd_setImageWithURL:[NSURL URLWithString:[mInfo.product.imageURL smallHead]] placeholderImage:[UIImage imageNamed:@"default_image.png"]];
    [_nameL setText:mInfo.product.proName];
    
    //单价
    NSString *price = [NSString stringWithFormat:@"￥%.2f", [mInfo.product.price floatValue]];
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:price];
    [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14.0] range:NSMakeRange(0, 1)];
    [str addAttribute:NSFontAttributeName value:[UIFont fontWithName:kAkzidenzGroteskBQ size:22.0] range:NSMakeRange(1, price.length-4)];
    _priceL.attributedText = str;
    
    //间隔为5
    int G_W = 5;
    CGFloat mW = (SCREEN_WIDTH - 28 - 3*G_W)/4;
    int i = 0;
    
    //每行放3个
    for (NSString *imageUrl in mInfo.imgArray) {
        int x_o = i/4;
        int y_o = i%4;
        
        UIButton *mv = [[UIButton alloc] initWithFrame:CGRectMake(14+(mW+G_W)*y_o, CGRectGetMaxY(_bgView.frame) + 14 + (mW+G_W)*x_o, mW, mW)];
        CLog(@"%@", [imageUrl smallHead]);
        
        [mv sd_setBackgroundImageWithURL:[NSURL URLWithString:[imageUrl middleImage]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"default_image.png"]];
        [mv setTag:i+1000];
        //图片填充方式
        [mv setContentMode:UIViewContentModeScaleAspectFill];
        mv.layer.masksToBounds = YES;
        [mv addTarget:self action:@selector(buttonTapped:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:mv];
        
        i++;
    }
}

- (void)buttonTapped:(UIButton *)sender{
    if (_delegate && [_delegate respondsToSelector:@selector(buycell:clickImageIndex:cellWithRow:)]) {
        [_delegate buycell:self clickImageIndex:(sender.tag-1000) cellWithRow:_mRow];
    }
}


- (void)imageActiondo:(UITapGestureRecognizer *)tapGesture
{
    if (_delegate && [_delegate respondsToSelector:@selector(buycell:cellWithRow:)]) {
        [_delegate buycell:self cellWithRow:_mRow];
    }
}

@end
