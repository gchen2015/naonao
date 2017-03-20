//
//  GBaseViewController.m
//  Naonao
//
//  Created by 刘敏 on 16/7/29.
//  Copyright © 2016年 深圳市轩腾华兴科技开发有限公司. All rights reserved.
//

#import "GBaseViewController.h"

@interface GBaseViewController ()

@end

@implementation GBaseViewController


//懒加载(调用懒加载一定要用self来调用)
- (NSMutableArray *)tableArray
{
    if (!_tableArray) {
        _tableArray = [NSMutableArray array];
    }
    return _tableArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    UITableView *backTableView = [[UITableView alloc] init];
    backTableView.contentInset = self.tableViewEdinsets;
    [self.view addSubview:backTableView];
    
    backTableView.frame = CGRectMake(0, -20 , self.view.frame.size.width, self.view.frame.size.height - 49);
    backTableView.showsVerticalScrollIndicator = NO;
    self.tableView = backTableView;
    backTableView.dataSource = self;
    
    _mPage = 1;
    
    [self setupRefresh];
}


// 刷新控件
- (void)setupRefresh
{
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
}

#pragma mark - 下拉刷新更新数据
- (void)loadNewData{
    _mPage = 1;
    [self.tableView.mj_header endRefreshing];
}

#pragma mark - 上拉刷新更多数据
- (void)loadMoreData{
    _mPage++;
}


#pragma mark -  写这几个方法是为了消除警告
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 40;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        [cell.textLabel setFont:[UIFont systemFontOfSize:16.0]];
        [cell.textLabel setTextColor:[UIColor blackColor]];
        
        
        cell.detailTextLabel.minimumScaleFactor = 0.6f;
        cell.detailTextLabel.adjustsFontSizeToFitWidth = YES;
        [cell.detailTextLabel setFont:[UIFont systemFontOfSize:15.0]];
        [cell.detailTextLabel setTextColor:LIGHT_BLACK_COLOR];
    }
    
    cell.textLabel.text = [NSString stringWithFormat:@"%lu",indexPath.row];
    
    return cell;
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
