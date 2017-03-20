//
//  PickUpCell.h
//  Naonao
//
//  Created by 刘敏 on 2016/9/29.
//  Copyright © 2016年 深圳市轩腾华兴科技开发有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BookModel.h"

@interface PickUpCell : UITableViewCell

+ (PickUpCell *)cellWithTableView:(UITableView *)tableView;

- (void)setCellWithCellInfo:(PickUpData *)mInfo;

@end
