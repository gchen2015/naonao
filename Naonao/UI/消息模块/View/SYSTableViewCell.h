//
//  SYSTableViewCell.h
//  Naonao
//
//  Created by 刘敏 on 16/8/22.
//  Copyright © 2016年 深圳市轩腾华兴科技开发有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "STMessageCare.h"

@interface SYSTableViewCell : UITableViewCell

+ (SYSTableViewCell *)cellWithTableView:(UITableView *)tableView;

- (void)setCellWithCellInfo:(SYSMessage *)item;

@end
