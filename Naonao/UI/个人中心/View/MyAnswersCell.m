//
//  MyAnswersCell.m
//  Naonao
//
//  Created by 刘敏 on 16/8/6.
//  Copyright © 2016年 深圳市轩腾华兴科技开发有限公司. All rights reserved.
//

#import "MyAnswersCell.h"
#import "MLEmojiLabel.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "UserLogic.h"


@interface MyAnswersCell ()

@property (nonatomic, weak) UIView *bgView;
@property (nonatomic, weak) MLEmojiLabel *contentL;
@property (nonatomic, weak) UILabel *lineV;

@property (nonatomic, weak) UIImageView *headV;
@property (nonatomic, weak) MLEmojiLabel *answerL;

@end


@implementation MyAnswersCell

+ (MyAnswersCell *)cellWithTableView:(UITableView *)tableView{
    static NSString *ID = @"MyAnswersCell";
    
    MyAnswersCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[MyAnswersCell alloc ] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
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
    
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectZero];
    _bgView = bgView;
    [_bgView setBackgroundColor:[UIColor whiteColor]];
    [self.contentView addSubview:_bgView];
    
    MLEmojiLabel *contentL = [[MLEmojiLabel alloc] initWithFrame:CGRectZero];
    _contentL = contentL;
    _contentL.numberOfLines = 0;
    [_contentL setFont:[UIFont systemFontOfSize:16.0 weight:UIFontWeightMedium]];
    [_contentL setTextColor:BROWN_COLOR];
    _contentL.backgroundColor = [UIColor clearColor];
    _contentL.lineBreakMode = NSLineBreakByWordWrapping|NSLineBreakByTruncatingTail;
    
    [_bgView addSubview:_contentL];
    
    
    UILabel *lineV = [[UILabel alloc] initWithFrame:CGRectZero];
    _lineV = lineV;
    [_lineV setBackgroundColor:STROKE_GARY_COLOR];
    [_bgView addSubview:_lineV];
    
    UIImageView *headV = [[UIImageView alloc] initWithFrame:CGRectZero];
    _headV = headV;
    //圆角
    _headV.layer.cornerRadius = 12;                     //设置那个圆角的有多圆
    _headV.layer.masksToBounds = YES;                  //设为NO去试试
    [_bgView addSubview:_headV];
    
    
    
    MLEmojiLabel *answerL = [[MLEmojiLabel alloc] initWithFrame:CGRectZero];
    _answerL = answerL;
    _answerL.numberOfLines = 0;
    [_answerL setFont:[UIFont systemFontOfSize:14.0 weight:UIFontWeightMedium]];
    [_answerL setTextColor:BLACK_COLOR];
    _answerL.backgroundColor = [UIColor clearColor];
    _answerL.lineBreakMode = NSLineBreakByWordWrapping|NSLineBreakByTruncatingTail;
    [_bgView addSubview:_answerL];

}

- (void)setCellWithCellInfo:(UserAnswer *)md {
    [_contentL setText:md.orderT];
    CGSize mSize = [_contentL preferredSizeWithMaxWidth:(SCREEN_WIDTH - 54)];
    [_contentL setFrame:CGRectMake(14, 12, SCREEN_WIDTH - 54, mSize.height)];
    
    [_lineV setFrame:CGRectMake(0, CGRectGetMaxY(_contentL.frame)+10, SCREEN_WIDTH - 30, 0.5)];
    
    User *user = [[UserLogic sharedInstance] getUser];
    
    [_headV setFrame:CGRectMake(14, CGRectGetMaxY(_lineV.frame)+13, 24, 24)];
    [_headV sd_setImageWithURL:[NSURL URLWithString:[user.basic.avatarUrl smallHead]] placeholderImage:[UIImage imageNamed:@"default_avatar_large.png"]];
    
    [_answerL setText:md.content];
    CGFloat mH = [_answerL preferredSizeWithMaxWidth:(SCREEN_WIDTH - 92)].height;
    
    if (mH < 24) {
        mH = 24;
    }
    [_answerL setFrame:CGRectMake(52, CGRectGetMaxY(_lineV.frame)+13, SCREEN_WIDTH - 92, mH)];
    
    [_bgView setFrame:CGRectMake(15, 0, SCREEN_WIDTH - 30, CGRectGetMaxY(_answerL.frame)+15)];
}

@end
