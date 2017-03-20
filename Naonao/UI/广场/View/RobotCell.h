//
//  RobotCell.h
//  Naonao
//
//  Created by 刘敏 on 16/6/1.
//  Copyright © 2016年 深圳市轩腾华兴科技开发有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RobotCell;
@class RecommandDAO;
@protocol RobotCellDelegate <NSObject>

//点击商品图片购买
- (void)robotCell:(RobotCell *)cell buttonWithData:(RecommandDAO *)rDAO;

@end

@interface RobotCell : UITableViewCell

@property (nonatomic, weak) id<RobotCellDelegate> delegate;

+ (RobotCell *)cellWithTableView:(UITableView *)tableView;

- (void)setCellWithCellInfo:(NSArray *)array;

@end
