//
//  RudderCell.m
//  Naonao
//
//  Created by 刘敏 on 16/7/26.
//  Copyright © 2016年 深圳市轩腾华兴科技开发有限公司. All rights reserved.
//

#import "RudderCell.h"
#import "SHLUILabel.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "TimeUtil.h"
#import "UserLogic.h"
#import "CommunityLogic.h"


@interface RudderCell()
@property (nonatomic, weak) UIView *lineVA;
@property (nonatomic, weak) UIImageView *bigImageView;
@property (nonatomic, weak) SHLUILabel *desL;

@property (nonatomic, weak) UIImageView *headV;

@property (nonatomic, weak) UILabel *timeL;
@property (nonatomic, weak) UILabel *nickL;
@property (nonatomic, weak) UIImageView *tipV;
@property (nonatomic, weak) UIButton *followBtn;

@property (nonatomic, weak) UIView *lineVB;
@property (nonatomic, weak) UIView *intervalView;

@end

@implementation RudderCell


+ (RudderCell *)cellWithTableView:(UITableView *)tableView{
    static NSString *ID = @"RudderCell";
    
    RudderCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    cell = [[RudderCell alloc ] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
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
    //顶部分割线
    UIView *lineVA = [[UIView alloc] initWithFrame:CGRectZero];
    _lineVA = lineVA;
    _lineVA.backgroundColor = STROKE_GARY_COLOR;
    [self.contentView addSubview:_lineVA];
    
    UIImageView *bigImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    _bigImageView = bigImageView;
    [self.contentView addSubview:_bigImageView];
    
    SHLUILabel *desL = [[SHLUILabel alloc] initWithFrame:CGRectZero];
    _desL = desL;
    _desL.numberOfLines = 0;
    [_desL setTextColor:BLACK_COLOR];
    [_desL setFont:[UIFont systemFontOfSize:14.0 weight:UIFontWeightLight]];
    [self.contentView addSubview:_desL];
    
    
    UIImageView *headV = [[UIImageView alloc] initWithFrame:CGRectZero];
    _headV = headV;
    //圆角
    _headV.layer.cornerRadius = 20;                     //设置那个圆角的有多圆
    _headV.layer.masksToBounds = YES;
    [self.contentView addSubview:_headV];
    
    UILabel *timeL = [[UILabel alloc] initWithFrame:CGRectZero];
    _timeL = timeL;
    [_timeL setTextColor:LIGHT_BLACK_COLOR];
    [_timeL setFont:[UIFont systemFontOfSize:11.0 weight:UIFontWeightLight]];
    [self.contentView addSubview:_timeL];
    
    UILabel *nickL = [[UILabel alloc] initWithFrame:CGRectZero];
    _nickL = nickL;
    [_nickL setTextColor:GOLDEN_YELLOW];
    [_nickL setFont:[UIFont systemFontOfSize:15.0]];
    [self.contentView addSubview:_nickL];
    
    UIImageView *tipV = [[UIImageView alloc] init];
    _tipV = tipV;
    [_tipV setImage:[UIImage imageNamed:@"rudder_tag.png"]];
    [self.contentView addSubview:_tipV];
    
    
    UIButton *followBtn = [[UIButton alloc] initWithFrame:CGRectZero];
    _followBtn = followBtn;
    //圆角
    _followBtn.layer.cornerRadius = 14;
    _followBtn.layer.borderColor = PINK_COLOR.CGColor;
    _followBtn.layer.borderWidth = 0.5;
    _followBtn.layer.masksToBounds = YES;
    [_followBtn.titleLabel setFont:[UIFont systemFontOfSize:14.0]];
    [_followBtn setTitleColor:PINK_COLOR forState:UIControlStateNormal];
    [_followBtn setTitle:@"关 注" forState:UIControlStateNormal];
    [_followBtn addTarget:self action:@selector(followBtnTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_followBtn];
    
    //底部分割线
    UIView *lineVB = [[UIView alloc] initWithFrame:CGRectZero];
    _lineVB = lineVB;
    _lineVB.backgroundColor = STROKE_GARY_COLOR;
    [self.contentView addSubview:_lineVB];
    
    UIView *intervalView = [[UIView alloc] initWithFrame:CGRectZero];
    _intervalView = intervalView;
    [_intervalView setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
    [self.contentView addSubview:_intervalView];
}

- (void)followBtnTapped:(UIButton *)send{
    //判断是否登录
    if (![UserLogic sharedInstance].user.basic.userId) {
        [theAppDelegate popLoginView];
        return;
    }

    [self requestFocus:send.selected];
}

- (void)setModeFrame:(RudderModeFrame *)modeFrame{
    _modeFrame = modeFrame;
    
    _lineVA.frame = _modeFrame.linvAFrame;
    _bigImageView.frame = _modeFrame.bigImageViewFrame;
    _desL.frame =  _modeFrame.desFrame;
    _headV.frame = _modeFrame.headFrame;
    _timeL.frame = _modeFrame.timeFrame;
    _nickL.frame = _modeFrame.nickFrame;
    _tipV.frame = _modeFrame.tipFrame;
    _followBtn.frame = _modeFrame.followFrame;
    _lineVB.frame =_modeFrame.linvBFrame;
    _intervalView.frame = _modeFrame.intervalFrame;

    [self setCellWithCellInfo:_modeFrame.sModel];
}


- (void)setCellWithCellInfo:(STDuozhu *)model {
    [self.bigImageView setImageWithURL:[NSURL URLWithString:[model.extraInfo.photos objectAtIndex:0]] placeholderImage:[UIImage imageNamed:@"default_image.png"] animate:YES];
    
    //文字区域
    [_desL setText:model.extraInfo.introduce];
    
    [_headV sd_setImageWithURL:[NSURL URLWithString:[model.avatar smallHead]] placeholderImage:[UIImage imageNamed:@"default_avatar_large.png"]];
    
    //时间
    [_timeL setText:[TimeUtil getFormattedDateWithDate:model.createTime]];
    [_nickL setText:model.nickname];
    
    if ([model.isFollow boolValue]) {
        //已关注
        _followBtn.layer.borderColor = BLACK_COLOR.CGColor;
        [_followBtn setTitleColor:BLACK_COLOR forState:UIControlStateNormal];
        [_followBtn setTitle:@"已关注" forState:UIControlStateNormal];
    }
    else {
        _followBtn.layer.borderColor = PINK_COLOR.CGColor;
        [_followBtn setTitleColor:PINK_COLOR forState:UIControlStateNormal];
        [_followBtn setTitle:@"关 注" forState:UIControlStateNormal];
    }
}

- (void)requestFocus:(BOOL)isFollow {
    NSMutableDictionary *dict =[[NSMutableDictionary alloc] initWithCapacity:1];
    [dict setObject:_modeFrame.sModel.userid forKey:@"following"];
    
    __typeof (&*self) __weak weakSelf = self;
    
    if (isFollow) {
        //取消关注
        [[CommunityLogic sharedInstance] getUnAttentionUserInfo:dict withCallback:^(LogicResult *result) {
            if(result.statusCode == KLogicStatusSuccess)
            {
                weakSelf.modeFrame.sModel.isFollow = [NSNumber numberWithBool:NO];
                weakSelf.followBtn.layer.borderColor = PINK_COLOR.CGColor;
                [weakSelf.followBtn setTitleColor:PINK_COLOR forState:UIControlStateNormal];
                [weakSelf.followBtn setTitle:@"关 注" forState:UIControlStateNormal];
                
                [[NSNotificationCenter defaultCenter] postNotificationName:@"UPDATE_USER_DATA" object:nil];

            }
            else
                [theAppDelegate.window makeToast:result.stateDes];
        }];
    }
    else{
        //关注
        [[CommunityLogic sharedInstance] getAttentionUserInfo:dict withCallback:^(LogicResult *result) {
            if(result.statusCode == KLogicStatusSuccess)
            {
                weakSelf.modeFrame.sModel.isFollow = [NSNumber numberWithBool:YES];
                weakSelf.followBtn.layer.borderColor = BLACK_COLOR.CGColor;
                [weakSelf.followBtn setTitleColor:BLACK_COLOR forState:UIControlStateNormal];
                [weakSelf.followBtn setTitle:@"已关注" forState:UIControlStateNormal];
                
                [[NSNotificationCenter defaultCenter] postNotificationName:@"UPDATE_USER_DATA" object:nil];

                
            }
            else
                [theAppDelegate.window makeToast:result.stateDes];
        }];
    }
}

@end
