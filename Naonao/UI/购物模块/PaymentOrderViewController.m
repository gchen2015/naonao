//
//  PaymentOrderViewController.m
//  Naonao
//
//  Created by 刘敏 on 16/3/10.
//  Copyright © 2016年 深圳市轩腾华兴科技开发有限公司. All rights reserved.
//

#import "PaymentOrderViewController.h"
#import "PayResultsViewController.h"
#import "ORAddressViewController.h"
#import "AddressCell.h"
#import "PayOptionsCell.h"
#import "OrderAffiliatedCell.h"
#import "GoodsOrderCell.h"
#import "Pingpp.h"
#import "ShoppingLogic.h"
#import "CouponsViewController.h"
#import "OrderDetailsViewController.h"
#import "CartStoreCell.h"
#import "PickUpDateViewController.h"
#import "PickupWayViewController.h"
#import "MerchantAddressCell.h"

@interface PaymentOrderViewController ()<UITableViewDataSource, UITableViewDelegate, ORAddressViewControllerDelegate, CouponsViewControllerDelegate, PickupWayViewControllerDelegate>

@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic, weak) UILabel *amountL;
@property (nonatomic, strong) NSArray *paymentList;

@property (nonatomic,strong) NSMutableArray *clickArray;
@property (nonatomic,strong) PaymentChannelInfo *selectModel;

@property (nonatomic, assign) CGFloat combinedAmount;       //合计金额
@property (nonatomic, assign) CGFloat realAmount;           //实付金额

@property (nonatomic, strong) AddressInfo *mInfo;           //收件人信息

@property (nonatomic, strong) NSString *couponS;
@property (nonatomic, strong) NSNumber *couponID;

@property (nonatomic, strong) StoreData *store;
@property (nonatomic, assign) BOOL isPick;                  //为YES上门取，NO为快递

@end


@implementation PaymentOrderViewController

//初始化数据
- (void)initData
{
    _paymentList = [[ShoppingLogic sharedInstance] laodConfigListWithPayment];
    
    //判断当前机型以及系统版本（Apple Pay 支持机型ios9及以上，iPhone6s、iPhone6s Plus）
    if (!_clickArray) {
        _clickArray = [[NSMutableArray alloc] initWithArray:_paymentList];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:NO];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setNavBarTitle:@"确认订单"];
    [self setNavBarLeftBtn:[STNavBarView createImgNaviBarBtnByImgNormal:@"nav_back.png"
                                                           imgHighlight:@"nav_back_highlighted.png"
                                                                 target:self
                                                                 action:@selector(back:)]];
    _couponS = @"无可用优惠券";
    
    [self initData];
    
    [self calculatePaymentAmount];
    
    [self getAvailableCouponCount];
    
    //获取商家信息
    GoodsOData *gData = [ShoppingLogic sharedInstance].orderArray[0];
    _store = gData.store;
    if([_store.canTry boolValue]){
        _isPick = YES;
    }
    
    //获取默认地址
    _mInfo = [[ShoppingLogic sharedInstance] getDefaulAddress];

    UITableView *tableView = [[UITableView alloc] initWithFrame:MAINSCREEN style:UITableViewStyleGrouped];
    _tableView = tableView;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    [self resetScrollView:self.tableView tabBar:YES];
    
    //底部菜单
    [self initBottomView];
}

- (void)back:(UIButton *)sender
{
    [[ShoppingLogic sharedInstance].orderArray removeAllObjects];
    [self.navigationController popViewControllerAnimated:YES];
}

//获取可用优惠券个数
- (void)getAvailableCouponCount
{
    __typeof (&*self) __weak weakSelf = self;
    
    [[ShoppingLogic sharedInstance] getAvailableCouponCount:nil withCallback:^(LogicResult *result) {
        if(result.statusCode == KLogicStatusSuccess)
        {
            //生成预付款订单
            if (result.mObject) {
                _couponS = [NSString stringWithFormat:@"%@个优惠券", [result.mObject objectForKey:@"count"]];
            }
            else
                _couponS = @"无可用优惠券";
            
            [weakSelf.tableView reloadData];
        }
        else
            [weakSelf.view makeToast:result.stateDes];
 
    }];
}



// 添加底部购买按钮和加入购物车按钮的view
- (void)initBottomView{
    UIView* view = [[UIView alloc] init];
    view.frame = CGRectMake(0, SCREEN_HEIGHT - Bottom_H, SCREEN_WIDTH, Bottom_H);
    view.backgroundColor = [UIColor whiteColor];
    
    UILabel *lineV = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.5)];
    [lineV setBackgroundColor:LIGHT_BLACK_COLOR];
    [view addSubview:lineV];
    
    
    UILabel *mL = [[UILabel alloc] initWithFrame:CGRectMake(14, 4, 100, Bottom_H)];
    [mL setText:@"实付款:"];
    [mL setFont:[UIFont systemFontOfSize:14.0]];
    [view addSubview:mL];
    
    
    UILabel *amountL = [[UILabel alloc] initWithFrame:CGRectMake(66, 0, 130, Bottom_H)];
    _amountL = amountL;
    [_amountL setTextColor:PINK_COLOR];
    [_amountL setFont:[UIFont fontWithName:kAkzidenzGroteskBQ size:17.0]];
    NSString *st = [NSString stringWithFormat:@"￥%.2f", _realAmount];
    
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:st];
    [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15.0] range:NSMakeRange(0, 1)];
    [str addAttribute:NSFontAttributeName value:[UIFont fontWithName:kAkzidenzGroteskBQ size:28.0] range:NSMakeRange(1, st.length-4)];
    _amountL.attributedText = str;
    [view addSubview:_amountL];
    
    //结算
    UIButton* bBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH*5/8, 0, SCREEN_WIDTH*3/8, Bottom_H)];;
    [bBtn setTitle:@"立即支付" forState:UIControlStateNormal];
    [bBtn.titleLabel setFont:[UIFont systemFontOfSize:16.0]];
    [bBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [bBtn setBackgroundImage:[UIImage imageNamed:@"ST_btn_11.png"] forState:UIControlStateNormal];
    [bBtn setBackgroundImage:[UIImage imageNamed:@"btn_grey.png"] forState:UIControlStateHighlighted];
    [bBtn setBackgroundImage:[UIImage imageNamed:@"btn_grey.png"] forState:UIControlStateSelected];
    [bBtn addTarget:self action:@selector(payTapped:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:bBtn];
    
    [self.view addSubview:view];
}

//计算付款金额
- (void)calculatePaymentAmount
{
    CGFloat amount = 0.00f;
    
    for (GoodsOData *pD in [ShoppingLogic sharedInstance].orderArray) {
        amount += [pD.price floatValue] * [pD.count integerValue];
    }
    //合计金额 = amount + 运费
    
    _combinedAmount = amount;
    
    //实付金额 = 合计金额 - 优惠金额
    _realAmount = _combinedAmount;
}


#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 5;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        if ([_store.canTry boolValue]) {
            //支持上门取货
            return 2;
        }
        return 1;
    }
    
    
    if (section == 2 || section == 3) {
        return 1;
    }
    else if(section == 1)
    {
        return [ShoppingLogic sharedInstance].orderArray.count + 1;
    }
    
    return 2;
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
        if ([_store.canTry boolValue]) {
            if (indexPath.row == 0) {
                return 45.0;
            }
            
            if (indexPath.row == 1) {
                if (_isPick) {
                    return 68.0;
                }
                
                if(_mInfo.address)
                {
                    AddressCell *mCell = [AddressCell cellWithTableView:tableView];
                    return [mCell setCellWithCellInfo:_mInfo];
                }
            }
        }
        else{
            if(_mInfo.address)
            {
                AddressCell *mCell = [AddressCell cellWithTableView:tableView];
                return [mCell setCellWithCellInfo:_mInfo];
            }
            
            return 45.0;
        }
    }
    else if (indexPath.section == 1)
    {
        if (indexPath.row == 0) {
            return 40.0;
        }
        return 96.0;
    }
    else if (indexPath.section == 2)
    {
        return 110.0;
    }
    
    return 45.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 && _mInfo.address)
    {
        if ([_store.canTry boolValue]) {
            if (indexPath.row == 0) {
                static NSString *CellIdentifier = @"Cell";
                UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                if (cell == nil) {
                    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
                    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                    cell.selectionStyle = UITableViewCellSelectionStyleGray;
                    [cell.textLabel setFont:[UIFont systemFontOfSize:16.0]];
                    [cell.textLabel setTextColor:[UIColor blackColor]];
                    
                    
                    cell.detailTextLabel.minimumScaleFactor = 0.6f;
                    cell.detailTextLabel.adjustsFontSizeToFitWidth = YES;
                    [cell.detailTextLabel setFont:[UIFont systemFontOfSize:15.0]];
                    [cell.detailTextLabel setTextColor:PINK_COLOR];
                }
                cell.textLabel.text = @"取货方式";
                if (_isPick){
                    cell.detailTextLabel.text = @"门店自取";
                }
                else
                    cell.detailTextLabel.text = @"快递送达";
                
                return cell;
            }
            
            if (indexPath.row == 1) {
                if (_isPick) {
                    MerchantAddressCell *cell = [MerchantAddressCell cellWithTableView:tableView];
                    [cell setCellWithCellInfo:_store];
                    return cell;
                }
                else
                {
                    if(_mInfo.address)
                    {
                        AddressCell *mCell = [AddressCell cellWithTableView:tableView];
                        [mCell setCellWithCellInfo:_mInfo];
                        return mCell;
                    }
                }
            }
        }
        else{
            if(_mInfo.address)
            {
                AddressCell *mCell = [AddressCell cellWithTableView:tableView];
                [mCell setCellWithCellInfo:_mInfo];
                return mCell;
            }
        }  
    }
    else if (indexPath.section == 1)
    {
        if (indexPath.row == 0)
        {
            CartStoreCell *cell = [CartStoreCell cellWithTableView:tableView];
            GoodsOData *goodsTData = [ShoppingLogic sharedInstance].orderArray[indexPath.row];
            [cell setCellWithCellOrderInfo:goodsTData.store];
            
            return cell;
        }
        else{
            GoodsOrderCell *mCell = [GoodsOrderCell cellWithTableView:tableView];
            [mCell setCellWithCellInfo:[ShoppingLogic sharedInstance].orderArray[indexPath.row -1]];
            return mCell;
        }
    }
    else if (indexPath.section == 2) {
        OrderAffiliatedCell *mCell = [OrderAffiliatedCell cellWithTableView:tableView];
        [mCell setCellWithCellInfo:_combinedAmount];
        return mCell;
    }
    else if (indexPath.section == 4) {
        PayOptionsCell *pCell = [PayOptionsCell cellWithTableView:tableView];
        [pCell setCellWithCellInfo:_paymentList[indexPath.row]];
        pCell.btn.tag = indexPath.row;
        [pCell.btn addTarget:self action:@selector(ClickBtn:) forControlEvents:UIControlEventTouchUpInside];
        
        return pCell;
    }
    else
    {
        static NSString *CellIdentifier = @"Cell";
        UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.selectionStyle = UITableViewCellSelectionStyleGray;
            [cell.textLabel setFont:[UIFont systemFontOfSize:16.0]];
            [cell.textLabel setTextColor:[UIColor blackColor]];
            
            
            cell.detailTextLabel.minimumScaleFactor = 0.6f;
            cell.detailTextLabel.adjustsFontSizeToFitWidth = YES;
            [cell.detailTextLabel setFont:[UIFont systemFontOfSize:15.0]];
            [cell.detailTextLabel setTextColor:LIGHT_BLACK_COLOR];
        }
        
        if (indexPath.section == 0) {
            cell.textLabel.text = @"选择收货地址";
        }

        
        if (indexPath.section == 3) {
            cell.textLabel.text = @"优惠券";
            cell.detailTextLabel.text = _couponS;
        }

        return cell;
    }
    
    return nil;
}


#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 0) {
        if ([_store.canTry boolValue]) {
            if (indexPath.row == 0) {
                PickupWayViewController *pVC = [[PickupWayViewController alloc] init];
                pVC.delegate = self;
                [self.navigationController pushViewController:pVC animated:YES];
            }
            if (indexPath.row == 1) {
                if (!_isPick) {
                    ORAddressViewController *gVC = [[ORAddressViewController alloc] init];
                    gVC.selectModel = _mInfo;
                    gVC.delegate = self;
                    [self.navigationController pushViewController:gVC animated:YES];
                }
            }
        }
        else{
            ORAddressViewController *gVC = [[ORAddressViewController alloc] init];
            gVC.selectModel = _mInfo;
            gVC.delegate = self;
            [self.navigationController pushViewController:gVC animated:YES];
        }

    }
    
    if (indexPath.section == 3) {
        if (![_couponS isEqualToString:@"无可用优惠券"]) {
            CouponsViewController *sVC = [[CouponsViewController alloc] init];
            sVC.hidesBottomBarWhenPushed = YES;
            sVC.isPAY = YES;
            sVC.delegate = self;
            [self.navigationController pushViewController:sVC animated:YES];
        }
        
    }
}

- (void)ClickBtn:(UIButton *)btn
{
    if (self.selectModel) {
        if([self.selectModel.isSelected boolValue])
        {
            self.selectModel.isSelected = [NSNumber numberWithBool:NO];
        }
        else
            self.selectModel.isSelected = [NSNumber numberWithBool:YES];
    }
                                                    
    PaymentChannelInfo *model = self.paymentList[btn.tag];
    
    if (![model.isSelected boolValue]) {
        
        if([model.isSelected boolValue])
        {
            model.isSelected = [NSNumber numberWithBool:NO];
        }
        else
            model.isSelected = [NSNumber numberWithBool:YES];
        
        self.selectModel = model;
    }

    [self.tableView reloadData];
}


- (void)payTapped:(id)sender
{
    if (!_mInfo.address) {
        [self.view makeToast:@"请选收货地址"];
        return;
    }
    
    if(!_selectModel)
    {
        [self.view makeToast:@"请选择支付方式"];
        return;
    }
    
    NSMutableArray *temA = [NSMutableArray array];
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithCapacity:1];

    for (GoodsOData *goodsTData in [ShoppingLogic sharedInstance].orderArray) {
        
        NSString *recommendedS = @"0";
        //推荐者UserID
        if (goodsTData.source_uid) {
            recommendedS = [goodsTData.source_uid stringValue];
        }
        
        NSString *st = [NSString stringWithFormat:@"%@:%@:%@", goodsTData.skuTag, goodsTData.count, recommendedS];
        [temA addObject:st];
    }
    
    [dict setObject:[temA componentsJoinedByString:@"|"] forKey:@"sku_list"];
    
    //取货方式：1快递，2上门取
    if(_isPick){
        [dict setObject:[NSNumber numberWithInteger:2] forKey:@"type"];
    }
    else{
        [dict setObject:[NSNumber numberWithInteger:1] forKey:@"type"];
    }
    
    

    [theAppDelegate.HUDManager showTip:nil];
    __typeof (&*self) __weak weakSelf = self;
    //生成订单
    [[ShoppingLogic sharedInstance] getOrder:dict withCallback:^(LogicResult *result) {
        if(result.statusCode == KLogicStatusSuccess)
        {
            if(_couponID)
            {
                //使用优惠券
                [weakSelf userCoupons];
            }
            else{
                //生成预付款订单
                [weakSelf generatePreparePaymentOrder];
                
                if ([_store.canTry boolValue] && _isPick){
                    CLog(@"到店取，不需要收货地址");
                }
                else{
                    //关联订单地址
                    [weakSelf associatedOrderAddress];
                }
            }
        }
        else
        {
            [weakSelf.view makeToast:result.stateDes];
            [theAppDelegate.HUDManager hideHUD];
        }
        
    }];
}

//生成预付款订单
- (void)generatePreparePaymentOrder
{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithCapacity:0];
    //支付方式
    [dic setObject:_selectModel.paymentStatus forKey:@"channel"];
    
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
                   AlertWithTitleAndMessageAndPay(@"", @"付款失败, 是否要放弃付款？", self, @"确定");
               }
           }];
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        //取消支付，进入订单详情页
        OrderDetailsViewController *oVC = [[OrderDetailsViewController alloc] init];
        oVC.orderID = [ShoppingLogic sharedInstance].orderData.order_id;
        oVC.mType = KPayment;
        [self.navigationController pushViewController:oVC animated:YES];

        [self clearData];
    }
    else if(buttonIndex == 0)
    {
        //重新付款
        [self generatePreparePaymentOrder];
        [theAppDelegate.HUDManager showTip:nil];
    }
}


//关联订单地址
- (void)associatedOrderAddress
{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setObject:[ShoppingLogic sharedInstance].orderData.order_id forKey:@"order_id"];
    [dic setObject:_mInfo.addressId forKey:@"address_id"];
    
    __typeof (&*self) __weak weakSelf = self;
    //发起请求
    [[ShoppingLogic sharedInstance] associatedOrderAddress:dic withCallback:^(LogicResult *result) {
        if(result.statusCode == KLogicStatusSuccess)
        {
            
        }
        else
        {
            [weakSelf.view makeToast:result.stateDes];
        }
    }];
}

- (void)successState
{
    if ([_store.canTry boolValue] && _isPick){
        //进入预约界面（前提是该商家支持到店取，并且用户也选择了到店取）
        PickUpDateViewController *pVC = [[PickUpDateViewController alloc] init];
        pVC.orderId = [ShoppingLogic sharedInstance].orderData.order_id;
        
        [self.navigationController pushViewController:pVC animated:YES];
    }
    else{
        PayResultsViewController *pVC = [[PayResultsViewController alloc] init];
        pVC.orderID = [ShoppingLogic sharedInstance].orderData.order_id;
        
        [self.navigationController pushViewController:pVC animated:YES];
    }
    
    [self clearData];
}


#pragma mark - ORAddressViewControllerDelegate
- (void)selectedAddressInfo:(AddressInfo *)addInfo
{
    _mInfo = addInfo;
    [_tableView reloadData];
}


#pragma mark  CouponsViewControllerDelegate
- (void)updateCouponsUI:(CouponsModel *)cModel
{
    if ([cModel.type integerValue] == 2) {
        _couponS = @"使用优惠券";
        _couponID = cModel.mId;
        
        CGFloat m_count = _realAmount - [cModel.amount floatValue];
        //更新金额
        [_amountL setText:[NSString stringWithFormat:@"￥%.2f", m_count]];
    }
    else if ([cModel.type integerValue] == 1){
        
        NSDecimalNumber *denominator = [NSDecimalNumber decimalNumberWithString:[[NSNumber numberWithFloat:_realAmount] stringValue]];
        //折扣
        NSDecimalNumber *cof = [NSDecimalNumber decimalNumberWithString:[[NSNumber numberWithFloat:[cModel.amount floatValue]*0.01] stringValue]];

        //科学计算法(乘法)
        NSDecimalNumber *m_count = [denominator decimalNumberByMultiplyingBy:cof];
        //更新金额
//        [_amountL setText:[NSString stringWithFormat:@"￥%.2f", m_count]];
    }
    
    [self.tableView reloadData];
}


- (void)userCoupons
{
    //调用使用优惠券接口
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithCapacity:0];
    [dic setObject:[ShoppingLogic sharedInstance].orderData.order_id forKey:@"order_id"];
    [dic setObject:_couponID forKey:@"coupon_id"];
    
    __typeof (&*self) __weak weakSelf = self;
    
    [[ShoppingLogic sharedInstance] useCoupon:dic withCallback:^(LogicResult *result) {
        if(result.statusCode == KLogicStatusSuccess)
        {
            //生成预付款订单
            [weakSelf generatePreparePaymentOrder];
            
            //关联订单地址
            [weakSelf associatedOrderAddress];
        }
        else
        {
            [weakSelf.view makeToast:result.stateDes];
        }

    }];
}


- (void)clearData {
    //清空临时SKU
    [[ShoppingLogic sharedInstance].tempDict removeAllObjects];
    
    //清空临时订单信息
    [[ShoppingLogic sharedInstance] clearGoodsData];
}

#pragma mark  -PickupWayViewControllerDelegate
- (void)pickView:(PickupWayViewController *)mView selectedCellRow:(NSInteger)mRow
{
    _isPick = mRow;
    [_tableView reloadData];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
