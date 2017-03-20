//
//  OrderTotalCell.m
//  Naonao
//
//  Created by 刘敏 on 16/3/27.
//  Copyright © 2016年 深圳市轩腾华兴科技开发有限公司. All rights reserved.
//

#import "OrderTotalCell.h"
#import "UILabel+Extension.h"

@interface OrderTotalCell ()

@property (nonatomic, weak) UILabel *totalLabel;

@property (nonatomic, weak) UIButton *leftBtn;
@property (nonatomic, weak) UIButton *rightBtn;

@property (nonatomic, strong) OrderModel *mData;

@end

@implementation OrderTotalCell

+ (OrderTotalCell *)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"OrderTotalCell";
    
    OrderTotalCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    //删除重用
    NSArray *subviews = [[NSArray alloc] initWithArray:cell.contentView.subviews];
    for (UIView *subview in subviews) {
        [subview removeFromSuperview];
    }
    
    cell = [[OrderTotalCell alloc ] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (void)setLineNO:(NSUInteger)lineNO
{
    _lineNO = lineNO;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setUpChildView];
    }
    
    return self;
}

- (void)setUpChildView
{
    //共付款
    UILabel *mL = [[UILabel alloc] initWithTitle:@"共付款:" textColor:nil];
    [mL setFrame:CGRectMake(14, 13, 80, 25)];
    [mL setFont:[UIFont systemFontOfSize:13.0]];
    [self.contentView addSubview:mL];
    
    UILabel *totalLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 10, 160, 25)];
    _totalLabel = totalLabel;
    [_totalLabel setFont:[UIFont fontWithName:kAkzidenzGroteskBQ size:15.0]];
    [_totalLabel setTextColor:PINK_COLOR];
    [self.contentView addSubview:_totalLabel];
    
    //rightBtn
    UIButton *rightBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 80, 8, 66, 29)];
    _rightBtn = rightBtn;
    [_rightBtn.titleLabel setFont:[UIFont systemFontOfSize:13.0]];
    //圆角
    _rightBtn.layer.cornerRadius = 3.0;
    _rightBtn.layer.masksToBounds = YES;  //设为NO去试试
    [_rightBtn addTarget:self action:@selector(rightBtnTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_rightBtn];
    
    //leftBtn
    UIButton *leftBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 156, 8, 66, 29)];
    _leftBtn = leftBtn;
    [_leftBtn.titleLabel setFont:[UIFont systemFontOfSize:13.0]];
    //圆角
    _leftBtn.layer.cornerRadius = 3.0;
    _leftBtn.layer.masksToBounds = YES;  //设为NO去试试
    [_leftBtn addTarget:self action:@selector(leftBtnTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_leftBtn];
}


- (void)setCellWithOrderTotalCellInfo:(OrderModel *)oData
{
    _mData = oData;
    
    NSString *st = [NSString stringWithFormat:@"￥%.2f", [oData.totalPrice floatValue]];
    
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:st];
    [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:13.0] range:NSMakeRange(0, 1)];
    [str addAttribute:NSFontAttributeName value:[UIFont fontWithName:kAkzidenzGroteskBQ size:24.0] range:NSMakeRange(1, st.length-4)];
    _totalLabel.attributedText = str;


    if ([_mData.type integerValue] == 1){
        switch ([_mData.orderStatus integerValue]) {
                
            case KOrder_WaitingPayment:         //待支付
                [_rightBtn setTitle:@"付款" forState:UIControlStateNormal];
                [_rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                [_rightBtn setBackgroundImage:[UIImage imageNamed:@"btn_pink.png"] forState:UIControlStateNormal];
                
                _leftBtn.layer.borderWidth = 1;
                _leftBtn.layer.borderColor = BLACK_COLOR.CGColor;
                [_leftBtn setTitle:@"取消订单" forState:UIControlStateNormal];
                [_leftBtn setTitleColor:BLACK_COLOR forState:UIControlStateNormal];
                [_leftBtn setBackgroundImage:[UIImage imageNamed:@"btn_whitle_1.png"] forState:UIControlStateNormal];
                
                break;
                
            case KOrder_Cancel:                 //已取消
                _rightBtn.layer.borderWidth = 1;
                _rightBtn.layer.borderColor = BLACK_COLOR.CGColor;
                [_rightBtn setTitle:@"删除订单" forState:UIControlStateNormal];
                [_rightBtn setTitleColor:BLACK_COLOR forState:UIControlStateNormal];
                [_rightBtn setBackgroundImage:[UIImage imageNamed:@"btn_whitle_1.png"] forState:UIControlStateNormal];
                
                [_leftBtn setTitle:@"交易关闭" forState:UIControlStateNormal];
                [_leftBtn setTitleColor:BLACK_COLOR forState:UIControlStateNormal];
                [_leftBtn setEnabled:NO];
                break;
                
                
            case KOrder_PaySuccess:             //支付成功
                _rightBtn.layer.borderWidth = 1;
                _rightBtn.layer.borderColor = YELLOW_DARK.CGColor;
                [_rightBtn setTitle:@"确认收货" forState:UIControlStateNormal];
                [_rightBtn setTitleColor:YELLOW_DARK forState:UIControlStateNormal];
                [_rightBtn setBackgroundImage:[UIImage imageNamed:@"btn_whitle_1.png"] forState:UIControlStateNormal];
                
                _leftBtn.layer.borderWidth = 1;
                _leftBtn.layer.borderColor = BLACK_COLOR.CGColor;
                [_leftBtn setTitle:@"查看物流" forState:UIControlStateNormal];
                [_leftBtn setTitleColor:BLACK_COLOR forState:UIControlStateNormal];
                [_leftBtn setBackgroundImage:[UIImage imageNamed:@"btn_whitle_1.png"] forState:UIControlStateNormal];
                
                break;
                
            case KOrder_Signed:                 //已收货
                _rightBtn.layer.borderWidth = 1;
                _rightBtn.layer.borderColor = YELLOW_DARK.CGColor;
                [_rightBtn setTitle:@"评价" forState:UIControlStateNormal];
                [_rightBtn setTitleColor:YELLOW_DARK forState:UIControlStateNormal];
                [_rightBtn setBackgroundImage:[UIImage imageNamed:@"btn_whitle_1.png"] forState:UIControlStateNormal];
                
                
                _leftBtn.layer.borderWidth = 1;
                _leftBtn.layer.borderColor = BLACK_COLOR.CGColor;
                [_leftBtn setTitle:@"查看物流" forState:UIControlStateNormal];
                [_leftBtn setTitleColor:BLACK_COLOR forState:UIControlStateNormal];
                [_leftBtn setBackgroundImage:[UIImage imageNamed:@"btn_whitle_1.png"] forState:UIControlStateNormal];
                
                break;
                
            case KOrder_HaveEvaluation:         //已评价
                [_leftBtn setHidden:YES];
                
                [_rightBtn setTitle:@"交易完成" forState:UIControlStateNormal];
                [_rightBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
                [_rightBtn setTitleColor:BLACK_COLOR forState:UIControlStateNormal];
                [_rightBtn setEnabled:NO];

                break;
                
            default:
                break;
        }
    }
    else if ([_mData.type integerValue] == 2){
        switch ([_mData.orderStatus integerValue]) {
            case KOrder_WaitingPayment:         //待支付
                [_rightBtn setTitle:@"付款" forState:UIControlStateNormal];
                [_rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                [_rightBtn setBackgroundImage:[UIImage imageNamed:@"btn_pink.png"] forState:UIControlStateNormal];
                
                _leftBtn.layer.borderWidth = 1;
                _leftBtn.layer.borderColor = BLACK_COLOR.CGColor;
                [_leftBtn setTitle:@"取消订单" forState:UIControlStateNormal];
                [_leftBtn setTitleColor:BLACK_COLOR forState:UIControlStateNormal];
                [_leftBtn setBackgroundImage:[UIImage imageNamed:@"btn_whitle_1.png"] forState:UIControlStateNormal];
                
                break;
                
            case KOrder_Cancel:                 //已取消
                _rightBtn.layer.borderWidth = 1;
                _rightBtn.layer.borderColor = BLACK_COLOR.CGColor;
                [_rightBtn setTitle:@"删除订单" forState:UIControlStateNormal];
                [_rightBtn setTitleColor:BLACK_COLOR forState:UIControlStateNormal];
                [_rightBtn setBackgroundImage:[UIImage imageNamed:@"btn_whitle_1.png"] forState:UIControlStateNormal];
                
                [_leftBtn setTitle:@"交易关闭" forState:UIControlStateNormal];
                [_leftBtn setTitleColor:BLACK_COLOR forState:UIControlStateNormal];
                [_leftBtn setEnabled:NO];
                break;
                
                
            case KOrder_PaySuccess:             //支付成功
                [_leftBtn setHidden:YES];
                
                [_rightBtn setTitle:@"等待上门" forState:UIControlStateNormal];
                [_rightBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
                [_rightBtn setTitleColor:BLACK_COLOR forState:UIControlStateNormal];
                [_rightBtn setEnabled:NO];
                
                break;
                
            case KOrder_Signed:                 //已收货
                _rightBtn.layer.borderWidth = 1;
                _rightBtn.layer.borderColor = YELLOW_DARK.CGColor;
                [_rightBtn setTitle:@"评价" forState:UIControlStateNormal];
                [_rightBtn setTitleColor:YELLOW_DARK forState:UIControlStateNormal];
                [_rightBtn setBackgroundImage:[UIImage imageNamed:@"btn_whitle_1.png"] forState:UIControlStateNormal];
                
                [_leftBtn setHidden:YES];

                break;
                
            case KOrder_HaveEvaluation:         //已评价
                [_leftBtn setHidden:YES];
                
                [_rightBtn setTitle:@"交易完成" forState:UIControlStateNormal];
                [_rightBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
                [_rightBtn setTitleColor:BLACK_COLOR forState:UIControlStateNormal];
                [_rightBtn setEnabled:NO];
                
                break;
                
            default:
                break;
        }
    }
}

- (void)rightBtnTapped:(UIButton *)sender
{
    OrderBtnType mType;
    if ([_mData.orderStatus integerValue] == KOrder_WaitingPayment) {
        //付款
        mType = K_ORDER_PAY;
    }
    else if ([_mData.orderStatus integerValue] == KOrder_Cancel)
    {
        //删除订单
        AlertWithTitleAndMessageAndUnitsToTag(@"确定删除订单", @"订单删除之后，在手机上将不可见", self, @"确定", nil, 0x128);
        return;
    }
    else if ([_mData.orderStatus integerValue] == KOrder_PaySuccess)
    {
        //确认收货
        mType = K_ORDER_GOODS;
    }
    else if ([_mData.orderStatus integerValue] == KOrder_Signed)
    {
        //评价
        mType = K_ORDER_EVALUATION;
    }
    else{
        return;
    }
    
    if (_delegate && [_delegate respondsToSelector:@selector(orderTotalCellWithbuttonType:cellWithOrderID:lineNO:)]) {
        [_delegate orderTotalCellWithbuttonType:mType cellWithOrderID:_mData lineNO:_lineNO];
    }
}


//左按钮
- (void)leftBtnTapped:(UIButton *)sender
{
    
    OrderBtnType mType;
    if ([_mData.orderStatus integerValue] == KOrder_WaitingPayment) {
        //取消订单
        AlertWithTitleAndMessageAndUnitsToTag(@"确定取消该订单？", @"取消订单之后，交易将关闭", self, @"确定", nil, 0x256);
        return;
    }
    else if ([_mData.orderStatus integerValue] == KOrder_PaySuccess || [_mData.orderStatus integerValue] == KOrder_Signed)
    {
        //查看物流
        mType = K_ORDER_LOGISTICS;
    }
    else{
        return;
    }
    
    if (_delegate && [_delegate respondsToSelector:@selector(orderTotalCellWithbuttonType:cellWithOrderID:lineNO:)]) {
        [_delegate orderTotalCellWithbuttonType:mType cellWithOrderID:_mData lineNO:_lineNO];
    }

}


#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        OrderBtnType mType = -1;
        
        if(alertView.tag == 0x128)
        {
            //删除
            mType = K_ORDER_DELETE;
        }
        else if(alertView.tag == 0x256)
        {
            //取消订单
            mType = K_ORDER_CANCEL;
        }
        
        
        if (_delegate && [_delegate respondsToSelector:@selector(orderTotalCellWithbuttonType:cellWithOrderID:lineNO:)]) {
            [_delegate orderTotalCellWithbuttonType:mType cellWithOrderID:_mData lineNO:_lineNO];
        }
    }
}

@end
