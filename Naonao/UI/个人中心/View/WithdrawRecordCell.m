//
//  WithdrawRecordCell.m
//  Naonao
//
//  Created by 刘敏 on 16/5/19.
//  Copyright © 2016年 深圳市轩腾华兴科技开发有限公司. All rights reserved.
//

#import "WithdrawRecordCell.h"

@interface WithdrawRecordCell ()

@property (nonatomic, weak) UILabel *dateL;
@property (nonatomic, weak) UILabel *timeL;

@property (nonatomic, weak) UIImageView *imageV;
@property (nonatomic, weak) UILabel *amountL;
@property (nonatomic, weak) UILabel *desL;

@end


@implementation WithdrawRecordCell

+ (WithdrawRecordCell *)cellWithTableView:(UITableView *)tableView{
    static NSString *ID = @"WithdrawRecordCell";
    
    WithdrawRecordCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[WithdrawRecordCell alloc ] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
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
    
    UILabel *dateL = [[UILabel alloc] initWithFrame:CGRectMake(15, 13, 140, 25)];
    _dateL = dateL;
    [_dateL setTextColor:LIGHT_BLACK_COLOR];
    [_dateL setFont:[UIFont systemFontOfSize:17.0]];
    [self.contentView addSubview:_dateL];
    

    UILabel *timeL = [[UILabel alloc] initWithFrame:CGRectMake(15, 35, 140, 20)];
    _timeL = timeL;
    [_timeL setTextColor:LIGHT_BLACK_COLOR];
    [_timeL setFont:[UIFont systemFontOfSize:12.0]];
    [self.contentView addSubview:_timeL];
    
    
    UIImageView *imageV = [[UIImageView alloc] initWithFrame:CGRectMake(100, 13, 40, 40)];
    _imageV = imageV;
    [self.contentView addSubview:_imageV];
    
    
    UILabel *amountL = [[UILabel alloc] initWithFrame:CGRectMake(165, 10, 140, 25)];
    _amountL = amountL;
    [_amountL setTextColor:BLACK_COLOR];
    [_amountL setFont:[UIFont systemFontOfSize:23.0]];
    [self.contentView addSubview:_amountL];
    
    UILabel *desL = [[UILabel alloc] initWithFrame:CGRectMake(165, 38, 140, 20)];
    _desL = desL;
    [_desL setTextColor:LIGHT_BLACK_COLOR];
    [_desL setFont:[UIFont systemFontOfSize:14.0]];
    [self.contentView addSubview:_desL];
}



- (void)setCellWithCellInfo:(STWRecord *)sInfo
{
    NSUInteger month = [[sInfo.createTime substringWithRange:NSMakeRange(5, 2)] integerValue];
    NSUInteger date = [[sInfo.createTime substringWithRange:NSMakeRange(8, 2)] integerValue];
    
    [_dateL setText:[NSString stringWithFormat:@"%lu月%lu日", (unsigned long)month, (unsigned long)date]];
    [_timeL setText:[sInfo.createTime substringWithRange:NSMakeRange(11, 5)]];
    
    NSString *st = [NSString stringWithFormat:@"%.2f元", [sInfo.amount floatValue]/100.0];
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:st];

    [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:23.0] range:NSMakeRange(0, st.length-1)];
    [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:11.0] range:NSMakeRange(st.length-1, 1)];
    _amountL.attributedText = str;

    
    if ([sInfo.channel integerValue] == 1) {
        [_imageV setImage:[UIImage imageNamed:@"wechat_wallet.png"]];
        [_desL setText:@"挠挠--转出到微信钱包"];
    }
    else if([sInfo.channel integerValue] == 2){
        [_imageV setImage:[UIImage imageNamed:@"alipay_wallet.png"]];
        [_desL setText:@"挠挠--转出到支付宝"];
    }

}

@end
