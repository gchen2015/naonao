//
//  FavArticleCell.m
//  Naonao
//
//  Created by 刘敏 on 16/8/4.
//  Copyright © 2016年 深圳市轩腾华兴科技开发有限公司. All rights reserved.
//

#import "FavArticleCell.h"

@interface FavArticleCell ()

@property (nonatomic, weak) UIView *bgView;
@property (nonatomic, weak) UIImageView *bigImageView;
@property (nonatomic, weak) UILabel *titleLabel;

@end



@implementation FavArticleCell

+ (FavArticleCell *)cellWithTableView:(UITableView *)tableView{
    static NSString *ID = @"FavArticleCell";
    
    FavArticleCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[FavArticleCell alloc ] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
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

- (void)setUpChildView{
    [self setBackgroundColor:[UIColor clearColor]];
    [self.contentView setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
    
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(15, 0,  SCREEN_WIDTH-30, (SCREEN_WIDTH-30) * 0.46 +45)];
    _bgView = bgView;
    [_bgView setBackgroundColor:[UIColor whiteColor]];
    [self.contentView addSubview:_bgView];
    
    UIImageView *bigImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH-30, (SCREEN_WIDTH-30) * 0.46)];
    _bigImageView = bigImageView;
    [_bgView addSubview:_bigImageView];
    
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(13, CGRectGetMaxY(_bigImageView.frame), CGRectGetMaxX(_bigImageView.frame) - 26, 45)];
    _titleLabel = titleLabel;
    _titleLabel.font = [UIFont systemFontOfSize:16];
    [_titleLabel setTextColor:BLACK_COLOR];
    [_bgView addSubview:_titleLabel];
}

- (void)setCellWithCellInfo:(MagazineInfo *)mInfo {
    [self.bigImageView setImageWithURL:[NSURL URLWithString:mInfo.imgURL] placeholderImage:[UIImage imageNamed:@"default_image.png"] animate:YES];
    self.titleLabel.text = mInfo.title;
}


@end
