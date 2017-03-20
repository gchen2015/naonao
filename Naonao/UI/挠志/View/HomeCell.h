//
//  HomeCell.h
//  BanTang
//
//  Created by 天空之城 on 16/3/25.
//  Copyright © 2016年 天空之城. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MagazineInfo.h"

@interface HomeCell : UITableViewCell

@property (nonatomic, assign) CGFloat height;

+ (HomeCell *)cellWithTableView:(UITableView *)tableView;
- (void)setCellWithCellInfo:(MagazineInfo *)topic;

@end
