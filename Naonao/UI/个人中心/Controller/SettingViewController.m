//
//  SettingViewController.m
//  Naonao
//
//  Created by Richard Liu on 15/11/23.
//  Copyright © 2015年 深圳市轩腾华兴科技开发有限公司. All rights reserved.
//

#import "SettingViewController.h"
#import "LXActionSheet.h"
#import <SDWebImage/SDImageCache.h>
#import "OpinionViewController.h"
#import "AboutViewController.h"
#import "FindPasswordViewController.h"
#import "DPWebViewController.h"
#import "JPUSHService.h"
#import "ShoppingLogic.h"

@interface SettingViewController ()<UITableViewDataSource, UITableViewDelegate, LXActionSheetDelegate>

@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic, weak) UIButton *exitBtn;
@end

@implementation SettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setNavBarTitle:@"系统设置"];

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
    // Return the number of sections.
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if (section == 0) {
        return 3;
    }
    else if(section == 1)
    {
        return 3;
    }
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 20;
}


- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 2) {
        return 30;
    }
    return 0.1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    //搜索结果
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        cell.textLabel.font = [UIFont systemFontOfSize:16.0f];
        cell.detailTextLabel.font = [UIFont systemFontOfSize:16.0f];
    }
    
    NSString *imgN = nil;
    NSString *titS = nil;
    
    if (indexPath.section == 0)
    {
        if (indexPath.row == 0) {
            imgN = @"set_icon_password.png";
            titS = @"修改密码";
        }
        else if (indexPath.row == 1)
        {
            imgN = @"set_icon_opinion.png";
            titS = @"提意见";
        }
        else if (indexPath.row == 2)
        {
            imgN = @"set_icon_help.png";
            titS = @"帮助";
        }
        else if (indexPath.row == 3)
        {
            imgN = @"set_icon_bell.png";
            titS = @"通知推送";
        }
    }
    else if (indexPath.section == 1){
        if (indexPath.row == 0) {
            imgN = @"set_icon_trash.png";
            titS = @"清理缓存";
            float tmpSize = [[SDImageCache sharedImageCache] checkTmpSize];
            cell.detailTextLabel.text = tmpSize >= 1 ? [NSString stringWithFormat:@"%.2fM",tmpSize] : [NSString stringWithFormat:@"%.2fK",tmpSize * 1024];

        }
        else if (indexPath.row == 1)
        {
            imgN = @"set_icon_score.png";
            titS = @"评分鼓励";
        }
        else if (indexPath.row == 2)
        {
            imgN = @"set_icon_about.png";
            titS = @"关于挠挠";
        }
 
    }
    else if (indexPath.section == 2) {
        imgN = nil;
        titS = nil;
        UILabel *tL = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44)];
        tL.font = [UIFont systemFontOfSize:16.0f];
        tL.textAlignment = NSTextAlignmentCenter;
        [tL setText:@"退出登录"];
        [cell.contentView addSubview:tL];
        
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    cell.imageView.image = [UIImage imageNamed:imgN];
    cell.textLabel.text = titS;

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 0)
    {
        if (indexPath.row == 0) {
            User *user = [[UserLogic sharedInstance] getUser];
            if ([user.basic.telephone length] < 1) {
                AlertWithTitleAndMessageAndUnitsToTag(nil, @"您还未绑定手机，请先绑定手机", self, @"绑定", nil, 0x128);
                return;
            }
            
            FindPasswordViewController *cVC = [[FindPasswordViewController alloc] init];
            cVC.mType = KChangePassword_Setting;
            [self.navigationController pushViewController:cVC animated:YES];
        }
        
        if (indexPath.row == 1) {
            OpinionViewController *oVC = [[OpinionViewController alloc] initWithNibName:@"OpinionViewController" bundle:nil];
            [self.navigationController pushViewController:oVC animated:YES];
        }
        
        if (indexPath.row == 2) {
            DPWebViewController *dVC = [[DPWebViewController alloc] init];
            dVC.urlSting = K_HELP_URL;
            dVC.titName = @"帮助说明";
            
            [self.navigationController pushViewController:dVC animated:YES];
        }
    }
    
    if (indexPath.section == 1)
    {
        if (indexPath.row == 0) {
            AlertWithTitleAndMessageAndUnitsToTag(nil, @"确定要清除缓存吗？", self, @"清除", nil, 0x256);
        }
        if (indexPath.row == 1)
        {
            //评分鼓励
            [self evaluateScore];
        }
        if (indexPath.row == 2)
        {
            AboutViewController *aVC = [[AboutViewController alloc] init];
            [self.navigationController pushViewController:aVC animated:YES];
        }
    }
    
    
    if (indexPath.section == 2) {
        LXActionSheet *actionSheet = [[LXActionSheet alloc] initWithTitle:@"是否要退出当前账号？" delegate:self cancelButtonTitle:@"否" destructiveButtonTitle:nil otherButtonTitles:@[@"退出登录"]];
        [actionSheet showInView:self.view];
    }
}

#pragma mark - LXActionSheetDelegate
- (void)actionSheet:(LXActionSheet *)mActionSheet didClickOnButtonIndex:(int)buttonIndex
{
    switch (buttonIndex) {
        case 0:
            [self cancellation];
            break;
            
        default:
            break;
    }
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        
        if(alertView.tag == 0x128)
        {
            FindPasswordViewController *cVC = [[FindPasswordViewController alloc] init];
            cVC.mType = KChangePassword_BindPhone;
            [self.navigationController pushViewController:cVC animated:YES];

        }
        else if(alertView.tag == 0x256)
        {
            [[SDImageCache sharedImageCache] clearDiskOnCompletion:^{
                [self.view makeToast:@"清理完毕"];
                [_tableView reloadData];
            }];
        }
    }
}


//注销
- (void)cancellation
{
    [[UserLogic sharedInstance] cleanDataWhenLogout];
    [[ShoppingLogic sharedInstance] cleanDataWhenLogout];
    
    [self.navigationController popToRootViewControllerAnimated:NO];
    
    //注销设备(注销推送)
    [JPUSHService clearAllLocalNotifications];
}


//评分
- (void)evaluateScore{
    NSString *evaluateString = nil;
    
    if (isIOS7) {
        evaluateString = [NSString stringWithFormat:@"itms-apps://itunes.apple.com/app/id1062732158"];
    }
    else{
        evaluateString = [NSString stringWithFormat:@"itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=1062732158"];
    }
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:evaluateString]];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
