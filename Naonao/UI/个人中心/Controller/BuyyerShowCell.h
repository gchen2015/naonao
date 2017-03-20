//
//  BuyyerShowCell.h
//  Naonao
//
//  Created by 刘敏 on 2016/9/30.
//  Copyright © 2016年 深圳市轩腾华兴科技开发有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShowModel.h"

@class BuyyerShowCell;
@protocol BuyyerShowCellDelegate <NSObject>

- (void)buycell:(BuyyerShowCell *)cell clickImageIndex:(NSInteger)index cellWithRow:(NSInteger)row;

//商品点击
- (void)buycell:(BuyyerShowCell *)cell cellWithRow:(NSInteger)row;

@end

@interface BuyyerShowCell : UITableViewCell

@property (nonatomic, weak) id<BuyyerShowCellDelegate> delegate;
@property (nonatomic, assign) NSInteger mRow;

+ (BuyyerShowCell *)cellWithTableView:(UITableView *)tableView;

- (void)setCellWithCellInfo:(ShowModel *)mInfo;

@end
