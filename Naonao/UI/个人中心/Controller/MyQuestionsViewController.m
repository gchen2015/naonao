//
//  MyQuestionsViewController.m
//  Naonao
//
//  Created by 刘敏 on 16/8/1.
//  Copyright © 2016年 深圳市轩腾华兴科技开发有限公司. All rights reserved.
//

#import "MyQuestionsViewController.h"
#import "UITableView+Mascot.h"
#import "SquareLogic.h"
#import "MyQuestionCell.h"
#import "AnswerViewController.h"
#import "MLEmojiLabel.h"
#import "MJRefresh.h"


@interface MyQuestionsViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *tableArray;

@end

@implementation MyQuestionsViewController

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
    // Do any additional setup after loading the view.
    [self setNavBarTitle:@"我的提问"];
    [self setNavBarRightBtn:[STNavBarView createNormalNaviBarBtnByTitle:@"编辑" target:self action:@selector(editTapped:)]];

    UITableView *tableView = [[UITableView alloc] initWithFrame:MAINSCREEN style:UITableViewStyleGrouped];
    _tableView = tableView;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];

    //校正滚动区域
    [self resetScrollView:_tableView tabBar:NO];

    [self getSquareList];


    self.tableView.tableFooterView = [UIView new];
    [self.tableView setLoadedImageName:@"bird_no_order.png"];
    [self.tableView setDescriptionText:@"还没有任何消息，到别处看看吧"];
    [self.tableView setButtonText:@""];
    
    [self setupRefresh];
}

// 刷新控件
- (void)setupRefresh
{
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
}

#pragma mark - 下拉刷新更新数据
- (void)loadNewData{
    //    _mPage = 1;
    
    [self.tableView.mj_header endRefreshing];
    [self getSquareList];
}


- (void)editTapped:(UIButton *)sender
{
    sender.selected = !sender.selected;
    if (sender.selected) {
        [self.tableView setEditing:YES animated:YES];
        [sender setTitle:@"完成" forState:UIControlStateNormal];
    }
    else {
        [self.tableView setEditing:NO animated:YES];
        [sender setTitle:@"编辑" forState:UIControlStateNormal];
    }
}

- (void)getSquareList
{
    // 只需一行代码，我来解放你的代码
    self.tableView.loading = YES;
    
    __typeof (&*self) __weak weakSelf = self;
    
    [[SquareLogic sharedInstance] getMyOrders:nil withCallback:^(LogicResult *result) {
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
        
        [weakSelf.tableView.mj_header endRefreshing];
        weakSelf.tableView.loading = NO;
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
    return 15;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SquareModel *oInfo = [self.tableArray objectAtIndex:indexPath.section];
    
    MLEmojiLabel *contentL = [[MLEmojiLabel alloc] initWithFrame:CGRectZero];
    contentL.numberOfLines = 0;
    [contentL setFont:[UIFont systemFontOfSize:16.0 weight:UIFontWeightMedium]];
    contentL.lineBreakMode = NSLineBreakByWordWrapping|NSLineBreakByTruncatingTail;
    
    [contentL setText:oInfo.orderInfo.content];
    CGSize mSize = [contentL preferredSizeWithMaxWidth:(SCREEN_WIDTH - 54)];
    
    return mSize.height + 78.5f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MyQuestionCell *cell = [MyQuestionCell cellWithTableView:tableView];
    [cell setCellWithCellInfo:_tableArray[indexPath.section]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    SquareModel *oInfo = [self.tableArray objectAtIndex:indexPath.section];
    AnswerViewController *nVC = [[AnswerViewController alloc] init];
    nVC.orderId = oInfo.orderInfo.orderId;
    nVC.hidesBottomBarWhenPushed = YES;
    
    [self.navigationController pushViewController:nVC animated:YES];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self deleteCellWithTableView:_tableArray[indexPath.section] didSelectRowAtIndexPath:indexPath];
    }
}

- (void)deleteCellWithTableView:(SquareModel *)model didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithCapacity:1];
    
    [dic setObject:model.orderInfo.orderId forKey:@"orderid"];
    
    __typeof (&*self) __weak weakSelf = self;
    
    // 只需一行代码，我来解放你的代码
    self.tableView.loading = YES;
    
    [[SquareLogic sharedInstance] getDeleteOrder:dic withCallback:^(LogicResult *result) {
        if(result.statusCode == KLogicStatusSuccess)
        {
            [weakSelf.tableArray removeObjectAtIndex:indexPath.section];
            [weakSelf.tableView reloadData];
        }
        else
        {
            [weakSelf.view makeToast:result.stateDes];
        }
        
        self.tableView.loading = NO;
    }];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
