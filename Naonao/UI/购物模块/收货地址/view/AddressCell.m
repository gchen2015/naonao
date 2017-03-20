//
//  AddressCell.m
//  Naonao
//
//  Created by 刘敏 on 16/3/20.
//  Copyright © 2016年 深圳市轩腾华兴科技开发有限公司. All rights reserved.
//

#import "AddressCell.h"

@interface AddressCell ()

@property (nonatomic, weak) UILabel *mL;
@property (nonatomic, weak) UILabel *pL;
@property (nonatomic, weak) UILabel *aL;

@end

@implementation AddressCell

+ (AddressCell *)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"AddressCell";
    
    AddressCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[AddressCell alloc ] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell.imageView setImage:[UIImage imageNamed:@"cell_address_icon.png"]];
    
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
    UILabel *mL = [[UILabel alloc] initWithFrame:CGRectMake(35, 15, 150, 20)];
    _mL = mL;
    [_mL setTextColor:BLACK_COLOR];
    [_mL setFont:[UIFont systemFontOfSize:16.0]];
    [self addSubview:_mL];
    
    //手机
    UILabel *pL = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 160, 15, 120, 20)];
    _pL = pL;
    [_pL setTextColor:BLACK_COLOR];
    [_pL setFont:[UIFont systemFontOfSize:16.0]];
    [_pL setTextAlignment:NSTextAlignmentRight];
    [self addSubview:_pL];
    
    //地址
    UILabel *aL = [[UILabel alloc] initWithFrame:CGRectMake(35, 40, SCREEN_WIDTH - 67, 40)];
    _aL = aL;
    [_aL setTextColor:BLACK_COLOR];
    _aL.numberOfLines = 0;
    [_aL setFont:[UIFont systemFontOfSize:16.0]];
    [self addSubview:_aL];
    
}

- (CGFloat)setCellWithCellInfo:(AddressInfo *)mInfo
{
    [_mL setText:mInfo.name];
    [_pL setText:mInfo.telephone];
    
    NSString *st = nil;
    if(mInfo.country.length < 1)
    {
       st = [NSString stringWithFormat:@"%@%@%@", mInfo.province, mInfo.city, mInfo.address];
    }
    else
        st = [NSString stringWithFormat:@"%@%@%@%@", mInfo.province, mInfo.city, mInfo.country, mInfo.address];
    
    [_aL setText:st];
    
    //计算高度
    CGSize titleSize = [st boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 67, MAXFLOAT)
                                                         options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading
                                                      attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16.0]}
                                                         context:nil].size;
    
    _aL.size = titleSize;
    
    return CGRectGetMaxY(_aL.frame)+15; 
}

@end



@interface AddressNewCell ()

@property (nonatomic, weak) UILabel *mL;
@property (nonatomic, weak) UILabel *pL;
@property (nonatomic, weak) UILabel *aL;

@end

@implementation AddressNewCell

+ (AddressNewCell *)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"AddressNewCell";
    
    AddressNewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[AddressNewCell alloc ] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell.imageView setImage:[UIImage imageNamed:@"cell_address_icon.png"]];
    
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
    UILabel *mL = [[UILabel alloc] initWithFrame:CGRectMake(35, 15, 150, 20)];
    _mL = mL;
    [_mL setTextColor:BLACK_COLOR];
    [_mL setFont:[UIFont systemFontOfSize:16.0]];
    [self addSubview:_mL];
    
    //手机
    UILabel *pL = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 135, 15, 120, 20)];
    _pL = pL;
    [_pL setTextColor:BLACK_COLOR];
    [_pL setFont:[UIFont systemFontOfSize:16.0]];
    [_pL setTextAlignment:NSTextAlignmentRight];
    [self addSubview:_pL];
    
    //地址
    UILabel *aL = [[UILabel alloc] initWithFrame:CGRectMake(35, 40, SCREEN_WIDTH - 50, 40)];
    _aL = aL;
    [_aL setTextColor:BLACK_COLOR];
    aL.numberOfLines = 0;
    [aL setFont:[UIFont systemFontOfSize:16.0]];
    [self addSubview:aL];
}


- (CGFloat)setCellWithCellInfo:(DeliveryInfo *)mInfo
{
    [_mL setText:[NSString stringWithFormat:@"收货人：%@", mInfo.receiver_name]];
    [_pL setText:mInfo.receiver_telephone];
    [_aL setText:mInfo.receiver_addr];
    
    //计算高度
    CGSize titleSize = [mInfo.receiver_addr boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 50, MAXFLOAT)
                                                        options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading
                                                     attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16.0]}
                                                        context:nil].size;
    
    _aL.size = titleSize;
    
    return CGRectGetMaxY(_aL.frame)+15;
}

@end
