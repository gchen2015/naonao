//
//  WalletCell.h
//  Naonao
//
//  Created by 刘敏 on 16/5/17.
//  Copyright © 2016年 深圳市轩腾华兴科技开发有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WithdrawModel.h"


@interface WalletCell : UITableViewCell

+ (WalletCell *)cellWithTableView:(UITableView *)tableView;

- (void)setCellWithCellInfo:(WithdrawRecord *)record;

@end
