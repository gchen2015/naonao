//
//  PayOptionsCell.m
//  Naonao
//
//  Created by 刘敏 on 16/3/11.
//  Copyright © 2016年 深圳市轩腾华兴科技开发有限公司. All rights reserved.
//

#import "PayOptionsCell.h"

@interface PayOptionsCell ()

@property (nonatomic, weak) UIImageView *headImageView;
@property (nonatomic, weak) UILabel *titLabel;
@property (nonatomic, weak) UIImageView *checkImageView;

@end


@implementation PayOptionsCell

+ (PayOptionsCell *)cellWithTableView:(UITableView *)tableView{
    static NSString *ID = @"PayOptionsCell";
    
    PayOptionsCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[PayOptionsCell alloc ] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
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
    UIImageView *headImageView = [[UIImageView alloc] initWithFrame:CGRectMake(14, 12.5, 23, 23)];
    _headImageView = headImageView;
    [self.contentView addSubview:_headImageView];
    
    //标题
    UILabel *titLabel = [[UILabel alloc] initWithFrame:CGRectMake(48, 14, 100, 20)];
    _titLabel = titLabel;
    [_titLabel setFont:[UIFont systemFontOfSize:16.0]];
    [_titLabel setTextColor:[UIColor blackColor]];
    [self.contentView addSubview:_titLabel];
    
    //选中按钮
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-48, 0, 48, 48)];
    _btn = btn;
    [self.contentView addSubview:_btn];
}


- (void)setCellWithCellInfo:(PaymentChannelInfo *)pInfo
{
    [_headImageView setImage:[UIImage imageNamed:pInfo.imgN]];
    [_titLabel setText:pInfo.titS];
    
    if ([pInfo.isSelected boolValue]) {
        [_btn setImage:[UIImage imageNamed:@"icon_selected.png"] forState:UIControlStateNormal];
    } else {
        [_btn setImage:[UIImage imageNamed:@"icon_selected_no.png"] forState:UIControlStateNormal];
    }
}

@end
