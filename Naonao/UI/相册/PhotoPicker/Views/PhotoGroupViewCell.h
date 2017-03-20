//
//  PhotoGroupViewCell.h
//  Naonao
//
//  Created by 刘敏 on 16/6/28.
//  Copyright © 2016年 深圳市轩腾华兴科技开发有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@class STPhotoPickerGroup;

@interface PhotoGroupViewCell : UITableViewCell

+ (PhotoGroupViewCell *)cellWithTableView:(UITableView *)tableView;

- (void)setCellWithCellInfo:(STPhotoPickerGroup *)group;

@end
