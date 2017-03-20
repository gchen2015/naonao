//
//  PraiseController.m
//  Naonao
//
//  Created by 刘敏 on 16/8/18.
//  Copyright © 2016年 深圳市轩腾华兴科技开发有限公司. All rights reserved.
//

#import "PraiseController.h"
#import "MessageCenter.h"
#import "UITableView+Mascot.h"
#import "MJRefresh.h"
#import "PraiseMessageModeFrame.h"
#import "PraiseTableViewCell.h"
#import "STMessageViewController.h"
#import "UserCenterViewController.h"

#import "AnswerViewController.h"

//#import "CommunityLogic.h"

@interface PraiseController ()<PraiseTableViewCellDelegate>

@property (nonatomic, strong) NSMutableArray *tableArray;
@property (nonatomic, assign) NSUInteger mPage;                     //页码

@end

@implementation PraiseController


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
    _mPage = 1;
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.tableFooterView = [UIView new];
    [self.tableView setLoadedImageName:@"bird_no_order.png"];
    [self.tableView setDescriptionText:@"还没有任何消息，到别处看看吧"];
    [self.tableView setButtonText:@""];
    
    [self getData];
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    
    //删除多余
    [self setExtraCellLineHidden:self.tableView];
}

//清除多余分割线
- (void)setExtraCellLineHidden:(UITableView *)tableView
{
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [self.tableView setTableFooterView:view];
}


- (void)getData{
    if (![UserLogic sharedInstance].user.basic.userId) {
        [theAppDelegate popLoginView];
        return;
    }
    
    
    __typeof (&*self) __weak weakSelf = self;
    
    // 只需一行代码，我来解放你的代码
    self.tableView.loading = YES;
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithCapacity:2];
    [dic setObject:[NSNumber numberWithInteger:_mPage] forKey:@"page_no"];
    [dic setObject:[NSNumber numberWithInteger:10] forKey:@"page_size"];
    
    //赞
    [[MessageCenter sharedInstance] getMessageCenterWithPraise:dic withCallback:^(LogicResult *result) {
        if(result.statusCode == KLogicStatusSuccess)
        {
            if (_mPage == 1) {
                [weakSelf.tableArray removeAllObjects];
                [weakSelf.tableView.mj_footer setHidden:NO];
            }
            
            [self.tableArray addObjectsFromArray:result.mObject];
            [weakSelf.tableView reloadData];
            
            NSArray *tempA = (NSArray *)result.mObject;
            if (tempA.count == 0 || tempA.count < 10) {
                //隐藏加载更多
                [weakSelf.tableView.mj_footer setHidden:YES];
            }
        }
        else
        {
            [weakSelf.view makeToast:result.stateDes];
            [weakSelf.tableView.mj_footer setHidden:YES];
        }
        
        self.tableView.loading = NO;
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    }];
}

#pragma mark - 下拉刷新更新数据
- (void)loadNewData{
    [self.tableView.mj_header endRefreshing];
    _mPage = 1;
    [self getData];
}

#pragma mark - 上拉刷新更多数据
- (void)loadMoreData{
    _mPage ++;
    // 发送网络请求
    [self getData];
    
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _tableArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    PraiseMessageModeFrame *modeFrame = _tableArray[indexPath.row];
    return modeFrame.rowHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PraiseTableViewCell *cell = [PraiseTableViewCell cellWithTableView:tableView];
    cell.modeFrame = _tableArray[indexPath.row];
    cell.delegate = self;
    return cell;
}

#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    PraiseMessageModeFrame *modeFrame = _tableArray[indexPath.row];
    AnswerViewController *nVC = [[AnswerViewController alloc] init];
    nVC.orderId = modeFrame.pMode.content.extraData.oInfo.orderInfo.orderId;
    nVC.hidesBottomBarWhenPushed = YES;
    
    [_rootVC.navigationController pushViewController:nVC animated:YES];
}

#pragma mark  - PraiseTableViewCellDelegate
- (void)nickNameTapped:(NSNumber *)userID {
    //进入个人中心页面
    UserCenterViewController *cVC = [[UserCenterViewController alloc] init];
    cVC.userId = userID;
    cVC.hidesBottomBarWhenPushed = YES;
    [_rootVC.navigationController pushViewController:cVC animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
