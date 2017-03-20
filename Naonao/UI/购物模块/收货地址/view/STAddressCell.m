//
//  STAddressCell.m
//  Naonao
//
//  Created by 刘敏 on 16/3/28.
//  Copyright © 2016年 深圳市轩腾华兴科技开发有限公司. All rights reserved.
//

#import "STAddressCell.h"
#import "NSString+RETableViewManagerAdditions.h"

@interface STAddressCell ()

@property (nonatomic, weak) UILabel *nameLabel;
@property (nonatomic, weak) UILabel *phoneLabel;
@property (nonatomic, weak) UILabel *areaLabel;
@property (nonatomic, weak) UILabel *addressLabel;

@end

@implementation STAddressCell

+ (STAddressCell *)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"STAddressCell";
    
    STAddressCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[STAddressCell alloc ] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
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
    UILabel *phoneLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 135, 15, 120, 20)];
    _phoneLabel = phoneLabel;
    [_phoneLabel setTextAlignment:NSTextAlignmentRight];
    [_phoneLabel setTextColor:BLACK_COLOR];
    [_phoneLabel setFont:[UIFont systemFontOfSize:17.0]];
    [self addSubview:_phoneLabel];
    
    
    //地址
    UILabel *areaLabel = [[UILabel alloc] initWithFrame:CGRectMake(14, 40, SCREEN_WIDTH - 29, 20)];
    _areaLabel = areaLabel;
    [_areaLabel setTextColor:[UIColor colorWithHex:0x979797]];
    [_areaLabel setFont:[UIFont systemFontOfSize:14.0]];
    [self addSubview:_areaLabel];
    
    UILabel *addressLabel = [[UILabel alloc] initWithFrame:CGRectMake(14, 65, SCREEN_WIDTH - 29, 20)];
    _addressLabel = addressLabel;
    [_addressLabel setTextColor:[UIColor colorWithHex:0x979797]];
    [_addressLabel setFont:[UIFont systemFontOfSize:14.0]];
    [self addSubview:_addressLabel];
}


- (void)setCellWithCellInfo:(AddressInfo *)mInfo
{
    [_nameLabel setText:mInfo.name];
    [_phoneLabel setText:mInfo.telephone];

    [_areaLabel setText:[NSString stringWithFormat:@"%@  %@  %@", mInfo.province, mInfo.city, mInfo.country]];
    [_addressLabel setText:mInfo.address];
}

@end
