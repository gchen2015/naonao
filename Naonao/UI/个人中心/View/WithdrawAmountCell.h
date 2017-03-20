//
//  WithdrawAmountCell.h
//  Naonao
//
//  Created by 刘敏 on 16/5/18.
//  Copyright © 2016年 深圳市轩腾华兴科技开发有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PaymentChannelInfo.h"


@interface WithdrawAmountCell : UITableViewCell

@property (weak, nonatomic) UIButton *btn;
@property (assign, nonatomic)NSInteger clickCount;

+ (WithdrawAmountCell *)cellWithTableView:(UITableView *)tableView;

- (void)setCellWithCellInfo:(WithdrawChannelInfo *)pInfo;

@end
