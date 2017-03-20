//
//  ReGoodsCell.h
//  Naonao
//
//  Created by 刘敏 on 16/6/3.
//  Copyright © 2016年 深圳市轩腾华兴科技开发有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TagsMode.h"


@protocol ReGoodsCellDelegate <NSObject>

- (void)imageTapped:(GoodsMode *)mode;

@end


@interface ReGoodsCell : UITableViewCell

@property (nonatomic, weak) id<ReGoodsCellDelegate> delegate;

+ (ReGoodsCell *)cellWithTableView:(UITableView *)tableView;

- (void)setCellWithCellInfo:(GoodsMode *)mode;

@end
