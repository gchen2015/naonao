//
//  ShopCartCell.h
//  Naonao
//
//  Created by 刘敏 on 16/3/24.
//  Copyright © 2016年 深圳市轩腾华兴科技开发有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GoodsOData.h"

@protocol ShopCartCellDelegate <NSObject>

@optional
- (void)chooseProduct:(BOOL)isSelected chooseWithInfo:(GoodsOData *)goodsTData goodsClick:(NSIndexPath *)indexPath;

- (void)goodsClick:(GoodsOData *)goodsTData;

- (void)updateShopCart;

@end

@interface ShopCartCell : UITableViewCell

@property (nonatomic, weak) id<ShopCartCellDelegate> delegate;
@property (nonatomic, strong) NSIndexPath *indexPath;

+ (ShopCartCell *)cellWithTableView:(UITableView *)tableView;

- (void)setCellWithCellInfo:(GoodsOData *)goodsTData setChooseBtn:(BOOL)isSelected isEdit:(BOOL)isEdit;

@end
