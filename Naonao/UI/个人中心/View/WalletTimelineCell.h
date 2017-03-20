//
//  WalletTimelineCell.h
//  Naonao
//
//  Created by 刘敏 on 16/5/18.
//  Copyright © 2016年 深圳市轩腾华兴科技开发有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WithdrawModel.h"

@interface WalletTimelineCell : UITableViewCell

+ (WalletTimelineCell *)cellWithTableView:(UITableView *)tableView;

- (void)setCellWithCellWPInfo:(WPayTimeline *)pInfo;

- (void)setCellWithCellWSInfo:(WShowTimeline *)showTime;

- (void)updateDotView;

@end
