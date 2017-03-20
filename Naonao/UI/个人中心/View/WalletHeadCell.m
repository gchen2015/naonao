//
//  WalletHeadCell.m
//  Naonao
//
//  Created by 刘敏 on 16/5/16.
//  Copyright © 2016年 深圳市轩腾华兴科技开发有限公司. All rights reserved.
//

#import "WalletHeadCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "UserLogic.h"

@interface WalletHeadCell ()

@property (nonatomic, weak) UILabel *balanceL;      //账户余额
@property (nonatomic, weak) UILabel *amountL;       //总金额

@property (nonatomic, weak) UILabel *withdrawalL;

@end

@implementation WalletHeadCell

+ (WalletHeadCell *)cellWithTableView:(UITableView *)tableView{
    static NSString *ID = @"WalletHeadCell";
    
    WalletHeadCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[WalletHeadCell alloc ] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setUpChildView];
        [self.contentView setBackgroundColor:PINK_COLOR];
    }
    
    return self;
}

- (void)setUpChildView{
    
    //标题
    UILabel *titLA = [[UILabel alloc] initWithFrame:CGRectMake(15, 15, 120, 24)];
    [titLA setText:@"账户余额 （元）"];
    [titLA setTextColor:[UIColor whiteColor]];
    [titLA setFont:[UIFont systemFontOfSize:14.0]];
    [self.contentView addSubview:titLA];
    
    
    UILabel *balanceL = [[UILabel alloc] initWithFrame:CGRectMake(15, 36, 300, 60)];
    _balanceL = balanceL;
    [_balanceL setTextColor:[UIColor whiteColor]];
    [_balanceL setFont:[UIFont systemFontOfSize:56.0]];
    
    [self.contentView addSubview:_balanceL];
    
    //分割线
    UILabel *lineV = [[UILabel alloc] initWithFrame:CGRectMake(15, 100, SCREEN_WIDTH - 15, 0.5)];
    [lineV setBackgroundColor:[UIColor colorWithWhite:0.90 alpha:0.5]];
    [self.contentView addSubview:lineV];
    
    //头像
    UIImageView *headV = [[UIImageView alloc] initWithFrame:CGRectMake(15, 114, 30, 30)];
    [headV sd_setImageWithURL:[NSURL URLWithString:[UserLogic sharedInstance].user.basic.avatarUrl] placeholderImage:[UIImage imageNamed:@"default_avatar_large.png"]];
    headV.layer.cornerRadius = CGRectGetWidth(headV.frame)/2; //设置那个圆角的有多圆
    headV.layer.masksToBounds = YES;  //设为NO去试试
    headV.layer.borderColor = LIGHT_BLACK_COLOR.CGColor;
    headV.layer.borderWidth = 0.4;
    [self.contentView addSubview:headV];
    
    //总共收益
    UILabel *amountL = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(headV.frame)+10, 114, 200, CGRectGetWidth(headV.frame))];
    _amountL = amountL;
    [_amountL setFont:[UIFont systemFontOfSize:13.0]];
    [_amountL setTextColor:[UIColor colorWithWhite:1.0 alpha:0.8]];
    
    [self.contentView addSubview:_amountL];
    
    
    UIImageView *rightV = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-25, 122, 10, 14)];
    [rightV setImage:[UIImage imageNamed:@"arrow_icon.png"]];
    [self.contentView addSubview:rightV];
    
    
    UILabel *withdrawalL = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 190, 114, 160, 30)];
    _withdrawalL = withdrawalL;
    [_withdrawalL setFont:[UIFont systemFontOfSize:14.0]];
    [_withdrawalL setTextColor:[UIColor colorWithWhite:1.0 alpha:0.8]];
    [_withdrawalL setTextAlignment:NSTextAlignmentRight];
    [self.contentView addSubview:_withdrawalL];
    
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 100, SCREEN_WIDTH, 60)];
    [btn addTarget:self action:@selector(btnTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:btn];
}

- (void)setCellWithCellInfo:(WithdrawModel *)md
{
    //账户余额
    [_balanceL setText:[NSString stringWithFormat:@"%.02f", [md.free floatValue]]];
    //总共收益
    [_amountL setText:[NSString stringWithFormat:@"总共收益：%.02f", [md.total floatValue]]];
    
    [_withdrawalL setText:@"提现"];
    
}


- (void)btnTapped:(id)sender
{
    if (_delegate && [_delegate respondsToSelector:@selector(jumpWithdrawView)]) {
        [_delegate jumpWithdrawView];
    }
}


@end
