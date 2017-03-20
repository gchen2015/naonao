//
//  FittingCell.h
//  Naonao
//
//  Created by 刘敏 on 2016/9/18.
//  Copyright © 2016年 深圳市轩腾华兴科技开发有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BookModel.h"

@interface FittingCell : UITableViewCell

+ (FittingCell *)cellWithTableView:(UITableView *)tableView;

- (void)setCellWithCellInfo:(FitData *)mInfo;

@end
