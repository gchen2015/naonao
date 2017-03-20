//
//  AnswerTableViewCell.m
//  Naonao
//
//  Created by 刘敏 on 16/8/21.
//  Copyright © 2016年 深圳市轩腾华兴科技开发有限公司. All rights reserved.
//

#import "AnswerTableViewCell.h"
#import "MLEmojiLabel.h"

@interface AnswerTableViewCell ()

@property (nonatomic, weak) UILabel *nickL;
@property (nonatomic, weak) UILabel *contentL;
@property (nonatomic, weak) MLEmojiLabel *commentsL;
@property (nonatomic, weak) UILabel *lineV;

@end

@implementation AnswerTableViewCell

+ (AnswerTableViewCell *)cellWithTableView:(UITableView *)tableView{
    static NSString *ID = @"AnswerTableViewCell";
    
    AnswerTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    cell = [[AnswerTableViewCell alloc ] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
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

- (void)setUpChildView {
    UILabel *nickL = [[UILabel alloc] init];
    _nickL = nickL;
    [_nickL setFont:[UIFont systemFontOfSize:13.0]];
    [_nickL setTextColor:GOLDEN_YELLOW];
    //添加点击事件
    _nickL.userInteractionEnabled = YES;
    UITapGestureRecognizer *labelTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                                action:@selector(labelTouchUpInside:)];
    [_nickL addGestureRecognizer:labelTapGestureRecognizer];
    [self.contentView addSubview:_nickL];
    
    UILabel *contentL = [[UILabel alloc] init];
    _contentL = contentL;
    [_contentL setFont:[UIFont systemFontOfSize:13.0 weight:UIFontWeightLight]];
    [_contentL setTextColor:BLACK_COLOR];
    [self.contentView addSubview:_contentL];
    
    MLEmojiLabel *commentsL = [[MLEmojiLabel alloc] initWithFrame:CGRectZero];
    _commentsL = commentsL;
    _commentsL.numberOfLines = 0;
    _commentsL.font = [UIFont systemFontOfSize:15.0];
    _commentsL.customEmojiRegex = @"\\[[a-zA-Z0-9\\u4e00-\\u9fa5]+\\]";
    _commentsL.customEmojiPlistName = @"MLEmoji_ExpressionImage";
    _commentsL.textAlignment = NSTextAlignmentLeft;
    _commentsL.backgroundColor = [UIColor clearColor];
    _commentsL.isNeedAtAndPoundSign = YES;
    [_commentsL setTextColor:BLACK_COLOR];
    [self.contentView addSubview:_commentsL];
    
    //分割线
    UILabel *lineV = [[UILabel alloc] initWithFrame:CGRectZero];
    _lineV = lineV;
    [_lineV setBackgroundColor:STROKE_GARY_COLOR];
    [self addSubview:_lineV];
    
}

- (void)setModeFrame:(AnswerMessageModeFrame *)modeFrame{
    _modeFrame = modeFrame;
    
    _nickL.frame = _modeFrame.nickNameFrame;
    _contentL.frame = _modeFrame.contentFrame;
    _commentsL.frame = _modeFrame.commentsFrame;
    _lineV.frame = _modeFrame.lineVFrame;
    
    [self setCellWithCellInfo:_modeFrame.pMode];
}

- (void)setCellWithCellInfo:(STMessageCare *)pMode
{
    [_nickL setText:pMode.content.name];
    [_contentL setText:pMode.content.msg];
    [_commentsL setText:pMode.content.question.orderInfo.content];
}


- (void)labelTouchUpInside:(UITapGestureRecognizer *)recognizer{
    
    if ([self.delegate respondsToSelector:@selector(nickNameTapped:)]) {
        [self.delegate nickNameTapped:_modeFrame.pMode.content.userid];
    }
}

@end
