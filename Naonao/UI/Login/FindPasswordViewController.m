//
//  FindPasswordViewController.m
//  NaoNao
//
//  Created by sunlin on 15/9/9.
//  Copyright (c) 2015年 HentenWasiky. All rights reserved.
//

#import "FindPasswordViewController.h"
#import "SetNewPswViewController.h"
#import "SettingPasswordViewController.h"
#import "MSWeakTimer.h"

const static NSUInteger kSecondsPerMinute = 60;

@interface FindPasswordViewController ()

@property (nonatomic, weak) UIView *bgView;
@property (nonatomic, weak) UITextField *phone;
@property (nonatomic, weak) UITextField *code;
@property (nonatomic, weak) UIButton *yzButton;

@property (nonatomic, strong) MSWeakTimer *timeToStart;     //计时器
@property (nonatomic, assign) NSInteger timeNum;            //计时器的时间

@end

@implementation FindPasswordViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    
    if (_mType == KChangePassword_BindPhone) {
        [self setNavBarTitle:@"绑定手机"];
        [self setNavBarLeftBtn:nil];
    }
    else
        [self setNavBarTitle:@"获取验证码"];

    [self drawUI];
    
    [self initToolBar];
    
    self.reParam = [[RegisterParam alloc] init];
}


- (void)drawUI
{
    
    // 分割线一
    UILabel *line1 = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.navbar.frame)+74, SCREEN_WIDTH, 0.5)];
    [line1 setBackgroundColor:LINE_COLOR];
    [self.view addSubview:line1];
    
    
    UILabel *phoneL = [[UILabel alloc] initWithFrame:CGRectMake(25, CGRectGetMaxY(self.navbar.frame)+40, 65, 20)];
    [phoneL setText:@"手机号"];
    [phoneL setFont:[UIFont systemFontOfSize:16 weight:UIFontWeightLight]];
    [phoneL setTextColor:BLACK_COLOR];
    [self.view addSubview:phoneL];
    
    UITextField *phoneItem = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(phoneL.frame), CGRectGetMaxY(self.navbar.frame)+35, SCREEN_WIDTH-25 - CGRectGetMaxX(phoneL.frame), 30)];
    _phone = phoneItem;
    _phone.placeholder = @"请输入手机号码";
    _phone.font = [UIFont systemFontOfSize:16];
    _phone.borderStyle=UITextBorderStyleNone;
    _phone.textColor = BLACK_COLOR;
    _phone.keyboardType = UIKeyboardTypeNumberPad;
    _phone.delegate = self;
    _phone.clearButtonMode = UITextFieldViewModeWhileEditing;
    User* user = [[UserLogic sharedInstance] getUser];
    if (user) {
        _phone.text = user.basic.telephone;
    }
    [self.view addSubview:_phone];
    
    // 分割线二
    UILabel *line2 = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(line1.frame)+74, SCREEN_WIDTH, 0.5)];
    [line2 setBackgroundColor:LINE_COLOR];
    [self.view addSubview:line2];
    
    UILabel *passwordL = [[UILabel alloc] initWithFrame:CGRectMake(25, CGRectGetMaxY(line1.frame)+40, 65, 20)];
    [passwordL setText:@"验证码"];
    [passwordL setFont:[UIFont systemFontOfSize:16 weight:UIFontWeightLight]];
    [passwordL setTextColor:BLACK_COLOR];
    [self.view addSubview:passwordL];
    
    
    UITextField *code = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(passwordL.frame), CGRectGetMaxY(line1.frame)+40, SCREEN_WIDTH-100 - CGRectGetMaxX(passwordL.frame), 20)];
    _code = code;
    _code.placeholder = @"请输入验证码";
    _code.font = [UIFont systemFontOfSize:16];
    _code.borderStyle = UITextBorderStyleNone;
    _code.textColor = BLACK_COLOR;
    _code.clearButtonMode = UITextFieldViewModeWhileEditing;
    _code.delegate = self;
    [self.view addSubview:_code];
    
    UIButton *yzButton = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-25-70, CGRectGetMaxY(line1.frame)+35, 70, 30)];
    _yzButton = yzButton;
    [_yzButton setTitle:@"获取验证码" forState:UIControlStateNormal];
    [_yzButton.titleLabel setFont:[UIFont systemFontOfSize:13.0 weight:UIFontWeightLight]];
    [_yzButton setTitleColor:PINK_COLOR forState:UIControlStateNormal];
    [_yzButton.titleLabel setFont:[UIFont systemFontOfSize:13]];
    _yzButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [_yzButton addTarget:self action:@selector(getValidCode:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_yzButton];
    
    
    UIButton *landBtn = [self createButtonFrame:CGRectMake((SCREEN_WIDTH-150)/2, CGRectGetMaxY(line2.frame)+50, 150, 40) backImageName:@"btn_pink.png" title:@"下一步" titleColor:[UIColor whiteColor]  font:[UIFont systemFontOfSize:16] target:self action:@selector(nextButtonTapped:)];
    //圆角
    landBtn.layer.cornerRadius = 20; //设置那个圆角的有多圆
    landBtn.layer.masksToBounds = YES;  //设为NO去试试
    [self.view addSubview:landBtn];
}


- (void)getValidCode:(id)sender
{
    [self.phone resignFirstResponder];

    if ([self.phone.text length] != 11)
    {
        [self.view makeToast:@"请检查您的手机号是否填写正确"];
        return;
    }

    
    self.reParam.telephone = self.phone.text;
    
    //判断是否是注册
    if(_mType == KChangePassword_Register || _mType == KChangePassword_BindPhone)
    {
        //验证手机号码是否被注册
        __typeof (&*self) __weak weakSelf = self;
        [[UserLogic sharedInstance] whetherPhoneNumberRegistered:self.reParam withCallback:^(LogicResult *result) {
            if(result.statusCode == KLogicStatusSuccess)
            {
                if ([result.mObject boolValue]) {
                    
                    if (_mType == KChangePassword_Register) {
                        [weakSelf.view makeToast:@"该手机号码已经注册，请直接登录。如果忘记密码请尝试找回密码"];
                    }
                    
                    if (_mType == KChangePassword_BindPhone) {
                        [weakSelf.view makeToast:@"该手机号码已经被绑定，请更换手机号码再试"];
                    }
                    
                    return ;
                }
                else{
                    //成功, 获取验证码
                    [theAppDelegate.HUDManager showSimpleTip:@"短信发送中" interval:NSNotFound];
                    [weakSelf getPhoneCode];
                }
            }
            else
                [weakSelf.view makeToast:result.stateDes];
        }];
    }
    else
    {
        [theAppDelegate.HUDManager showSimpleTip:@"短信发送中" interval:NSNotFound];
        //获取验证码
        [self getPhoneCode];
    }
    
}


//获取验证码
- (void)getPhoneCode
{
    __typeof (&*self) __weak weakSelf = self;
    [[UserLogic sharedInstance] getPhoneVerificationCode:self.reParam withCallback:^(LogicResult *result) {
        if(result.statusCode == KLogicStatusSuccess)
        {
            //成功
            [weakSelf.view makeToast:@"验证码已发送，请检查您的手机短信"];
            [weakSelf disableGetVerifyCodeButton];
        }
        else
            [weakSelf.view makeToast:result.stateDes];
        
        [theAppDelegate.HUDManager hideHUD];
    }];
}


- (void)nextButtonTapped:(id)sender
{
    [_code resignFirstResponder];
    
    if (_code.text.length == 0) {
        [self.view makeToast:@"短信验证码不能为空"];
        return;
    }
    
    self.reParam.telephone = self.phone.text;
    self.reParam.authcode = self.code.text;
    
    if (_mType == KChangePassword_BindPhone) {
        
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithCapacity:2];
        [dic setObject:_phone.text forKey:@"telephone"];
        [dic setObject:_code.text forKey:@"code"];
        
        
        //验证验证码
        __typeof (&*self) __weak weakSelf = self;
        [[UserLogic sharedInstance] requestUserCheckcode:dic withCallback:^(LogicResult *result) {
            if(result.statusCode == KLogicStatusSuccess)
            {
                //成功
                [weakSelf jumpToSetNewPswViewController];
            }
            else
                [weakSelf.view makeToast:result.stateDes];
            
            [theAppDelegate.HUDManager hideHUD];
        }];
        
    }
    else if (_mType == KChangePassword_Register)
    {
        //注册
        SettingPasswordViewController *vc = [[SettingPasswordViewController alloc] init];
        vc.reParam = self.reParam;
        [self.navigationController pushViewController:vc animated:YES];
    }
    else{
        [self jumpToSetNewPswViewController];
    }
}

- (void)jumpToSetNewPswViewController
{
    //忘记密码、修改密码
    SetNewPswViewController *vc = [[SetNewPswViewController alloc] init];
    vc.reParam = self.reParam;
    vc.mType = self.mType;
    [self.navigationController pushViewController:vc animated:YES];
}


#pragma mark 计时器
/*********************************  计时器  *******************************/
- (void)enableGetVerifyCodeButton {
    [_timeToStart invalidate];
    [_yzButton setEnabled:YES];
}


- (void)disableGetVerifyCodeButton {
    _timeNum = kSecondsPerMinute;
    _timeToStart = [MSWeakTimer scheduledTimerWithTimeInterval:1
                                                        target:self
                                                      selector:@selector(timeCountAfterGetVerifyCodePressed:)
                                                      userInfo:nil
                                                       repeats:YES
                                                 dispatchQueue:dispatch_get_main_queue()];
}

- (void)timeCountAfterGetVerifyCodePressed:(id)sender {
    _timeNum--;
    [UIView setAnimationsEnabled:NO];
    [_yzButton setTitle:[NSString stringWithFormat:@"%lu秒后重新获取",  (long)_timeNum] forState:UIControlStateDisabled];
    [_yzButton layoutIfNeeded];
    [UIView setAnimationsEnabled:YES];
    
    if (_timeNum == 0) {
        [self enableGetVerifyCodeButton];
    }
}





- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
