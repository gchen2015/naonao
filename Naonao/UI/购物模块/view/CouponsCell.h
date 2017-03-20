//
//  CouponsCell.h
//  Naonao
//
//  Created by 刘敏 on 16/5/11.
//  Copyright © 2016年 深圳市轩腾华兴科技开发有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CouponsModel.h"


@interface CouponsCell : UITableViewCell

+ (CouponsCell *)cellWithTableView:(UITableView *)tableView;

- (void)setCellWithCellInfo:(CouponsModel *)cModel;

@end
