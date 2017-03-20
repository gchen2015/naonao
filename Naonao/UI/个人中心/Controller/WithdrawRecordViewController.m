//
//  WithdrawRecordViewController.m
//  Naonao
//
//  Created by 刘敏 on 16/5/19.
//  Copyright © 2016年 深圳市轩腾华兴科技开发有限公司. All rights reserved.
//

#import "WithdrawRecordViewController.h"
#import "WithdrawLogic.h"
#import "MJRefresh.h"
#import "WithdrawRecordCell.h"
#import "UITableView+Mascot.h"

@interface WithdrawRecordViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic, strong) NSArray *tableArray;

@end

@implementation WithdrawRecordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setNavBarTitle:@"提现记录"];
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:MAINSCREEN style:UITableViewStylePlain];
    _tableView = tableView;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = BACKGROUND_GARY_COLOR;
    [self.view addSubview:_tableView];
    [self resetScrollView:self.tableView tabBar:NO];
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    
    self.tableView.tableFooterView = [UIView new];
    [self.tableView setLoadedImageName:@"bird_no_response.png"];
    [self.tableView setDescriptionText:@"您还没有提现记录"];
    [self.tableView setButtonText:@""];
    [self getWithdrawRecord];
    
    //删除多余
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
    [self getWithdrawRecord];
}


- (void)getWithdrawRecord{
    __typeof (&*self) __weak weakSelf = self;
    
    // 只需一行代码，我来解放你的代码
    self.tableView.loading = YES;
    
    [[WithdrawLogic sharedInstance] getWithdrawRecords:nil withCallback:^(LogicResult *result) {
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
        self.tableView.loading = NO;
    }];
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _tableArray.count;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 66;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WithdrawRecordCell *cell = [WithdrawRecordCell cellWithTableView:tableView];
    [cell setCellWithCellInfo:_tableArray[indexPath.row]];
    return cell;

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
