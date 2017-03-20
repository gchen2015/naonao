//
//  TextFieldEditViewController.h
//  MeeBra
//
//  Created by Richard Liu on 15/9/22.
//  Copyright © 2015年 广州杉川投资管理有限公司. All rights reserved.
//

#import "STChildViewController.h"
#import "RETableViewManager.h"

@interface TextFieldEditViewController : STChildViewController

@property (strong, readonly, nonatomic) RETableViewManager *manager;
@property (nonatomic, weak)  UITableView *tableView;

@end
