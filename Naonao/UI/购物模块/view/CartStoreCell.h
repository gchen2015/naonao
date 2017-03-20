//
//  CartStoreCell.h
//  Naonao
//
//  Created by 刘敏 on 2016/9/23.
//  Copyright © 2016年 深圳市轩腾华兴科技开发有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GoodsOData.h"

@class CartStoreCell;
@protocol CartStoreCellDelegate <NSObject>

- (void)chooseBtnState:(BOOL)isSelected goodsClick:(NSInteger )mSection;

@end


@interface CartStoreCell : UITableViewCell

@property (nonatomic, weak) id<CartStoreCellDelegate> delegate;

+ (CartStoreCell *)cellWithTableView:(UITableView *)tableView;

- (void)setCellWithCellInfo:(StoreData *)store setChooseBtn:(BOOL)isSelected mSection:(NSInteger)section;

- (void)setCellWithCellOrderInfo:(StoreData *)store;

@end
