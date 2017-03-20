//
//  FavAnswerViewController.m
//  Naonao
//
//  Created by 刘敏 on 16/7/29.
//  Copyright © 2016年 深圳市轩腾华兴科技开发有限公司. All rights reserved.
//

#import "FavAnswerViewController.h"
#import "AnswerViewController.h"
#import "FavoritesViewController.h"
#import "SquareLogic.h"
#import "MJRefresh.h"
#import "MyQuestionCell.h"
#import "MLEmojiLabel.h"


@interface FavAnswerViewController ()
@property (nonatomic, strong) NSMutableArray *tableArray;         
@end

@implementation FavAnswerViewController


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
    
    [[SquareLogic sharedInstance] getCareAnswers:nil withCallback:^(LogicResult *result) {
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    SquareModel *oInfo = [self.tableArray objectAtIndex:indexPath.section];
    
    MLEmojiLabel *contentL = [[MLEmojiLabel alloc] initWithFrame:CGRectZero];
    contentL.numberOfLines = 0;
    [contentL setFont:[UIFont systemFontOfSize:16.0 weight:UIFontWeightMedium]];
    contentL.lineBreakMode = NSLineBreakByWordWrapping|NSLineBreakByTruncatingTail;
    
    [contentL setText:oInfo.orderInfo.content];
    CGSize mSize = [contentL preferredSizeWithMaxWidth:(SCREEN_WIDTH - 54)];
    
    return mSize.height + 82.5f;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MyQuestionCell *cell = [MyQuestionCell cellWithTableView:tableView];
    [cell setCellWithCellData:_tableArray[indexPath.section]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    SquareModel *model = _tableArray[indexPath.section];
    AnswerViewController *nVC = [[AnswerViewController alloc] init];
    nVC.orderId = model.orderInfo.orderId;
    nVC.hidesBottomBarWhenPushed = YES;
    
    [_rootVC.navigationController pushViewController:nVC animated:YES];
}

@end
