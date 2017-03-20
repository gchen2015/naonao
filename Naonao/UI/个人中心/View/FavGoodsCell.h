//
//  FavGoodsCell.h
//  Naonao
//
//  Created by Richard Liu on 16/1/5.
//  Copyright © 2016年 深圳市轩腾华兴科技开发有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FavGoodsModel.h"

#define K_S_W   (SCREEN_WIDTH-15*3)/2.0f     //单个高度

@protocol FavGoodsCellDelegate;

@interface FavGoodsCell : UITableViewCell

@property (nonatomic, weak) id<FavGoodsCellDelegate> delegate;
+ (FavGoodsCell *)cellWithTableView:(UITableView *)tableView;

- (void)setCellWithCellInfo:(NSArray *)mArray;


@end

@protocol FavGoodsCellDelegate <NSObject>

- (void)goodsCell:(FavGoodsCell *)cell didSelectRowWithData:(FavGoodsModel *)cInfo;

@end
