//
//  WithdrawDetailViewController.m
//  Naonao
//
//  Created by 刘敏 on 16/5/17.
//  Copyright © 2016年 深圳市轩腾华兴科技开发有限公司. All rights reserved.
//

#import "WithdrawDetailViewController.h"
#import "WithdrawLogic.h"
#import "WalletCell.h"
#import "WalletTimelineCell.h"
#import "MJRefresh.h"

@interface WithdrawDetailViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic, strong) WithdrawTimeline *wData;

@end

@implementation WithdrawDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setNavBarTitle:@"明细"];
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:MAINSCREEN style:UITableViewStylePlain];
    _tableView = tableView;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = BACKGROUND_GARY_COLOR;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    [self resetScrollView:self.tableView tabBar:NO];
    
    [self getWalletDetails];

    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
}


#pragma mark - 下拉刷新更新数据
- (void)loadNewData{
    [self getWalletDetails];
}

- (void)getWalletDetails
{
    __typeof (&*self) __weak weakSelf = self;
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithCapacity:1];
    [dic setObject:_record.product.productId forKey:@"product_id"];
    
    [[WithdrawLogic sharedInstance] getGoodsWithdrawDetails:dic withCallback:^(LogicResult *result) {
        if(result.statusCode == KLogicStatusSuccess)
        {
            weakSelf.wData = result.mObject;
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
    if (_wData) {
        return 2;
    }
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    }
    else{
        if (_wData.payList.count > 0) {
            return _wData.payList.count+1;
        }
        
        return 1;
    }
}

#pragma mark - Table view data source
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 80;
    }
    
    return 65;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        WalletCell *cell = [WalletCell cellWithTableView:tableView];
        [cell setCellWithCellInfo:_record];
        return cell;
    }
    else
    {
        WalletTimelineCell *cell = [WalletTimelineCell cellWithTableView:tableView];
        if (_wData.payList.count > 0) {
            
            if (indexPath.row == _wData.payList.count) {
                //分享时间
                [cell setCellWithCellWSInfo:_wData.showTime];
            }
            else{
                [cell setCellWithCellWPInfo:_wData.payList[indexPath.row]];
                if (indexPath.row == 0) {
                    [cell updateDotView];
                }
            }
        }
        else
        {
            //分享时间
            [cell setCellWithCellWSInfo:_wData.showTime];
            [cell updateDotView];
        }

        return cell;
    }
}

@end
