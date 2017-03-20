//
//  BrandGoodsCell.h
//  Naonao
//
//  Created by 刘敏 on 2016/10/9.
//  Copyright © 2016年 深圳市轩腾华兴科技开发有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MagazineInfo.h"

@class BrandProViewController;
@interface BrandGoodsCell : UITableViewCell

@property (nonatomic, assign) CGFloat height;
@property (nonatomic, strong) BrandProViewController *rootVC;

+ (BrandGoodsCell *)cellWithTableView:(UITableView *)tableView;

- (void)setCellWithCellInfo:(STBrand *)topic;


@end
