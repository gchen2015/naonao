//
//  RecommandCell.h
//  Naonao
//
//  Created by 刘敏 on 16/5/4.
//  Copyright © 2016年 深圳市轩腾华兴科技开发有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SquareModel.h"


@class RecommandCell;

@protocol RecommandCellDelegate <NSObject>

//购买按钮点击
- (void)recommandCell:(RecommandCell *)pView clickWithInfo:(SameModel *)sMode;

@end

@interface RecommandCell : UITableViewCell

@property (nonatomic, weak) id<RecommandCellDelegate> delegate;

+ (RecommandCell *)cellWithTableView:(UITableView *)tableView;

- (void)setCellWithCellInfo:(NSArray *)recommandArray;

@end
