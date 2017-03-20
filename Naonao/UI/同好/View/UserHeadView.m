//
//  UserHeadView.m
//  Naonao
//
//  Created by 刘敏 on 16/4/13.
//  Copyright © 2016年 深圳市轩腾华兴科技开发有限公司. All rights reserved.
//

#import "UserHeadView.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "CommunityLogic.h"
#import "ZFProgressView.h"


@interface UserHeadView ()
//关注
@property (nonatomic, weak) UIButton *focusButton;

@property (nonatomic, weak) UIImageView *headV;
@property (nonatomic, weak) UILabel *nameL;
@property (nonatomic, weak) UILabel *followL;
@property (nonatomic, weak) UIButton *followBtn;

@property (nonatomic, strong) STUserInfo *userInfo;
@property (nonatomic, weak) UIView *yellowView;

@property (nonatomic, weak) UILabel *lineV;
@property (nonatomic, weak) UIButton *arrowBtn;

@end


@implementation UserHeadView


+ (instancetype)personalHeaderViewWithCGSize:(CGSize)headerSize
{
    UserHeadView *headerView = [[UserHeadView alloc] initWithFrame:CGRectMake(0, 0, headerSize.width, headerSize.height)];
    [headerView setUpChildView];
    return headerView;
}

- (void)setUpChildView
{
    [self setBackgroundColor:[UIColor whiteColor]];
    
    self.userInteractionEnabled = YES;
    
    UIImageView *headV = [[UIImageView alloc] initWithFrame:CGRectMake(14, 20, 45, 45)];
    _headV = headV;
    _headV.layer.cornerRadius = CGRectGetHeight(_headV.frame)/2;        //设置那个圆角的有多圆
    _headV.layer.masksToBounds = YES;                                   //设为NO去试试
    _headV.layer.borderWidth = 1;                                       //设置边框的宽度，当然可以不要
    _headV.layer.borderColor = [UIColor lightGrayColor].CGColor;        //设置边框的颜色
    [self addSubview:_headV];
    
    
    UILabel *nameL = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_headV.frame)+5, 20, 200, 25)];
    _nameL = nameL;
    [_nameL setTextColor:BLACK_COLOR];
    [_nameL setFont:[UIFont boldSystemFontOfSize:16.0]];
    [self addSubview:_nameL];
    
    
    UILabel *followL = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_headV.frame)+5, 45, 200, 20)];
    _followL = followL;
    [_followL setTextColor:LIGHT_BLACK_COLOR];
    [_followL setFont:[UIFont systemFontOfSize:13.0]];
    [self addSubview:_followL];
    
    UIButton *focusButton = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH- 80, 27.5, 66, 30)];
    self.focusButton = focusButton;
    //圆角
    self.focusButton.layer.cornerRadius = 14;
    self.focusButton.layer.borderColor = BLACK_COLOR.CGColor;
    self.focusButton.layer.borderWidth = 0.5;
    self.focusButton.layer.masksToBounds = YES;
    [self.focusButton.titleLabel setFont:[UIFont systemFontOfSize:14.0]];
    [self.focusButton setTitleColor:BLACK_COLOR forState:UIControlStateNormal];
    [self.focusButton addTarget:self action:@selector(focusButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.focusButton];
    
    UIView *yellowView = [[UIView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2 - 90, CGRectGetMaxY(_headV.frame)+14, 180, 30)];
    _yellowView = yellowView;
    [_yellowView setBackgroundColor:[UIColor colorWithHex:0xfaf1e3]];
    _yellowView.layer.cornerRadius = 5;
    _yellowView.layer.masksToBounds = YES;
    [self addSubview:_yellowView];
    
}


- (void)updateUI:(STUserInfo *)userInfo
{
    _userInfo = userInfo;
    
    
    [_nameL setText:userInfo.userName];
    [_followL setText:[NSString stringWithFormat:@"%@ 关注的人，%@ 粉丝", userInfo.collect.following, userInfo.collect.follower]];
    
    [_headV sd_setImageWithURL:[NSURL URLWithString:[userInfo.portraitUrl smallHead]] placeholderImage:[UIImage imageNamed:@"default_avatar_large.png"]];
    
    //设置关注
    if ([userInfo.isFollow boolValue]) {
        //已关注
        _focusButton.layer.borderColor = BLACK_COLOR.CGColor;
        [_focusButton setTitleColor:BLACK_COLOR forState:UIControlStateNormal];
        [_focusButton setTitle:@"已关注" forState:UIControlStateNormal];
    }
    else {
        _focusButton.layer.borderColor = PINK_COLOR.CGColor;
        [_focusButton setTitleColor:PINK_COLOR forState:UIControlStateNormal];
        [_focusButton setTitle:@"关 注" forState:UIControlStateNormal];
    }

    
    UILabel *degreeA = [[UILabel alloc] initWithFrame:CGRectMake(8, 0, 70, 30)];
    [degreeA setFont:[UIFont systemFontOfSize:13.0]];
    [degreeA setText:@"与您同好度"];
    [degreeA setTextColor:PINK_COLOR];
    [_yellowView addSubview:degreeA];
    
    UILabel *degreeB = [[UILabel alloc] initWithFrame:CGRectMake(112, 0, 60, 30)];
    [degreeB setFont:[UIFont boldSystemFontOfSize:21.0]];
    [degreeB setTextColor:PINK_COLOR];
    [degreeB setTextAlignment:NSTextAlignmentRight];
    
    NSString *st = [NSString stringWithFormat:@"%@%@", userInfo.scoresInfo.total, @"%"];
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:st];
    
    [str addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:21.0] range:NSMakeRange(0, st.length-1)];
    [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:13.0] range:NSMakeRange(st.length-1, 1)];
    
    degreeB.attributedText = str;
    [_yellowView addSubview:degreeB];
    
    [self drawProgressView];

}

- (void)drawProgressView
{
    CGFloat mW = (SCREEN_WIDTH - 75*3)/4;
    
    /****************************************  兴趣   **************************************************/
    UIButton *v1 = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 80, 80)];
    v1.layer.borderWidth = 1;
    v1.layer.borderColor = [UIColor lightGrayColor].CGColor;
    v1.layer.cornerRadius = 40.0;
    v1.tag = 10001;
    //添加点击事件
    [v1 addTarget:self action:@selector(interestDo:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:v1];
    
    ZFProgressView *progress1 = [[ZFProgressView alloc] initWithFrame:CGRectMake(mW, CGRectGetMaxY(_yellowView.frame)+20, 75, 75)];
    progress1.progressLineWidth = 2;
    progress1.backgourndLineWidth = 0;
    progress1.timeDuration = 1.0;
    //进度条填充颜色
    [progress1 setProgressStrokeColor:BLACK_COLOR];
    [progress1 setProgress:[_userInfo.scoresInfo.interest floatValue]/100.0f Animated:YES];
    [self addSubview:progress1];
    v1.center = progress1.center;
    
    UILabel *lA = [[UILabel alloc] initWithFrame:v1.frame];
    [lA setText:@"兴趣"];
    [lA setTextColor:BLACK_COLOR];
    [lA setTextAlignment:NSTextAlignmentCenter];
    [lA setFont:[UIFont systemFontOfSize:25.0]];
    [self addSubview:lA];
    
    UILabel *mA = [[UILabel alloc] initWithFrame:CGRectMake(mW-5, CGRectGetMaxY(progress1.frame)+10, 85, 15)];
    NSString *st1 = [NSString stringWithFormat:@"兴趣相似度%@%@", _userInfo.scoresInfo.interest, @"%"];
    [mA setText:st1];
    [mA setTextColor:BLACK_COLOR];
    [mA setTextAlignment:NSTextAlignmentCenter];
    [mA setFont:[UIFont systemFontOfSize:11.0]];
    [self addSubview:mA];
    
    
    
    
    /****************************************  风格   **************************************************/
    UIButton *v2 = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 80, 80)];
    v2.layer.borderWidth = 1;
    v2.layer.borderColor = [UIColor lightGrayColor].CGColor;
    v2.layer.cornerRadius = 40.0;
    v2.tag = 10002;
    //添加点击事件
    [v2 addTarget:self action:@selector(interestDo:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:v2];
    
    ZFProgressView *progress2 = [[ZFProgressView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-75)/2, CGRectGetMaxY(_yellowView.frame)+20, 75, 75)];
    progress2.progressLineWidth = 2;
    progress2.backgourndLineWidth = 0;
    progress2.timeDuration = 1.0;
    //进度条填充颜色
    [progress2 setProgressStrokeColor:BLACK_COLOR];
    [progress2 setProgress:[_userInfo.scoresInfo.style floatValue]/100.0f Animated:YES];
    [self addSubview:progress2];
    v2.center = progress2.center;
    
    UILabel *lB = [[UILabel alloc] initWithFrame:v2.frame];
    [lB setText:@"风格"];
    [lB setTextColor:BLACK_COLOR];
    [lB setTextAlignment:NSTextAlignmentCenter];
    [lB setFont:[UIFont systemFontOfSize:25.0]];
    [self addSubview:lB];
    
    
    UILabel *mB = [[UILabel alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-85)/2, CGRectGetMaxY(progress1.frame)+10, 85, 15)];
    NSString *st2 = [NSString stringWithFormat:@"风格相似度%@%@", _userInfo.scoresInfo.style, @"%"];
    [mB setText:st2];
    [mB setTextColor:BLACK_COLOR];
    [mB setTextAlignment:NSTextAlignmentCenter];
    [mB setFont:[UIFont systemFontOfSize:11.0]];
    [self addSubview:mB];


    /****************************************  身材   **************************************************/
    UIButton *v3 = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 80, 80)];
    v3.layer.borderWidth = 1;
    v3.layer.borderColor = [UIColor lightGrayColor].CGColor;
    v3.layer.cornerRadius = 40.0;
    v3.tag = 10003;
    //添加点击事件
    [v3 addTarget:self action:@selector(interestDo:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:v3];
    
    ZFProgressView *progress3 = [[ZFProgressView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(progress2.frame)+mW, CGRectGetMaxY(_yellowView.frame)+20, 75, 75)];
    progress3.progressLineWidth = 2;
    progress3.backgourndLineWidth = 0;
    progress3.timeDuration = 1.0;
    //进度条填充颜色
    [progress3 setProgressStrokeColor:BLACK_COLOR];

    
    [progress3 setProgress:[_userInfo.scoresInfo.body floatValue]/100.0f Animated:YES];
    [self addSubview:progress3];
    v3.center = progress3.center;
    
    
    UILabel *lC = [[UILabel alloc] initWithFrame:v3.frame];
    [lC setText:@"身材"];
    [lC setTextColor:BLACK_COLOR];
    [lC setTextAlignment:NSTextAlignmentCenter];
    [lC setFont:[UIFont systemFontOfSize:25.0]];
    [self addSubview:lC];
    
    
    UILabel *mC = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(progress2.frame)+mW-5, CGRectGetMaxY(progress1.frame)+10, 85, 15)];
    NSString *st3 = [NSString stringWithFormat:@"身材相似度%@%@", _userInfo.scoresInfo.body, @"%"];
    [mC setText:st3];
    [mC setTextColor:BLACK_COLOR];
    [mC setTextAlignment:NSTextAlignmentCenter];
    [mC setFont:[UIFont systemFontOfSize:11.0]];
    [self addSubview:mC];
    
    
    
    [self bringSubviewToFront:v1];
    [self bringSubviewToFront:v2];
    [self bringSubviewToFront:v3];
}


#pragma mark - focusButton的点击事件
- (void)focusButtonTapped:(UIButton *)sender{
    
    NSMutableDictionary *dict =[[NSMutableDictionary alloc] initWithCapacity:1];
    [dict setObject:_userInfo.userId forKey:@"following"];
    
    
    if ([_userInfo.isFollow boolValue]) {
        
        //取消关注
        [[CommunityLogic sharedInstance] getUnAttentionUserInfo:dict withCallback:^(LogicResult *result) {
            if(result.statusCode == KLogicStatusSuccess)
            {
                _userInfo.isFollow = [NSNumber numberWithBool:NO];
                sender.layer.borderColor = PINK_COLOR.CGColor;
                [sender setTitleColor:PINK_COLOR forState:UIControlStateNormal];
                [sender setTitle:@"关 注" forState:UIControlStateNormal];

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
                _userInfo.isFollow = [NSNumber numberWithBool:YES];
                
                sender.layer.borderColor = BLACK_COLOR.CGColor;
                [sender setTitleColor:BLACK_COLOR forState:UIControlStateNormal];
                [sender setTitle:@"已关注" forState:UIControlStateNormal];
                
                [[NSNotificationCenter defaultCenter] postNotificationName:@"UPDATE_USER_DATA" object:nil];
                
            }
            else
                [theAppDelegate.window makeToast:result.stateDes];
        }];
    }
}

- (void)changeHigh
{
    CGRect mRect = CGRectZero;
    
    if (self.frame.size.height == 126.0) {
        mRect = CGRectMake(0, 0, SCREEN_WIDTH, 254.0);
    }
    else
    {
        mRect = CGRectMake(0, 0, SCREEN_WIDTH, 126.0);
    }
    self.frame = mRect;
    
    [_lineV setFrame:CGRectMake(0, CGRectGetHeight(self.frame)-0.5, SCREEN_WIDTH, 0.5)];
    [_arrowBtn setFrame:CGRectMake((SCREEN_WIDTH- 29)/2, CGRectGetHeight(self.frame)-11, 29, 11)];
    
    if (_delegate && [_delegate respondsToSelector:@selector(updateUserHeadView)])
    {
        [_delegate updateUserHeadView];
    }
    
}

- (void)interestDo:(UIButton *)sender
{
    if (_delegate && [_delegate respondsToSelector:@selector(userHeadView:indexWithBtn:)]) {
        [_delegate userHeadView:self indexWithBtn:sender.tag - 10000];
    }
}


@end
