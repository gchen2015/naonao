//
//  WalletHeadCell.h
//  Naonao
//
//  Created by 刘敏 on 16/5/16.
//  Copyright © 2016年 深圳市轩腾华兴科技开发有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WithdrawModel.h"

@protocol WalletHeadCellDelegate <NSObject>

- (void)jumpWithdrawView;

@end


@interface WalletHeadCell : UITableViewCell

@property (nonatomic, weak) id<WalletHeadCellDelegate> delegate;

+ (WalletHeadCell *)cellWithTableView:(UITableView *)tableView;

- (void)setCellWithCellInfo:(WithdrawModel *)md;

@end
