//
//  STGoodsCommentsViewController.m
//  Naonao
//
//  Created by 刘敏 on 16/5/4.
//  Copyright © 2016年 深圳市轩腾华兴科技开发有限公司. All rights reserved.
//

#import "STGoodsCommentsViewController.h"
#import "ShoppingLogic.h"
#import "GoodsCommentsCell.h"
#import "CommentsModelFrame.h"
#import "MJRefresh.h"
#import "UserCenterViewController.h"


@interface STGoodsCommentsViewController ()<UITableViewDataSource, UITableViewDelegate, CommentsProductCellDelegate>

@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *tableArray;

@property (nonatomic, assign) NSUInteger mPage;

@end


@implementation STGoodsCommentsViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:NO];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setNavBarTitle:@"评论"];
    
    if (!_tableArray) {
        self.tableArray = [NSMutableArray array];
    }
    
    _mPage = 1;
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:MAINSCREEN style:UITableViewStylePlain];
    _tableView = tableView;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    [self.view addSubview:_tableView];
    
    [self resetScrollView:self.tableView tabBar:NO];
    
    [self setExtraCellLineHidden:_tableView];
    [self setupRefresh];
    
    [self getProductComments];
}


//清除多余分割线
- (void)setExtraCellLineHidden:(UITableView *)tableView
{
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [self.tableView setTableFooterView:view];
}


// 刷新控件
- (void)setupRefresh
{
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    //    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
}


#pragma mark - 下拉刷新更新数据
- (void)loadNewData{
    _mPage = 1;
    // 发送网络请求
    [self getProductComments];
}

#pragma mark - 上拉刷新更多数据
- (void)loadMoreData{
    _mPage++;
    // 发送网络请求
    [self getProductComments];
    
}


- (void)getProductComments
{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithCapacity:1];
    [dic setObject:_productID forKey:@"product_id"];
    __typeof (&*self) __weak weakSelf = self;
    
    [[ShoppingLogic sharedInstance] getProductCommentsList:dic withCallback:^(LogicResult *result) {
        
        [self.tableView.mj_header endRefreshing];
        
        if(result.statusCode == KLogicStatusSuccess)
        {
            if (_mPage == 1) {
                [weakSelf.tableArray removeAllObjects];
            }
            
            [_tableArray removeAllObjects];
            [_tableArray addObjectsFromArray:result.mObject];
            [_tableView reloadData];
        }
        else
            [weakSelf.view makeToast:result.stateDes];
    }];

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return _tableArray.count;
}

#pragma mark - Table view data source
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CommentsProductFrame *comFrame = _tableArray[indexPath.row];
    return comFrame.rowHeight ;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CommentsProductCell *cell = [CommentsProductCell cellWithTableView:tableView];
    CommentsProductFrame *comFrame = _tableArray[indexPath.row];
    cell.comFrame = comFrame;
    cell.delegate = self;
    
    return cell;
}


#pragma mark - CommentsProductCellDelegate
//进入个人中心
- (void)commentsProductCell:(CommentsProductCell *)cell tappedWithUserInfo:(CommentInfo *)tData
{
    UserCenterViewController *cVC = [[UserCenterViewController alloc] init];
    cVC.userId = tData.userId;
    [self.navigationController pushViewController:cVC animated:YES];
}


@end
