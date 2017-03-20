//
//  AnswerGoodsCell.h
//  Naonao
//
//  Created by 刘敏 on 16/6/3.
//  Copyright © 2016年 深圳市轩腾华兴科技开发有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AnswerModeFrame.h"
#import "PAboveView.h"
#import "PGoodsView.h"
#import "PCenterView.h"
#import "AnswerCommentsView.h"
#import "AnswerToolbarView.h"


@interface AnswerGoodsCell : UITableViewCell

@property (nonatomic, strong) AnswerModeFrame *anFrame;

@property (nonatomic, weak) PAboveView *aboveView;              //顶部
@property (nonatomic, weak) PCenterView *centerView;            //中部
@property (nonatomic, weak) PGoodsView *goodsView;              //商品
@property (nonatomic, weak) AnswerCommentsView *commentView;
@property (nonatomic, weak) AnswerToolbarView *toolbar;


+ (AnswerGoodsCell *)cellWithTableView:(UITableView *)tableView;

@end
