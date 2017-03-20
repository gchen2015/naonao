//
//  PaymentResultCell.m
//  Naonao
//
//  Created by 刘敏 on 16/4/13.
//  Copyright © 2016年 深圳市轩腾华兴科技开发有限公司. All rights reserved.
//

#import "PaymentResultCell.h"

@interface PaymentResultCell ()

@property (nonatomic, weak) UILabel *amountL;

@end


@implementation PaymentResultCell

+ (PaymentResultCell *)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"PaymentResultCell";
    
    PaymentResultCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[PaymentResultCell alloc ] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
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
    
    UILabel *amountL = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 215, 7, 200, 30)];
    _amountL  = amountL;
    [_amountL setTextAlignment:NSTextAlignmentRight];
    [self.contentView addSubview:_amountL];
    
    UIButton *orderButton = [[UIButton alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - 150)/2, 70, 150, 36)];
    [orderButton setTitle:@"查看订单" forState:UIControlStateNormal];
    [orderButton setTitleColor:PINK_COLOR forState:UIControlStateNormal];

    //圆角
    orderButton.layer.cornerRadius = 5; //设置那个圆角的有多圆
    orderButton.layer.masksToBounds = YES;  //设为NO去试试
    orderButton.layer.borderWidth = 1;
    [orderButton.titleLabel setFont:[UIFont systemFontOfSize:15.0]];
    orderButton.layer.borderColor = PINK_COLOR.CGColor;
    [orderButton setBackgroundImage:[UIImage imageNamed:@"btn_whitle_1"] forState:UIControlStateNormal];
    [orderButton setBackgroundImage:[UIImage imageNamed:@"btn_grey"] forState:UIControlStateSelected];
    [orderButton addTarget:self action:@selector(orderButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.contentView addSubview:orderButton];
    
}

- (void)setCellWithCellInfo:(CGFloat)combinedAmount
{
    NSString *st = [NSString stringWithFormat:@"实付款：￥%.2f", combinedAmount];
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:st];
    
    [str addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0, 4)];
    [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15.0] range:NSMakeRange(0, 4)];
    
    [str addAttribute:NSForegroundColorAttributeName value:PINK_COLOR range:NSMakeRange(4, 1)];
    [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15.0] range:NSMakeRange(4, 1)];
    
    [str addAttribute:NSForegroundColorAttributeName value:PINK_COLOR range:NSMakeRange(5, st.length - 5)];
    [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:24.0] range:NSMakeRange(5, st.length - 5)];

    _amountL.attributedText = str;
}

- (void)orderButtonTapped:(id)sender
{
    if (_delegate && [_delegate respondsToSelector:@selector(jumpToNextOrderDetails)]) {
        [_delegate jumpToNextOrderDetails];
    }
}

@end
