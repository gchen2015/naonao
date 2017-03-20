//
//  WithdrawTypeCell.h
//  Naonao
//
//  Created by 刘敏 on 16/5/18.
//  Copyright © 2016年 深圳市轩腾华兴科技开发有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WithdrawTypeCell : UITableViewCell

+ (WithdrawTypeCell *)cellWithTableView:(UITableView *)tableView;

- (void)setCellWithRow:(NSUInteger)mRow;

@end
