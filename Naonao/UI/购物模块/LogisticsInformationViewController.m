//
//  LogisticsInformationViewController.m
//  Naonao
//
//  Created by 刘敏 on 16/4/8.
//  Copyright © 2016年 深圳市轩腾华兴科技开发有限公司. All rights reserved.
//

#import "LogisticsInformationViewController.h"
#import "ShoppingLogic.h"
#import "AttenceTimelineCell.h"
#import "LogisticsHeaderCell.h"


@interface LogisticsInformationViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic, strong) CourierInfo *cInfo;

@end

@implementation LogisticsInformationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setNavBarTitle:@"物流信息"];
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:MAINSCREEN style:UITableViewStyleGrouped];
    _tableView = tableView;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    
    [self resetScrollView:self.tableView tabBar:NO];
    
    [self getLogisticsInfo];

}

- (void)getLogisticsInfo
{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithCapacity:1];
    [dict setObject:_orderID forKey:@"order_id"];
    
    __typeof (&*self) __weak weakSelf = self;
    
    [[ShoppingLogic sharedInstance] lookLogisticsInfo:dict withCallback:^(LogicResult *result) {
        if(result.statusCode == KLogicStatusSuccess)
        {
            weakSelf.cInfo = result.mObject;
            [weakSelf.tableView reloadData];
        }
        else
            [weakSelf.view makeToast:result.stateDes];
    }];
}


#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (_cInfo.logis.logisticCode){
        return 2;
    }
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    }

    return _cInfo.logis.stationArray.count;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 12.0;
}


#pragma mark - Table view data source
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1) {
        AttenceTimelineCell *cell = [AttenceTimelineCell cellWithTableView:tableView];
        NSInteger count = _cInfo.logis.stationArray.count - 1 - indexPath.row;
        //倒序
        [cell setCellWithCellInfo:_cInfo.logis.stationArray[count] row:indexPath.row];
        
        return cell.mH;
    }
    
    return 80;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        LogisticsHeaderCell *cell = [LogisticsHeaderCell cellWithTableView:tableView];
        [cell setCellWithCellInfo:_cInfo];
        return cell;
    }
    else{
        AttenceTimelineCell *cell = [AttenceTimelineCell cellWithTableView:tableView];
        NSInteger count = _cInfo.logis.stationArray.count - 1 - indexPath.row;
        //倒序
        [cell setCellWithCellInfo:_cInfo.logis.stationArray[count] row:indexPath.row];

        return cell;
    }
}



@end
