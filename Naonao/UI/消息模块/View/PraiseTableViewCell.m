//
//  PraiseTableViewCell.m
//  Naonao
//
//  Created by 刘敏 on 16/8/19.
//  Copyright © 2016年 深圳市轩腾华兴科技开发有限公司. All rights reserved.
//

#import "PraiseTableViewCell.h"
#import "SHLUILabel.h"
#import "MLEmojiLabel.h"


@interface PraiseTableViewCell ()

@property (nonatomic, weak) UILabel *nickL;
@property (nonatomic, weak) UILabel *contentL;
@property (nonatomic, weak) MLEmojiLabel *commentsL;

@property (nonatomic, weak) UIImageView *praiseV;

@property (nonatomic, weak) UILabel *numL;
@property (nonatomic, weak) SHLUILabel *desL;

@property (nonatomic, weak) UILabel *lineV;

@end


@implementation PraiseTableViewCell

+ (PraiseTableViewCell *)cellWithTableView:(UITableView *)tableView{
    static NSString *ID = @"PraiseTableViewCell";
    
    PraiseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    cell = [[PraiseTableViewCell alloc ] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
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
    
    //赞的人数
    UIImageView *praiseV = [[UIImageView alloc] init];
    _praiseV = praiseV;
    [_praiseV setImage:[UIImage imageNamed:@"icon_praise1_selected.png"]];
    [self.contentView addSubview:_praiseV];
    
    UILabel *numL = [[UILabel alloc] init];
    _numL = numL;
    [_numL setFont:[UIFont systemFontOfSize:13.0]];
    [_numL setTextColor:PINK_COLOR];
    [self.contentView addSubview:_numL];
    
    SHLUILabel *desL = [[SHLUILabel alloc] initWithFrame:CGRectZero];
    _desL = desL;
    _desL.numberOfLines = 0;
    [_desL setTextColor:BLACK_COLOR];
    [_desL setFont:[UIFont systemFontOfSize:13.0]];
    [self.contentView addSubview:_desL];
    
    
    //分割线
    UILabel *lineV = [[UILabel alloc] initWithFrame:CGRectZero];
    _lineV = lineV;
    [_lineV setBackgroundColor:STROKE_GARY_COLOR];
    [self addSubview:_lineV];
}

- (void)setModeFrame:(PraiseMessageModeFrame *)modeFrame{
    _modeFrame = modeFrame;
    
    _nickL.frame = _modeFrame.nickNameFrame;
    _contentL.frame = _modeFrame.contentFrame;
    _commentsL.frame = _modeFrame.commentsFrame;
    _praiseV.frame = _modeFrame.picFrame;
    _numL.frame = _modeFrame.numFrame;
    _desL.frame = _modeFrame.desFrame;
    _lineV.frame = _modeFrame.lineVFrame;
    
    [self setCellWithCellInfo:_modeFrame.pMode];
}

- (void)setCellWithCellInfo:(STMessagePraise *)pMode
{
    [_nickL setText:pMode.content.name];
    [_contentL setText:pMode.content.msg];
    [_commentsL setText:pMode.content.extraData.content];
    
    [_numL setText:[pMode.content.extraData.nums stringValue]];
    [_desL setText:pMode.content.extraData.oInfo.orderInfo.content];
}


- (void)labelTouchUpInside:(UITapGestureRecognizer *)recognizer{
    
    if ([self.delegate respondsToSelector:@selector(nickNameTapped:)]) {
        [self.delegate nickNameTapped:_modeFrame.pMode.content.userid];
    }
    
}

@end
