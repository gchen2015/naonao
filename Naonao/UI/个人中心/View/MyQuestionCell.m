//
//  MyQuestionCell.m
//  Naonao
//
//  Created by 刘敏 on 16/8/3.
//  Copyright © 2016年 深圳市轩腾华兴科技开发有限公司. All rights reserved.
//

#import "MyQuestionCell.h"
#import "MLEmojiLabel.h"
#import <SDWebImage/UIImageView+WebCache.h>


@interface MyQuestionCell ()

@property (nonatomic, weak) UIView *bgView;
@property (nonatomic, weak) MLEmojiLabel *contentL;
@property (nonatomic, weak) UILabel *desLabel;
@property (nonatomic, weak) UILabel *lineV;

@property (nonatomic, weak) UILabel *focusL;

@property (nonatomic, weak) UIImageView *headV;
@property (nonatomic, weak) UILabel *nickL;
@property (nonatomic, weak) UIImageView *tipV;

@end

@implementation MyQuestionCell

+ (MyQuestionCell *)cellWithTableView:(UITableView *)tableView{
    static NSString *ID = @"MyQuestionCell";
    
    MyQuestionCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[MyQuestionCell alloc ] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
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
    [_contentL setFont:[UIFont systemFontOfSize:16.0]];
    [_contentL setTextColor:BLACK_COLOR];
    _contentL.backgroundColor = [UIColor clearColor];
    _contentL.lineBreakMode = NSLineBreakByWordWrapping|NSLineBreakByTruncatingTail;
    
    [_bgView addSubview:_contentL];
    
    
    UILabel *desLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _desLabel = desLabel;
    [_desLabel setFont:[UIFont systemFontOfSize:11.0]];
    [_desLabel setTextColor:GARY_COLOR];
    [_desLabel setBackgroundColor:[UIColor clearColor]];
    [_bgView addSubview:_desLabel];
    
    UILabel *lineV = [[UILabel alloc] initWithFrame:CGRectZero];
    _lineV = lineV;
    [_lineV setBackgroundColor:STROKE_GARY_COLOR];
    [_bgView addSubview:_lineV];
    

    UILabel *focusL = [[UILabel alloc] initWithFrame:CGRectZero];
    _focusL = focusL;
    [_focusL setFont:[UIFont systemFontOfSize:14.0 weight:UIFontWeightMedium]];
    [_focusL setTextColor:BLACK_COLOR];
    [_bgView addSubview:_focusL];
    
    
    UIImageView *headV = [[UIImageView alloc] initWithFrame:CGRectZero];
    _headV = headV;
    //圆角
    _headV.layer.cornerRadius = 14;                     //设置那个圆角的有多圆
    _headV.layer.masksToBounds = YES;                  //设为NO去试试
    [_bgView addSubview:_headV];
    
    
    UILabel *nickL = [[UILabel alloc] initWithFrame:CGRectZero];
    _nickL = nickL;
    [_nickL setFont:[UIFont systemFontOfSize:12.0]];
    [_nickL setTextColor:GOLDEN_YELLOW];
    [_bgView addSubview:_nickL];
    
    
    UIImageView *tipV = [[UIImageView alloc] init];
    _tipV = tipV;
    [_tipV setImage:[UIImage imageNamed:@"rudder_tag.png"]];
    [_bgView addSubview:_tipV];
}

- (void)setCellWithCellInfo:(SquareModel *)md {
    [_contentL setText:md.orderInfo.content];
    CGSize mSize = [_contentL preferredSizeWithMaxWidth:(SCREEN_WIDTH - 54)];
    [_contentL setFrame:CGRectMake(14, 12, SCREEN_WIDTH - 54, mSize.height)];
    
    [_desLabel setFrame:CGRectMake(14, CGRectGetMaxY(_contentL.frame)+10, SCREEN_WIDTH - 54, 12)];
    [_desLabel setText:md.orderInfo.summarize];
    
    [_lineV setFrame:CGRectMake(0, CGRectGetMaxY(_desLabel.frame)+10, SCREEN_WIDTH - 30, 0.5)];
    
    [_focusL setFrame:CGRectMake(14, CGRectGetMaxY(_lineV.frame), SCREEN_WIDTH - 54, 34)];
    [_focusL setText:[NSString stringWithFormat:@"%@人关注         %@个回答", md.answerInfo.care, md.answerInfo.num]];
    
    [_bgView setFrame:CGRectMake(15, 0, SCREEN_WIDTH - 30, CGRectGetMaxY(_focusL.frame))];
}


- (void)setCellWithCellData:(SquareModel *)sInfo {
    
    [_contentL setText:sInfo.orderInfo.content];
    CGSize mSize = [_contentL preferredSizeWithMaxWidth:(SCREEN_WIDTH - 54)];
    [_contentL setFrame:CGRectMake(14, 12, SCREEN_WIDTH - 54, mSize.height)];
    
    [_desLabel setFrame:CGRectMake(14, CGRectGetMaxY(_contentL.frame)+10, SCREEN_WIDTH - 54, 12)];
    [_desLabel setText:sInfo.orderInfo.summarize];
    
    [_lineV setFrame:CGRectMake(0, CGRectGetMaxY(_desLabel.frame)+10, SCREEN_WIDTH - 30, 0.5)];
    
    [_headV setFrame:CGRectMake(14, CGRectGetMaxY(_lineV.frame)+5, 28, 28)];
    [_headV sd_setImageWithURL:[NSURL URLWithString:[sInfo.userInfo.avatar smallHead]] placeholderImage:[UIImage imageNamed:@"default_avatar_large.png"]];
    
    
    [_nickL setText:sInfo.userInfo.nickname];
    
    CGSize nickSize = [sInfo.userInfo.nickname boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 67, MAXFLOAT)
                                                     options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading
                                                  attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12.0]}
                                                     context:nil].size;
    [_nickL setFrame:CGRectMake(CGRectGetMaxX(_headV.frame)+6, CGRectGetMaxY(_lineV.frame)+5, nickSize.width, 28)];
    
    //舵主标识
    [_tipV setFrame:CGRectMake(CGRectGetMaxX(_nickL.frame)+3, CGRectGetMaxY(_lineV.frame)+11.5, 15, 15)];
    
    
    [_focusL setFont:[UIFont systemFontOfSize:14.0]];
    [_focusL setTextAlignment:NSTextAlignmentRight];
    [_focusL setFrame:CGRectMake(SCREEN_WIDTH - 200, CGRectGetMaxY(_lineV.frame), 160, 38)];
    [_focusL setText:[NSString stringWithFormat:@"%@个回答", sInfo.answerInfo.num]];
    
    [_bgView setFrame:CGRectMake(15, 0, SCREEN_WIDTH - 30, CGRectGetMaxY(_lineV.frame)+38)];
}


@end
