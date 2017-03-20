//
//  STAddressCell.h
//  Naonao
//
//  Created by 刘敏 on 16/3/28.
//  Copyright © 2016年 深圳市轩腾华兴科技开发有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AddressInfo.h"


@interface STAddressCell : UITableViewCell

+ (STAddressCell *)cellWithTableView:(UITableView *)tableView;

- (void)setCellWithCellInfo:(AddressInfo *)mInfo;

@end
