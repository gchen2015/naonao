//
//  ExampleViewController.m
//  SegmentView
//
//  Created by tom.sun on 16/5/27.
//  Copyright © 2016年 tom.sun. All rights reserved.
//

#import "ExampleViewController.h"
#import "UITableView+Mascot.h"
#import "STGoodsMainViewController.h"
#import "ReGoodsCell.h"
#import "SquareLogic.h"
#import "MJRefresh.h"
#import "MagazineInfo.h"


@interface ExampleViewController ()<UITableViewDelegate, UITableViewDataSource, ReGoodsCellDelegate>

@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic, strong) NSArray *tableArray;
@property (nonatomic, copy) NSNumber *categoryId;
@property (nonatomic, copy) NSNumber *orderID;


@end

@implementation ExampleViewController


- (instancetype)initWithIndex:(NSInteger)index categoryId:(NSNumber *)categoryId orderId:(NSNumber *)orderID
{
    self = [super init];
    if (self) {
        _categoryId = categoryId;
        _orderID = orderID;
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    // Do any additional setup after loading the view.
    [self setExtraCellLineHidden:_tableView];
    
    [self searchTagsWithGoods];
}

- (void)setupUI
{
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 104) style:UITableViewStyleGrouped];
    _tableView = tableView;
    _tableView.delegate = self;
    [_tableView setBackgroundColor:[UIColor whiteColor]];
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];

    self.tableView.tableFooterView = [UIView new];
    [self.tableView setLoadedImageName:@"bird_no_order.png"];
    [self.tableView setDescriptionText:@"还没有任何消息，到别处看看吧"];
    [self.tableView setButtonText:@""];
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];

}

#pragma mark - 下拉刷新更新数据
- (void)loadNewData{
    [self.tableView.mj_header endRefreshing];
    
    [self searchTagsWithGoods];
}


//清除多余分割线
- (void)setExtraCellLineHidden:(UITableView *)tableView
{
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
}


- (void)searchTagsWithGoods
{
    __typeof (&*self) __weak weakSelf = self;
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithCapacity:0];
    [dic setObject:_categoryId forKey:@"sub_category"];
    [dic setObject:_orderID forKey:@"order_id"];
    

    // 只需一行代码，我来解放你的代码
    self.tableView.loading = YES;

    [[SquareLogic sharedInstance] searchKeywordWithGoods:dic withCallback:^(LogicResult *result) {
        if(result.statusCode == KLogicStatusSuccess)
        {
            weakSelf.tableArray = result.mObject;
            [weakSelf.tableView reloadData];
        }
        else
            [weakSelf.view makeToast:result.stateDes];

        weakSelf.tableView.loading = NO;
        [weakSelf.tableView.mj_header endRefreshing];

    }];
}


#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return _tableArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return 1;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 96;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{

    return 12;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ReGoodsCell *cell = [ReGoodsCell cellWithTableView:tableView];
    [cell setCellWithCellInfo:_tableArray[indexPath.section]];
    cell.delegate = self;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    //添加商品
    [[SquareLogic sharedInstance] setGMode:_tableArray[indexPath.section]];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"AddGoodsModeCompletionNotification" object:nil];

    [self.navigationController popViewControllerAnimated:YES];
}


- (void)imageTapped:(GoodsMode *)mode
{
    MagazineContentInfo *mcInfo = [[MagazineContentInfo alloc] init];
    mcInfo.productId = mode.mId;
    
    STGoodsMainViewController *goodsVC = [[STGoodsMainViewController alloc] init];
    goodsVC.mInfo = mcInfo;

    [self.navigationController pushViewController:goodsVC animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
