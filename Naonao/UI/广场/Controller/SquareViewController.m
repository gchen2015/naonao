//
//  SquareViewController.m
//  Naonao
//
//  Created by 刘敏 on 16/5/30.
//  Copyright © 2016年 深圳市轩腾华兴科技开发有限公司. All rights reserved.
//

#import "SquareViewController.h"
#import "AnswerViewController.h"
#import "DemandViewController.h"
#import "FigureGuideViewController.h"
#import "STNavigationController.h"
#import "SquareLogic.h"
#import "SquareCell.h"
#import "BannerCell.h"
#import "MJRefresh.h"
#import "LeftMenuView.h"
#import "DPWebViewController.h"
#import "MagazineInfo.h"


@interface SquareViewController ()<UITableViewDelegate, UITableViewDataSource, LeftMenuViewDelegate, BannerCellDelegate>

@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *tableArray;
@property (nonatomic, strong) NSArray *bannerArray;             //广告条数组

@property (nonatomic, strong) LeftMenuView *menuView;
@property (nonatomic, assign) NSUInteger mPage;

@end

@implementation SquareViewController


//懒加载(调用懒加载一定要用self来调用)
- (NSMutableArray *)tableArray
{
    if(_tableArray == nil) {
        _tableArray = [NSMutableArray array];
    }
    return _tableArray;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"UPDATE_FILTER_CONDITIONS" object:nil];
}


- (void)readCacheData{
    _bannerArray = [[SquareLogic sharedInstance] readSquareBanner];
    NSArray *tempA = [[SquareLogic sharedInstance] readSquareList];
    [self.tableArray addObjectsFromArray:tempA];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setNavBarTitle:@"问答"];
    [self setNavBarLeftBtn:nil];
    
    //更新筛选条件
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateFilterConditions) name:@"UPDATE_FILTER_CONDITIONS" object:nil];
    
    _mPage = 0;
    [self readCacheData];
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(5, 22, 64, 40)];
    [btn setImage:[UIImage imageNamed:@"filter_icon.png"] forState:UIControlStateNormal];
    [btn setTitle:@" 筛选" forState:UIControlStateNormal];
    [btn setTitleColor:BLACK_COLOR forState:UIControlStateNormal];
    [btn setTitleColor:PINK_COLOR forState:UIControlStateHighlighted];
    [btn.titleLabel setFont:[UIFont systemFontOfSize:13.0 weight:UIFontWeightLight]];
    [btn addTarget:self action:@selector(leftBtnTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self.navbar addSubview:btn];
    [self setNavBarLeftBtn:nil];
    
    [self setNavBarRightBtn:[STNavBarView createImgNaviBarBtnByImgNormal:@"add_red.png" imgHighlight:@"add_red.png" target:self action:@selector(addBtnTapped:)]];
    UITableView *tableView = [[UITableView alloc] initWithFrame:MAINSCREEN style:UITableViewStyleGrouped];
    _tableView = tableView;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    [self.view addSubview:_tableView];
    
    //校正滚动区域
    [self resetScrollView:_tableView tabBar:YES];
    [self getSquareList];
    [self setupRefresh];
}

- (void)getSquareList {
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithCapacity:0];
    [dict setObject:[NSNumber numberWithInteger:_mPage] forKey:@"start"];
    [dict setObject:[NSNumber numberWithInteger:20] forKey:@"size"];
    
    FilterData *fData = [SquareLogic sharedInstance].fData;
    NSMutableArray *temA = [NSMutableArray arrayWithCapacity:0];
    
    if (fData.category) {
        [temA addObject:[NSString stringWithFormat:@"category:%@", fData.category]];
    }
    if (fData.scene) {
        [temA addObject:[NSString stringWithFormat:@"scene:%@", fData.scene]];
    }
    if (fData.style) {
        [temA addObject:[NSString stringWithFormat:@"style:%@", fData.style]];
    }
    
    //筛选条件
    if (temA.count > 0) {
        
        NSString *st = [temA componentsJoinedByString:@"|"];
        [dict setObject:st forKey:@"filter"];
    }

    __typeof (&*self) __weak weakSelf = self;
    
    [[SquareLogic sharedInstance] getSquareList:dict withCallback:^(LogicResult *result) {
        if(result.statusCode == KLogicStatusSuccess)
        {
            if (_mPage == 0) {
                [weakSelf.tableArray removeAllObjects];
                [self.tableView.mj_footer setHidden:NO];
             }
            
            _bannerArray = (NSArray *)result.otherObject;
            
            NSArray *temA = (NSArray *)result.mObject;
            if (temA.count == 0) {
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


// 刷新控件
- (void)setupRefresh
{
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    [self.tableView.mj_footer setHidden:YES];
}


#pragma mark - 下拉刷新更新数据
- (void)loadNewData {
    [self.tableView.mj_header endRefreshing];
    _mPage = 0;
    // 发送网络请求
    [self getSquareList];
}

#pragma mark - 上拉刷新更多数据
- (void)loadMoreData {
    _mPage +=21;
    // 发送网络请求
    [self getSquareList];
}


- (void)updateTableView {
    // 马上进入刷新状态
    [self.tableView.mj_header beginRefreshing];
}


#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (_bannerArray.count > 0) {
        return 2;
    }
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_bannerArray.count > 0 && section == 0) {
        return 1;
    }
    
    // Return the number of rows in the section.
    return _tableArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 0) {
        return 10;
    }
    
    return 0.1;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_bannerArray.count > 0 && indexPath.section == 0) {
        return Aspect_Ratio*SCREEN_WIDTH;
    }
    
    return 135.0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_bannerArray.count > 0 && indexPath.section == 0) {
        BannerCell *cell = [BannerCell cellWithTableView:tableView];
        cell.delegate = self;
        [cell setCellWithCellInfo:_bannerArray];
        return cell;
    }

    SquareCell *cell = [SquareCell cellWithTableView:tableView];
    [cell setCellWithCellInfo:_tableArray[indexPath.row]];

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (![UserLogic sharedInstance].user.basic.userId) {
        [theAppDelegate popLoginView];
        return;
    }

    SquareModel *model = _tableArray[indexPath.row];
    AnswerViewController *nVC = [[AnswerViewController alloc] init];
    nVC.orderId = model.orderInfo.orderId;
    nVC.hidesBottomBarWhenPushed = YES;
    
    [self.navigationController pushViewController:nVC animated:YES];
}

- (void)leftBtnTapped:(id)sender {
    if (!_menuView)
    {
        _menuView = [[LeftMenuView alloc] initWithFrame:MAINBOUNDS];
        [_menuView setDelegate:self];
        [theAppDelegate.window addSubview:_menuView];

    }
    else{
        [_menuView setHidden:NO];
        [_menuView showView];
    }
    
    [theAppDelegate.window bringSubviewToFront:_menuView];
}


- (void)addBtnTapped:(id)sender {
    if (![UserLogic sharedInstance].user.basic.userId) {
        [theAppDelegate popLoginView];
        return;
    }
    
    //判断身材数据是否已经完善
    User *user = [[UserLogic sharedInstance] getUser];
    if (user.body) {
        DemandViewController *sVC = CREATCONTROLLER(DemandViewController);
        STNavigationController *nav = [[STNavigationController alloc] initWithRootViewController:sVC];
        [self presentViewController:nav animated:YES completion:nil];
    }
    else{
        FigureGuideViewController *sVC = CREATCONTROLLER(FigureGuideViewController);
        sVC.isPOP = YES;
        STNavigationController *nav = [[STNavigationController alloc] initWithRootViewController:sVC];
        [self presentViewController:nav animated:YES completion:nil];
    }
}


#pragma mark  BannerCellDelegate
- (void)bannerCell:(BannerCell *)myCell imageViewClicked:(NSUInteger)mRow {
    STBanInfo *sInfo = _bannerArray[mRow];
    
    DPWebViewController *dVC = [[DPWebViewController alloc] init];
    dVC.urlSting = sInfo.content;
    dVC.titName = sInfo.title;
    dVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:dVC animated:YES];
}


#pragma mark LeftMenuViewDelegate
- (void)setHideMenuView {
    [_menuView setHidden:YES];
}

//更新筛选条件
- (void)updateFilterConditions{
    _mPage = 0;
    [self getSquareList];
}

@end
