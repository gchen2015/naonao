//
//  SYSTableViewCell.m
//  Naonao
//
//  Created by 刘敏 on 16/8/22.
//  Copyright © 2016年 深圳市轩腾华兴科技开发有限公司. All rights reserved.
//

#import "SYSTableViewCell.h"

@interface SYSTableViewCell ()

@property (nonatomic, strong) UILabel *describeL;

@end

@implementation SYSTableViewCell

+ (SYSTableViewCell *)cellWithTableView:(UITableView *)tableView{
    static NSString *ID = @"SYSTableViewCell";
    
    SYSTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    cell = [[SYSTableViewCell alloc ] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.contentView.userInteractionEnabled = YES;
        [self setUpChildView];
    }
    
    return self;
}

- (void)setUpChildView{
    UILabel *titleL = [[UILabel alloc] initWithFrame:CGRectMake(15, 15, 200, 16)];
    [titleL setText:@"收到平台通知"];
    [titleL setFont:[UIFont systemFontOfSize:13.0 weight:UIFontWeightLight]];
    [titleL setTextColor:LIGHT_BLACK_COLOR];
    [self.contentView addSubview:titleL];
    
    UILabel *describeL = [[UILabel alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(titleL.frame)+6, SCREEN_WIDTH-30, 20)];
    _describeL = describeL;
    _describeL.font = [UIFont systemFontOfSize:15.0];
    [_describeL setTextColor:BLACK_COLOR];
    [self.contentView addSubview:_describeL];
    
    //分割线
    UILabel *lineV = [[UILabel alloc] initWithFrame:CGRectMake(0, 69.5, SCREEN_WIDTH, 0.5)];
    [lineV setBackgroundColor:STROKE_GARY_COLOR];
    [self addSubview:lineV];
}



- (void)setCellWithCellInfo:(SYSMessage *)item
{
    [_describeL setText:item.content.msg];
}

@end
