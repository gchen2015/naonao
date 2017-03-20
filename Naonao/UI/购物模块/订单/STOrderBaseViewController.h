//
//  STOrderBaseViewController.h
//  Naonao
//
//  Created by 刘敏 on 16/3/25.
//  Copyright © 2016年 深圳市轩腾华兴科技开发有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UITableView+Mascot.h"


@class OrdersViewController;

@interface STOrderBaseViewController : UITableViewController

@property (nonatomic, weak) OrdersViewController *rootVC;

@property (nonatomic, assign) OrderType orderType;              //订单类型
@property (nonatomic, strong) NSMutableArray *tableData;

//获取订单信息
- (void)getOrderList;

@end
