//
//  FocusListViewController.m
//  Naonao
//
//  Created by 刘敏 on 16/7/21.
//  Copyright © 2016年 深圳市轩腾华兴科技开发有限公司. All rights reserved.
//

#import "FocusListViewController.h"
#import "UserCenterViewController.h"
#import "UserLogic.h"
#import "FocusCell.h"
#import "MJRefresh.h"


@interface FocusListViewController ()<UITableViewDataSource, UITableViewDelegate, FocusCellDelegate>

@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *tableArray;

@property (nonatomic, assign) NSUInteger mPage;

@end



@implementation FocusListViewController

#pragma mark - 懒加载
- (NSMutableArray *)tableArray
{
    if (!_tableArray) {
        self.tableArray = [NSMutableArray array];
    }
    return _tableArray;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"UPDATE_USER_DATA" object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:MAINSCREEN style:UITableViewStylePlain];
    _tableView = tableView;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    
    _mPage = 0;
    
    //校正滚动区域
    [self resetScrollView:_tableView tabBar:NO];
    
    if (_mIndex == 1) {
        [self setNavBarTitle:@"我的关注"];
        [self getFocusList];
    }
    else{
        [self setNavBarTitle:@"我的粉丝"];
        [self getFansList];
    }

    [self setupRefresh];

}

// 刷新控件
- (void)setupRefresh
{
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    [self.tableView.mj_footer setHidden:YES];
}


#pragma mark - 下拉刷新更新数据
- (void)loadNewData{
    [self.tableView.mj_header endRefreshing];
    _mPage = 0;

    // 发送网络请求
    if (_mIndex == 1) {
        [self getFocusList];
    }
    else{
        [self getFansList];
    }
}

#pragma mark - 上拉刷新更多数据
- (void)loadMoreData{
    _mPage = _tableArray.count;
    // 发送网络请求
    if (_mIndex == 1) {
        [self getFocusList];
    }
    else{
        [self getFansList];
    }
}

- (void)getFocusList{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithCapacity:1];
    [dict setObject:[NSNumber numberWithInteger:_mPage] forKey:@"start"];
    [dict setObject:[NSNumber numberWithInteger:30] forKey:@"size"];
    
    __typeof (&*self) __weak weakSelf = self;
    
    [[UserLogic sharedInstance] requestUserFocusList:dict withCallback:^(LogicResult *result) {
        if(result.statusCode == KLogicStatusSuccess)
        {
            if (_mPage == 0) {
                [weakSelf.tableArray removeAllObjects];
                [self.tableView.mj_footer setHidden:NO];
            }
            
            NSArray *temA = (NSArray *)result.mObject;
            if (temA.count < 30) {
                //隐藏
                [self.tableView.mj_footer setHidden:YES];
            }
            [weakSelf.tableArray addObjectsFromArray:temA];
            [weakSelf.tableView reloadData];
        }
        else
        {
            [weakSelf.view makeToast:result.stateDes];
        }
        
        
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    }];
}

- (void)getFansList{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithCapacity:1];
    [dict setObject:[NSNumber numberWithInteger:_mPage] forKey:@"start"];
    [dict setObject:[NSNumber numberWithInteger:30] forKey:@"size"];
    
    __typeof (&*self) __weak weakSelf = self;
    
    [[UserLogic sharedInstance] requestUserFansList:dict withCallback:^(LogicResult *result) {
        if(result.statusCode == KLogicStatusSuccess)
        {
            if (_mPage == 0) {
                [weakSelf.tableArray removeAllObjects];
                [self.tableView.mj_footer setHidden:NO];
            }
            
            NSArray *temA = (NSArray *)result.mObject;
            if (temA.count < 30) {
                //隐藏
                [self.tableView.mj_footer setHidden:YES];
            }
            
            [weakSelf.tableArray addObjectsFromArray:temA];
            [weakSelf.tableView reloadData];
        }
        else
        {
            [weakSelf.view makeToast:result.stateDes];
        }
        
        
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    }];
}


#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return _tableArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 64;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FocusCell *cell = [FocusCell cellWithTableView:tableView];
    cell.delegate = self;
    UserFollow *model = _tableArray[indexPath.row];
    
    if (_mIndex == 1)
    {
        model.isFollow = [NSNumber numberWithBool:YES];
    }
    [cell setCellWithCellInfo:model];
    cell.mIndex = _mIndex;
    
    return cell;
}

#pragma mark - FocusCellDelegate
- (void)focusCell:(FocusCell *)mCell headBtnTapped:(NSNumber *)userId {
    //进入个人中心页面
    UserCenterViewController *cVC = [[UserCenterViewController alloc] init];
    cVC.userId = userId;
    [self.navigationController pushViewController:cVC animated:YES];
}

@end
