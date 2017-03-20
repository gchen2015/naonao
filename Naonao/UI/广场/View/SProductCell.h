//
//  SProductCell.h
//  Naonao
//
//  Created by Richard Liu on 16/2/1.
//  Copyright © 2016年 深圳市轩腾华兴科技开发有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProductModeFrame.h"
#import "PAboveView.h"
#import "PGoodsView.h"
#import "PCenterView.h"


@interface SProductCell : UITableViewCell

@property (nonatomic, strong) ProductModeFrame *proFrame;

@property (nonatomic, weak) PAboveView *aboveView;              //顶部
@property (nonatomic, weak) PCenterView *centerView;            //中部
@property (nonatomic, weak) PGoodsView *goodsView;              //商品


+ (SProductCell *)cellWithTableView:(UITableView *)tableView;

@end
