//
//  LoginViewController.m
//  Naonao
//
//  Created by Richard Liu on 15/11/19.
//  Copyright © 2015年 深圳市轩腾华兴科技开发有限公司. All rights reserved.
//

#import "LoginViewController.h"
#import "FindPasswordViewController.h"
#import "LogicParam.h"
#import <UMSocialCore/UMSocialCore.h>
#import "LoginDAO.h"


@interface LoginViewController ()
//<UMSocialUIDelegate>

@property (nonatomic, weak) UIView *bgView;
@property (nonatomic, weak) UITextField *phoneItem;       //账号
@property (nonatomic, weak) UITextField *pswItem;         //密码

@property (nonatomic, weak) UIButton *forgetButton;
@property (nonatomic, weak) UIButton *registeredButton;

@property (nonatomic, weak) UIButton *loginButton;

@end

@implementation LoginViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setNavBarTitle:@"登录"];
    
    [self setNavBarLeftBtn:[STNavBarView createImgNaviBarBtnByImgNormal:@"icon_close.png"
                                                           imgHighlight:@"icon_close_highlighted.png"
                                                                 target:self
                                                                 action:@selector(back:)]];

    [self createTextFields];
    
    [self addThirdMenu];
    
    [self initToolBar];
}


/****************************************** 绘制界面  ******************************************/
#pragma mark 绘制界面
- (void)createTextFields {
    
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
    _phoneItem = phoneItem;
    _phoneItem.placeholder = @"请输入手机号码";
    _phoneItem.font = [UIFont systemFontOfSize:16];
    _phoneItem.borderStyle=UITextBorderStyleNone;
    _phoneItem.textColor = BLACK_COLOR;
    _phoneItem.keyboardType = UIKeyboardTypeNumberPad;
    _phoneItem.delegate = self;
    _phoneItem.clearButtonMode = UITextFieldViewModeWhileEditing;
    [self.view addSubview:_phoneItem];
    
    
    // 分割线二
    UILabel *line2 = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(line1.frame)+74, SCREEN_WIDTH, 0.5)];
    [line2 setBackgroundColor:LINE_COLOR];
    [self.view addSubview:line2];
    
    UILabel *passwordL = [[UILabel alloc] initWithFrame:CGRectMake(25, CGRectGetMaxY(line1.frame)+40, 65, 20)];
    [passwordL setText:@"密码"];
    [passwordL setFont:[UIFont systemFontOfSize:16 weight:UIFontWeightLight]];
    [passwordL setTextColor:BLACK_COLOR];
    [self.view addSubview:passwordL];
    
    
    UITextField *pswItem = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(passwordL.frame), CGRectGetMaxY(line1.frame)+40, SCREEN_WIDTH-100 - CGRectGetMaxX(passwordL.frame), 20)];
    _pswItem = pswItem;
    _pswItem.placeholder = @"请输入密码";
    _pswItem.font = [UIFont systemFontOfSize:16];
    _pswItem.borderStyle=UITextBorderStyleNone;
    _pswItem.textColor = BLACK_COLOR;
    _pswItem.clearButtonMode = UITextFieldViewModeWhileEditing;
    _pswItem.secureTextEntry = YES;
    _pswItem.delegate = self;
    [self.view addSubview:_pswItem];
    
    
    //忘记密码
    UIButton *forgetButton = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-25-70, CGRectGetMaxY(line1.frame)+35, 70, 30)];
    _forgetButton = forgetButton;
    [_forgetButton setTitle:@"忘记密码？" forState:UIControlStateNormal];
    [_forgetButton.titleLabel setFont:[UIFont systemFontOfSize:13.0 weight:UIFontWeightLight]];
    [_forgetButton setTitleColor:PINK_COLOR forState:UIControlStateNormal];
    _forgetButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [_forgetButton addTarget:self action:@selector(forgetButtonTapped:) forControlEvents:UIControlEventTouchUpInside];


    [self.view addSubview:_forgetButton];
    
    //登录按钮
    UIButton *loginButton = [self createButtonFrame:CGRectMake(25, CGRectGetMaxY(line2.frame)+50, SCREEN_WIDTH/2 - 25 - 15, 40) backImageName:@"btn_pink.png" title:@"登录" titleColor:[UIColor whiteColor]  font:[UIFont systemFontOfSize:16] target:self action:@selector(loginButtonTapped:)];
    _loginButton = loginButton;
    //圆角
    _loginButton.layer.cornerRadius = 20; //设置那个圆角的有多圆
    _loginButton.layer.masksToBounds = YES;  //设为NO去试试
    [self.view addSubview:_loginButton];
    
    
    UIButton *registeredButton = [self createButtonFrame:CGRectMake(SCREEN_WIDTH/2+15, CGRectGetMaxY(line2.frame)+50, SCREEN_WIDTH/2 - 25 - 15, 40) backImageName:@"btn_whitle_1.png" title:@"注册" titleColor:PINK_COLOR  font:[UIFont systemFontOfSize:16] target:self action:@selector(registeredButtonTapped:)];
    _registeredButton = registeredButton;
    [_registeredButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    //圆角
    _registeredButton.layer.cornerRadius = 20; //设置那个圆角的有多圆
    _registeredButton.layer.masksToBounds = YES;  //设为NO去试试
    _registeredButton.layer.borderWidth = 0.5;
    _registeredButton.layer.borderColor = PINK_COLOR.CGColor;
    [self.view addSubview:_registeredButton];
}



- (void)addThirdMenu
{
    CGFloat mG = (SCREEN_WIDTH - 54*3)/4.0;
    
    //微信
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"wechat://"]])
    {
        UILabel *lineV3= [[UILabel alloc] initWithFrame:CGRectMake(26, SCREEN_HEIGHT-130, SCREEN_WIDTH-52, 0.5)];
        [lineV3 setBackgroundColor:LINE_COLOR];
        [self.view addSubview:lineV3];
        
        UILabel *mL = [[UILabel alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-100)/2, CGRectGetMaxY(lineV3.frame)-10, 100, 20)];
        [mL setText:@"快速登录"];
        [mL setTextAlignment:NSTextAlignmentCenter];
        [mL setFont:[UIFont systemFontOfSize:15.0 weight:UIFontWeightLight]];
        [mL setTextColor:LIGHT_GARY_COLOR];
        [mL setBackgroundColor:[UIColor whiteColor]];
        [self.view addSubview:mL];
        
        /********************************************* 第三方登录 ***********************************/
        for (int i = 0; i< 3; i++) {
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            if (i == 0)
            {
                [btn setFrame:CGRectMake(mG, SCREEN_HEIGHT-94, 54, 54)];
                [btn setBackgroundImage:[UIImage imageNamed:@"weixin_icon.png"] forState:UIControlStateNormal];
            }
            else if (i == 1)
            {
                [btn setFrame:CGRectMake((SCREEN_WIDTH-54)/2, SCREEN_HEIGHT-94, 54, 54)];
                [btn setBackgroundImage:[UIImage imageNamed:@"qq_icon.png"] forState:UIControlStateNormal];
            }
            else
            {
                [btn setFrame:CGRectMake(SCREEN_WIDTH-mG-54, SCREEN_HEIGHT-94, 54, 54)];
                [btn setBackgroundImage:[UIImage imageNamed:@"weibo_icon.png"] forState:UIControlStateNormal];
            }
            
            [btn setTag:KLoginWX+i];
            [btn addTarget:self action:@selector(btnTapped:) forControlEvents:UIControlEventTouchUpInside];
            [self.view addSubview:btn];
        }
    }
}

- (void)btnTapped:(UIButton *)sender
{
    [self thirdPartyLogin:(ThirdLoginType)sender.tag];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    if (![_phoneItem isExclusiveTouch] ||  ![_pswItem isExclusiveTouch]) {
        [_phoneItem resignFirstResponder];
        [_pswItem resignFirstResponder];
    }
}

- (void)forgetButtonTapped:(id)sender
{
    FindPasswordViewController *fVC = [[FindPasswordViewController alloc] init];
    fVC.mType = KChangePassword_Login;
    [self.navigationController pushViewController:fVC animated:YES];
}

- (void)registeredButtonTapped:(id)sender
{
    FindPasswordViewController *rVC = [[FindPasswordViewController alloc] init];
    rVC.mType = KChangePassword_Register;
    [self.navigationController pushViewController:rVC animated:YES];
}


- (void)loginButtonTapped:(id)sender
{
    if ([self.phoneItem.text length] != 11) {
        [self.view makeToast:@"手机号码不正确"];
        return;
    }
    
    if ([self.pswItem.text length] == 0) {
        [self.view makeToast:@"密码不能为空"];
        return;
    }
    
    LoginParam* loginParam = [[LoginParam alloc] init];
    loginParam.phone = self.phoneItem.text;
    loginParam.password = self.pswItem.text;
    
    [theAppDelegate.HUDManager showSimpleTip:@"登录中..." interval:NSNotFound];

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
    [self dismissViewControllerAnimated:YES completion:NULL];
}

/*********************************** 第三方登录 *******************************/
- (void)thirdPartyLogin:(ThirdLoginType)loginType
{
    UMSocialPlatformType platformType = 0;
    
    if (loginType == KLoginWX) {
        platformType = UMSocialPlatformType_WechatSession;
    }
    
    if (loginType == KLoginQQ) {
        platformType = UMSocialPlatformType_QQ;
    }
    
    if (loginType == KLoginWB) {
        platformType = UMSocialPlatformType_Sina;
    }
    
    
    __typeof (&*self) __weak weakSelf = self;
    
    //如果需要获得用户信息直接跳转的话，需要先取消授权
    //step1 取消授权
    [[UMSocialManager defaultManager] cancelAuthWithPlatform:platformType completion:^(id result, NSError *error) {
        //step2 获得用户信息(获得用户信息中包含检查授权的信息了)
        [[UMSocialManager defaultManager] getUserInfoWithPlatform:platformType currentViewController:self completion:^(id result, NSError *error) {
            if (error) {
                [weakSelf.view makeToast:@"授权失败"];
            }
            else{
                if ([result isKindOfClass:[UMSocialUserInfoResponse class]]) {
                    UMSocialUserInfoResponse *resp = result;
                    
                    ThirdLoginParam* loginParam = [[ThirdLoginParam alloc] init];
                    loginParam.nickname = resp.name;
                    loginParam.profileUrl = resp.iconurl;
                    loginParam.openid = resp.openid;
                    
                    //微博
                    if (loginType == KLoginWB) {
                        loginParam.openid = resp.uid;
                    }
                    
                    //微信专有
                    if (loginType == KLoginWX) {
                        loginParam.access_token = resp.accessToken;
                        loginParam.unionid = [resp.originalResponse objectForKeyNotNull:@"unionid"];
                    }
                    
                    
                    //性别为数字（f为女， m为男）
                    if ([resp.gender isEqualToString:@"m"]) {
                        loginParam.gender = @"male";
                    }
                    else
                    {
                        loginParam.gender = @"female";
                    }
                    
                    loginParam.loginType = loginType;
                    [weakSelf thirdLogin:loginParam];
                    
                }
                else{
                    [weakSelf.view makeToast:@"授权失败"];
                }
            }
        }];
    }];
}

- (void)thirdLogin:(ThirdLoginParam *)param {
    
    [theAppDelegate.HUDManager showSimpleTip:@"登录中..." interval:NSNotFound];
    
    __typeof (&*self) __weak weakSelf = self;
    [[UserLogic sharedInstance] thirdPartyLogin:param withCallback:^(LogicResult *result) {
        
        [theAppDelegate.HUDManager hideHUD];
        
        if(result.statusCode == KLogicStatusSuccess)
        {
            [theAppDelegate loginSuccess];
            [weakSelf perfectUserInfo];
        }
        else
            [weakSelf.view makeToast:result.stateDes];
        
    }];

}


//完善用户资料
- (void)perfectUserInfo{
    User *user = [[UserLogic sharedInstance] getUser];
    
    //弹出完善资料页面
    if ([user.is_reg integerValue] == 1) {
        
        //强制要求绑定手机
        FindPasswordViewController *cVC = [[FindPasswordViewController alloc] init];
        cVC.mType = KChangePassword_BindPhone;
        [self.navigationController pushViewController:cVC animated:YES];
    }
    else
    {
        [self back:nil];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
