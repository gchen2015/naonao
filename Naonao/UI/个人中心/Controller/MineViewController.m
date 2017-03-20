//
//  MineViewController.m
//  Naonao
//
//  Created by Richard Liu on 15/12/9.
//  Copyright © 2015年 深圳市轩腾华兴科技开发有限公司. All rights reserved.
//

#import "MineViewController.h"
#import "SettingViewController.h"
#import "ShopCartViewController.h"
#import "CouponsViewController.h"
#import "PersonalInfoViewController.h"
#import "OrdersViewController.h"
#import "ShapeInfoViewController.h"
#import "FigureGuideViewController.h"
#import "MineHeadCell.h"
#import "WalletViewController.h"
#import "MyAnswerViewController.h"
#import "FocusListViewController.h"
#import "FavoritesViewController.h"
#import "MyQuestionsViewController.h"
#import "MyCommentsViewController.h"
#import "MyUpgradeViewController.h"
#import "ScanQRCodeViewController.h"
#import "MyAppointmentViewController.h"
#import "MyPhotoViewController.h"
#import "AprizeViewController.h"



@interface MineViewController ()<UITableViewDataSource, UITableViewDelegate, MineHeadCellDelegate>

@property (nonatomic, weak) UITableView *tableView;

@end

@implementation MineViewController

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    User *user = [[UserLogic sharedInstance] getUser];
    if (user)
    {
        [self setNavBarTitle:user.basic.userName];
    }
    else{
        [self setNavBarTitle:@"我的"];
    }
    
    [_tableView reloadData];
}

- (void)dealloc
{
    //移除消息
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"UPDATE_USER_DATA" object:nil];
}

- (void)addNotification{
    //增加消息通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateData) name:@"UPDATE_USER_DATA" object:nil];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setNavBarTitle:@"我的"];
    [self setNavBarLeftBtn:[STNavBarView createImgNaviBarBtnByImgNormal:@"icon_mine_setting.png" imgHighlight:@"icon_mine_setting.png" target:self action:@selector(settingBtnTapped:)]];
    [self setNavBarRightBtn:[STNavBarView createImgNaviBarBtnByImgNormal:@"scan_icon.png" imgHighlight:@"scan_icon.png" target:self action:@selector(qrCodeTapped:)]];


    UITableView *tableView = [[UITableView alloc] initWithFrame:MAINSCREEN style:UITableViewStyleGrouped];
    _tableView = tableView;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = [UIColor colorWithHex:0xEEEBEB];
    [self.view addSubview:_tableView];
    
    [self addNotification];
    
    [self resetScrollView:self.tableView tabBar:YES];
}

- (void)settingBtnTapped:(id)sender{
    if (![UserLogic sharedInstance].user.basic.userId) {
        [theAppDelegate popLoginView];
        return;
    }
    
    SettingViewController *sVC = [[SettingViewController alloc] init];
    sVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:sVC animated:YES];
}

- (void)qrCodeTapped:(id)sender {
    if (![UserLogic sharedInstance].user.basic.userId) {
        [theAppDelegate popLoginView];
        return;
    }
    
    ScanQRCodeViewController *qrVC = CREATCONTROLLER(ScanQRCodeViewController);
    qrVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:qrVC animated:YES];
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if (section == 0) {
        return 1;
    }
    else if (section == 1)
    {
        return 2;
    }
    else if (section == 2){
        return 2;
    }
    
    return 5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.1;
}


- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 15;
}

#pragma mark - Table view data source
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 180.0;
    }
    
    return 45.0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        MineHeadCell *cell = [MineHeadCell cellWithTableView:tableView];
        [cell updateUI];
        cell.delegate = self;
        return cell;
    }
    else{
        
        static NSString *CellIdentifier = @"Cell";
        UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.selectionStyle = UITableViewCellSelectionStyleGray;
            [cell.textLabel setFont:[UIFont systemFontOfSize:14.0]];
            [cell.textLabel setTextColor:BLACK_COLOR];
            
            cell.detailTextLabel.minimumScaleFactor = 0.6f;
            cell.detailTextLabel.adjustsFontSizeToFitWidth = YES;
            [cell.detailTextLabel setFont:[UIFont systemFontOfSize:12.0]];
            [cell.detailTextLabel setTextColor:LIGHT_BLACK_COLOR];
        }
        
        NSString *imageN = nil;
        NSString *nameN = nil;
        NSString *value = nil;
        
        if (indexPath.section == 1) {
            if (indexPath.row == 0) {
                imageN = @"mine_icon_questions.png";
                nameN = @"我的提问";
            }
            else if(indexPath.row == 1){
                imageN = @"mine_icon_answer.png";
                nameN = @"我的回答";
            }
            else if(indexPath.row == 2){
                imageN = @"mine_icon_momments.png";
                nameN = @"我的评论";
            }
        }
        else if (indexPath.section == 2) {
            if (indexPath.row == 0) {
                imageN = @"mine_icon_photo.png";
                nameN = @"我的写真";
            }
            else if(indexPath.row == 1){
                imageN = @"mine_icon_appointment.png";
                nameN = @"我的预约";
            }
        }
        else if (indexPath.section == 3) {
            if (indexPath.row == 0) {
                imageN = @"mine_icon_order.png";
                nameN = @"我的订单";
            }
            else if(indexPath.row == 1){
                imageN = @"mine_icon_cart.png";
                nameN = @"购物车";
            }
            else if(indexPath.row == 2){
                imageN = @"mine_icon_coupons.png";
                nameN = @"优惠券";
            }
            else if (indexPath.row == 3) {
                nameN = @"我的身材信息";
                
                User *user = [[UserLogic sharedInstance] getUser];
                if (user.body){
                    value = nil;
                    imageN = @"mine_icon_figure.png";
                }
                else
                {
                    imageN = @"mine_icon_figure_red.png";
                    [cell.detailTextLabel setTextColor:[UIColor redColor]];
                    value = @"拿现金券";
                }
            }
//            else if(indexPath.row == 4){
//                imageN = @"mine_icon_growth.png";
//                nameN = @"我的成长";
//            }
            else if(indexPath.row == 4){
                imageN = @"mine_icon_share.png";
                nameN = @"邀请奖励";
            }
        }
        
        [cell.imageView setImage:[UIImage imageNamed:imageN]];
        cell.textLabel.text = nameN;
        cell.detailTextLabel.text = value;
        
        return cell;
        
    }
}


#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (![UserLogic sharedInstance].user.basic.userId) {
        [theAppDelegate popLoginView];
        return;
    }
    
    if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            //我的提问
            MyQuestionsViewController *sVC = [[MyQuestionsViewController alloc] init];
            sVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:sVC animated:YES];
        }
        else if(indexPath.row == 1){
            //我的回答
            MyAnswerViewController *sVC = [[MyAnswerViewController alloc] init];
            sVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:sVC animated:YES];
        }
        else if(indexPath.row == 2){
            MyCommentsViewController *sVC = [[MyCommentsViewController alloc] init];
            sVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:sVC animated:YES];
        }
    }
    else if (indexPath.section == 2){
        if (indexPath.row == 0) {
            MyPhotoViewController *sVC = [[MyPhotoViewController alloc] init];
            sVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:sVC animated:YES];
        }
        else if(indexPath.row == 1){
            MyAppointmentViewController *sVC = [[MyAppointmentViewController alloc] init];
            sVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:sVC animated:YES];
        }
    }
    else if (indexPath.section == 3) {
        if (indexPath.row == 0) {
            //我的订单
            OrdersViewController *sVC = [[OrdersViewController alloc] init];
            sVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:sVC animated:YES];
        }
        else if(indexPath.row == 1){
            //购物车
            ShopCartViewController *sVC = [[ShopCartViewController alloc] init];
            sVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:sVC animated:YES];
        }
        else if(indexPath.row == 2){
            //优惠券
            CouponsViewController *sVC = [[CouponsViewController alloc] init];
            sVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:sVC animated:YES];
        }
        else if (indexPath.row == 3) {
            User *user = [[UserLogic sharedInstance] getUser];
            if (user.body) {
                ShapeInfoViewController *sVC = [[ShapeInfoViewController alloc] init];
                sVC.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:sVC animated:YES];
            }
            else{
                FigureGuideViewController *bVC = CREATCONTROLLER(FigureGuideViewController);
                bVC.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:bVC animated:YES];
            }
        }
//        else if(indexPath.row == 4){
//            //我的成长
//            MyUpgradeViewController *sVC = [[MyUpgradeViewController alloc] init];
//            sVC.hidesBottomBarWhenPushed = YES;
//            [self.navigationController pushViewController:sVC animated:YES];
//        }
        else if(indexPath.row == 4){
            //设置
            AprizeViewController *sVC = CREATCONTROLLER(AprizeViewController);
            sVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:sVC animated:YES];
        }
    }
}

#pragma mark -MineHeadCellDelegate代理
- (void)mineHeadView:(MineHeadCell *)mycell bTnIndex:(NSInteger) index {
    
    if (![UserLogic sharedInstance].user.basic.userId) {
        [theAppDelegate popLoginView];
        return;
    }
    
    switch (index) {
        case 0:
        {
            //收藏夹
            FavoritesViewController *sVC = [[FavoritesViewController alloc] init];
            sVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:sVC animated:YES];
        }
            
            break;
            
        case 1:
        {
            //关注
            FocusListViewController *sVC = [[FocusListViewController alloc] init];
            sVC.hidesBottomBarWhenPushed = YES;
            sVC.mIndex = 1;
            [self.navigationController pushViewController:sVC animated:YES];
        }
            
            break;
            
        case 2:
        {
            //粉丝
            FocusListViewController *sVC = [[FocusListViewController alloc] init];
            sVC.hidesBottomBarWhenPushed = YES;
            sVC.mIndex = 2;
            [self.navigationController pushViewController:sVC animated:YES];
        }
            
            break;
            
        case 3:
        {
            //我的钱包
            WalletViewController *sVC = [[WalletViewController alloc] init];
            sVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:sVC animated:YES];
            
        }
            break;

        default:
            break;
    }
}

#pragma mark 头像点击---进入--编辑个人资料
- (void)mineHeadTapped
{
    if (![UserLogic sharedInstance].user.basic.userId) {
        [theAppDelegate popLoginView];
        return;
    }
    
    PersonalInfoViewController *pVC = [[PersonalInfoViewController alloc] init];
    pVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:pVC animated:YES];
}

- (void)updateData
{
    [_tableView reloadData];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
