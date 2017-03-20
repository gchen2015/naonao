//
//  WalletCell.m
//  Naonao
//
//  Created by 刘敏 on 16/5/17.
//  Copyright © 2016年 深圳市轩腾华兴科技开发有限公司. All rights reserved.
//

#import "WalletCell.h"
#import <SDWebImage/UIImageView+WebCache.h>


@interface WalletCell ()

@property (nonatomic, weak) UIImageView *headV;
@property (nonatomic, weak) UILabel *nameL;               //商品名称

@property (nonatomic, weak) UILabel *desL;
@property (nonatomic, weak) UILabel *todayL;

@end


@implementation WalletCell


+ (WalletCell *)cellWithTableView:(UITableView *)tableView{
    static NSString *ID = @"WalletCell";
    
    WalletCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[WalletCell alloc ] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
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
    UIImageView *headV = [[UIImageView alloc] initWithFrame:CGRectMake(14, 10, 60, 60)];
    _headV = headV;
    //图像填充方式
    [headV setContentMode:UIViewContentModeScaleAspectFill];
    headV.layer.masksToBounds = YES;
    [self.contentView addSubview:_headV];
    
    UILabel *nameL = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_headV.frame) +10, 10, SCREEN_WIDTH - CGRectGetMaxX(_headV.frame) - 22, 18)];
    _nameL = nameL;
    [_nameL setFont:[UIFont systemFontOfSize:13.0]];
    [_nameL setTextColor:PINK_COLOR];
    [self.contentView addSubview:_nameL];
    
    UILabel *desL = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_headV.frame) +10, 33, SCREEN_WIDTH - CGRectGetMaxX(_headV.frame) - 22, 18)];
    _desL = desL;
    [_desL setFont:[UIFont systemFontOfSize:15.0]];
    [_desL setTextColor:BLACK_COLOR];
    [self.contentView addSubview:_desL];
    
    UILabel *todayL = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_headV.frame) +10, 55, SCREEN_WIDTH - CGRectGetMaxX(_headV.frame) - 22, 18)];
    _todayL = todayL;
    [_todayL setFont:[UIFont systemFontOfSize:11.0]];
    [_todayL setTextColor:BLACK_COLOR];
    [self.contentView addSubview:_todayL];
    
}


- (void)setCellWithCellInfo:(WithdrawRecord *)record
{
    [_headV sd_setImageWithURL:[NSURL URLWithString:record.product.productImg] placeholderImage:[UIImage imageNamed:@"default_image.png"]];
    [_nameL setText:record.product.productTitle];
    
    
    NSString *sk = [NSString stringWithFormat:@"共被 %@ 人购买，共获得 %@ 元", record.count, record.amount];
    NSMutableAttributedString *strD = [[NSMutableAttributedString alloc] initWithString:sk];
    [strD addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:15.0] range:NSMakeRange(3, [record.count stringValue].length)];
    [strD addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:15.0] range:NSMakeRange(sk.length - [record.amount stringValue].length - 2, [record.amount stringValue].length)];
    _desL.attributedText = strD;
    
    
    //今日新增
    NSString *st = [NSString stringWithFormat:@"今日新增 %@ 单", record.today_pay];
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:st];
    [str addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(5, [record.today_pay stringValue].length)];
    [str addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:12.0] range:NSMakeRange(5, [record.today_pay stringValue].length)];
    _todayL.attributedText = str;
}

@end
