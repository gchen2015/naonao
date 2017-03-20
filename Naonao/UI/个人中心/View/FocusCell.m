//
//  FocusCell.m
//  Naonao
//
//  Created by 刘敏 on 16/7/21.
//  Copyright © 2016年 深圳市轩腾华兴科技开发有限公司. All rights reserved.
//

#import "FocusCell.h"
#import <SDWebImage/UIButton+WebCache.h>
#import "CommunityLogic.h"

@interface FocusCell ()

@property (nonatomic, weak) UIButton *headBtn;
@property (nonatomic, weak) UILabel *nickLabel;
@property (nonatomic, weak) UIButton *followBtn;
@property (nonatomic, weak) UserFollow *sInfo;

@end

@implementation FocusCell


+ (FocusCell *)cellWithTableView:(UITableView *)tableView{
    static NSString *ID = @"FocusCell";
    
    FocusCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[FocusCell alloc ] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
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
    UIButton *headBtn = [[UIButton alloc] initWithFrame:CGRectMake(16, 12, 40, 40)];
    _headBtn = headBtn;
    //圆角
    _headBtn.layer.cornerRadius = CGRectGetWidth(_headBtn.frame)/2; //设置那个圆角的有多圆
    _headBtn.layer.masksToBounds = YES;  //设为NO去试试
    _headBtn.layer.borderColor = [UIColor whiteColor].CGColor;
    _headBtn.layer.borderWidth = 0.5;
    _headBtn.userInteractionEnabled = YES;
    [_headBtn addTarget:self action:@selector(headBtnTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_headBtn];
    
    
    UILabel *nickLabel = [[UILabel alloc] initWithFrame:CGRectMake(70, 12, 200, 40)];
    _nickLabel = nickLabel;
    [_nickLabel setTextColor:BLACK_COLOR];
    [_nickLabel setFont:[UIFont systemFontOfSize:15]];
    [self.contentView addSubview:_nickLabel];
    
    UIButton *followBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 81, 17, 66, 30)];
    _followBtn = followBtn;
    //圆角
    _followBtn.layer.cornerRadius = 14;
    _followBtn.layer.borderColor = BLACK_COLOR.CGColor;
    _followBtn.layer.borderWidth = 0.5;
    _followBtn.layer.masksToBounds = YES;
    [_followBtn.titleLabel setFont:[UIFont systemFontOfSize:14.0]];
    [_followBtn setTitleColor:BLACK_COLOR forState:UIControlStateNormal];
    [_followBtn addTarget:self action:@selector(followBtnTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_followBtn];
    
    //分割线
    UIView *lineV = [[UIView alloc] initWithFrame:CGRectMake(70 , 63.5, SCREEN_WIDTH - 70, 0.5)];
    lineV.backgroundColor = STROKE_GARY_COLOR;
    [self.contentView addSubview:lineV];
}


- (void)setCellWithCellInfo:(UserFollow *)sInfo
{
    [_headBtn sd_setBackgroundImageWithURL:[NSURL URLWithString:[sInfo.avatar smallHead]] forState:UIControlStateNormal];
    [_nickLabel setText:sInfo.nickname];
    
    if ([sInfo.isFollow boolValue]) {
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
    
    _sInfo = sInfo;
}

- (void)headBtnTapped:(id)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(focusCell:headBtnTapped:)]) {
        [_delegate focusCell:self headBtnTapped:_sInfo.userId];
    }
}

- (void)followBtnTapped:(id)sender {
    NSMutableDictionary *dict =[[NSMutableDictionary alloc] initWithCapacity:1];
    [dict setObject:_sInfo.userId forKey:@"following"];
    
    __typeof (&*self) __weak weakSelf = self;
    
    if ([_sInfo.isFollow boolValue]) {
        //取消关注
        [[CommunityLogic sharedInstance] getUnAttentionUserInfo:dict withCallback:^(LogicResult *result) {
            if(result.statusCode == KLogicStatusSuccess)
            {
                weakSelf.sInfo.isFollow = [NSNumber numberWithBool:NO];
                weakSelf.followBtn.layer.borderColor = PINK_COLOR.CGColor;
                [weakSelf.followBtn setTitleColor:PINK_COLOR forState:UIControlStateNormal];
                [weakSelf.followBtn setTitle:@"关 注" forState:UIControlStateNormal];
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
                weakSelf.sInfo.isFollow = [NSNumber numberWithBool:YES];
                weakSelf.followBtn.layer.borderColor = BLACK_COLOR.CGColor;
                [weakSelf.followBtn setTitleColor:BLACK_COLOR forState:UIControlStateNormal];
                [weakSelf.followBtn setTitle:@"已关注" forState:UIControlStateNormal];

            }
            else
                [theAppDelegate.window makeToast:result.stateDes];
        }];
    }
}

@end
