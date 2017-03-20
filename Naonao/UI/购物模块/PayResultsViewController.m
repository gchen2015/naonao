//
//  PayResultsViewController.m
//  Naonao
//
//  Created by 刘敏 on 16/3/10.
//  Copyright © 2016年 深圳市轩腾华兴科技开发有限公司. All rights reserved.
//

#import "PayResultsViewController.h"
#import "OrderDetailsViewController.h"
#import "SuccessCell.h"
#import "AddressCell.h"
#import "ShoppingLogic.h"
#import "PaymentResultCell.h"
#import "GoodsOrderCell.h"


@interface PayResultsViewController ()<UITableViewDataSource, UITableViewDelegate, PaymentResultCellDelegate>

@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic, strong) OrderDetails *gData;
@end

@implementation PayResultsViewController


- (void)viewDidAppear:(BOOL)animated {
    //关闭右滑返回
    [self navigationCanDragBack:NO];
    [super viewWillAppear:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
    //开启右滑返回
    [self navigationCanDragBack:YES];
    [super viewWillDisappear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setNavBarTitle:@"支付结果"];
    [self setNavBarLeftBtn:nil];
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:MAINSCREEN style:UITableViewStyleGrouped];
    _tableView = tableView;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    [self resetScrollView:self.tableView tabBar:NO];
    
    [self getOrderDetails];
}

- (void)getOrderDetails {
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithCapacity:1];
    [dict setObject:_orderID forKey:@"order_id"];
    
    __typeof (&*self) __weak weakSelf = self;
    [[ShoppingLogic sharedInstance] getOrderDetails:dict withCallback:^(LogicResult *result) {
        if(result.statusCode == KLogicStatusSuccess)
        {
            weakSelf.gData = result.mObject;
            [weakSelf.tableView reloadData];

        }
        else
            [weakSelf.view makeToast:result.stateDes];
    }];
}



#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (!_gData) {
        return 1;
    }
    
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0 || section == 1) {
        return 1;
    }
    
    return _gData.skuList.count +1;
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
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 87.0;
    }
    else if (indexPath.section == 1)
    {
        AddressNewCell *mCell = [AddressNewCell cellWithTableView:tableView];
        return [mCell setCellWithCellInfo:_gData.deliveryInfo];
    }
    else if (indexPath.section == 2) {
        if (indexPath.row == _gData.skuList.count) {
            return 150.0;
        }
        
        return 96.0;
    }
    
    return 0.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    if (indexPath.section == 0) {
        SuccessCell *mCell = [SuccessCell cellWithTableView:tableView];
        return mCell;
    }
    else if(indexPath.section == 1)
    {
        AddressNewCell *mCell = [AddressNewCell cellWithTableView:tableView];
        [mCell setCellWithCellInfo:_gData.deliveryInfo];
        return mCell;
    }
    else if(indexPath.section == 2)
    {
        if (indexPath.row == _gData.skuList.count) {
            PaymentResultCell *mCell = [PaymentResultCell cellWithTableView:tableView];
            [mCell setCellWithCellInfo:[_gData.total_price floatValue]];
            mCell.delegate = self;
            return mCell;
        }
        
        GoodsOrderCell *mCell = [GoodsOrderCell cellWithTableView:tableView];
        [mCell setCellWithOrderCellInfo:_gData.skuList[indexPath.row]];
        return mCell;
    }
    
    return nil;
}


#pragma mark - PaymentResultCellDelegate
- (void)jumpToNextOrderDetails {
    
    OrderDetailsViewController *oVC = [[OrderDetailsViewController alloc] init];
    oVC.orderID = _orderID;
    oVC.mType = KPayment;
    [self.navigationController pushViewController:oVC animated:YES];
}

@end
