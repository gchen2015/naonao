//
//  EditAddressCell.m
//  Naonao
//
//  Created by 刘敏 on 16/4/12.
//  Copyright © 2016年 深圳市轩腾华兴科技开发有限公司. All rights reserved.
//

#import "EditAddressCell.h"


@interface EditAddressCell ()

@property (nonatomic, weak) UIButton *custButton;
@property (nonatomic, strong) AddressInfo *mInfo;

@end



@implementation EditAddressCell


+ (EditAddressCell *)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"EditAddressCell";
    
    EditAddressCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[EditAddressCell alloc ] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
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
    UIButton *custButton = [[UIButton alloc] initWithFrame:CGRectMake(5, 4, 100, 36)];
    _custButton = custButton;
    [_custButton addTarget:self action:@selector(setDefaultTapped:) forControlEvents:UIControlEventTouchUpInside];
    [_custButton.titleLabel setFont:[UIFont systemFontOfSize:15.0]];
    [self.contentView addSubview:_custButton];

    
    UIButton *deleteButton = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-75, 4, 70, 36)];
    [deleteButton setImage:[UIImage imageNamed:@"icon_lajitong.png"] forState:UIControlStateNormal];
    [deleteButton setTitle:@" 删除" forState:UIControlStateNormal];
    [deleteButton.titleLabel setFont:[UIFont systemFontOfSize:15.0]];
    [deleteButton setTitleColor:BLACK_COLOR forState:UIControlStateNormal];
    [deleteButton addTarget:self action:@selector(deleteButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:deleteButton];
    
    UIButton *editButton = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-150, 4, 70, 36)];
    [editButton setImage:[UIImage imageNamed:@"icon_bianji.png"] forState:UIControlStateNormal];
    [editButton setTitle:@" 编辑" forState:UIControlStateNormal];
    [editButton.titleLabel setFont:[UIFont systemFontOfSize:15.0]];
    [editButton setTitleColor:BLACK_COLOR forState:UIControlStateNormal];
    [editButton addTarget:self action:@selector(editButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:editButton];
}

- (void)setCellWithCellInfo:(AddressInfo *)mInfo
{
    _mInfo = mInfo;
    
    if ([mInfo.isDefault boolValue]) {
        [_custButton setTitle:@" 默认地址" forState:UIControlStateNormal];
        [_custButton setTitleColor:PINK_COLOR forState:UIControlStateNormal];
        [_custButton setImage:[UIImage imageNamed:@"icon_selected_small.png"] forState:UIControlStateNormal];
    }
    else
    {
        [_custButton setTitle:@" 设为默认" forState:UIControlStateNormal];
        [_custButton setTitleColor:BLACK_COLOR forState:UIControlStateNormal];
        [_custButton setImage:[UIImage imageNamed:@"icon_selected_small_no.png"] forState:UIControlStateNormal];
        
    }
}

- (void)editButtonTapped:(id)sender
{
    if (_delegate && [_delegate respondsToSelector:@selector(editAddressCell:edictCellInfo:)]) {
        [_delegate editAddressCell:self edictCellInfo:_mInfo];
    }
}


- (void)deleteButtonTapped:(id)sender
{
    AlertWithTitleAndMessageAndUnitsToTag(@"确定删除该地址", nil, self, @"确定", nil, 0x128);
}

- (void)setDefaultTapped:(id)sender
{
    if (![_mInfo.isDefault boolValue])
    {
        if (_delegate && [_delegate respondsToSelector:@selector(editAddressCell:setDefaultCellInfo:)]) {
            [_delegate editAddressCell:self setDefaultCellInfo:_mInfo];
        }
    }
}


#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        
        if(alertView.tag == 0x128)
        {
            //删除订单
            if (_delegate && [_delegate respondsToSelector:@selector(editAddressCell:deleteCellInfo:)]) {
                [_delegate editAddressCell:self deleteCellInfo:_mInfo];
            };
        }
    }
}





@end
