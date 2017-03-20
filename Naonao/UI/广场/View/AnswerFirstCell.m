//
//  AnswerFirstCell.m
//  Naonao
//
//  Created by 刘敏 on 16/6/1.
//  Copyright © 2016年 深圳市轩腾华兴科技开发有限公司. All rights reserved.
//

#import "AnswerFirstCell.h"
#import "TimeUtil.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "SquareLogic.h"
#import "ZQNewGuideView.h"
#import "SHLUILabel.h"


@interface AnswerFirstCell ()

@property (nonatomic, weak) SHLUILabel *contentL;
@property (nonatomic, weak) UILabel *desL;
@property (nonatomic, weak) UILabel *timeL;
@property (nonatomic, weak) UIView *lineV;


@property (nonatomic, weak) UIButton *careBtn;

@property (nonatomic, assign) BOOL isSend;

@property (nonatomic, strong) ZQNewGuideView *guideView;

@end


@implementation AnswerFirstCell

+ (AnswerFirstCell *)cellWithTableView:(UITableView *)tableView{
    static NSString *ID = @"AnswerFirstCell";
    
    AnswerFirstCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[AnswerFirstCell alloc ] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
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
    SHLUILabel *contentL = [[SHLUILabel alloc] initWithFrame:CGRectZero];
    _contentL = contentL;
    [_contentL setFont:[UIFont systemFontOfSize:16.0]];
    _contentL.lineBreakMode = NSLineBreakByWordWrapping;
    [_contentL setTextColor:BLACK_COLOR];
    [_contentL setTextAlignment:NSTextAlignmentLeft];
    _contentL.numberOfLines = 0;
    [self.contentView addSubview:_contentL];
    
    UILabel *desL = [[UILabel alloc] init];
    _desL = desL;
    [_desL setFont:[UIFont systemFontOfSize:11.0]];
    [_desL setTextColor:GARY_COLOR];
    [self.contentView addSubview:_desL];
    
    
    UILabel *timeL = [[UILabel alloc] init];
    _timeL = timeL;
    [_timeL setTextAlignment:NSTextAlignmentRight];
    [_timeL setFont:[UIFont systemFontOfSize:11.0]];
    [_timeL setTextColor:LIGHT_BLACK_COLOR];
    [self.contentView addSubview:_timeL];
    
    UIView *lineV = [[UIView alloc] init];
    _lineV = lineV;
    _lineV.backgroundColor = STROKE_GARY_COLOR;
    [self.contentView addSubview:_lineV];
    
    
    UIButton *answerBtn = [[UIButton alloc] init];
    _answerBtn = answerBtn;
    [_answerBtn setImage:[UIImage imageNamed:@"pen_icon_red.png"] forState:UIControlStateNormal];
    [_answerBtn setTitle:@" 写答案" forState:UIControlStateNormal];
    [_answerBtn addTarget:self action:@selector(jumpToNext) forControlEvents:UIControlEventTouchUpInside];
    [_answerBtn setTitleColor:BLACK_COLOR forState:UIControlStateNormal];
    [_answerBtn.titleLabel setFont:[UIFont systemFontOfSize:14.0]];
    //圆角
    _answerBtn.layer.cornerRadius = 6;                     //设置那个圆角的有多圆
    _answerBtn.layer.masksToBounds = YES;                  //设为NO去试试
    _answerBtn.layer.borderColor = LIGHT_BLACK_COLOR.CGColor;
    _answerBtn.layer.borderWidth = 0.5;
    
    [self.contentView addSubview:_answerBtn];
    
    
    UIButton *careBtn = [[UIButton alloc] init];
    _careBtn = careBtn;
    [_careBtn setTitleColor:BLACK_COLOR forState:UIControlStateNormal];
    [_careBtn.titleLabel setFont:[UIFont systemFontOfSize:14.0]];
    [_careBtn addTarget:self action:@selector(careBtnTapped:) forControlEvents:UIControlEventTouchUpInside];
    //圆角
    _careBtn.layer.cornerRadius = 6;                     //设置那个圆角的有多圆
    _careBtn.layer.masksToBounds = YES;                  //设为NO去试试
    _careBtn.layer.borderColor = LIGHT_BLACK_COLOR.CGColor;
    _careBtn.layer.borderWidth = 0.5;
    
    [self.contentView addSubview:_careBtn];
}

- (void)setAnModeFrame:(AnswerFirstModeFrame *)anModeFrame{
    _anModeFrame = anModeFrame;
    
    _contentL.frame = _anModeFrame.contentFrame;
    _desL.frame = _anModeFrame.desFrame;
    _timeL.frame = _anModeFrame.timeFrame;
    _lineV.frame = _anModeFrame.lineFrame;
    
    _answerBtn.frame = _anModeFrame.answerFrame;
    _careBtn.frame = _anModeFrame.careFrame;
    
    [self setCellWithCellInfo:_anModeFrame.sModel];
}


- (void)setCellWithCellInfo:(SquareModel *)model
{
    [_contentL setText:model.orderInfo.content];
    [_desL setText:model.orderInfo.summarize];
    [_timeL setText:[TimeUtil turningMillisecondsForDate:[model.orderInfo.createTime longLongValue]]];
    
    //是否已经关心
    if([model.orderInfo.care boolValue])
    {
        [_careBtn setImage:[UIImage imageNamed:@"care_icon.png"] forState:UIControlStateNormal];
    }
    else
    {
        [_careBtn setImage:[UIImage imageNamed:@"care_no_icon.png"] forState:UIControlStateNormal];
    }

    [_careBtn setTitle:@" 收藏" forState:UIControlStateNormal];
    
    
    BOOL firstComeInTeacherDetail = [[NSUserDefaults standardUserDefaults] boolForKey:@"AnswerViewFirstEnterHere"];
    if (!firstComeInTeacherDetail) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"AnswerViewFirstEnterHere"];
        //坐标转换
        CGRect rc = CGRectMake(_answerBtn.frame.origin.x, _answerBtn.frame.origin.y+64, _answerBtn.frame.size.width, _answerBtn.frame.size.height);
        
        [self makeGuideView:rc];
    }

}

- (void)jumpToNext {
    //判断是否登录
    if (![UserLogic sharedInstance].user.basic.userId) {
        [theAppDelegate popLoginView];
        return;
    }
    
    if (_delegate && [_delegate respondsToSelector:@selector(jumpToSearchView)]) {
        [_delegate jumpToSearchView];
    }
}

- (void)careBtnTapped:(id)sender {
    //判断是否登录
    if (![UserLogic sharedInstance].user.basic.userId) {
        [theAppDelegate popLoginView];
        return;
    }
    
    //利用计时器来防止重发发送
    if(_isSend)
    {
        return;
    }

    _isSend = YES;
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithCapacity:0];
    [dic setObject:_anModeFrame.sModel.orderInfo.orderId forKey:@"order_id"];
    
    
    if ([_anModeFrame.sModel.orderInfo.care boolValue]) {
        AlertWithTitleAndMessageAndUnits(@"取消提示", @"确定取消关心这个话题？", self, @"确认", nil);
    }
    else{
        //关心
        [[SquareLogic sharedInstance] getCareAnswer:dic withCallback:^(LogicResult *result) {
            if(result.statusCode == KLogicStatusSuccess)
            {
                [_careBtn setImage:[UIImage imageNamed:@"care_icon.png"] forState:UIControlStateNormal];
                
                _anModeFrame.sModel.orderInfo.care = [NSNumber numberWithBool:YES];
                
                if (_anModeFrame.sModel.answerInfo) {
                    [_careBtn setTitle:[NSString stringWithFormat:@" 收藏%@", _anModeFrame.sModel.answerInfo.care] forState:UIControlStateNormal];
                }
            }
            else
                [theAppDelegate.window makeToast:result.stateDes];
            
            _isSend = NO;
        }];
    }
}


- (void)imageActiondo:(UITapGestureRecognizer *)tapGesture {
    //判断是否登录
    if (![UserLogic sharedInstance].user.basic.userId) {
        [theAppDelegate popLoginView];
        return;
    }
    
    if (_delegate && [_delegate respondsToSelector:@selector(headTapped)]) {
        [_delegate headTapped];
    }
}


#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithCapacity:0];
        [dic setObject:_anModeFrame.sModel.orderInfo.orderId forKey:@"order_id"];
        __typeof (&*self) __weak weakSelf = self;
        //不关心
        [[SquareLogic sharedInstance] getUnCareAnswer:dic withCallback:^(LogicResult *result) {
            if(result.statusCode == KLogicStatusSuccess)
            {
                [weakSelf.careBtn setImage:[UIImage imageNamed:@"care_no_icon.png"] forState:UIControlStateNormal];
                
                _anModeFrame.sModel.orderInfo.care = [NSNumber numberWithBool:NO];
                
                if (_anModeFrame.sModel.answerInfo) {
                    [_careBtn setTitle:[NSString stringWithFormat:@" 收藏%@", _anModeFrame.sModel.answerInfo.care] forState:UIControlStateNormal];
                }
                
            }
            else
                [theAppDelegate.window makeToast:result.stateDes];
            
            
        }];
    }
    
    _isSend = NO;
}

#pragma mark - getter & setter
- (ZQNewGuideView *)guideView
{
    if (_guideView == nil) {
        _guideView = [[ZQNewGuideView alloc] initWithFrame:[UIApplication sharedApplication].keyWindow.bounds];
    }
    return _guideView;
}


- (void)makeGuideView:(CGRect)mRect{
    
    self.guideView.showRect = mRect;
    
    self.guideView.textImage = [UIImage imageNamed:@"prompt_answer.png"];
    self.guideView.textImageFrame = CGRectMake(SCREEN_WIDTH - self.guideView.textImage.size.width -10, mRect.origin.y - self.guideView.textImage.size.height-8, self.guideView.textImage.size.width, self.guideView.textImage.size.height);
    self.guideView.model = ZQNewGuideViewModeRoundRect;
    
    __typeof (&*self) __weak weakSelf = self;
    self.guideView.clickedShowRectBlock = ^{
        [weakSelf jumpToNext];
        
    };
    
    //延迟执行
    double delayInSeconds = 0.5;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [[UIApplication sharedApplication].keyWindow addSubview:self.guideView];
    });
    
}


@end
