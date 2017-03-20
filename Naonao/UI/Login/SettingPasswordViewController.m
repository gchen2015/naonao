//
//  SettingPasswordViewController.m
//  Naonao
//
//  Created by Richard Liu on 15/11/30.
//  Copyright © 2015年 深圳市轩腾华兴科技开发有限公司. All rights reserved.
//

#import "SettingPasswordViewController.h"

@interface SettingPasswordViewController ()<UITextFieldDelegate>

@property (nonatomic, weak) UIButton *nextBtn;

@property (nonatomic, weak) UIView *bgView;
@property (nonatomic, weak) UITextField *nickField;     //昵称
@property (nonatomic, weak) UITextField *pswField;
@property (nonatomic, weak) UITextField *rePswField;    //重复密码

@end

@implementation SettingPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setNavBarTitle:@"设置密码"];
    
    [self drawUI];
    
    [self initToolBar];
}

- (void)drawUI
{
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(18, 75, self.view.frame.size.width-90, 30)];
    label.text = @"请设置昵称、密码";
    label.textColor = [UIColor grayColor];
    label.textAlignment = NSTextAlignmentLeft;
    label.font = [UIFont systemFontOfSize:13];
    [self.view addSubview:label];
    
    
    CGRect frame = [UIScreen mainScreen].bounds;
    
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(15, 110, frame.size.width-30, 150)];
    _bgView = bgView;
    _bgView.layer.cornerRadius = 5.0;
    _bgView.backgroundColor = [UIColor whiteColor];
    _bgView.backgroundColor = [UIColor whiteColor];
    _bgView.layer.borderColor = BLACK_COLOR.CGColor;
    _bgView.layer.borderWidth = 0.5;
    [self.view addSubview:_bgView];
    
    
    
    UILabel *nickL = [[UILabel alloc] initWithFrame:CGRectMake(12, 12, 70, 25)];
    [nickL setText:@"昵称"];
    [self.bgView addSubview:nickL];
    
    UITextField *nickField = [self createTextFielfFrame:CGRectMake(95, 120, CGRectGetWidth(bgView.frame)-95, 30) font:[UIFont systemFontOfSize:15] placeholder:@"用户昵称"];
    _nickField = nickField;
    _nickField.keyboardType = UIKeyboardTypeDefault;
    _nickField.returnKeyType = UIReturnKeyNext;
    _nickField.delegate = self;
    [self.view addSubview:_nickField];
    
    
    
    UILabel *phonelabel=[[UILabel alloc]initWithFrame:CGRectMake(12, 62, 70, 25)];
    phonelabel.text = @"密码";
    phonelabel.textColor=[UIColor blackColor];
    phonelabel.textAlignment = NSTextAlignmentLeft;
    phonelabel.font=[UIFont systemFontOfSize:15];
    
    UILabel *codelabel=[[UILabel alloc]initWithFrame:CGRectMake(12, 112, 70, 25)];
    codelabel.text = @"重复密码";
    codelabel.textColor=[UIColor blackColor];
    codelabel.textAlignment = NSTextAlignmentLeft;
    codelabel.font = [UIFont systemFontOfSize:15];
    
    
    UITextField *pswField = [self createTextFielfFrame:CGRectMake(95, 170, CGRectGetWidth(bgView.frame)-95, 30) font:[UIFont systemFontOfSize:15] placeholder:@"您的密码"];
    _pswField = pswField;
    _pswField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _pswField.secureTextEntry = YES;
    _pswField.keyboardType = UIKeyboardTypeDefault;
    _pswField.returnKeyType = UIReturnKeyNext;
    
    UITextField *rePswField =[self createTextFielfFrame:CGRectMake(95, 220, CGRectGetWidth(bgView.frame)-95, 30) font:[UIFont systemFontOfSize:15]  placeholder:@"再次输入您的密码" ];
    _rePswField = rePswField;
    
    _rePswField.clearButtonMode = UITextFieldViewModeWhileEditing;
    //密文样式
    _rePswField.secureTextEntry = YES;
    _rePswField.keyboardType = UIKeyboardTypeDefault;
    _rePswField.returnKeyType = UIReturnKeyDone;
    
    
    UIImageView *line1 = [self createImageViewFrame:CGRectMake(12, 50, bgView.frame.size.width-24, 0.5) imageName:nil color:[UIColor colorWithHex:0xa2a1a1 alpha:0.7]];;
    
    UIImageView *line2 = [self createImageViewFrame:CGRectMake(12, 100, bgView.frame.size.width-24, 0.5) imageName:nil color:[UIColor colorWithHex:0xa2a1a1 alpha:0.7]];;
    
    UIButton *landBtn = [self createButtonFrame:CGRectMake(15, bgView.frame.size.height+bgView.frame.origin.y+30,self.view.frame.size.width-30, 37) backImageName:@"btn_yellow_2.png" title:@"注 册" titleColor:[UIColor whiteColor]  font:[UIFont systemFontOfSize:17] target:self action:@selector(registeredButtonTapped:)];
    landBtn.layer.cornerRadius = 5.0f;
    landBtn.layer.masksToBounds = YES;
    
    [self.view addSubview:_pswField];
    [self.view addSubview:_rePswField];
    
    [bgView addSubview:phonelabel];
    [bgView addSubview:codelabel];
    [bgView addSubview:line1];
    [bgView addSubview:line2];
    [self.view addSubview:landBtn];
}



- (void)registeredButtonTapped:(id)sender
{
    [self.nickField resignFirstResponder];
    [self.pswField resignFirstResponder];
    [self.rePswField resignFirstResponder];
    
    
    if (!self.nickField.text) {
        [self.view makeToast:@"昵称不能为空"];
        return;
    }
    
    if (self.pswField.text.length <= 6) {
        [self.view makeToast:@"密码长度须大于六位数"];
        return;
    }
    
    if (![self.pswField.text isEqualToString:self.rePswField.text]){
        [self.view makeToast:@"两次输入的密码长度不一致"];
        return;
    }
    
    self.reParam.password = self.pswField.text;
    self.reParam.nickname = self.nickField.text;
    
    [theAppDelegate.HUDManager showSimpleTip:@"注册中..." interval:NSNotFound];
    
    __typeof (&*self) __weak weakSelf = self;
    [[UserLogic sharedInstance] registered:self.reParam withCallback:^(LogicResult *result) {

        if(result.statusCode == KLogicStatusSuccess)
        {
            [weakSelf.view makeToast:@"注册成功"];
            [weakSelf immediatelyLogin];
        }
        else
        {
            [weakSelf.view makeToast:result.stateDes];
            [theAppDelegate.HUDManager hideHUD];
        }
    }];
}

// 创建账户成功之后立即自动登录
- (void)immediatelyLogin {
    LoginParam* loginParam = [[LoginParam alloc] init];
    loginParam.phone = self.reParam.telephone;
    loginParam.password = self.reParam.password;
    
    [theAppDelegate.HUDManager showSimpleTip:@"登录中..." interval:NSNotFound];
    
    __typeof (&*self) __weak weakSelf = self;
    [[UserLogic sharedInstance] login:loginParam withCallback:^(LogicResult *result) {
        
        [theAppDelegate.HUDManager hideHUD];
        
        if(result.statusCode == KLogicStatusSuccess)
        {
            [weakSelf back:nil];
        }
        else
            [weakSelf.view makeToast:result.stateDes];
        
    }];

}


- (void)back:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:NULL];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
