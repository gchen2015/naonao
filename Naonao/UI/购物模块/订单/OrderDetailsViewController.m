//
//  OrderDetailsViewController.m
//  Naonao
//
//  Created by 刘敏 on 16/3/14.
//  Copyright © 2016年 深圳市轩腾华兴科技开发有限公司. All rights reserved.
//

#import "OrderDetailsViewController.h"
#import "PayResultsViewController.h"
#import "EvaluationOrderViewController.h"
#import "LogisticsInformationViewController.h"
#import "ShoppingLogic.h"
#import "OrderStateCell.h"
#import "GoodsOData.h"
#import "AddressCell.h"
#import "OrderAffiliatedCell.h"
#import "GoodsOrderCell.h"
#import "OrderInstructionsCell.h"
#import "Pingpp.h"
#import "LXActionSheet.h"
#import "PickUpDateViewController.h"
#import "CartStoreCell.h"


@interface OrderDetailsViewController ()<UITableViewDelegate, UITableViewDataSource, LXActionSheetDelegate>

@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic, strong) OrderDetails *gData;

@property (nonatomic, weak) UIButton *leftBtn;
@property (nonatomic, weak) UIButton *rightBtn;


@end

@implementation OrderDetailsViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setNavBarTitle:@"订单详情"];
    [self setNavBarLeftBtn:[STNavBarView createImgNaviBarBtnByImgNormal:@"nav_back.png" imgHighlight:@"nav_back_highlighted.png" imgSelected:nil target:self action:@selector(back:)]];
    
    [self initTableView];

    [self getOrderDetails];
}


- (void)back:(id)sender
{
    if (_mType == KCommom) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else{
        // 进入我的
        [theAppDelegate.tabBarController setSelectedIndex:3];
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}


- (void)initTableView
{
    UITableView *tableView = [[UITableView alloc] initWithFrame:MAINSCREEN style:UITableViewStyleGrouped];
    _tableView = tableView;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    
    [self resetScrollView:self.tableView tabBar:YES];
}


- (void)getOrderDetails
{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithCapacity:1];
    [dict setObject:_orderID forKey:@"order_id"];
    
    __typeof (&*self) __weak weakSelf = self;
    [[ShoppingLogic sharedInstance] getOrderDetails:dict withCallback:^(LogicResult *result) {
        if(result.statusCode == KLogicStatusSuccess)
        {
            weakSelf.gData = result.mObject;
            [weakSelf.tableView reloadData];
            
            //底部菜单
            [weakSelf initBottomView];
        }
        else
            [weakSelf.view makeToast:result.stateDes];
    }];
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    if (!_gData) {
        return 0;
    }
    
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        if ([_gData.type integerValue] == 2) {
            return 1;
        }
        return 2;
    }
    
    if (section == 1)
    {
        return _gData.skuList.count +2;
    }
    
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
        if (indexPath.row == 0) {
            return 76.0;
        }
        else if (indexPath.row == 1) {
            AddressNewCell *mCell = [AddressNewCell cellWithTableView:tableView];
            return [mCell setCellWithCellInfo:_gData.deliveryInfo];
        }
    }
    if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            return 40.0;
        }
        if (indexPath.row == _gData.skuList.count + 1) {
            return 110.0;
        }
        
        return 96.0;
    }
    
    return 72.0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0)
    {
        if (indexPath.row == 0) {
            OrderStateCell *mCell = [OrderStateCell cellWithTableView:tableView];
            [mCell setCellWithOrderTotalCellInfo:_gData];
            return mCell;
        }
        else
        {
            AddressNewCell *mCell = [AddressNewCell cellWithTableView:tableView];
            [mCell setCellWithCellInfo:_gData.deliveryInfo];
            return mCell;
        }
    }
    else if (indexPath.section == 1)
    {
        if (indexPath.row == 0)
        {
            CartStoreCell *cell = [CartStoreCell cellWithTableView:tableView];
            SKUOrderModel *mInfo = _gData.skuList[0];
            [cell setCellWithCellOrderInfo:mInfo.store];
            
            return cell;
        }
        
        if (indexPath.row == _gData.skuList.count + 1) {
            OrderAffiliatedCell *mCell = [OrderAffiliatedCell cellWithTableView:tableView];
            [mCell setCellWithCellInfo:[_gData.total_price floatValue]];
            return mCell;
        }
        
        GoodsOrderCell *mCell = [GoodsOrderCell cellWithTableView:tableView];
        [mCell setCellWithOrderCellInfo:_gData.skuList[indexPath.row - 1]];
        return mCell;
    }
    else if (indexPath.section == 2)
    {
        OrderInstructionsCell *mcell = [OrderInstructionsCell cellWithTableView:tableView];
        [mcell setCellWithOrderTotalCellInfo:_gData];
        return mcell;
    }
    
    return nil;
}


// 添加底部购买按钮和加入购物车按钮的view
- (void)initBottomView{
    UIView* view = [[UIView alloc] init];
    [view setTag:0x1024];
    view.frame = CGRectMake(0, SCREEN_HEIGHT - Bottom_H, SCREEN_WIDTH, Bottom_H);
    view.backgroundColor = [UIColor whiteColor];
    
    UILabel *lineV = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.5)];
    [lineV setBackgroundColor:LIGHT_BLACK_COLOR];
    [view addSubview:lineV];
    
    
    //rightBtn
    UIButton *rightBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 80, 10, 66, 29)];
    _rightBtn = rightBtn;
    [_rightBtn.titleLabel setFont:[UIFont systemFontOfSize:13.0]];
    //圆角
    _rightBtn.layer.cornerRadius = 3.0;
    _rightBtn.layer.masksToBounds = YES;  //设为NO去试试
    [_rightBtn addTarget:self action:@selector(rightBtnTapped:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:_rightBtn];
    
    //leftBtn
    UIButton *leftBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 156, 10, 66, 29)];
    _leftBtn = leftBtn;
    [_leftBtn.titleLabel setFont:[UIFont systemFontOfSize:13.0]];
    //圆角
    _leftBtn.layer.cornerRadius = 3.0;
    _leftBtn.layer.masksToBounds = YES;  //设为NO去试试
    [_leftBtn addTarget:self action:@selector(leftBtnTapped:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:_leftBtn];

    [self.view addSubview:view];
    
    [self updateBottomView];
}

- (void)updateBottomView {
    
    if ([_gData.type integerValue] == 1) {
        switch ([_gData.status integerValue]) {
            case KOrder_WaitingPayment:         //待支付
                [_rightBtn setTitle:@"付款" forState:UIControlStateNormal];
                [_rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                [_rightBtn setBackgroundImage:[UIImage imageNamed:@"btn_pink.png"] forState:UIControlStateNormal];
                
                _leftBtn.layer.borderWidth = 1;
                _leftBtn.layer.borderColor = BLACK_COLOR.CGColor;
                [_leftBtn setTitle:@"取消订单" forState:UIControlStateNormal];
                [_leftBtn setTitleColor:BLACK_COLOR forState:UIControlStateNormal];
                [_leftBtn setBackgroundImage:[UIImage imageNamed:@"btn_whitle_1.png"] forState:UIControlStateNormal];
                
                break;
                
            case KOrder_Cancel:                 //已取消
                _rightBtn.layer.borderWidth = 1;
                _rightBtn.layer.borderColor = BLACK_COLOR.CGColor;
                [_rightBtn setTitle:@"删除订单" forState:UIControlStateNormal];
                [_rightBtn setTitleColor:BLACK_COLOR forState:UIControlStateNormal];
                [_rightBtn setBackgroundImage:[UIImage imageNamed:@"btn_whitle_1.png"] forState:UIControlStateNormal];
                
                
                [_leftBtn setHidden:YES];
                break;
                
                
            case KOrder_PaySuccess:             //支付成功
                _rightBtn.layer.borderWidth = 1;
                _rightBtn.layer.borderColor = YELLOW_DARK.CGColor;
                [_rightBtn setTitle:@"确认收货" forState:UIControlStateNormal];
                [_rightBtn setTitleColor:YELLOW_DARK forState:UIControlStateNormal];
                [_rightBtn setBackgroundImage:[UIImage imageNamed:@"btn_whitle_1.png"] forState:UIControlStateNormal];
                
                _leftBtn.layer.borderWidth = 1;
                _leftBtn.layer.borderColor = BLACK_COLOR.CGColor;
                [_leftBtn setTitle:@"查看物流" forState:UIControlStateNormal];
                [_leftBtn setTitleColor:BLACK_COLOR forState:UIControlStateNormal];
                [_leftBtn setBackgroundImage:[UIImage imageNamed:@"btn_whitle_1.png"] forState:UIControlStateNormal];
                
                break;
                
            case KOrder_Signed:                 //已收货
                _rightBtn.layer.borderWidth = 1;
                _rightBtn.layer.borderColor = YELLOW_DARK.CGColor;
                [_rightBtn setTitle:@"评价" forState:UIControlStateNormal];
                [_rightBtn setTitleColor:YELLOW_DARK forState:UIControlStateNormal];
                [_rightBtn setBackgroundImage:[UIImage imageNamed:@"btn_whitle_1.png"] forState:UIControlStateNormal];
                
                
                _leftBtn.layer.borderWidth = 1;
                _leftBtn.layer.borderColor = BLACK_COLOR.CGColor;
                [_leftBtn setTitle:@"查看物流" forState:UIControlStateNormal];
                [_leftBtn setTitleColor:BLACK_COLOR forState:UIControlStateNormal];
                [_leftBtn setBackgroundImage:[UIImage imageNamed:@"btn_whitle_1.png"] forState:UIControlStateNormal];
                
                break;
                
            case KOrder_HaveEvaluation:         //已评价
                _rightBtn.layer.borderWidth = 1;
                _rightBtn.layer.borderColor = BLACK_COLOR.CGColor;
                [_rightBtn setTitle:@"查看物流" forState:UIControlStateNormal];
                [_rightBtn setTitleColor:BLACK_COLOR forState:UIControlStateNormal];
                [_rightBtn setBackgroundImage:[UIImage imageNamed:@"btn_whitle_1.png"] forState:UIControlStateNormal];
                
                
                [_leftBtn setHidden:YES];
                
                break;
                
            default:
                break;
        }
    }
    else if ([_gData.type integerValue] == 2){
        switch ([_gData.status integerValue]) {
            case KOrder_WaitingPayment:         //待支付
                [_rightBtn setTitle:@"付款" forState:UIControlStateNormal];
                [_rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                [_rightBtn setBackgroundImage:[UIImage imageNamed:@"btn_pink.png"] forState:UIControlStateNormal];
                
                _leftBtn.layer.borderWidth = 1;
                _leftBtn.layer.borderColor = BLACK_COLOR.CGColor;
                [_leftBtn setTitle:@"取消订单" forState:UIControlStateNormal];
                [_leftBtn setTitleColor:BLACK_COLOR forState:UIControlStateNormal];
                [_leftBtn setBackgroundImage:[UIImage imageNamed:@"btn_whitle_1.png"] forState:UIControlStateNormal];
                
                break;
                
            case KOrder_Cancel:                 //已取消
                _rightBtn.layer.borderWidth = 1;
                _rightBtn.layer.borderColor = BLACK_COLOR.CGColor;
                [_rightBtn setTitle:@"删除订单" forState:UIControlStateNormal];
                [_rightBtn setTitleColor:BLACK_COLOR forState:UIControlStateNormal];
                [_rightBtn setBackgroundImage:[UIImage imageNamed:@"btn_whitle_1.png"] forState:UIControlStateNormal];
                
                [_leftBtn setHidden:YES];
                
                break;
                
                
            case KOrder_PaySuccess:             //支付成功
            {
                UIView* view = (UIView *)[self.view viewWithTag:0x1024];
                if (view) {
                    [view setHidden:YES];
                }
            }
                break;
                
            case KOrder_Signed:                 //已收货
                _rightBtn.layer.borderWidth = 1;
                _rightBtn.layer.borderColor = YELLOW_DARK.CGColor;
                [_rightBtn setTitle:@"评价" forState:UIControlStateNormal];
                [_rightBtn setTitleColor:YELLOW_DARK forState:UIControlStateNormal];
                [_rightBtn setBackgroundImage:[UIImage imageNamed:@"btn_whitle_1.png"] forState:UIControlStateNormal];
                
                [_leftBtn setHidden:YES];

                break;
                
            case KOrder_HaveEvaluation:         //已评价
            {
                UIView* view = (UIView *)[self.view viewWithTag:0x1024];
                if (view) {
                    [view setHidden:YES];
                }
            }
                
                break;
                
            default:
                break;
        }
    }
}


- (void)rightBtnTapped:(UIButton *)sender
{
    if ([_gData.status integerValue] == KOrder_WaitingPayment) {
        //付款
        LXActionSheet *actionSheet = [[LXActionSheet alloc] initWithTitle:@"选择支付方式"
                                                                 delegate:self
                                                        cancelButtonTitle:@"取消"
                                                   destructiveButtonTitle:nil
                                                        otherButtonTitles:@[@"支付宝", @"微信支付"]];
        [actionSheet showInView:self.view];
    }
    else if ([_gData.status integerValue] == KOrder_Cancel)
    {
        //删除订单
        AlertWithTitleAndMessageAndUnitsToTag(@"确定删除订单", @"订单删除之后，在手机上将不可见", self, @"确定", nil, 0x128);
    }
    else if ([_gData.status integerValue] == KOrder_PaySuccess)
    {
        //确认收货
        [self acceptGoods];
    }
    else if ([_gData.status integerValue] == KOrder_Signed)
    {
        //评价
        [self commentGoods];
    }
    else if ([_gData.status integerValue] == KOrder_HaveEvaluation)
    {
        //查看物流
        [self checkLogistics];
    }
}


//左按钮
- (void)leftBtnTapped:(UIButton *)sender
{
    
    if ([_gData.status integerValue] == KOrder_WaitingPayment) {
        //取消订单
        AlertWithTitleAndMessageAndUnitsToTag(@"确定取消该订单？", @"取消订单之后，交易将关闭", self, @"确定", nil, 0x256);
    }
    else if ([_gData.status integerValue] == KOrder_PaySuccess || [_gData.status integerValue] == KOrder_Signed)
    {
        //查看物流
        [self checkLogistics];
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

// 取消订单
- (void)cancelOrder
{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithCapacity:1];
    [dict setObject:_gData.order_id forKey:@"order_id"];
    
    __typeof (&*self) __weak weakSelf = self;
    
    [[ShoppingLogic sharedInstance] cancelOrder:dict withCallback:^(LogicResult *result) {
        if(result.statusCode == KLogicStatusSuccess)
        {
            [weakSelf back:nil];
        }
        else
            [weakSelf.view makeToast:result.stateDes];
    }];
}

// 删除订单
- (void)deleteOrder
{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithCapacity:1];
    [dict setObject:_gData.order_id forKey:@"order_id"];
    
    __typeof (&*self) __weak weakSelf = self;
    
    [[ShoppingLogic sharedInstance] deleteOrder:dict withCallback:^(LogicResult *result) {
        if(result.statusCode == KLogicStatusSuccess)
        {
            [weakSelf back:nil];
        }
        else
            [weakSelf.view makeToast:result.stateDes];
    }];
}

//确定收货
- (void)acceptGoods
{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithCapacity:1];
    [dict setObject:_gData.order_id forKey:@"order_id"];
    
    __typeof (&*self) __weak weakSelf = self;
    
    [[ShoppingLogic sharedInstance] signOrder:dict withCallback:^(LogicResult *result) {
        if(result.statusCode == KLogicStatusSuccess)
        {
            [weakSelf back:nil];
            [theAppDelegate.window makeToast:@"签收成功"];
        }
        else
            [weakSelf.view makeToast:result.stateDes];
    }];
}

//查看物流
- (void)checkLogistics
{
    LogisticsInformationViewController *loVC = [[LogisticsInformationViewController alloc] init];
    loVC.orderID = _gData.order_id;
    [self.navigationController pushViewController:loVC animated:YES];
}

//发表评价
- (void)commentGoods
{
    EvaluationOrderViewController *eVC = [[EvaluationOrderViewController alloc] init];
    eVC.gData = _gData;
    [self.navigationController pushViewController:eVC animated:YES];
}


- (void)successState
{
    SKUOrderModel *mInfo = _gData.skuList[0];
    if ([mInfo.store.canTry boolValue] && !_gData.deliveryInfo.receiver_addr){
        
        //进入预约界面（前提是该商家支持到店取，并且用户也选择了到店取）
        PickUpDateViewController *pVC = [[PickUpDateViewController alloc] init];
        pVC.orderId = [ShoppingLogic sharedInstance].orderData.order_id;
        
        [self.navigationController pushViewController:pVC animated:YES];
    }
    else{
        PayResultsViewController *pVC = [[PayResultsViewController alloc] init];
        pVC.orderID = _orderID;
        [self.navigationController pushViewController:pVC animated:YES];
    }
}



#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        
        if(alertView.tag == 0x128)
        {
            //删除订单
            [self deleteOrder];
        }
        else if(alertView.tag == 0x256)
        {
            //取消订单
            [self cancelOrder];
        }
    }
}

#pragma mark - LXActionSheetDelegate
- (void)actionSheet:(LXActionSheet *)mActionSheet didClickOnButtonIndex:(int)buttonIndex
{
    
    if (![ShoppingLogic sharedInstance].orderData) {
        [ShoppingLogic sharedInstance].orderData = [[OrderData alloc] init];
    }
    
    [ShoppingLogic sharedInstance].orderData.order_id = _gData.order_id;
    
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


@end
