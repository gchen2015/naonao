//
//  OrderInstructionsCell.m
//  Naonao
//
//  Created by 刘敏 on 16/3/31.
//  Copyright © 2016年 深圳市轩腾华兴科技开发有限公司. All rights reserved.
//

#import "OrderInstructionsCell.h"

@interface OrderInstructionsCell ()

@property (nonatomic, weak) UILabel *orderNoL;
@property (nonatomic, weak) UILabel *timeL;

@end

@implementation OrderInstructionsCell

+ (OrderInstructionsCell *)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"OrderStateCell";
    
    OrderInstructionsCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[OrderInstructionsCell alloc ] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
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
    UILabel *LA = [[UILabel alloc] initWithFrame:CGRectMake(14, 15, 80, 16)];
    [LA setText:@"订单编号："];
    [LA setTextColor:BLACK_COLOR];
    [LA setFont:[UIFont systemFontOfSize:14.0]];
    [self.contentView addSubview:LA];

    UILabel *LB = [[UILabel alloc] initWithFrame:CGRectMake(14, 40, 80, 16)];
    [LB setText:@"下单时间："];
    [LB setTextColor:BLACK_COLOR];
    [LB setFont:[UIFont systemFontOfSize:14.0]];
    [self.contentView addSubview:LB];
    
    UILabel *orderNoL = [[UILabel alloc] initWithFrame:CGRectMake(84, 15, 200, 16)];
    _orderNoL = orderNoL;
    [_orderNoL setTextColor:BLACK_COLOR];
    [_orderNoL setFont:[UIFont systemFontOfSize:14.0]];
    [self.contentView addSubview:_orderNoL];
    
    UILabel *timeL = [[UILabel alloc] initWithFrame:CGRectMake(84, 40, 200, 16)];
    _timeL = timeL;
    [_timeL setTextColor:BLACK_COLOR];
    [_timeL setFont:[UIFont systemFontOfSize:14.0]];
    [self.contentView addSubview:_timeL];
}


- (void)setCellWithOrderTotalCellInfo:(OrderDetails *)oData
{
    [_orderNoL setText:oData.order_no];
    [_timeL setText:oData.create_time];
}

@end
