//
//  PickupViewController.m
//  Naonao
//
//  Created by 刘敏 on 2016/9/17.
//  Copyright © 2016年 深圳市轩腾华兴科技开发有限公司. All rights reserved.
//

#import "PickupViewController.h"
#import "MJRefresh.h"
#import "AppointmentLogic.h"
#import "PickUpCell.h"
#import "PUDetailsViewController.h"
#import "MyAppointmentViewController.h"


@interface PickupViewController ()

@property (nonatomic, strong) NSArray *tableArray;

@end

@implementation PickupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

    [self getMyChicdateTakeOrder];
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
    [self getMyChicdateTakeOrder];
}



// 获取我的上门试衣
- (void)getMyChicdateTakeOrder{
    __typeof (&*self) __weak weakSelf = self;
    
    [[AppointmentLogic sharedInstance] getMyChicdateTakeOrder:nil withCallback:^(LogicResult *result) {
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
    PickUpData *mInfo = _tableArray[indexPath.section];
    return 164.0 + mInfo.skuArray.count*54;
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
    PickUpCell *cell = [PickUpCell cellWithTableView:tableView];
    [cell setCellWithCellInfo:_tableArray[indexPath.section]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    PUDetailsViewController *fVC = [[PUDetailsViewController alloc] init];
    fVC.mInfo = _tableArray[indexPath.section];
    [_rootVC.navigationController pushViewController:fVC animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
