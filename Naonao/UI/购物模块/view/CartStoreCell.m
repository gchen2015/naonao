//
//  CartStoreCell.m
//  Naonao
//
//  Created by 刘敏 on 2016/9/23.
//  Copyright © 2016年 深圳市轩腾华兴科技开发有限公司. All rights reserved.
//

#import "CartStoreCell.h"
#import <SDWebImage/UIButton+WebCache.h>

@interface CartStoreCell ()

@property (nonatomic, weak) UIButton *chooseBtn;
@property (nonatomic, weak) UILabel *nameL;
@property (nonatomic, weak) UIImageView *desV;

@property (nonatomic, assign) NSInteger row;

@end


@implementation CartStoreCell

+ (CartStoreCell *)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"CartStoreCell";
    
    CartStoreCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[CartStoreCell alloc ] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
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
    UIButton *chooseBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, Bottom_H, 40)];
    _chooseBtn = chooseBtn;
    [_chooseBtn setImage:[UIImage imageNamed:@"icon_selected_no.png"] forState:UIControlStateNormal];
    [_chooseBtn setImage:[UIImage imageNamed:@"icon_selected.png"] forState:UIControlStateHighlighted];
    [_chooseBtn setImage:[UIImage imageNamed:@"icon_selected.png"] forState:UIControlStateSelected];
    [_chooseBtn addTarget:self action:@selector(chooseGoodsTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_chooseBtn];
    
    UILabel *nameL = [[UILabel alloc] initWithFrame:CGRectZero];
    _nameL = nameL;
    [_nameL setTextColor:LIGHT_BLACK_COLOR];
    [_nameL setFont:[UIFont systemFontOfSize:14.0]];
    [self.contentView addSubview:_nameL];
    
    UIImageView *desV = [[UIImageView alloc] initWithFrame:CGRectZero];
    _desV = desV;
    [_desV setImage:[UIImage imageNamed:@"door_tips.png"]];
    [self.contentView addSubview:_desV];
}

- (void)setCellWithCellInfo:(StoreData *)store setChooseBtn:(BOOL)isSelected mSection:(NSInteger)section {
    
    _row = section;
    
    [_chooseBtn setSelected:isSelected];
    [_nameL setText:store.name];
    CGFloat mW = [_nameL sizeThatFits:CGSizeMake(MAXFLOAT, 20)].width;
    [_nameL setFrame:CGRectMake(48, 10, mW, 20)];
    
    if (![store.canTry boolValue]) {
        [_desV setHidden:YES];
    }
    else{
        [_desV setFrame:CGRectMake(CGRectGetMaxX(_nameL.frame), 11, 45, 18)];
        [_desV setHidden:NO];
    }
}

- (void)setCellWithCellOrderInfo:(StoreData *)store{
    [_chooseBtn setHidden:YES];
    
    UIImageView *logoV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"default_merchants.png"]];
    [logoV setFrame:CGRectMake(15, 10, 20, 20)];
    //圆角
    logoV.layer.cornerRadius = 4;                       //设置那个圆角的有多圆
    logoV.layer.masksToBounds = YES;                    //设为NO去试试
    [self.contentView addSubview:logoV];

    [_nameL setText:store.name];
    CGFloat mW = [_nameL sizeThatFits:CGSizeMake(MAXFLOAT, 20)].width;
    [_nameL setFrame:CGRectMake(48, 10, mW, 20)];
    
    if (![store.canTry boolValue]) {
        [_desV setHidden:YES];
    }
    else{
        [_desV setFrame:CGRectMake(CGRectGetMaxX(_nameL.frame), 11, 45, 18)];
        [_desV setHidden:NO];
    }
}

- (void)chooseGoodsTapped:(UIButton *)sender
{
    sender.selected = !sender.selected;
    
    if (_delegate && [_delegate respondsToSelector:@selector(chooseBtnState:goodsClick:)]){
        [_delegate chooseBtnState:sender.selected goodsClick:_row];
    }
}

    
@end
