//
//  AnswerViewController.m
//  Naonao
//
//  Created by 刘敏 on 16/6/1.
//  Copyright © 2016年 深圳市轩腾华兴科技开发有限公司. All rights reserved.
//

#import "AnswerViewController.h"
#import "DPWebViewController.h"
#import "STGoodsMainViewController.h"
#import "UserCenterViewController.h"
#import "STPhotoBrowserViewController.h"
#import "DPWebViewController.h"
#import "STReplyViewController.h"
#import "STNavigationController.h"
#import "AnCommentsViewController.h"
#import "AnswerFirstCell.h"
#import "SquareLogic.h"
#import "RobotCell.h"
#import "AnswerGoodsCell.h"
#import "MJRefresh.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "AnswerFirstModeFrame.h"
#import "UserCenterViewController.h"


@interface AnswerViewController ()<UITableViewDelegate, UITableViewDataSource, PGoodsViewDelegate, AnswerFirstCellDelegate, PAboveViewDelegate, RobotCellDelegate, PCenterViewDelegate, STPhotoBrowserViewControllerDelegate, STPhotoBrowserViewControllerDataSource, AnswerToolbarViewDelegate, AnswerCommentsViewDelegate>

@property (nonatomic, strong) AnswerFirstModeFrame *anModeFrame;

@property (nonatomic, strong) SquareModel *sInfo;

@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic, strong) NSArray *robotArray;          //系统推荐
@property (nonatomic, strong) NSMutableArray *tableArray;

@property (nonatomic, strong) NSArray *links;

@property (nonatomic, assign) NSUInteger mSection;

@end


@implementation AnswerViewController


#pragma mark - 注册消息事件
- (void)initNotionCenter{
    //添加了商品（真实发送完成）
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updateTableView:)
                                                 name:@"AddAnswerCompletionNotification"
                                               object:nil];
    
    //添加了商品（模拟）
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(simulationAddAnswer:)
                                                 name:@"SimulationAddAnswerCompletionNotification"
                                               object:nil];
    
    //成功添加评论
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(successAddComments:)
                                                 name:@"SuccessAddCommentsNotification"
                                               object:nil];
}


- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"AddAnswerCompletionNotification" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"SimulationAddAnswerCompletionNotification" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"SuccessAddCommentsNotification" object:nil];
}




- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    if(_tableArray == nil) {
        _tableArray = [NSMutableArray array];
    }
    
    _mSection = 0;
    

    UITableView *tableView = [[UITableView alloc] initWithFrame:MAINSCREEN style:UITableViewStyleGrouped];
    _tableView = tableView;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    
    //校正滚动区域
    [self resetScrollView:_tableView tabBar:NO];

    [self getBasic];

    [self setupRefresh];
    
    [self initNotionCenter];
}

- (void)initializeTitle{
    
    UIView *mV = [[UIView alloc] initWithFrame:CGRectZero];
    [mV setBackgroundColor:[UIColor clearColor]];
    
    UIImageView *headV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 1, 28, 28)];
    [headV sd_setImageWithURL:[NSURL URLWithString:[_sInfo.userInfo.avatar smallHead]]  placeholderImage:[UIImage imageNamed:@"default_avatar_large.png"]];
    //圆角
    headV.layer.cornerRadius = CGRectGetWidth(headV.frame)/2;                     //设置那个圆角的有多圆
    headV.layer.borderWidth = 0.5;
    headV.layer.borderColor = LIGHT_BLACK_COLOR.CGColor;
    headV.layer.masksToBounds = YES;                  //设为NO去试试
    [mV addSubview:headV];
    
    UILabel *nickL = [[UILabel alloc] initWithFrame:CGRectZero];
    [nickL setText:_sInfo.userInfo.nickname];
    [nickL setTextColor:BLACK_COLOR];
    [nickL setFont:[UIFont boldSystemFontOfSize:15.0]];
    //计算文字宽度
    [mV addSubview:nickL];
    CGSize size = [_sInfo.userInfo.nickname sizeWithAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:15.0]}];
    [nickL setFrame:CGRectMake(CGRectGetWidth(headV.frame)+10, 0, size.width, 30)];
    
    [mV setFrame:CGRectMake((SCREEN_WIDTH - CGRectGetMaxX(nickL.frame))/2, 27, CGRectGetMaxX(nickL.frame), 30)];
    
    //添加点击事件
    mV.userInteractionEnabled = YES;
    UITapGestureRecognizer *labelTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                                action:@selector(labelTouchUpInside:)];
    [mV addGestureRecognizer:labelTapGestureRecognizer];
    
    [self.navbar addSubview:mV];
    
}

- (void)labelTouchUpInside:(UITapGestureRecognizer *)recognizer{
    // 进入用户详情页
    UserCenterViewController *cVC = [[UserCenterViewController alloc] init];
    cVC.userId = _sInfo.userInfo.userId;
    [self.navigationController pushViewController:cVC animated:YES];
    
}

// 刷新控件
- (void)setupRefresh
{
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
}

#pragma mark - 下拉刷新更新数据
- (void)loadNewData{
    [_tableArray removeAllObjects];
    // 发送网络请求
    [self getRobotAnswerList];
}

- (void)getBasic
{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithCapacity:1];
    //订单ID
    [dic setObject:_orderId forKey:@"order_id"];
    
    __typeof (&*self) __weak weakSelf = self;
    [[SquareLogic sharedInstance] getSquareBasic:dic withCallback:^(LogicResult *result) {
        if(result.statusCode == KLogicStatusSuccess)
        {
            weakSelf.sInfo = result.mObject;
            weakSelf.anModeFrame = [[AnswerFirstModeFrame alloc] init];
            weakSelf.anModeFrame.sModel = _sInfo;
            [weakSelf.tableView reloadData];
            
            [weakSelf getRobotAnswerList];
            [weakSelf initializeTitle];
        }
        else
            [weakSelf.view makeToast:result.stateDes];
        
        [self.tableView.mj_header endRefreshing];
    }];
}

//获取系统回应
- (void)getRobotAnswerList
{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithCapacity:1];
    //订单ID
    [dic setObject:_orderId forKey:@"orderid"];
    
    __typeof (&*self) __weak weakSelf = self;
    
    [[SquareLogic sharedInstance] getPublishRobotAnswerList:dic withCallback:^(LogicResult *result) {
        if(result.statusCode == KLogicStatusSuccess)
        {
            weakSelf.robotArray = result.mObject;
            
            [weakSelf.tableView reloadData];
            [weakSelf getDuozhuAnswerList];
        }
        else
            [weakSelf.view makeToast:result.stateDes];
        
        [self.tableView.mj_header endRefreshing];
        
    }];
}


//获取舵主的推荐
- (void)getDuozhuAnswerList{
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithCapacity:1];
    //订单ID
    [dic setObject:_orderId forKey:@"order_id"];
    
    __typeof (&*self) __weak weakSelf = self;
    
    [[SquareLogic sharedInstance] getAnswerList:dic withCallback:^(LogicResult *result) {
        if(result.statusCode == KLogicStatusSuccess)
        {
            if ([result.mObject count] > 0) {
                [_tableArray addObjectsFromArray:result.mObject];
                [weakSelf.tableView reloadData];
                
                //滚动到固定位置
                [weakSelf.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:_mSection] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
            }
        }
        else
            [weakSelf.view makeToast:result.stateDes];
        
        [self.tableView.mj_header endRefreshing];
        
    }];
    
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    if(_sInfo){
        if (_robotArray.count > 0) {
            return 2 + _tableArray.count;
        }
        
        return 1 + _tableArray.count;
    }
    
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 12.0;
}

#pragma mark - Table view data source
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return _anModeFrame.rowHeight;
    }
    else if(indexPath.section == 1)
    {
        return 270;
    }
    else
    {
        if(!_tableArray || _tableArray.count == 0){
            return 0;
        }

        AnswerModeFrame *aFrame = _tableArray[indexPath.section-2];
        return aFrame.rowHeight;
    }

    return 0;
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        AnswerFirstCell *cell = [AnswerFirstCell cellWithTableView:tableView];
        cell.delegate = self;
        cell.anModeFrame = _anModeFrame;
        return cell;
    }
    else if (indexPath.section == 1)
    {
        RobotCell *cell = [RobotCell cellWithTableView:tableView];
        [cell setCellWithCellInfo:_robotArray];
        cell.delegate = self;
        
        return cell;
    }
    else
    {
        if(!_tableArray || _tableArray.count == 0){
            static NSString *CellIdentifier = @"Photos";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            
            if(cell == nil)
            {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            }
            
            return cell;
        }

        AnswerGoodsCell *cell = [AnswerGoodsCell cellWithTableView:tableView];
        AnswerModeFrame *aFrame = _tableArray[indexPath.section-2];
        cell.anFrame = aFrame;
        cell.anFrame.index = indexPath.section-2;
        cell.goodsView.delegate = self;
        cell.centerView.delegate = self;
        cell.aboveView.delegate = self;
        cell.commentView.delegate = self;
        cell.toolbar.delegate = self;
        return cell;
    }
    
    return nil;
}

#pragma mark -PGoodsViewDelegate
//购买按钮点击
- (void)pGoodsView:(PGoodsView *)pView buttonWithIndex:(NSUInteger)index
{
    if([_tableArray[index] isKindOfClass:[ProductModeFrame class]]){
        
        ProductModeFrame *aFrame = _tableArray[index];
        
        if (aFrame.pData.sourceType == 1) {
            //淘宝
            DPWebViewController *dVC = [[DPWebViewController alloc] init];
            dVC.urlSting = aFrame.pData.website;
            dVC.titName = aFrame.pData.wrapTitle;
            
            [self.navigationController pushViewController:dVC animated:YES];
        }
        else if(aFrame.pData.sourceType == 0)
        {
            //自营
            MagazineContentInfo *mcInfo = [[MagazineContentInfo alloc] init];
            mcInfo.productId = aFrame.pData.productId;
            mcInfo.coverUrl = aFrame.pData.imgurl;
            
            
            STGoodsMainViewController *goodsVC = [[STGoodsMainViewController alloc] init];
            goodsVC.mInfo = mcInfo;
            goodsVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:goodsVC animated:YES];
        }
    }
    else if([_tableArray[index] isKindOfClass:[AnswerModeFrame class]]){
        
        AnswerModeFrame *aFrame = _tableArray[index];
        //自营
        MagazineContentInfo *mcInfo = [[MagazineContentInfo alloc] init];
        mcInfo.productId = aFrame.aMode.proData.mId;
        mcInfo.coverUrl = aFrame.aMode.proData.img;
        
        
        STGoodsMainViewController *goodsVC = [[STGoodsMainViewController alloc] init];
        goodsVC.mInfo = mcInfo;
        //记录返现
        goodsVC.re_userId = aFrame.aMode.userInfo.userId;
        
        [self.navigationController pushViewController:goodsVC animated:YES];
    }
}


#pragma mark -RobotCellDelegate
//点击商品图片购买
- (void)robotCell:(RobotCell *)cell buttonWithData:(RecommandDAO *)rDAO {

    if (rDAO.sourceType == 1) {
        //淘宝
        DPWebViewController *dVC = [[DPWebViewController alloc] init];
        dVC.urlSting = rDAO.website;
        dVC.titName = rDAO.wrapTitle;
        
        [self.navigationController pushViewController:dVC animated:YES];
    }
    else if(rDAO.sourceType == 0)
    {
        //自营
        MagazineContentInfo *mcInfo = [[MagazineContentInfo alloc] init];
        mcInfo.productId = rDAO.productId;
        mcInfo.coverUrl = rDAO.imgurl;
        
        
        STGoodsMainViewController *goodsVC = [[STGoodsMainViewController alloc] init];
        goodsVC.mInfo = mcInfo;
        goodsVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:goodsVC animated:YES];
    }
}


#pragma mark -AnswerFirstCellDelegate
//添加答案
- (void)jumpToSearchView
{
    STReplyViewController *vc = [[STReplyViewController alloc] init];
    vc.orderInfo = _sInfo.orderInfo;
    STNavigationController *nav = [[STNavigationController alloc] initWithRootViewController:vc];
    [self presentViewController:nav animated:YES completion:nil];
}


- (void)headTapped
{
    //进入个人中心页面
    UserCenterViewController *cVC = [[UserCenterViewController alloc] init];
    cVC.userId = _sInfo.userInfo.userId;
    [self.navigationController pushViewController:cVC animated:YES];
}

//点击头像
- (void)pAboveView:(PAboveView *)pView headWithIndex:(NSUInteger)index {
    NSNumber *userId;
    if([_tableArray[index] isKindOfClass:[ProductModeFrame class]]){
        ProductModeFrame *aFrame = _tableArray[index];
        userId = aFrame.pData.duozhu.userId;
    }
    else if([_tableArray[index] isKindOfClass:[AnswerModeFrame class]]){
        
        AnswerModeFrame *aFrame = _tableArray[index];
        userId = aFrame.aMode.userInfo.userId;

    }
    
    //进入个人中心页面
    UserCenterViewController *cVC = [[UserCenterViewController alloc] init];
    cVC.userId = userId;
    [self.navigationController pushViewController:cVC animated:YES];
}

#pragma mark -PCenterViewDelegate
- (void)pCenterView:(PCenterView *)mView didSelectItemAtIndexPath:(NSIndexPath *)indexPath imageArray:(NSArray *)images{
    
    NSMutableArray *temA = [[NSMutableArray alloc] initWithCapacity:images.count];
    
    for (NSString *image in images) {
        STBrowserPhoto *photo = [[STBrowserPhoto alloc] init];
        photo.photoURL = [NSURL URLWithString:[image originalImageTurnWebp]];
        [temA addObject:photo];
    }
    
    _links = temA;
    
    STPhotoBrowserViewController *broswerVC = [[STPhotoBrowserViewController alloc] init];
    broswerVC.delegate = self;
    broswerVC.dataSource = self;
    broswerVC.showType = STShowImageTypeImageURL;
    // 当前选中的值
    broswerVC.currentIndexPath = indexPath;
    
    [self.navigationController pushViewController:broswerVC animated:YES];
}

#pragma mark - STPhotoBrowserViewControllerDataSource
- (NSInteger)numberOfSectionInPhotosInPickerBrowser:(STPhotoBrowserViewController *)pickerBrowser{
    return 1;
}

- (NSInteger)photoBrowser:(STPhotoBrowserViewController *)photoBrowser numberOfItemsInSection:(NSUInteger)section{
    return self.links.count;
}

- (STBrowserPhoto *)photoBrowser:(STPhotoBrowserViewController *)pickerBrowser photoAtIndexPath:(NSIndexPath *)indexPath
{
    return [self.links objectAtIndex:indexPath.item];
}

#pragma mark -AnswerToolbarViewDelegate
//进入评论列表
- (void)answerToolsbarView:(AnswerToolbarView *)answerToolsbarView answerMode:(AnswerMode *)aMode index:(NSUInteger)mRow{
    //记录row
    _mSection = mRow +1;
    
    AnCommentsViewController *aVC = [[AnCommentsViewController alloc] init];
    aVC.aMode = aMode;
    aVC.orderID = _sInfo.orderInfo.orderId;
    [self.navigationController pushViewController:aVC animated:YES];
}

#pragma mark  -AnswerCommentsViewDelegate
// 点击用户昵称
- (void)answerCommentsView:(AnswerCommentsView *)answerCommentsView WithUserId:(NSNumber *)userId {
    //进入个人中心页面
    UserCenterViewController *cVC = [[UserCenterViewController alloc] init];
    cVC.userId = userId;
    [self.navigationController pushViewController:cVC animated:YES];
}

//进入评论列表
- (void)answerCommentsView:(AnswerCommentsView *)answerCommentsView answerMode:(AnswerMode *)aMode index:(NSUInteger)mRow {
    //记录row
    _mSection = mRow +1;
    
    AnCommentsViewController *aVC = [[AnCommentsViewController alloc] init];
    aVC.aMode = aMode;
    [self.navigationController pushViewController:aVC animated:YES];
}

//添加答案完成
- (void)updateTableView:(NSNotification *)notification {
    //延迟执行
    double delayInSeconds = 0.5;
    __typeof (&*self) __weak weakSelf = self;
    
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        
        //马上进入刷新状态
        [weakSelf loadNewData];
    });
    
}

//模拟添加答案
- (void)simulationAddAnswer:(NSNotification *)notification {
    
    _mSection = 0;
    //延迟执行
    double delayInSeconds = 0.5;
    __typeof (&*self) __weak weakSelf = self;
    
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        AnswerModeFrame *anFrame = notification.object;
        [weakSelf.tableArray addObject:anFrame];
        [weakSelf.tableView reloadData];
    });
}




- (void)successAddComments:(NSNotification *)notification {
    //延迟执行
    double delayInSeconds = 0.3;
    __typeof (&*self) __weak weakSelf = self;
    
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        
        //马上进入刷新状态
        [_tableArray removeAllObjects];
        
        // 发送网络请求
        [weakSelf getRobotAnswerList];
        

    });
}


@end
