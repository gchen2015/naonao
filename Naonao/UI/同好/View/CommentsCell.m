//
//  CommentsCell.m
//  Naonao
//
//  Created by 刘敏 on 16/4/6.
//  Copyright © 2016年 深圳市轩腾华兴科技开发有限公司. All rights reserved.
//

#import "CommentsCell.h"
#import <SDWebImage/UIButton+WebCache.h>
#import "TimeUtil.h"
#import "MLEmojiLabel.h"



@interface CommentsCell ()<MLEmojiLabelDelegate>

@property (weak, nonatomic) UIButton *headV;        //头像
@property (weak, nonatomic) UILabel *timeLabel;     //时间
@property (weak, nonatomic) UILabel *nameL;

@property (nonatomic, strong) MLEmojiLabel *comLabel;

@end



@implementation CommentsCell

+ (CommentsCell *)cellWithTableView:(UITableView *)tableView{
    static NSString *ID = @"CommentsCell";
    
    CommentsCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[CommentsCell alloc ] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
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
    UIButton *headV = [[UIButton alloc] init];
    _headV = headV;

    [_headV addTarget:self action:@selector(headTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_headV];
    
    UILabel *nameL = [[UILabel alloc] init];
    _nameL = nameL;
    [_nameL setTextColor:PINK_COLOR];
    [_nameL setFont:[UIFont systemFontOfSize:14.0]];
    [self.contentView addSubview:_nameL];
    
    UILabel *timeLabel = [[UILabel alloc] init];
    _timeLabel = timeLabel;
    [_timeLabel setTextColor:LIGHT_BLACK_COLOR];
    [_timeLabel setTextAlignment:NSTextAlignmentRight];
    [_timeLabel setFont:[UIFont systemFontOfSize:12.0]];
    [self.contentView addSubview:_timeLabel];
    
    
    //评论总条数
    _comLabel = [[MLEmojiLabel alloc] initWithFrame:CGRectZero];
    _comLabel.numberOfLines = 0;
    _comLabel.font = [UIFont systemFontOfSize:14.0];
    _comLabel.delegate = self;
    _comLabel.customEmojiRegex = @"\\[[a-zA-Z0-9\\u4e00-\\u9fa5]+\\]";
    _comLabel.customEmojiPlistName = @"MLEmoji_ExpressionImage";
    _comLabel.textAlignment = NSTextAlignmentLeft;
    _comLabel.backgroundColor = [UIColor clearColor];
    _comLabel.isNeedAtAndPoundSign = YES;
    
}

- (void)setComModelFrame:(CommentsModelFrame *)comModelFrame
{
    _comModelFrame = comModelFrame;
    
    _headV.frame = comModelFrame.headVFrame;
    _nameL.frame = comModelFrame.nameLabelFrame;
    _timeLabel.frame = comModelFrame.timeFrame;
    
    //圆角
    _headV.layer.cornerRadius = CGRectGetWidth(_headV.frame)/2; //设置那个圆角的有多圆
    _headV.layer.masksToBounds = YES;  //设为NO去试试
    _headV.layer.borderColor = LIGHT_BLACK_COLOR.CGColor;
    _headV.layer.borderWidth = 0.4;
    
    _comLabel.frame = comModelFrame.contentFrame;
    
    [self setUpChildData];
}

- (void)setUpChildData
{
    
    if(_comModelFrame.tData.avatorUrl)
    {
        [_headV sd_setBackgroundImageWithURL:[NSURL URLWithString:[_comModelFrame.tData.avatorUrl smallHead]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"default_avatar_large.png"]];
    }
    else{
        [_headV setImage:[UIImage imageNamed:@"default_avatar_large.png"] forState:UIControlStateNormal];
    }

    [_nameL setText:_comModelFrame.tData.nickName];
    [_timeLabel setText:[TimeUtil getFormattedTimeWithDate:_comModelFrame.tData.createTime]];
    
    [self drawComLabel];
    
}

- (void)drawComLabel
{
    NSString *tempS = @"";
    
    //计算评论区域高度
    if ([_comModelFrame.tData.at_userId integerValue] == [_comModelFrame.authorID integerValue]) {
        //评论作者
        tempS = [NSString stringWithFormat:@"%@", _comModelFrame.tData.content];
        _comLabel.text = [tempS stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    }
    else
    {
        //A评论B
        tempS = [NSString stringWithFormat:@"@%@  %@", _comModelFrame.tData.at_nickName, _comModelFrame.tData.content];
        
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
        [dic setObject:_comModelFrame.tData.at_userId forKey:@"at_userid"];
        [dic setObject:_comModelFrame.tData.at_nickName forKey:@"at_nickname"];
        _comLabel.text = [tempS stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        
        [_comLabel addLinkToTransitInformation:dic withRange:NSMakeRange(0, _comModelFrame.tData.at_nickName.length+1)];
    }
    
    [self.contentView addSubview:_comLabel];
}


- (void)headTapped:(id)sender
{
    if (_delegate && [_delegate respondsToSelector:@selector(commentsCell:useId:)]) {
        [_delegate commentsCell:self useId:_comModelFrame.tData.userId];
    }
}


- (void)attributedLabel:(TTTAttributedLabel *)label didSelectLinkWithTransitInformation:(NSDictionary *)components
{
    if (_delegate && [_delegate respondsToSelector:@selector(commentsCell:commentsWithInfo:indexWithRow:)]) {
        [_delegate commentsCell:self commentsWithInfo:components indexWithRow:_lineNO];
    }
}


@end
