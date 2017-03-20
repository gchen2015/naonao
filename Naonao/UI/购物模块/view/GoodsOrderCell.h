//
//  GoodsOrderCell.h
//  Naonao
//
//  Created by 刘敏 on 16/3/23.
//  Copyright © 2016年 深圳市轩腾华兴科技开发有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GoodsOData.h"


@interface GoodsOrderCell : UITableViewCell

+ (GoodsOrderCell *)cellWithTableView:(UITableView *)tableView;

- (void)setCellWithCellInfo:(GoodsOData *)goodsTData;

- (void)setCellWithOrderCellInfo:(SKUOrderModel *)sData;

@end
