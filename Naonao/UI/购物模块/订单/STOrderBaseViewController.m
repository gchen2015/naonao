//
//  STOrderBaseViewController.m
//  Naonao
//
//  Created by 刘敏 on 16/3/25.
//  Copyright © 2016年 深圳市轩腾华兴科技开发有限公司. All rights reserved.
//

#import "STOrderBaseViewController.h"
#import "LogisticsInformationViewController.h"
#import "EvaluationOrderViewController.h"
#import "OrderDetailsViewController.h"
#import "ShoppingLogic.h"
#import "GoodsOrderCell.h"
#import "OrderTotalCell.h"
#import "MJRefresh.h"
#import "LXActionSheet.h"
#import "PayResultsViewController.h"
#import "Pingpp.h"
#import "OrdersViewController.h"
#import "CartStoreCell.h"
#import "PickUpDateViewController.h"

@interface STOrderBaseViewController ()<OrderTotalCellDelegate, LXActionSheetDelegate>

@property (nonatomic, assign) NSUInteger mRow;
@property (nonatomic, assign) NSUInteger mPage;

@end

@implementation STOrderBaseViewController


//懒加载
- (NSMutableArray *)tableData
{
    if(_tableData == nil) {
        _tableData = [NSMutableArray array];
    }
    return _tableData;
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    _mPage= 1;
    [self getOrderList];
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    _mPage = 1;
    self.tableView.tableFooterView = [UIView new];
    [self.tableView setLoadedImageName:@"bird_no_order.png"];
    [self.tableView setDescriptionText:@"您还没有相关的订单"];
    [self.tableView setButtonText:@""];
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
}

- (void)setRootVC:(OrdersViewController *)rootVC
{
    _rootVC = rootVC;
}

#pragma mark - 下拉刷新更新数据
- (void)loadNewData{
    [self.tableView.mj_header endRefreshing];
    _mPage = 1;
    [self getOrderList];
}

#pragma mark - 上拉刷新更多数据
- (void)loadMoreData{
    _mPage ++;
    // 发送网络请求
    [self getOrderList];
    
}

//获取订单信息
- (void)getOrderList
{
    // 只需一行代码，我来解放你的代码
    self.tableView.loading = YES;
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithCapacity:3];
    [dict setObject:[NSNumber numberWithInteger:_orderType] forKey:@"status"];
    [dict setObject:[NSNumber numberWithInteger:_mPage] forKey:@"page_no"];
    [dict setObject:[NSNumber numberWithInteger:10] forKey:@"page_size"];

    __typeof (&*self) __weak weakSelf = self;
    [[ShoppingLogic sharedInstance] getOrderList:dict withCallback:^(LogicResult *result) {
        if(result.statusCode == KLogicStatusSuccess)
        {
            if (_mPage == 1) {
                [weakSelf.tableData removeAllObjects];
                [weakSelf.tableView.mj_footer setHidden:NO];
            }
            
            [weakSelf.tableData addObjectsFromArray:result.mObject];
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

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.tableData.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    OrderModel *model = self.tableData[section];
    return model.skuList.count +2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    OrderModel *model = self.tableData[indexPath.section];
    if (indexPath.row == 0) {
        return 40.0;
    }
    if (indexPath.row == model.skuList.count + 1) {
        return 45.0;
    }
    
    return 96.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 32.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 32.0)];//创建一个视图（v_headerView）
    [bgView setBackgroundColor:[UIColor clearColor]];

    OrderModel *model = self.tableData[section];
    
    UILabel *timeL = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, SCREEN_WIDTH, 20)];
    [timeL setTextColor:LIGHT_BLACK_COLOR];
    [timeL setFont:[UIFont systemFontOfSize:13.0]];
    [timeL setText:model.createTime];
    [timeL setTextAlignment:NSTextAlignmentCenter];
    [bgView addSubview:timeL];
    
    return bgView;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    OrderModel *model = self.tableData[indexPath.section];
    
    if (indexPath.row == 0)
    {
        CartStoreCell *cell = [CartStoreCell cellWithTableView:tableView];
        SKUOrderModel *mInfo = model.skuList[0];
        [cell setCellWithCellOrderInfo:mInfo.store];

        return cell;
    }
    
    if (indexPath.row == model.skuList.count + 1) {
        OrderTotalCell *tCell = [OrderTotalCell cellWithTableView:tableView];
        [tCell setCellWithOrderTotalCellInfo:model];
        tCell.lineNO = indexPath.section;
        [tCell setDelegate:self];
        
        return tCell;
    }

    
    GoodsOrderCell * mCell = [GoodsOrderCell cellWithTableView:tableView];
    SKUOrderModel *sModel = model.skuList[indexPath.row-1];
    [mCell setCellWithOrderCellInfo:sModel];
    
    return mCell;

}

#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    OrderModel *model = self.tableData[indexPath.section];
    //返回订单号
    [self jumpToOrderDetailsViewController:model.orderId];
}


#pragma mark - OrderTotalCellDelegate
- (void)orderTotalCellWithbuttonType:(OrderBtnType)btnType cellWithOrderID:(OrderModel *)oData lineNO:(NSUInteger)lineNO
{
    _mRow = lineNO;
    
    switch (btnType) {
        case K_ORDER_PAY:
        {
            //支付
            LXActionSheet *actionSheet = [[LXActionSheet alloc] initWithTitle:@"选择支付方式" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@[@"支付宝", @"微信支付"]];
            [actionSheet showInView:theAppDelegate.window];
        }
            break;
            
        case K_ORDER_DELETE:
            //删除订单
            [self deleteOrder:oData.orderId];
            break;
            
        case K_ORDER_GOODS:
            //确认收货
            [self acceptGoods:oData.orderId];
            break;
            
        case K_ORDER_EVALUATION:
            //评价
            [self commentGoods];
            break;
            
        case K_ORDER_CANCEL:
            //取消订单
            [self cancelOrder:oData.orderId];
            break;
            
        case K_ORDER_LOGISTICS:
            //查看物流
            [self checkLogistics:oData.orderId];
            break;
            
        default:
            break;
    }
}


#pragma mark - 执行操作
//确定收货
- (void)acceptGoods:(NSNumber *)orderID
{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithCapacity:1];
    [dict setObject:orderID forKey:@"order_id"];
    
    __typeof (&*self) __weak weakSelf = self;
    
    [[ShoppingLogic sharedInstance] signOrder:dict withCallback:^(LogicResult *result) {
        if(result.statusCode == KLogicStatusSuccess)
        {
            [weakSelf getOrderList];
            [theAppDelegate.window makeToast:@"签收成功"];
        }
        else
            [weakSelf.view makeToast:result.stateDes];
    }];
}


// 取消订单
- (void)cancelOrder:(NSNumber *)orderID
{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithCapacity:1];
    [dict setObject:orderID forKey:@"order_id"];
    
    __typeof (&*self) __weak weakSelf = self;
    
    [[ShoppingLogic sharedInstance] cancelOrder:dict withCallback:^(LogicResult *result) {
        if(result.statusCode == KLogicStatusSuccess)
        {
            [weakSelf getOrderList];
        }
        else
            [weakSelf.view makeToast:result.stateDes];
    }];
}

// 删除订单
- (void)deleteOrder:(NSNumber *)orderID
{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithCapacity:1];
    [dict setObject:orderID forKey:@"order_id"];
    
    __typeof (&*self) __weak weakSelf = self;
    
    [[ShoppingLogic sharedInstance] deleteOrder:dict withCallback:^(LogicResult *result) {
        if(result.statusCode == KLogicStatusSuccess)
        {
            [weakSelf getOrderList];
        }
        else
            [weakSelf.view makeToast:result.stateDes];
    }];
}

//查看物流
- (void)checkLogistics:(NSNumber *)orderID
{
    LogisticsInformationViewController *loVC = [[LogisticsInformationViewController alloc] init];
    loVC.orderID = orderID;
    [_rootVC.navigationController pushViewController:loVC animated:YES];
}

//发表评价
- (void)commentGoods
{
    OrderModel *model = self.tableData[_mRow];
    
    OrderDetails *gData = [[OrderDetails alloc] init];
    gData.order_id =  model.orderId;
    gData.skuList = model.skuList;
    
    EvaluationOrderViewController *eVC = [[EvaluationOrderViewController alloc] init];
    eVC.gData = gData;
    [_rootVC.navigationController pushViewController:eVC animated:YES];
}

//进入订单详情页
- (void)jumpToOrderDetailsViewController:(NSNumber *)orderID
{
    OrderDetailsViewController *oVC = [[OrderDetailsViewController alloc] init];
    oVC.orderID = orderID;
    oVC.mType = KCommom;
    [_rootVC.navigationController pushViewController:oVC animated:YES];
}


#pragma mark - LXActionSheetDelegate
- (void)actionSheet:(LXActionSheet *)mActionSheet didClickOnButtonIndex:(int)buttonIndex
{
    
    if (![ShoppingLogic sharedInstance].orderData) {
        [ShoppingLogic sharedInstance].orderData = [[OrderData alloc] init];
    }
    
    OrderModel *model = self.tableData[_mRow];
    [ShoppingLogic sharedInstance].orderData.order_id = model.orderId;
    
    switch (buttonIndex) {
        case 0:
            //支付宝
            [self generatePreparePaymentOrder:KPaymentChannel_Alipay];
            break;
            
        case 1:
            [self generatePreparePaymentOrder:KPaymentChannel_WechatPay];
            break;
            
        default:
            break;
    }
}


#pragma mark - 执行事件
//生成预付款订单
- (void)generatePreparePaymentOrder:(PaymentChannel)payChannel
{
    [theAppDelegate.HUDManager showTip:nil];
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithCapacity:0];
    [dic setObject:[NSNumber numberWithInteger:payChannel] forKey:@"channel"];
    
    __typeof (&*self) __weak weakSelf = self;
    
    [[ShoppingLogic sharedInstance] getGeneratePreparePaymentOrder:dic withCallback:^(LogicResult *result) {
        
        if(result.statusCode == KLogicStatusSuccess)
        {
            [weakSelf payment:result.mObject];
        }
        else
        {
            [weakSelf.view makeToast:result.stateDes];
        }
        
        [theAppDelegate.HUDManager hideHUD];
    }];
}

//支付
- (void)payment:(NSObject *)charge
{
    [theAppDelegate.HUDManager hideHUD];
    __typeof (&*self) __weak weakSelf = self;
    
    [Pingpp createPayment:charge
           viewController:self
             appURLScheme:MY_APP_URL
           withCompletion:^(NSString *result, PingppError *error) {
               if ([result isEqualToString:@"success"]) {
                   // 支付成功
                   [weakSelf successState];
               } else {
                   [weakSelf.view makeToast:error.getMsg];
               }
           }];
}


- (void)successState
{
    OrderModel *model = self.tableData[_mRow];
    SKUOrderModel *mInfo = model.skuList[0];
    
    if ([mInfo.store.canTry boolValue]){
        
        //进入预约界面（前提是该商家支持到店取，并且用户也选择了到店取）
        PickUpDateViewController *pVC = [[PickUpDateViewController alloc] init];
        pVC.orderId = [ShoppingLogic sharedInstance].orderData.order_id;
        
        [_rootVC.navigationController pushViewController:pVC animated:YES];
    }
    else{
        PayResultsViewController *pVC = [[PayResultsViewController alloc] init];
        pVC.orderID = model.orderId;
        [_rootVC.navigationController pushViewController:pVC animated:YES];
    }
}


@end
