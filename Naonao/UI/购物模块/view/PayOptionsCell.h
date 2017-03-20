//
//  PayOptionsCell.h
//  Naonao
//
//  Created by 刘敏 on 16/3/11.
//  Copyright © 2016年 深圳市轩腾华兴科技开发有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PaymentChannelInfo.h"

@interface PayOptionsCell : UITableViewCell

@property (weak, nonatomic) UIButton *btn;
@property (assign, nonatomic)NSInteger clickCount;

+ (PayOptionsCell *)cellWithTableView:(UITableView *)tableView;

- (void)setCellWithCellInfo:(PaymentChannelInfo *)pInfo;

@end
