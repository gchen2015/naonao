//
//  PAboveView.m
//  Naonao
//
//  Created by Richard Liu on 16/2/1.
//  Copyright © 2016年 深圳市轩腾华兴科技开发有限公司. All rights reserved.
//

#import "PAboveView.h"
#import "SHLUILabel.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "CommunityLogic.h"

@interface PAboveView ()

@property (nonatomic, weak) UIImageView *headV;
@property (nonatomic, weak) UILabel *nameL;
@property (nonatomic, weak) UIImageView *tipV;
@property (nonatomic, weak) UILabel *similarL;


@end

@implementation PAboveView

- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        [self setUpChildView];
    }
    return self;
}

- (void)setUpChildView {
    
    UIImageView *headV = [[UIImageView alloc] init];
    _headV = headV;
    [self addSubview:_headV];
    //点击事件
    _headV.userInteractionEnabled = YES;
    //添加点击事件
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageActiondo:)];
    [_headV addGestureRecognizer:tapGesture];
    [self addSubview:_headV];

    UILabel *nameL = [[UILabel alloc] init];
    _nameL = nameL;
    [_nameL setFont:[UIFont systemFontOfSize:15.0]];
    [_nameL setTextColor:BLACK_COLOR];
    [self addSubview:_nameL];
    
    
    UIImageView *tipV = [[UIImageView alloc] init];
    _tipV = tipV;
    [_tipV setImage:[UIImage imageNamed:@"rudder_tag.png"]];
    [self addSubview:_tipV];
    
    UILabel *similarL = [[UILabel alloc] init];
    _similarL = similarL;
    [_similarL setTextAlignment:NSTextAlignmentRight];
    [self addSubview:_similarL];

}


- (void)setProFrame:(ProductModeFrame *)proFrame
{
    _proFrame = proFrame;
    
    _headV.frame = _proFrame.headFrame;
    _nameL.frame = _proFrame.nikeFrame;
    _tipV.frame = _proFrame.tipFrame;

    [self setChildViewData];
}


- (void)setAnFrame:(AnswerModeFrame *)anFrame
{
    _anFrame = anFrame;
    
    _headV.frame = _anFrame.headFrame;
    _nameL.frame = _anFrame.nikeFrame;
    _tipV.frame = _anFrame.tipFrame;
    _similarL.frame = _anFrame.similarFrame;
    
    [self setAnChildViewData];
}

- (void)setChildViewData
{
    //圆角
    _headV.layer.cornerRadius = CGRectGetWidth(_headV.frame)/2; //设置那个圆角的有多圆
    _headV.layer.masksToBounds = YES;  //设为NO去试试
    _headV.layer.borderColor = LIGHT_BLACK_COLOR.CGColor;
    _headV.layer.borderWidth = 0.5;
    [_headV sd_setImageWithURL:[NSURL URLWithString:_proFrame.pData.duozhu.avatar] placeholderImage:[UIImage imageNamed:@"default_avatar_large.png"]];
    [_nameL setText:_proFrame.pData.duozhu.nickname];
}


- (void)setAnChildViewData {
    //圆角
    _headV.layer.cornerRadius = CGRectGetWidth(_headV.frame)/2; //设置那个圆角的有多圆
    _headV.layer.masksToBounds = YES;  //设为NO去试试
    _headV.layer.borderColor = LIGHT_BLACK_COLOR.CGColor;
    _headV.layer.borderWidth = 0.5;
    [_headV sd_setImageWithURL:[NSURL URLWithString:_anFrame.aMode.userInfo.avatar] placeholderImage:[UIImage imageNamed:@"default_avatar_large.png"]];
    [_nameL setText:_anFrame.aMode.userInfo.nickname];
    
    NSString *st = [NSString stringWithFormat:@"与你相似度 %@%@", _anFrame.aMode.match_score, @"%"];
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:st];
    [str addAttribute:NSForegroundColorAttributeName value:BLACK_COLOR range:NSMakeRange(0, 6)];
    [str addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHex:0x4f4c4c] range:NSMakeRange(6, st.length-7)];
    [str addAttribute:NSForegroundColorAttributeName value:BLACK_COLOR range:NSMakeRange(st.length-1, 1)];
    
    [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:11.0] range:NSMakeRange(0, 6)];
    [str addAttribute:NSFontAttributeName value:[UIFont fontWithName:kAkzidenzGroteskBQ size:25.0] range:NSMakeRange(6, st.length-7)];
    [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:11.0] range:NSMakeRange(st.length-1, 1)];
    _similarL.attributedText = str;
 
}


- (void)imageActiondo:(UITapGestureRecognizer *)tapGesture
{
    //判断是否登录
    if (![UserLogic sharedInstance].user.basic.userId) {
        [theAppDelegate popLoginView];
        return;
    }
    
    if (_delegate && [_delegate respondsToSelector:@selector(pAboveView:headWithIndex:)]) {
        if(_proFrame)
        {
            [_delegate pAboveView:self headWithIndex:_proFrame.index];
        }
        else if (_anFrame)
        {
            [_delegate pAboveView:self headWithIndex:_anFrame.index];
        }
    }
}



@end
