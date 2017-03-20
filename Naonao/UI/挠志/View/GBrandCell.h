//
//  GBrandCell.h
//  Naonao
//
//  Created by 刘敏 on 16/8/5.
//  Copyright © 2016年 深圳市轩腾华兴科技开发有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MagazineInfo.h"


@interface GBrandCell : UITableViewCell

@property (nonatomic,assign) CGFloat height;

+ (GBrandCell *)cellWithTableView:(UITableView *)tableView;
- (void)setCellWithCellInfo:(STBrand *)topic;


@end
