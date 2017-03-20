//
//  TagsTableCell.h
//  Naonao
//
//  Created by Richard Liu on 16/2/23.
//  Copyright © 2016年 深圳市轩腾华兴科技开发有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TagsTableCell : UITableViewCell

+ (TagsTableCell *)cellWithTableView:(UITableView *)tableView;

- (void)setCellWithCellInfo:(NSArray *)array;

- (void)setCellWithmultiSelectCellInfo:(NSArray *)array key:(NSString *)key;

@end
