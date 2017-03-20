//
//  GBrandCell.m
//  Naonao
//
//  Created by 刘敏 on 16/8/5.
//  Copyright © 2016年 深圳市轩腾华兴科技开发有限公司. All rights reserved.
//

#import "GBrandCell.h"

@interface GBrandCell()

@property (nonatomic, weak) UIImageView *bigImageView;
@property (nonatomic, weak) UILabel *titleLabel;
@property (nonatomic, weak) UIView *lineV;
@end



@implementation GBrandCell

+ (GBrandCell *)cellWithTableView:(UITableView *)tableView{
    static NSString *ID = @"GBrandCell";
    
    GBrandCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    cell = [[GBrandCell alloc ] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
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
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(_bigImageView.frame)+15, SCREEN_WIDTH-30, 20)];
    _titleLabel = titleLabel;
    _titleLabel.font = [UIFont systemFontOfSize:18];
    [_titleLabel setTextColor:BLACK_COLOR];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:_titleLabel];
    
    //分割线
    UIView *lineV = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_titleLabel.frame)+19.5, SCREEN_WIDTH, 0.5)];
    _lineV = lineV;
    _lineV.backgroundColor = STROKE_GARY_COLOR;
    [self.contentView addSubview:_lineV];

}

- (void)setCellWithCellInfo:(STBrand *)topic
{
    [self.bigImageView setImageWithURL:[NSURL URLWithString:topic.imgURL] placeholderImage:[UIImage imageNamed:@"default_image.png"] animate:YES];
    self.titleLabel.text = topic.title;

}

- (CGFloat)height {
    [self layoutIfNeeded];
    
    return CGRectGetMaxY(_titleLabel.frame) + 20;
}


@end
