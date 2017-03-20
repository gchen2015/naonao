//
//  MineHeadCell.m
//  Naonao
//
//  Created by 刘敏 on 16/7/19.
//  Copyright © 2016年 深圳市轩腾华兴科技开发有限公司. All rights reserved.
//

#import "MineHeadCell.h"
#import <SDWebImage/UIButton+WebCache.h>
#import "WithdrawModel.h"
#import "WithdrawLogic.h"
#import "ZQNewGuideView.h"
#import "CommunityLogic.h"
#import "STButton.h"
#import "STUserInfo.h"
#import "JSBadgeView.h"


@interface MineHeadCell ()

@property (strong, nonatomic) ZQNewGuideView *guideView;

@property (nonatomic, weak) UIButton *headBtn;
@property (nonatomic, weak) UIButton *mButton;          //进入返现模块按钮

@property (nonatomic, weak) UILabel *numL;
@property (nonatomic, weak) UILabel *amountL;

@property (nonatomic, weak) UILabel *desL;


@end


@implementation MineHeadCell

+ (MineHeadCell *)cellWithTableView:(UITableView *)tableView{
    static NSString *ID = @"WithdrawRecordCell";
    
    MineHeadCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[MineHeadCell alloc ] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
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
    UIButton *headBtn = [[UIButton alloc] initWithFrame:CGRectMake(20, 20, 72, 72)];
    _headBtn = headBtn;
    _headBtn.layer.cornerRadius = CGRectGetHeight(_headBtn.frame)/2;        //设置那个圆角的有多圆
    _headBtn.layer.masksToBounds = YES;                                     //设为NO去试试
    _headBtn.layer.borderWidth = 2;                                         //设置边框的宽度，当然可以不要
    _headBtn.layer.borderColor = [[UIColor colorWithHex:0xE7E1CE] CGColor];            //设置边框的颜色
    [_headBtn addTarget:self action:@selector(headBtnTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_headBtn];
    
    UIButton *mButton = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_headBtn.frame)+14, 28, SCREEN_WIDTH - CGRectGetMaxX(_headBtn.frame)-30, 30)];
    _mButton = mButton;
    //圆角
    _mButton.layer.cornerRadius = 5;                                    //设置那个圆角的有多圆
    _mButton.layer.masksToBounds = YES;                                 //设为NO去试试
    _mButton.layer.borderColor = PINK_COLOR.CGColor;
    _mButton.layer.borderWidth = 1.0;
    [_mButton addTarget:self action:@selector(walletBtnTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_mButton];
    
    UILabel *numL = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 100, 30)];
    _numL = numL;
    [_numL setTextColor:PINK_COLOR];
    [_numL setFont:[UIFont systemFontOfSize:13.0 weight:UIFontWeightMedium]];
    [_mButton addSubview:_numL];
    
    
    UILabel *amountL = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(_mButton.frame)-10, 30)];
    _amountL = amountL;
    [_amountL setTextColor:PINK_COLOR];
    [_amountL setFont:[UIFont systemFontOfSize:13.0  weight:UIFontWeightMedium]];
    [_amountL setTextAlignment:NSTextAlignmentRight];
    [_mButton addSubview:_amountL];
    
    //个人描述
    UILabel *desL = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_headBtn.frame)+14, 64, SCREEN_WIDTH - CGRectGetMaxX(_headBtn.frame)-30, 30)];
    _desL = desL;
    [_desL setTextColor:[UIColor colorWithHex:0xBAB3B3]];
    [_desL setFont:[UIFont systemFontOfSize:12.0]];
    [self.contentView addSubview:_desL];

    //按钮
    [self setUpMines];
}


- (void)setUpMines{
    CGFloat btnY = CGRectGetMaxY(_headBtn.frame) + 18;
    CGFloat btnW = SCREEN_WIDTH / 3;
    CGFloat btnH = 70;
    
    for (int i = 0; i < 3; i++) {
        STButton *nums = nil;
        if (i == 0) {
            nums = [[STButton alloc] initWithFrame:CGRectZero buttonWithTitle:@"收藏夹" countL:0];
        }
        if (i == 1) {
            nums = [[STButton alloc] initWithFrame:CGRectZero buttonWithTitle:@"关注" countL:0];
//            //添加上标
//            JSBadgeView *badgeView = [[JSBadgeView alloc] initWithParentView:nums alignment:JSBadgeViewAlignmentTopCenter];
//            [badgeView setBadgeTextFont:[UIFont systemFontOfSize:11.0]];
//            
//            //2、如果显示的位置不对，可以自己调整，超爽啊！
//            badgeView.badgePositionAdjustment = CGPointMake(13, 10);
//            
//            badgeView.badgeOverlayColor = [UIColor clearColor];
//            badgeView.badgeStrokeColor = [UIColor clearColor];
//            badgeView.badgeShadowColor = [UIColor clearColor];
//            badgeView.badgeTextColor = [UIColor whiteColor];
//            
//            [self updateBadgeView:badgeView enable:8];
        }
        if (i == 2) {
            nums = [[STButton alloc] initWithFrame:CGRectZero buttonWithTitle:@"粉丝" countL:0];
        }
        
        nums.tag = i+2000;
        nums.frame = CGRectMake(btnW * i, btnY, btnW, btnH);
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapEvents:)];
        tapGesture.numberOfTapsRequired = 1;
        tapGesture.numberOfTouchesRequired = 1;
        
        //开启触摸事件响应
        [nums addGestureRecognizer:tapGesture];
        
        UIView *lineV = [[UIView alloc] initWithFrame:CGRectMake(btnW * (i + 1) , btnY+16, 1, 28)];
        lineV.backgroundColor = STROKE_GARY_COLOR;
        [self addSubview:lineV];
        
        [self addSubview:nums];
    }
}


//头像点击
- (void)headBtnTapped:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(mineHeadTapped)]) {
        [self.delegate mineHeadTapped];
    }
}

- (void)walletBtnTapped
{
    if ([self.delegate respondsToSelector:@selector(mineHeadView:bTnIndex:)]) {
        [self.delegate mineHeadView:self bTnIndex:3];
    }
}

//触摸事件响应
- (void)tapEvents:(UITapGestureRecognizer *)tapGesture
{
    NSInteger tag = tapGesture.view.tag - 2000;
    if ([self.delegate respondsToSelector:@selector(mineHeadView:bTnIndex:)]) {
        [self.delegate mineHeadView:self bTnIndex:tag];
    }
}

- (void)updateUI
{
    User* user = [[UserLogic sharedInstance] getUser];
    [_headBtn sd_setBackgroundImageWithURL:[NSURL URLWithString:[user.basic.avatarUrl middleImage]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"default_avatar_large.png"]];
    
    if(user){
        [self getUserInfo];
        [self getWallet];

        //指引说明
        [self performSelector:@selector(makeFunctionGuide) withObject:nil afterDelay:0.2f];
    }
    
    [_desL setText:@"心如止水，万物皆为精灵"];
}


- (void)getUserInfo {
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithCapacity:1];
    [dict setObject:[UserLogic sharedInstance].user.basic.userId forKey:@"uid"];
    
    __typeof (&*self) __weak weakSelf = self;
    
    [[CommunityLogic sharedInstance] getUserInfo:dict withCallback:^(LogicResult *result) {
        if(result.statusCode == KLogicStatusSuccess)
        {
            STUserInfo *userInfo = result.mObject;
            [weakSelf updateSTButton:userInfo.collect];
        }

    }];
}

- (void)updateSTButton:(STCollect *)collect {
    for (int i = 0; i < 3; i++) {
        STButton *nums = (STButton *)[self viewWithTag:i+2000];
        if (i == 0) {
            [nums setCountLabelText:collect.like];
        }
        else if (i == 1) {
            [nums setCountLabelText:collect.following];
        }
        else if (i == 2) {
            [nums setCountLabelText:collect.follower];
        }
    }
}


//获取钱包信息
- (void)getWallet
{
    __typeof (&*self) __weak weakSelf = self;
    
    [[WithdrawLogic sharedInstance] getMyWallet:nil withCallback:^(LogicResult *result) {
        if(result.statusCode == KLogicStatusSuccess)
        {
            WithdrawModel *md = result.mObject;
            NSUInteger i = 0;
            for (WithdrawRecord *record in md.records){
                i += [record.count integerValue];
            }
            [weakSelf.numL setText:[NSString stringWithFormat:@"有%ld人购买", i]];
            [weakSelf.amountL setText:[NSString stringWithFormat:@"我的收益：%@ RMB", md.total]];
        }
        else
            CLog(@"失败");
    }];
}

#pragma mark - getter & setter
- (ZQNewGuideView *)guideView {
    if (_guideView == nil) {
        _guideView = [[ZQNewGuideView alloc] initWithFrame:[UIApplication sharedApplication].keyWindow.bounds];
    }
    return _guideView;
}

- (void)makeFunctionGuide{
    BOOL firstComeInTeacherDetail = [[NSUserDefaults standardUserDefaults] boolForKey:@"MineFirstEnterHere"];
    if (!firstComeInTeacherDetail) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"MineFirstEnterHere"];
        [self makeGuideView];
    }
}

- (void)makeGuideView{
    //坐标转换
    CGRect rc = _headBtn.frame;
    
    CGRect mRect = CGRectMake(rc.origin.x+16, rc.origin.y+16+64, 41, 41);
    
    self.guideView.showRect = mRect;
    
    self.guideView.textImage = [UIImage imageNamed:@"prompt_mine.png"];
    self.guideView.textImageFrame = CGRectMake(106, 50, self.guideView.textImage.size.width, self.guideView.textImage.size.height);
    self.guideView.model = ZQNewGuideViewModeOval;
    
    __typeof (&*self) __weak weakSelf = self;
    self.guideView.clickedShowRectBlock = ^{
        [weakSelf headBtnTapped:nil];
        
    };
    [[UIApplication sharedApplication].keyWindow addSubview:self.guideView];
}

- (void)updateBadgeView:(JSBadgeView *)badgeView enable:(NSInteger)count {
    if (count > 0) {
        [badgeView setBadgeText:[NSString stringWithFormat:@"%ld", (long)count]];
    }
    else {
        [badgeView setBadgeText:nil];
    }
}

@end
