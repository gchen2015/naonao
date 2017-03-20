//
//  MineHeadCell.h
//  Naonao
//
//  Created by 刘敏 on 16/7/19.
//  Copyright © 2016年 深圳市轩腾华兴科技开发有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MineHeadCell;

@protocol MineHeadCellDelegate <NSObject>

@optional

- (void)mineHeadView:(MineHeadCell *)mycell bTnIndex:(NSInteger) index;

//头像点击
- (void)mineHeadTapped;


@end


@interface MineHeadCell : UITableViewCell

@property (nonatomic, weak) id<MineHeadCellDelegate> delegate;

+ (MineHeadCell *)cellWithTableView:(UITableView *)tableView;

- (void)updateUI;

@end
