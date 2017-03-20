//
//  ShapeInfoCell.h
//  Naonao
//
//  Created by 刘敏 on 16/6/17.
//  Copyright © 2016年 深圳市轩腾华兴科技开发有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShapeInfoCell : UITableViewCell

+ (ShapeInfoCell *)cellWithTableView:(UITableView *)tableView;

- (void)setCellWithCellInfo:(NSUInteger)mRow setArray:(NSArray *)mArray;

@end
