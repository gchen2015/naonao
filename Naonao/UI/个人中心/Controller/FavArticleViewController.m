//
//  FavArticleViewController.m
//  Naonao
//
//  Created by 刘敏 on 16/8/1.
//  Copyright © 2016年 深圳市轩腾华兴科技开发有限公司. All rights reserved.
//

#import "FavArticleViewController.h"
#import "FavoritesViewController.h"
#import "MJRefresh.h"
#import "MagazineLogic.h"
#import "UserLogic.h"
#import "FavArticleCell.h"
#import "ArticleViewController.h"

@interface FavArticleViewController ()

@property (nonatomic, strong) NSMutableArray *tableArray;

@end

@implementation FavArticleViewController

#pragma mark - 懒加载
- (NSMutableArray *)tableArray
{
    if (!_tableArray) {
        self.tableArray = [NSMutableArray array];
    }
    return _tableArray;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self getData];
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
    [self getData];
}


- (void)getData
{
    __typeof (&*self) __weak weakSelf = self;
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithCapacity:1];
    User *user = [[UserLogic sharedInstance] getUser];
    [dict setObject:user.basic.userId forKey:@"userid"];
    
    [[MagazineLogic sharedInstance] favorArticleList:dict withCallback:^(LogicResult *result) {
        if(result.statusCode == KLogicStatusSuccess)
        {
            [weakSelf.tableArray removeAllObjects];
            
            [weakSelf.tableArray addObjectsFromArray:result.mObject];
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

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == _tableArray.count - 1) {
        return 10;
    }
    
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return (SCREEN_WIDTH-30) * 0.46 +45;
}

 - (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
     FavArticleCell *cell = [FavArticleCell cellWithTableView:tableView];
     [cell setCellWithCellInfo:_tableArray[indexPath.section]];

     return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    MagazineInfo *topic = self.tableArray[indexPath.row];
    if ([topic.type integerValue] == 1) {
        ArticleViewController *dVC = [[ArticleViewController alloc] init];
        dVC.hidesBottomBarWhenPushed = YES;
        dVC.urlSting = topic.content;
        dVC.titName = topic.title;
        dVC.mInfo = topic;
        [_rootVC.navigationController pushViewController:dVC animated:YES];
    }
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
