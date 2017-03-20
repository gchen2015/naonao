//
//  STSelcetedAddressCell.m
//  Naonao
//
//  Created by 刘敏 on 16/4/4.
//  Copyright © 2016年 深圳市轩腾华兴科技开发有限公司. All rights reserved.
//

#import "STSelcetedAddressCell.h"
#import "NSString+RETableViewManagerAdditions.h"

@interface STSelcetedAddressCell ()

@property (nonatomic, weak) UILabel *nameLabel;
@property (nonatomic, weak) UILabel *phoneLabel;
@property (nonatomic, weak) UILabel *areaLabel;
@property (nonatomic, weak) UILabel *addressLabel;
@property (nonatomic, weak) UIImageView *sV;

@end

@implementation STSelcetedAddressCell

+ (STSelcetedAddressCell *)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"STSelcetedAddressCell";
    
    STSelcetedAddressCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[STSelcetedAddressCell alloc ] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    cell.accessoryType = UITableViewCellAccessoryNone;
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
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(14, 15, 150, 20)];
    _nameLabel = nameLabel;
    [_nameLabel setFont:[UIFont boldSystemFontOfSize:17.0]];
    [_nameLabel setTextColor:BLACK_COLOR];
    [self addSubview:_nameLabel];
    
    //手机
    UILabel *phoneLabel = [[UILabel alloc] initWithFrame:CGRectMake(70, 15, 120, 20)];
    _phoneLabel = phoneLabel;
    [_phoneLabel setTextColor:BLACK_COLOR];
    [_phoneLabel setFont:[UIFont systemFontOfSize:17.0]];
    [self addSubview:_phoneLabel];

    
    //地址
    UILabel *areaLabel = [[UILabel alloc] initWithFrame:CGRectMake(14, 40, SCREEN_WIDTH - 46, 20)];
    _areaLabel = areaLabel;
    [_areaLabel setTextColor:[UIColor colorWithHex:0x979797]];
    [_areaLabel setFont:[UIFont systemFontOfSize:14.0]];
    [self addSubview:_areaLabel];
    
    UILabel *addressLabel = [[UILabel alloc] initWithFrame:CGRectMake(14, 65, SCREEN_WIDTH - 46, 20)];
    _addressLabel = addressLabel;
    [_addressLabel setTextColor:[UIColor colorWithHex:0x979797]];
    [_addressLabel setFont:[UIFont systemFontOfSize:14.0]];
    [self addSubview:_addressLabel];
    
    
    UIImageView *sV = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-35, 35, 20, 20)];
    _sV = sV;
    [self.contentView addSubview:_sV];
    
    //选中按钮
    UIButton *selctBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 90)];
    _selctBtn = selctBtn;
    [self.contentView addSubview:_selctBtn];

}

- (void)setCellWithCellInfo:(AddressInfo *)mInfo compareAddressInfo:(AddressInfo *)selectModel
{
    NSString * content = nil;
    if ([mInfo.isDefault boolValue]) {
        content = [NSString stringWithFormat:@"[默认地址] %@", mInfo.name];
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:content];
        
        [str addAttribute:NSForegroundColorAttributeName value:PINK_COLOR range:NSMakeRange(0,6)];
        [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:17.0] range:NSMakeRange(0,6)];
        
        _nameLabel.attributedText = str;
    }
    else{
        content = mInfo.name;
        [_nameLabel setText:mInfo.name];
    }

    
    CGSize labelsize = [content re_sizeWithFont:[UIFont boldSystemFontOfSize:17.0]];
    [_nameLabel setFrame:CGRectMake(14, 15, labelsize.width, 20)];
    
    [_phoneLabel setText:mInfo.telephone];
    CGSize phoneSize = [mInfo.telephone re_sizeWithFont:[UIFont systemFontOfSize:17.0]];
    [_phoneLabel setFrame:CGRectMake(CGRectGetMaxX(_nameLabel.frame)+20, 15, phoneSize.width, 20)];
    
    
    [_areaLabel setText:[NSString stringWithFormat:@"%@  %@  %@", mInfo.province, mInfo.city, mInfo.country]];
    [_addressLabel setText:mInfo.address];
    
    
    if (selectModel) {
        if ([selectModel.addressId integerValue] == [mInfo.addressId integerValue]) {
            [_sV setImage:[UIImage imageNamed:@"icon_selected.png"]];
        }
        else
            [_sV setImage:[UIImage imageNamed:@"icon_selected_no.png"]];
    }
    else{
        if ([mInfo.isSelected boolValue]) {
            [_sV setImage:[UIImage imageNamed:@"icon_selected.png"]];
            
        }
        else {
            
            [_sV setImage:[UIImage imageNamed:@"icon_selected_no.png"]];
        }
    }
}


@end
