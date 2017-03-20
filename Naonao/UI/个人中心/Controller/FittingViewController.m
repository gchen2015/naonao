//
//  FittingViewController.m
//  Naonao
//
//  Created by 刘敏 on 2016/9/17.
//  Copyright © 2016年 深圳市轩腾华兴科技开发有限公司. All rights reserved.
//

#import "FittingViewController.h"
#import "MyAppointmentViewController.h"
#import "FittingDetailsViewController.h"
#import "MJRefresh.h"
#import "AppointmentLogic.h"
#import "FittingCell.h"

@interface FittingViewController ()

@property (nonatomic, strong) NSArray *tableArray;

@end

@implementation FittingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self getMyReservation];
    [self setupRefresh];
}

// 刷新控件
- (void)setupRefresh
{
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
}

#pragma mark - 下拉刷新更新数据
- (void)loadNewData{
    [self.tableView.mj_header endRefreshing];
    [self getMyReservation];
}


// 获取我的上门试衣
- (void)getMyReservation{
    __typeof (&*self) __weak weakSelf = self;
    
    [[AppointmentLogic sharedInstance] getMyReservation:nil withCallback:^(LogicResult *result) {
        if(result.statusCode == KLogicStatusSuccess)
        {
            weakSelf.tableArray = result.mObject;
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
    return _tableArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 222.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 15.0;
}


- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == _tableArray.count-1) {
        return 15.0;
    }
    
    return 0.1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FittingCell *cell = [FittingCell cellWithTableView:tableView];
    [cell setCellWithCellInfo:_tableArray[indexPath.section]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    FittingDetailsViewController *fVC = [[FittingDetailsViewController alloc] init];
    fVC.mInfo = _tableArray[indexPath.section];
    [_rootVC.navigationController pushViewController:fVC animated:YES];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
