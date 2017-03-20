//
//  LogisticsHeaderCell.h
//  Naonao
//
//  Created by 刘敏 on 2016/10/27.
//  Copyright © 2016年 深圳市轩腾华兴科技开发有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AddressInfo.h"

@interface LogisticsHeaderCell : UITableViewCell

+ (LogisticsHeaderCell *)cellWithTableView:(UITableView *)tableView;

- (void)setCellWithCellInfo:(CourierInfo *)cInfo;

@end
