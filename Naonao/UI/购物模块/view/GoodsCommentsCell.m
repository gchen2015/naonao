//
//  GoodsCommentsCell.m
//  Naonao
//
//  Created by 刘敏 on 16/4/25.
//  Copyright © 2016年 深圳市轩腾华兴科技开发有限公司. All rights reserved.
//

#import "GoodsCommentsCell.h"
#import "SHLUILabel.h"
#import <SDWebImage/UIImageView+WebCache.h>



@interface GoodsCommentsCell ()

@property (nonatomic, weak) UILabel *lA;
@property (nonatomic, weak) UIImageView *headV;
@property (nonatomic, weak) UILabel *nikeL;
@property (nonatomic, weak) SHLUILabel* desLabel;

@property (nonatomic, weak) UILabel *lineV;

@end

@implementation GoodsCommentsCell


+ (GoodsCommentsCell *)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"GoodsCommentsCell";
    
    GoodsCommentsCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[GoodsCommentsCell alloc ] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
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
    UILabel *lA = [[UILabel alloc] initWithFrame:CGRectMake(14, 15, 100, 18)];
    _lA = lA;
    [_lA setFont:[UIFont boldSystemFontOfSize:13.0]];
    [_lA setTextColor:BLACK_COLOR];
    [self.contentView addSubview:_lA];
    
    //查看所有评论按钮
    UIButton *brandBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 90, 11.5, 80, 25)];
    UIImage *imageA = [UIImage imageNamed:@"icon_arrow_right.png"];
    [brandBtn setImage:imageA forState:UIControlStateNormal];
    [brandBtn setTitle:@"更多评论" forState:UIControlStateNormal];
    [brandBtn.titleLabel setFont:[UIFont boldSystemFontOfSize:13.0]];
    [brandBtn setTitleColor:BLACK_COLOR forState:UIControlStateNormal];
    
    [brandBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, -10, 0, imageA.size.width)];
    [brandBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 65, 0, 0)];
    
    [brandBtn addTarget:self action:@selector(brandBtnTapped:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.contentView addSubview:brandBtn];
    
    
    //头像
    UIImageView *headV = [[UIImageView alloc] initWithFrame:CGRectMake(14, CGRectGetMaxY(_lA.frame)+10, 30, 30)];
    _headV = headV;
    //圆角
    _headV.layer.cornerRadius = 15; //设置那个圆角的有多圆
    _headV.layer.masksToBounds = YES;  //设为NO去试试
    _headV.layer.borderColor = LIGHT_BLACK_COLOR.CGColor;
    _headV.layer.borderWidth = 0.5;
    [self.contentView addSubview:_headV];
    
    
    UILabel *nikeL = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_headV.frame)+10, CGRectGetMaxY(_lA.frame)+10, 100, 30)];
    _nikeL = nikeL;
    [_nikeL setTextColor:BLACK_COLOR];
    [_nikeL setFont:[UIFont systemFontOfSize:14.0]];
    [self.contentView addSubview:_nikeL];
    
    
    //评论信息
    SHLUILabel* desLabel = [[SHLUILabel alloc] init];
    _desLabel = desLabel;
    [_desLabel setTextColor:[UIColor grayColor]];
    [_desLabel setFont:[UIFont systemFontOfSize:15.0]];
    _desLabel.lineBreakMode = NSLineBreakByWordWrapping;
    _desLabel.numberOfLines = 0;
    [self addSubview:_desLabel];
    
    
    UILabel *lineV = [[UILabel alloc] initWithFrame:CGRectZero];
    _lineV = lineV;
    [_lineV setBackgroundColor:[UIColor colorWithWhite:0.8 alpha:1]];
    [self.contentView addSubview:_lineV];
}

- (CGFloat)setCellWithCellInfo:(CommentInfo *)cInfo commentNumber:(NSNumber *)commentsNum
{
    [_lA setText:[NSString stringWithFormat:@"评论(%@)", commentsNum]];
    [_headV sd_setImageWithURL:[NSURL URLWithString:cInfo.avatorUrl] placeholderImage:[UIImage imageNamed:@"default_avatar_large.png"]];
    [_nikeL setText:cInfo.cName];
    
    [_desLabel setText:cInfo.content];
    
    //根据字符串长度和Label显示的宽度计算出contentLab的高
    int labelHeight = [_desLabel getAttributedStringHeightWidthValue:SCREEN_WIDTH-28];
    [_desLabel setFrame:CGRectMake(14, CGRectGetMaxY(_headV.frame)+8, SCREEN_WIDTH-28, labelHeight)];
    
    [_lineV setFrame:CGRectMake(14, CGRectGetMaxY(_desLabel.frame)+29.5, SCREEN_WIDTH-28, 0.5)];
    
    return CGRectGetMaxY(_desLabel.frame)+30.0;
}


- (void)brandBtnTapped:(id)sender
{
    if (_delegate && [_delegate respondsToSelector:@selector(goodsCommentsCellJumpToCommentsList)]) {
        [_delegate goodsCommentsCellJumpToCommentsList];
    }
}


@end



/*****************************************  商品详情评论页的评论 cell *******************************/
@interface CommentsProductCell ()

@property (nonatomic, weak) UIImageView *headV;
@property (nonatomic, weak) UILabel *nikeL;
@property (nonatomic, weak) UILabel *timeL;
@property (nonatomic, weak) SHLUILabel* desLabel;

@end

@implementation CommentsProductCell

+ (CommentsProductCell *)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"CommentsProductCell";
    
    CommentsProductCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[CommentsProductCell alloc ] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
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
    //头像
    UIImageView *headV = [[UIImageView alloc] init];
    _headV = headV;
    //圆角
    _headV.layer.cornerRadius = 18; //设置那个圆角的有多圆
    _headV.layer.masksToBounds = YES;  //设为NO去试试
    _headV.layer.borderColor = LIGHT_BLACK_COLOR.CGColor;
    _headV.layer.borderWidth = 0.5;
    [self.contentView addSubview:_headV];
    _headV.userInteractionEnabled = YES;
    //头像点击
    UITapGestureRecognizer *tapGesturRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(headTapped:)];
    [_headV addGestureRecognizer:tapGesturRecognizer];
    
    
    //昵称
    UILabel *nikeL = [[UILabel alloc] init];
    _nikeL = nikeL;
    [_nikeL setTextColor:BLACK_COLOR];
    [_nikeL setFont:[UIFont systemFontOfSize:15.0]];
    [self.contentView addSubview:_nikeL];
    
    //时间
    UILabel *timeL = [[UILabel alloc] init];
    _timeL = timeL;
    [_timeL setTextAlignment:NSTextAlignmentRight];
    [_timeL setTextColor:LIGHT_BLACK_COLOR];
    [_timeL setFont:[UIFont systemFontOfSize:12.0]];
    [self.contentView addSubview:_timeL];
    
    
    //评论信息
    SHLUILabel* desLabel = [[SHLUILabel alloc] init];
    _desLabel = desLabel;
    [_desLabel setTextColor:[UIColor grayColor]];
    [_desLabel setFont:[UIFont systemFontOfSize:14.0]];
    [_desLabel setTextColor:[UIColor colorWithHex:0x595757 alpha:0.8]];
    _desLabel.lineBreakMode = NSLineBreakByWordWrapping;
    _desLabel.numberOfLines = 0;
    [self addSubview:_desLabel];
}

- (void)setComFrame:(CommentsProductFrame *)comFrame
{
    _comFrame = comFrame;
    
    _headV.frame = _comFrame.headVFrame;
    _nikeL.frame = _comFrame.nameLabelFrame;
    _timeL.frame = _comFrame.timeFrame;
    _desLabel.frame = _comFrame.contentFrame;
    
    [self setUpChildData];
}

- (void)setUpChildData
{
    [_headV sd_setImageWithURL:[NSURL URLWithString:_comFrame.tData.avatorUrl] placeholderImage:[UIImage imageNamed:@"default_avatar_large.png"]];
    [_nikeL setText:_comFrame.tData.cName];
    [_timeL setText:_comFrame.tData.createTime];
    
    [_desLabel setText:_comFrame.tData.content];
}


- (void)headTapped:(id)sender
{
    if (_delegate && [_delegate respondsToSelector:@selector(commentsProductCell:tappedWithUserInfo:)]) {
        [_delegate commentsProductCell:self tappedWithUserInfo:_comFrame.tData];
    }
}

@end
