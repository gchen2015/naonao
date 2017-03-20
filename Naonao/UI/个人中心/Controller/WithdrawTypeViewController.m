//
//  WithdrawTypeViewController.m
//  Naonao
//
//  Created by 刘敏 on 16/5/16.
//  Copyright © 2016年 深圳市轩腾华兴科技开发有限公司. All rights reserved.
//

#import "WithdrawTypeViewController.h"
#import "WithdrawTypeCell.h"
#import "WithdrawalViewController.h"
#import "DPWebViewController.h"


@interface WithdrawTypeViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic, strong) NSArray *tableArray;

@end


@implementation WithdrawTypeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setNavBarTitle:@"选择提现方式"];
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:MAINSCREEN style:UITableViewStylePlain];
    _tableView = tableView;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    [self resetScrollView:self.tableView tabBar:NO];
    
    [self setExtraCellLineHidden:_tableView];
}


//清除多余分割线
- (void)setExtraCellLineHidden:(UITableView *)tableView
{
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [self.tableView setTableFooterView:view];
}


#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}


#pragma mark - Table view data source
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 64;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    WithdrawTypeCell *cell = [WithdrawTypeCell cellWithTableView:tableView];
    [cell setCellWithRow:indexPath.row];

    return cell;
}


#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row +1 == KWithdrawal_WX){
        //判断微信是否已关注了[挠挠]服务号
        if (![_md.follow_wx boolValue]) {
            DPWebViewController *dVC = [[DPWebViewController alloc] init];
            dVC.urlSting = K_WX_CASH;
            dVC.titName = @"微信提现说明";
            [self.navigationController pushViewController:dVC animated:YES];
            
            return;
        }
    }
    
    
    
    WithdrawalViewController *vc = [[WithdrawalViewController alloc] init];
    vc.mType = indexPath.row +1;
    [self.navigationController pushViewController:vc animated:YES];
    
}


@end
