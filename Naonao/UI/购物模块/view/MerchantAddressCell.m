//
//  MerchantAddressCell.m
//  Naonao
//
//  Created by 刘敏 on 2016/9/28.
//  Copyright © 2016年 深圳市轩腾华兴科技开发有限公司. All rights reserved.
//

#import "MerchantAddressCell.h"

@interface MerchantAddressCell ()

@property (nonatomic, weak) UILabel *nameL;
@property (nonatomic, weak) UILabel *addressL;

@end

@implementation MerchantAddressCell

+ (MerchantAddressCell *)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"MerchantAddressCell";
    
    MerchantAddressCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[MerchantAddressCell alloc ] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
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
    UILabel *nameL = [[UILabel alloc] initWithFrame:CGRectMake(15, 15, SCREEN_WIDTH - 30, 14)];
    _nameL = nameL;
    [_nameL setFont:[UIFont systemFontOfSize:15.0]];
    [_nameL setTextColor:BROWN_COLOR];
    [self.contentView addSubview:_nameL];
    
    UILabel *addressL = [[UILabel alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(nameL.frame)+4, SCREEN_WIDTH - 30, 20)];
    _addressL = addressL;
    [_addressL setTextColor:GARY_COLOR];
    [_addressL setFont:[UIFont systemFontOfSize:12.0]];
    [self.contentView addSubview:_addressL];
}

- (void)setCellWithCellInfo:(StoreData *)store{
    [_nameL setText:store.name];
    [_addressL setText:[NSString stringWithFormat:@"地址：%@", store.address]];
}

@end
