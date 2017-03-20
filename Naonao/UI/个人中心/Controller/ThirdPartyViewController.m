//
//  ThirdPartyViewController.m
//  Naonao
//
//  Created by Richard Liu on 16/1/7.
//  Copyright © 2016年 深圳市轩腾华兴科技开发有限公司. All rights reserved.
//

#import "ThirdPartyViewController.h"
#import <UMSocialCore/UMSocialCore.h>
#import "LoginDAO.h"


@interface ThirdPartyViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) UITableView *tableView;
@property (nonatomic, strong) NSArray *mArray;

@property (nonatomic, assign) BOOL isWX;
@property (nonatomic, assign) BOOL isQQ;
@property (nonatomic, assign) BOOL isWB;

@end

@implementation ThirdPartyViewController


- (void)updateUI
{
    _isWX = NO;
    _isQQ = NO;
    _isWB = NO;
    
    User *user = [[UserLogic sharedInstance] getUser];
    _mArray =  user.thirdparty;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setNavBarTitle:@"第三方账号"];
    
    [self updateUI];

    UITableView *tableView = [[UITableView alloc] initWithFrame:MAINSCREEN style:UITableViewStyleGrouped];
    _tableView = tableView;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    [self resetScrollView:self.tableView tabBar:NO];
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 20;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"settingsCell";
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    }
    
    cell.detailTextLabel.font = [UIFont systemFontOfSize:16.0f];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

    if (indexPath.row == 0) {
        cell.imageView.image = [UIImage imageNamed:@"Share_binding_wechat.png"];
        cell.textLabel.text = @"微信";
        
        if (_mArray) {
            
            for (NSString *item in _mArray) {
                if ([item integerValue] == KLoginWX) {
                    cell.detailTextLabel.text = @"已绑定";
                    cell.accessoryType = UITableViewCellAccessoryNone;
                    _isWX = YES;
                }
            }
            
            if (!_isWX)
            {
                cell.detailTextLabel.text = @"立即绑定";
                cell.detailTextLabel.textColor = [UIColor redColor];
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            }
        }
        else
        {
            cell.detailTextLabel.text = @"立即绑定";
            cell.detailTextLabel.textColor = [UIColor redColor];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }

    }
    
    if (indexPath.row == 1)
    {
        cell.imageView.image = [UIImage imageNamed:@"Share_binding_QQ.png"];
        cell.textLabel.text = @"QQ";
        
        if (_mArray) {
            
            for (NSString *item in _mArray) {
                if ([item integerValue] == KLoginQQ) {
                    cell.detailTextLabel.text = @"已绑定";
                    cell.accessoryType = UITableViewCellAccessoryNone;
                    _isQQ = YES;
                }
            }
            
            if (!_isQQ)
            {
                cell.detailTextLabel.text = @"立即绑定";
                cell.detailTextLabel.textColor = [UIColor redColor];
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            }
        }
        else
        {
            cell.detailTextLabel.text = @"立即绑定";
            cell.detailTextLabel.textColor = [UIColor redColor];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
    }
    
    
    if (indexPath.row == 2) {
        cell.imageView.image = [UIImage imageNamed:@"Share_binding_weibo.png"];
        cell.textLabel.text = @"微博";
        
        if (_mArray) {
            
            for (NSString *item in _mArray) {
                if ([item integerValue] == KLoginWB) {
                    cell.detailTextLabel.text = @"已绑定";
                    cell.accessoryType = UITableViewCellAccessoryNone;
                    _isWB = YES;
                }
            }
            
            if (!_isWB)
            {
                cell.detailTextLabel.text = @"立即绑定";
                cell.detailTextLabel.textColor = [UIColor redColor];
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            }
        }
        else
        {
            cell.detailTextLabel.text = @"立即绑定";
            cell.detailTextLabel.textColor = [UIColor redColor];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
    }

    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row == 0 && !_isWX) {
        //微信
        [self thirdPartyLogin:KLoginWX];
    }
    
    if (indexPath.row == 1 && !_isQQ) {
        //QQ
        [self thirdPartyLogin:KLoginQQ];
    }
    
    if (indexPath.row == 2 && !_isWB) {
        //微博
        [self thirdPartyLogin:KLoginWB];
    }
    
}

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
                    
                    [weakSelf bindThirdPart:loginParam];
                    
                }
                else{
                    [weakSelf.view makeToast:@"授权失败"];
                }
            }
        }];
    }];
}

- (void)bindThirdPart:(ThirdLoginParam *)loginParam
{
    [theAppDelegate.HUDManager showSimpleTip:@"绑定中..." interval:NSNotFound];
    
    __typeof (&*self) __weak weakSelf = self;
    
    [[UserLogic sharedInstance] bindThirdParty:loginParam withCallback:^(LogicResult *result) {
        [theAppDelegate.HUDManager hideHUD];
        
        if(result.statusCode == KLogicStatusSuccess)
        {
            [weakSelf updateUI];
            [weakSelf.tableView reloadData];
        }
        else
            [weakSelf.view makeToast:result.stateDes];
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
