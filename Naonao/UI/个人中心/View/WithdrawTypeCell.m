//
//  WithdrawTypeCell.m
//  Naonao
//
//  Created by 刘敏 on 16/5/18.
//  Copyright © 2016年 深圳市轩腾华兴科技开发有限公司. All rights reserved.
//

#import "WithdrawTypeCell.h"

@interface WithdrawTypeCell ()

@property (nonatomic, weak) UIImageView *imageV;
@property (nonatomic, weak) UILabel *nameL;

@end

@implementation WithdrawTypeCell


+ (WithdrawTypeCell *)cellWithTableView:(UITableView *)tableView{
    static NSString *ID = @"WithdrawTypeCell";
    
    WithdrawTypeCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[WithdrawTypeCell alloc ] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setUpChildView];
        
    }
    
    return self;
}

- (void)setUpChildView{
    UIImageView *imageV = [[UIImageView alloc] initWithFrame:CGRectMake(15, 12, 40, 40)];
    _imageV = imageV;
    //填充方式
    [_imageV setContentMode:UIViewContentModeScaleAspectFill];
    [self.contentView addSubview:_imageV];
    
    UILabel *nameL = [[UILabel alloc] initWithFrame:CGRectMake(68, 15, 100, 34)];
    _nameL = nameL;
    [_nameL setTextColor:BLACK_COLOR];
    [_nameL setFont:[UIFont systemFontOfSize:17.0]];
    [self.contentView addSubview:_nameL];
}


- (void)setCellWithRow:(NSUInteger)mRow{
    if (mRow == 0) {
        [_nameL setText:@"微信钱包"];
        [_imageV setImage:[UIImage imageNamed:@"wechat_wallet.png"]];
    }
    else if(mRow == 1)
    {
        [_nameL setText:@"支付宝"];
        [_imageV setImage:[UIImage imageNamed:@"alipay_wallet.png"]];
    }
}

@end
