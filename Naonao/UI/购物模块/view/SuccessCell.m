//
//  SuccessCell.m
//  Naonao
//
//  Created by 刘敏 on 16/4/13.
//  Copyright © 2016年 深圳市轩腾华兴科技开发有限公司. All rights reserved.
//

#import "SuccessCell.h"

@implementation SuccessCell

+ (SuccessCell *)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"SuccessCell";
    
    SuccessCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[SuccessCell alloc ] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
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
    UIImageView *planeV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_font_feiji"]];
    [planeV setFrame:CGRectMake(SCREEN_WIDTH/2 - 96, 21.5, 44, 44)];
    [self.contentView addSubview:planeV];
    
    UILabel *mV = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(planeV.frame)+10, 21.5, 150, 44)];
    [mV setText:@"您已经成功付款"];
    [mV setFont:[UIFont boldSystemFontOfSize:18.0]];
    [self.contentView addSubview:mV];
}

@end

