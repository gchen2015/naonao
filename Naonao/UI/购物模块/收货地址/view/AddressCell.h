//
//  AddressCell.h
//  Naonao
//
//  Created by 刘敏 on 16/3/20.
//  Copyright © 2016年 深圳市轩腾华兴科技开发有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AddressInfo.h"
#import "GoodsOData.h"

@interface AddressCell : UITableViewCell

+ (AddressCell *)cellWithTableView:(UITableView *)tableView;

- (CGFloat)setCellWithCellInfo:(AddressInfo *)mInfo;

@end


@interface AddressNewCell : UITableViewCell

+ (AddressNewCell *)cellWithTableView:(UITableView *)tableView;

- (CGFloat)setCellWithCellInfo:(DeliveryInfo *)mInfo;

@end