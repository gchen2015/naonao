//
//  OrderAffiliatedCell.m
//  Naonao
//
//  Created by 刘敏 on 16/3/20.
//  Copyright © 2016年 深圳市轩腾华兴科技开发有限公司. All rights reserved.
//

#import "OrderAffiliatedCell.h"

@interface OrderAffiliatedCell ()

@property (nonatomic, weak) UILabel *LA;
@property (nonatomic, weak) UILabel *LB;
@property (nonatomic, weak) UILabel *LC;

@end


@implementation OrderAffiliatedCell

+ (OrderAffiliatedCell *)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"OrderAffiliatedCell";
    
    OrderAffiliatedCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[OrderAffiliatedCell alloc ] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
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
    
    UILabel *mA = [[UILabel alloc] initWithFrame:CGRectMake(14, 20, 80, 18)];
    [mA setText:@"运费"];
    [mA setTextColor:BLACK_COLOR];
    [mA setFont:[UIFont systemFontOfSize:13.0]];
    [self addSubview:mA];
    
    UILabel *LA = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 114, 20, 100, 18)];
    _LA = LA;
    [_LA setTextColor:LIGHT_BLACK_COLOR];
    [_LA setTextAlignment:NSTextAlignmentRight];
    [_LA setText:@"￥0.00"];
    [_LA setFont:[UIFont systemFontOfSize:13.0]];
    [self addSubview:_LA];

    UILabel *mB = [[UILabel alloc] initWithFrame:CGRectMake(14, 48, 80, 18)];
    [mB setText:@"税金"];
    [mB setTextColor:BLACK_COLOR];
    [mB setFont:[UIFont systemFontOfSize:13.0]];
    [self addSubview:mB];
    
    UILabel *LB = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 114, 48, 100, 18)];
    _LB = LB;
    [_LB setTextColor:LIGHT_BLACK_COLOR];
    [_LB setTextAlignment:NSTextAlignmentRight];
    [_LB setText:@"￥0.00"];
    [_LB setFont:[UIFont systemFontOfSize:13.0]];
    [self addSubview:_LB];
    
    UILabel *mC = [[UILabel alloc] initWithFrame:CGRectMake(14, 76, 130, 18)];
    [mC setText:@"合计（含运费）"];
    [mC setTextColor:BLACK_COLOR];
    [mC setFont:[UIFont systemFontOfSize:13.0]];
    [self addSubview:mC];
    
    UILabel *LC = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 114, 76, 100, 18)];
    _LC = LC;
    [_LC setTextColor:PINK_COLOR];
    [_LC setTextAlignment:NSTextAlignmentRight];
    
    [_LC setFont:[UIFont fontWithName:kAkzidenzGroteskBQ size:14.0]];
    [self addSubview:_LC];
}

- (void)setCellWithCellInfo:(CGFloat)combinedAmount
{
    NSString *st = [NSString stringWithFormat:@"￥%.2f", combinedAmount];
    
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:st];
    [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12.0] range:NSMakeRange(0, 1)];
    [str addAttribute:NSFontAttributeName value:[UIFont fontWithName:kAkzidenzGroteskBQ size:21.0] range:NSMakeRange(1, st.length-4)];
    _LC.attributedText = str;
}

@end
