//
//  WithdrawAmountCell.m
//  Naonao
//
//  Created by 刘敏 on 16/5/18.
//  Copyright © 2016年 深圳市轩腾华兴科技开发有限公司. All rights reserved.
//

#import "WithdrawAmountCell.h"

@interface WithdrawAmountCell ()

@property (nonatomic, weak) UILabel *titLabel;
@property (nonatomic, weak) UIImageView *checkImageView;

@end




@implementation WithdrawAmountCell

+ (WithdrawAmountCell *)cellWithTableView:(UITableView *)tableView{
    static NSString *ID = @"WithdrawAmountCell";
    
    WithdrawAmountCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[WithdrawAmountCell alloc ] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
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
    //标题
    UILabel *titLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 14, 100, 20)];
    _titLabel = titLabel;
    [_titLabel setFont:[UIFont systemFontOfSize:16.0]];
    [_titLabel setTextColor:[UIColor blackColor]];
    [self.contentView addSubview:_titLabel];
    
    //选中按钮
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-48, 0, 48, 48)];
    _btn = btn;
    [self.contentView addSubview:_btn];
}


- (void)setCellWithCellInfo:(WithdrawChannelInfo *)pInfo
{
    [_titLabel setText:[NSString stringWithFormat:@"%@ 元", pInfo.titS]];
    
    if ([pInfo.isSelected boolValue]) {
        [_btn setImage:[UIImage imageNamed:@"icon_selected.png"] forState:UIControlStateNormal];
    } else {
        [_btn setImage:[UIImage imageNamed:@"icon_selected_no.png"] forState:UIControlStateNormal];
    }
}



@end
