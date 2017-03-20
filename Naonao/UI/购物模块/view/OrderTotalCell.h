//
//  OrderTotalCell.h
//  Naonao
//
//  Created by 刘敏 on 16/3/27.
//  Copyright © 2016年 深圳市轩腾华兴科技开发有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GoodsOData.h"


@class OrderTotalCell;
@protocol OrderTotalCellDelegate <NSObject>

@optional

- (void)orderTotalCellWithbuttonType:(OrderBtnType)btnType cellWithOrderID:(OrderModel *)oData lineNO:(NSUInteger)row;

@end


@interface OrderTotalCell : UITableViewCell

@property (nonatomic, weak) id<OrderTotalCellDelegate> delegate;

@property (nonatomic, assign) NSUInteger lineNO;

+ (OrderTotalCell *)cellWithTableView:(UITableView *)tableView;

- (void)setCellWithOrderTotalCellInfo:(OrderModel *)oData;

@end
