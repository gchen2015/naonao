//
//  MyQuestionCell.h
//  Naonao
//
//  Created by 刘敏 on 16/8/3.
//  Copyright © 2016年 深圳市轩腾华兴科技开发有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SquareModel.h"

@interface MyQuestionCell : UITableViewCell

+ (MyQuestionCell *)cellWithTableView:(UITableView *)tableView;

- (void)setCellWithCellInfo:(SquareModel *)md;

- (void)setCellWithCellData:(SquareModel *)sInfo;

@end
