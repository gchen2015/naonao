//
//  HomeCell.m
//  BanTang
//
//  Created by 天空之城 on 16/3/25.
//  Copyright © 2016年 天空之城. All rights reserved.
//

#import "HomeCell.h"

@interface HomeCell ()
@property (nonatomic, weak) UIImageView *bigImageView;
@property (nonatomic, weak) UILabel *titleLabel;

@property (nonatomic, weak) UIView *bottomView;
@property (nonatomic, weak) UIImageView *dateImageView;
@property (nonatomic, weak) UILabel *nickL;
@property (nonatomic, weak) UILabel *timeL;

@property (nonatomic, weak) UIView *lineV;

@end

@implementation HomeCell

+ (HomeCell *)cellWithTableView:(UITableView *)tableView{
    static NSString *ID = @"HomeCell";
    
    HomeCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    cell = [[HomeCell alloc ] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
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
    UIImageView *bigImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 15, SCREEN_WIDTH-30, (SCREEN_WIDTH-30) * 0.5)];
    _bigImageView = bigImageView;
    [self.contentView addSubview:_bigImageView];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(_bigImageView.frame)+25, SCREEN_WIDTH-30, 20)];
    _titleLabel = titleLabel;
    _titleLabel.font = [UIFont systemFontOfSize:18];
    [_titleLabel setTextColor:BLACK_COLOR];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:_titleLabel];
    
    
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectZero];
    _bottomView = bottomView;
    [self.contentView addSubview:_bottomView];
    
    //用户昵称
    UILabel *nickL = [[UILabel alloc] init];
    _nickL = nickL;
    _nickL.font = [UIFont systemFontOfSize:11];
    [_nickL setTextColor:LIGHT_BLACK_COLOR];
    _nickL.textAlignment = NSTextAlignmentRight;
    [_bottomView addSubview:_nickL];
    
    //icon
    UIImageView *dateImageView = [[UIImageView alloc] init];
    _dateImageView = dateImageView;
    _dateImageView.image = [UIImage imageNamed:@"calendar_icon.png"];
    [_bottomView addSubview:_dateImageView];
    
    //日期
    UILabel *timeL = [[UILabel alloc] init];
    _timeL = timeL;
    _timeL.font = [UIFont systemFontOfSize:11];
    _timeL.textAlignment = NSTextAlignmentLeft;
    [_timeL setTextColor:LIGHT_BLACK_COLOR];
    [_bottomView addSubview:_timeL];
    
    //分割线
    UIView *lineV = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_titleLabel.frame)+39.5, SCREEN_WIDTH, 0.5)];
    _lineV = lineV;
    _lineV.backgroundColor = STROKE_GARY_COLOR;
    [self.contentView addSubview:_lineV];
}

- (void)setCellWithCellInfo:(MagazineInfo *)topic
{
    [self.bigImageView setImageWithURL:[NSURL URLWithString:topic.imgURL] placeholderImage:[UIImage imageNamed:@"default_image.png"] animate:YES];
    self.titleLabel.text = topic.title;
    self.nickL.text = topic.author;
    NSString *timeS = [self dateConversionDateS:topic.publishTime];
    self.timeL.text = timeS;
    
    //计算用户昵称宽度
    CGSize nicksize = [topic.author sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:11]}];
    [_nickL setFrame:CGRectMake(0, 0, nicksize.width, 13)];
    
    [_dateImageView setFrame:CGRectMake(CGRectGetMaxX(_nickL.frame)+10, 0, 11, 13)];

    //日期
    CGSize timesize = [timeS sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:11]}];
    [_timeL setFrame:CGRectMake(CGRectGetMaxX(_dateImageView.frame)+10, 0, timesize.width, 13)];
    
    [_bottomView setFrame:CGRectMake((SCREEN_WIDTH - CGRectGetMaxX(_timeL.frame))/2, CGRectGetMaxY(_titleLabel.frame)+10, CGRectGetMaxX(_timeL.frame), 13)];
    
}

- (NSString *)dateConversionDateS:(NSString *)str {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat: @"yyyy-MM-dd"];
    NSDate *destDate = [dateFormatter dateFromString:str];
    
    NSDateFormatter *tFormatter = [[NSDateFormatter alloc] init];
    //zzz表示时区，zzz可以删除，这样返回的日期字符将不包含时区信息。
    [tFormatter setDateFormat:@"dd/MM/yyyy"];
    
    NSString *destDateString = [tFormatter stringFromDate:destDate];
    
    return destDateString;
}


- (CGFloat)height {
    [self layoutIfNeeded];
    
    return CGRectGetMaxY(_titleLabel.frame) + 40;
}

@end
