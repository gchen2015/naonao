//
//  OrderStateCell.m
//  Naonao
//
//  Created by 刘敏 on 16/3/30.
//  Copyright © 2016年 深圳市轩腾华兴科技开发有限公司. All rights reserved.
//

#import "OrderStateCell.h"
#import "MSWeakTimer.h"
#import "TimeUtil.h"

@interface OrderStateCell ()

@property (nonatomic, weak) UIView *statusView;
@property (nonatomic, weak) UIImageView *imageV;
@property (nonatomic, weak) UILabel *stateL;
@property (nonatomic, weak) UILabel *timeL;

@property (nonatomic, strong) MSWeakTimer *timeToStart;         //计时器
@property (nonatomic, assign) NSInteger timeNum;                //计时器的时间

@end

@implementation OrderStateCell

+ (OrderStateCell *)cellWithTableView:(UITableView *)tableView {
    
    static NSString *ID = @"OrderStateCell";
    
    OrderStateCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    //删除重用
    NSArray *subviews = [[NSArray alloc] initWithArray:cell.contentView.subviews];
    for (UIView *subview in subviews) {
        [subview removeFromSuperview];
    }
    
    cell = [[OrderStateCell alloc ] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
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
    UIView *statusView = [[UIView alloc] initWithFrame:CGRectZero];
    _statusView = statusView;
    [self.contentView addSubview:_statusView];
    
    UIImageView *imageV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_order_note.png"]];
    [imageV setFrame:CGRectMake(0, 0, 20, 20)];
    [_statusView addSubview:imageV];
    
    UILabel *stateL = [[UILabel alloc] initWithFrame:CGRectZero];
    _stateL = stateL;
    [_stateL setTextAlignment:NSTextAlignmentCenter];
    [_stateL setTextColor:BLACK_COLOR];
    [_stateL setFont:[UIFont systemFontOfSize:15.0]];
    [_statusView addSubview:_stateL];
}

- (void)setCellWithOrderTotalCellInfo:(OrderDetails *)oData
{
    NSString *st = nil;
    NSUInteger tH = 20.0;
    //等待支付（增加计时器）
    if ([oData.status integerValue] == KOrder_WaitingPayment) {
        st = @"订单状态：待支付";
        
        UILabel *timeL = [[UILabel alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-200)/2, 44, 200, 16)];
        _timeL = timeL;
        [_timeL setTextAlignment:NSTextAlignmentCenter];
        [_timeL setTextColor:PINK_COLOR];
        [_timeL setFont:[UIFont systemFontOfSize:12.0]];
        [self.contentView addSubview:_timeL];
        
        //开启计时器
        [self startTimer:[oData.remain_sec integerValue]];
    }
    else
    {
        if ([oData.status integerValue] == KOrder_Cancel)
        {
            st = @"订单状态：交易关闭";
        }
        if ([oData.status integerValue] == KOrder_PaySuccess)
        {
            if ([oData.type integerValue] == 2){
               st = @"订单状态：等待上门";
            }
            else
                st = @"订单状态：等待收货";
        }
        if ([oData.status integerValue] == KOrder_Signed || [oData.status integerValue] == KOrder_HaveEvaluation)
        {
            st = @"订单状态：交易成功";
        }
        
        tH = 28.0;
    }

    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:st];
    [str addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:19] range:NSMakeRange(5, str.length-5)];
    [str addAttribute:NSForegroundColorAttributeName value:PINK_COLOR range:NSMakeRange(5, str.length-5)];
    [_stateL setAttributedText:str];
    
    //计算宽度
    CGFloat mW = [_stateL sizeThatFits:CGSizeMake(CGFLOAT_MAX, 20)].width;
    [_stateL setFrame:CGRectMake(30, 0, mW, 20)];
    [_statusView setFrame:CGRectMake((SCREEN_WIDTH - CGRectGetMaxX(_stateL.frame))/2, tH, CGRectGetMaxX(_stateL.frame), 20)];
}

#pragma mark 计时器
/*********************************  计时器  *******************************/
- (void)updateOrderState {
    [_timeToStart invalidate];
    
    [_timeL removeFromSuperview];
    
    NSString *st = @"订单状态：交易关闭";
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:st];
    [str addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:19] range:NSMakeRange(5, str.length-5)];
    [str addAttribute:NSForegroundColorAttributeName value:PINK_COLOR range:NSMakeRange(5, str.length-5)];
    [_stateL setAttributedText:str];
    
    [_stateL setFrame:CGRectMake((SCREEN_WIDTH-200)/2, 28, 200, 20)];
    
}

- (void)startTimer:(NSInteger)second{
    
    [_timeL setText:[NSString stringWithFormat:@"还剩 %@", [TimeUtil timeFormatted:second]]];
    
    _timeNum = second;
    _timeToStart = [MSWeakTimer scheduledTimerWithTimeInterval:1
                                                        target:self
                                                      selector:@selector(timeCountAfterGetVerifyCodePressed:)
                                                      userInfo:nil
                                                       repeats:YES
                                                 dispatchQueue:dispatch_get_main_queue()];
}

- (void)timeCountAfterGetVerifyCodePressed:(id)sender {
    _timeNum--;
    [UIView setAnimationsEnabled:NO];
    
    [_timeL setText:[NSString stringWithFormat:@"还剩 %@", [TimeUtil timeFormatted:_timeNum]]];
    [_timeL layoutIfNeeded];
    [UIView setAnimationsEnabled:YES];
    
    
    if (_timeNum <= 0) {
        //更改订单状态
        [self updateOrderState];
    }
}




@end
