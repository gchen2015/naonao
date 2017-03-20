//
//  CouponsCell.m
//  Naonao
//
//  Created by 刘敏 on 16/5/11.
//  Copyright © 2016年 深圳市轩腾华兴科技开发有限公司. All rights reserved.
//

#import "CouponsCell.h"
#import "SHLUILabel.h"

@interface CouponsCell ()
@property (nonatomic, weak) UIImageView *mV;
@property (nonatomic, weak) UILabel *countL;
@property (nonatomic, weak) UILabel *nameL;
@property (nonatomic, weak) UILabel *timeL;


@end

@implementation CouponsCell

+ (CouponsCell *)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"CouponsCell";
    
    CouponsCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[CouponsCell alloc ] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setUpChildView];
        [self.contentView setBackgroundColor:BACKGROUND_GARY_COLOR];
    }
    
    return self;
}

- (void)setUpChildView
{
    UIImageView *mV = [[UIImageView alloc] initWithFrame:CGRectMake(16, 16, SCREEN_WIDTH - 32, 84)];
    _mV = mV;
    [self.contentView addSubview:_mV];
    
    
    UILabel *countL = [[UILabel alloc] initWithFrame:CGRectMake(10, 12, 70, 60)];
    _countL = countL;
    [_countL setTextAlignment:NSTextAlignmentCenter];
    [_countL setTextColor:BLACK_COLOR];
    [mV addSubview:_countL];
    
    
    UILabel *nameL = [[UILabel alloc] initWithFrame:CGRectMake(110, 20, 100, 20)];
    _nameL = nameL;
    [_nameL setFont:[UIFont boldSystemFontOfSize:16.0]];
    [mV addSubview:_nameL];
    
    UILabel *timeL = [[UILabel alloc] initWithFrame:CGRectMake(110, 48, SCREEN_WIDTH - 150, 16)];
    _timeL = timeL;
    [_timeL setTextColor:BLACK_COLOR];
    [_timeL setFont:[UIFont systemFontOfSize:13.0]];
    [mV addSubview:_timeL];
}

- (void)setCellWithCellInfo:(CouponsModel *)cModel
{
    NSString *st = [NSString stringWithFormat:@"%@ 元", cModel.amount];
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:st];
    [str addAttribute:NSFontAttributeName value:[UIFont fontWithName:kAkzidenzGroteskBQ size:38.0] range:NSMakeRange(0, str.length-1)];
    [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:11.0] range:NSMakeRange(str.length-1, 1)];
    _countL.attributedText = str;
    
    //折扣券
    if ([cModel.type integerValue] == 1) {
        [_nameL setText:@"折扣券"];
        [_nameL setTextColor:PINK_COLOR];
        [_mV setImage:[UIImage imageNamed:@"coupons_bg.png"]];
    }
    
    if ([cModel.type integerValue] == 2) {
        [_nameL setText:@"现金券"];
        [_nameL setTextColor:PINK_COLOR];
        [_mV setImage:[UIImage imageNamed:@"coupons_bg.png"]];
    }
    
    if ([cModel.type integerValue] == 3) {
        [_nameL setText:@"活动代金券"];
        [_nameL setTextColor:[UIColor colorWithHex:0x7c2a41]];
        [_mV setImage:[UIImage imageNamed:@"copons_purple.png"]];
    }
    
    NSString *time = [cModel.endTime stringByReplacingOccurrencesOfString:@"." withString:@"-"];
    [_timeL setText:[NSString stringWithFormat:@"有效期至%@", time]];
}

@end
