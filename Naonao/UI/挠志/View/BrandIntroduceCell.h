//
//  BrandIntroduceCell.h
//  Naonao
//
//  Created by 刘敏 on 2016/10/9.
//  Copyright © 2016年 深圳市轩腾华兴科技开发有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MagazineInfo.h"

@interface BrandIntroduceCell : UITableViewCell

@property (nonatomic,assign) CGFloat height;

+ (BrandIntroduceCell *)cellWithTableView:(UITableView *)tableView;

- (void)setCellWithCellInfo:(STBrand *)topic;

@end
