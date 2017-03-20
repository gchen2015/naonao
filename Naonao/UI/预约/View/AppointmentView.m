//
//  AppointmentView.m
//  Naonao
//
//  Created by 刘敏 on 2016/9/14.
//  Copyright © 2016年 深圳市轩腾华兴科技开发有限公司. All rights reserved.
//

#import "AppointmentView.h"
#import "SHLUILabel.h"

@interface AppointmentView ()<UIGestureRecognizerDelegate>

@property (nonatomic, assign) id<AppointmentViewDelegate>delegate;


@property (nonatomic, weak) UIView *backGroundView;

@property (nonatomic, weak) UILabel *titLabel;
@property (nonatomic, weak) SHLUILabel *messageL;
@property (nonatomic, weak) UILabel *instructionsL;

@property (nonatomic, weak) UIButton *sureBtn;
@property (nonatomic, weak) UIButton *cancelBtn;


@end

@implementation AppointmentView


- (instancetype) initWithTitle:(NSString *)title
                      delegate:(id<AppointmentViewDelegate>)delegate
                       message:(NSString *)message
                  instructions:(NSString *)instructions
               leftButtonTitle:(NSString *)leftTitle
              rightButtonTitle:(NSString *)rightTitle
{
    self = [super init];
    
    if (self) {
        //初始化背景视图，添加手势
        self.frame = MAINBOUNDS;
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
        self.userInteractionEnabled = YES;
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tappedCancel)];
        [self addGestureRecognizer:tapGesture];
        
        if (delegate) {
            self.delegate = delegate;
        }

        UIView *backGroundView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 0)];
        _backGroundView = backGroundView;
        _backGroundView.backgroundColor = [UIColor whiteColor];
        [self addSubview:_backGroundView];
        
        UILabel *titLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 20, SCREEN_WIDTH-40, 20)];
        _titLabel = titLabel;
        [_titLabel setTextColor:BLACK_COLOR];
        [_titLabel setText:title];
        [_titLabel setFont:[UIFont boldSystemFontOfSize:18.0]];
        [_titLabel setTextAlignment:NSTextAlignmentCenter];
        [self.backGroundView addSubview:_titLabel];

        SHLUILabel *messageL = [[SHLUILabel alloc] initWithFrame:CGRectZero];
        _messageL = messageL;
        [_messageL setTextColor:BROWN_COLOR];
        _messageL.lineBreakMode = NSLineBreakByWordWrapping;
        [_messageL setText:message];
        _messageL.numberOfLines = 0;
        [_messageL setFont:[UIFont systemFontOfSize:14.0 weight:UIFontWeightMedium]];
        [_messageL setTextAlignment:NSTextAlignmentCenter];
        [self.backGroundView addSubview:_messageL];
        
        CGFloat messageH = [_messageL getAttributedStringHeightWidthValue:SCREEN_WIDTH - 56];
        [_messageL setFrame:CGRectMake(28, CGRectGetMaxY(_titLabel.frame)+25, SCREEN_WIDTH - 56, messageH)];
        
        CGFloat g_H = 0.0;
        if (instructions){
            UILabel *instructionsL = [[UILabel alloc] initWithFrame:CGRectZero];
            _instructionsL = instructionsL;
            [_instructionsL setTextAlignment:NSTextAlignmentCenter];
            [_instructionsL setText:instructions];
            _instructionsL.numberOfLines = 0;
            [_instructionsL setTextColor:PINK_COLOR];
            [_instructionsL setFont:[UIFont systemFontOfSize:11.0]];
            
            CGFloat in_h = [_instructionsL sizeThatFits:CGSizeMake(SCREEN_WIDTH-56, CGFLOAT_MAX)].height;
            [_instructionsL setFrame:CGRectMake(28, CGRectGetMaxY(_messageL.frame)+12, SCREEN_WIDTH-56, in_h)];
            [self.backGroundView addSubview:_instructionsL];
            
            g_H = CGRectGetMaxY(_instructionsL.frame)+24;
        }
        else{
            g_H = CGRectGetMaxY(_messageL.frame)+24;
        }
        
        //分割线
        UILabel *lineV = [[UILabel alloc] initWithFrame:CGRectMake(28, g_H, SCREEN_WIDTH-56, 0.5)];
        [lineV setBackgroundColor:LINE_COLOR];
        [self.backGroundView addSubview:lineV];
        
        CGFloat mW = (SCREEN_WIDTH - 28*4)/2;
        UIButton *cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake(28, CGRectGetMaxY(lineV.frame)+23, mW, 42)];
        _cancelBtn = cancelBtn;
        [_cancelBtn setTitle:leftTitle forState:UIControlStateNormal];
        [_cancelBtn setTitleColor:PINK_COLOR forState:UIControlStateNormal];
        [_cancelBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        [_cancelBtn setBackgroundImage:[UIImage imageNamed:@"btn_whitle_1.png"] forState:UIControlStateNormal];
        //圆角
        _cancelBtn.layer.cornerRadius = 21;                     //设置那个圆角的有多圆
        _cancelBtn.layer.masksToBounds = YES;                   //设为NO去试试
        _cancelBtn.layer.borderColor = PINK_COLOR.CGColor;
        _cancelBtn.layer.borderWidth = 0.5;
        [_cancelBtn.titleLabel setFont:[UIFont systemFontOfSize:15.0]];
        [_cancelBtn addTarget:self action:@selector(cancelBtnTapped:) forControlEvents:UIControlEventTouchUpInside];
        [self.backGroundView addSubview:_cancelBtn];
        
        UIButton *sureBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2+28, CGRectGetMaxY(lineV.frame)+23, mW, 42)];
        _sureBtn = sureBtn;
        [_sureBtn setTitle:rightTitle forState:UIControlStateNormal];
        [_sureBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_sureBtn setBackgroundImage:[UIImage imageNamed:@"btn_pink.png"] forState:UIControlStateNormal];
        [_sureBtn.titleLabel setFont:[UIFont systemFontOfSize:15.0]];
        //圆角
        _sureBtn.layer.cornerRadius = 21;                       //设置那个圆角的有多圆
        _sureBtn.layer.masksToBounds = YES;                     //设为NO去试试
        [_sureBtn addTarget:self action:@selector(sureBtnTapped:) forControlEvents:UIControlEventTouchUpInside];
        [self.backGroundView addSubview:_sureBtn];

        [self starAnimation];

    }
    
    
    return self;
}

- (void)starAnimation{
    [UIView animateWithDuration:0.25f animations:^{
        [self.backGroundView setFrame:CGRectMake(0, SCREEN_HEIGHT - CGRectGetMaxY(_sureBtn.frame)-26, SCREEN_WIDTH, CGRectGetMaxY(_sureBtn.frame)+26)];
    } completion:^(BOOL finished) {
    }];
}

- (void)tappedCancel
{
    [UIView animateWithDuration:0.25f animations:^{
        [self.backGroundView setFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 0)];
        self.alpha = 0;
    } completion:^(BOOL finished) {
        if (finished) {
            [self removeFromSuperview];
        }
    }];
    
    if (_delegate && [_delegate respondsToSelector:@selector(didClickOnSureButton:)]) {
        [_delegate didClickOnSureButton:NO];
    }
}

- (void)showInView:(UIView *)view
{
    [[UIApplication sharedApplication].delegate.window.rootViewController.view addSubview:self];
}

- (void)cancelBtnTapped:(id)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(didClickOnSureButton:)]) {
        [_delegate didClickOnSureButton:NO];
    }
    
    [self tappedCancel];
}


- (void)sureBtnTapped:(id)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(didClickOnSureButton:)]) {
        [_delegate didClickOnSureButton:YES];
    }
    
    [self tappedCancel];
}

@end
