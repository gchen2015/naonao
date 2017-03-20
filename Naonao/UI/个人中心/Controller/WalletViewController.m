//
//  WalletViewController.m
//  Naonao
//
//  Created by 刘敏 on 16/5/15.
//  Copyright © 2016年 深圳市轩腾华兴科技开发有限公司. All rights reserved.
//

#import "WalletViewController.h"
#import "WithdrawLogic.h"
#import "WalletHeadCell.h"
#import "WithdrawTypeViewController.h"
#import "WithdrawDetailViewController.h"
#import "WithdrawRecordViewController.h"
#import "MJRefresh.h"
#import "WalletCell.h"


@interface WalletViewController ()<UITableViewDataSource, UITableViewDelegate, WalletHeadCellDelegate>

@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic, strong) NSArray *tableArray;

@property (nonatomic, strong) WithdrawModel *md;

@end

@implementation WalletViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setNavBarTitle:@"我的钱包"];
    
    [self setNavBarRightBtn:[STNavBarView createNormalNaviBarBtnByTitle:@"记录" target:self action:@selector(recordTapped:)]];
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:MAINSCREEN style:UITableViewStylePlain];
    _tableView = tableView;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = BACKGROUND_GARY_COLOR;
    [self.view addSubview:_tableView];
    [self resetScrollView:self.tableView tabBar:NO];
    
    [self getWallet];
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    
    [self setExtraCellLineHidden:_tableView];
}


//清除多余分割线
- (void)setExtraCellLineHidden:(UITableView *)tableView
{
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [self.tableView setTableFooterView:view];
}


#pragma mark - 下拉刷新更新数据
- (void)loadNewData{
    [self getWallet];
}


- (void)getWallet
{
    __typeof (&*self) __weak weakSelf = self;
    
    [[WithdrawLogic sharedInstance] getMyWallet:nil withCallback:^(LogicResult *result) {
        if(result.statusCode == KLogicStatusSuccess)
        {
            weakSelf.md = result.mObject;
            weakSelf.tableArray = weakSelf.md.records;
            [weakSelf.tableView reloadData];
        }
        else
        {
            [weakSelf.view makeToast:result.stateDes];
        }
        
        [self.tableView.mj_header endRefreshing];
    }];
}



#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (_tableArray.count > 0) {
        return 2;
    }
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    }
    
    return _tableArray.count;
}


#pragma mark - Table view data source
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 160;
    }
    
    return 80;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        WalletHeadCell *cell = [WalletHeadCell cellWithTableView:tableView];
        [cell setCellWithCellInfo:_md];
        cell.delegate = self;
        return cell;
    }
    else
    {
        WalletCell *cell = [WalletCell cellWithTableView:tableView];
        [cell setCellWithCellInfo:_tableArray[indexPath.row]];
        
        return cell;
    }
}

#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if(indexPath.section > 0)
    {
        WithdrawDetailViewController *VC = [[WithdrawDetailViewController alloc] init];
        VC.record = _tableArray[indexPath.row];
        [self.navigationController pushViewController:VC animated:YES];
    }

}


#pragma mark - WalletHeadCellDelegate
- (void)jumpWithdrawView
{
    [WithdrawLogic sharedInstance].amount = _md.free;
    
    WithdrawTypeViewController *VC = [[WithdrawTypeViewController alloc] init];
    VC.md = _md;
    [self.navigationController pushViewController:VC animated:YES];
}


- (void)recordTapped:(id)sender
{
    WithdrawRecordViewController *VC = [[WithdrawRecordViewController alloc] init];
    [self.navigationController pushViewController:VC animated:YES];
}

@end
