//
//  SetNewPswViewController.m
//  Naonao
//
//  Created by Richard Liu on 15/12/8.
//  Copyright © 2015年 深圳市轩腾华兴科技开发有限公司. All rights reserved.
//

#import "SetNewPswViewController.h"

@interface SetNewPswViewController ()


@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UITextField *pswField;
@property (nonatomic, strong) UITextField *rePswField;    //重复密码

@end

@implementation SetNewPswViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    if(_mType == KChangePassword_BindPhone)
    {
        [self setNavBarTitle:@"设置密码"];
    }
    else
        [self setNavBarTitle:@"设置新密码"];
    
    [self drawUI];
    
    [self initToolBar];
}


- (void)drawUI {
    
    // 分割线一
    UILabel *line1 = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.navbar.frame)+74, SCREEN_WIDTH, 0.5)];
    [line1 setBackgroundColor:LINE_COLOR];
    [self.view addSubview:line1];
    
    
    UILabel *phoneL = [[UILabel alloc] initWithFrame:CGRectMake(25, CGRectGetMaxY(self.navbar.frame)+40, 85, 20)];
    [phoneL setText:@"密码"];
    [phoneL setFont:[UIFont systemFontOfSize:16 weight:UIFontWeightLight]];
    [phoneL setTextColor:BLACK_COLOR];
    [self.view addSubview:phoneL];
    
    UITextField *pswField = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(phoneL.frame), CGRectGetMaxY(self.navbar.frame)+35, SCREEN_WIDTH-25 - CGRectGetMaxX(phoneL.frame), 30)];
    _pswField = pswField;
    _pswField.placeholder = @"请设置您的密码";
    _pswField.font = [UIFont systemFontOfSize:16];
    _pswField.borderStyle=UITextBorderStyleNone;
    _pswField.textColor = BLACK_COLOR;
    _pswField.delegate = self;
    _pswField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _pswField.secureTextEntry = YES;
    [self.view addSubview:_pswField];
    
    // 分割线二
    UILabel *line2 = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(line1.frame)+74, SCREEN_WIDTH, 0.5)];
    [line2 setBackgroundColor:LINE_COLOR];
    [self.view addSubview:line2];
    
    UILabel *passwordL = [[UILabel alloc] initWithFrame:CGRectMake(25, CGRectGetMaxY(line1.frame)+40, 85, 20)];
    [passwordL setText:@"重复密码"];
    [passwordL setFont:[UIFont systemFontOfSize:16 weight:UIFontWeightLight]];
    [passwordL setTextColor:BLACK_COLOR];
    [self.view addSubview:passwordL];
    
    
    UITextField *rePswField = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(passwordL.frame), CGRectGetMaxY(line1.frame)+40, SCREEN_WIDTH-25 - CGRectGetMaxX(passwordL.frame), 20)];
    _rePswField = rePswField;
    _rePswField.placeholder = @"再次输入密码";
    _rePswField.font = [UIFont systemFontOfSize:16];
    _rePswField.borderStyle = UITextBorderStyleNone;
    _rePswField.textColor = BLACK_COLOR;
    _rePswField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _rePswField.delegate = self;
    _rePswField.secureTextEntry = YES;
    [self.view addSubview:_rePswField];
    
    
    UIButton *landBtn = [self createButtonFrame:CGRectMake((SCREEN_WIDTH-150)/2, CGRectGetMaxY(line2.frame)+50, 150, 40) backImageName:@"btn_pink.png" title:@"确定" titleColor:[UIColor whiteColor]  font:[UIFont systemFontOfSize:16] target:self action:@selector(registeredTapped:)];
    //圆角
    landBtn.layer.cornerRadius = 20; //设置那个圆角的有多圆
    landBtn.layer.masksToBounds = YES;  //设为NO去试试
    [self.view addSubview:landBtn];
}

- (void)registeredTapped:(id)sender
{
    [self.pswField resignFirstResponder];
    [self.rePswField resignFirstResponder];
    
    if (self.pswField.text.length <= 6) {
        [self.view makeToast:@"密码长度须大于六位数"];
        return;
    }
    
    if (![self.pswField.text isEqualToString:self.rePswField.text]){
        [self.view makeToast:@"两次输入的密码长度不一致"];
        return;
    }
    
    self.reParam.password = self.pswField.text;
    
    [theAppDelegate.HUDManager showSimpleTip:@"处理中..." interval:NSNotFound];
    
    __typeof (&*self) __weak weakSelf = self;
    if (_mType == KChangePassword_BindPhone) {
        //绑定手机
        [[UserLogic sharedInstance] bindPhoneNO:self.reParam withCallback:^(LogicResult *result) {
            if(result.statusCode == KLogicStatusSuccess)
            {
                [weakSelf dismissViewControllerAnimated:YES completion:NULL];
                [weakSelf.navigationController popToRootViewControllerAnimated:YES];
            }
            else
            {
                [weakSelf.view makeToast:result.stateDes];
                [theAppDelegate.HUDManager hideHUD];
            }
        }];
    }
    else{
        [[UserLogic sharedInstance] updatePassword:self.reParam withCallback:^(LogicResult *result) {
            
            if(result.statusCode == KLogicStatusSuccess)
            {
                [weakSelf.view makeToast:@"密码修改成功"];
                [weakSelf performSelector:@selector(immediatelyLogin) withObject:nil afterDelay:0.2];
            }
            else
            {
                [weakSelf.view makeToast:result.stateDes];
                [theAppDelegate.HUDManager hideHUD];
            }
        }];
    }
    
}

// 创建账户成功之后立即自动登录
- (void)immediatelyLogin {
    LoginParam* loginParam = [[LoginParam alloc] init];
    loginParam.phone = self.reParam.telephone;
    loginParam.password = self.reParam.password;
    
    
    if (self.mType == KChangePassword_Login) {
        [theAppDelegate.HUDManager showSimpleTip:@"登录中..." interval:NSNotFound];
    }
    else if (self.mType == KChangePassword_Setting)
    {
        [theAppDelegate.HUDManager showSimpleTip:@"使用新密码重新登录中..." interval:NSNotFound];
    }

    
    __typeof (&*self) __weak weakSelf = self;
    [[UserLogic sharedInstance] login:loginParam withCallback:^(LogicResult *result) {
        
        [theAppDelegate.HUDManager hideHUD];
        
        if(result.statusCode == KLogicStatusSuccess)
        {
            [theAppDelegate loginSuccess];
            [weakSelf back:nil];
        }
        else
            [weakSelf.view makeToast:result.stateDes];
        
    }];
    
}


- (void)back:(id)sender
{
    if (self.mType == KChangePassword_Login) {
        [self dismissViewControllerAnimated:YES completion:NULL];
    }
    else if (self.mType == KChangePassword_Setting)
    {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
