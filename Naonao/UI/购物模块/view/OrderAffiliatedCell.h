//
//  OrderAffiliatedCell.h
//  Naonao
//
//  Created by 刘敏 on 16/3/20.
//  Copyright © 2016年 深圳市轩腾华兴科技开发有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderAffiliatedCell : UITableViewCell

+ (OrderAffiliatedCell *)cellWithTableView:(UITableView *)tableView;

- (void)setCellWithCellInfo:(CGFloat)combinedAmount;

@end
