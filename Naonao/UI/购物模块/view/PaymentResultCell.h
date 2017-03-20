//
//  PaymentResultCell.h
//  Naonao
//
//  Created by 刘敏 on 16/4/13.
//  Copyright © 2016年 深圳市轩腾华兴科技开发有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol PaymentResultCellDelegate <NSObject>

- (void)jumpToNextOrderDetails;

@end


@interface PaymentResultCell : UITableViewCell

@property (nonatomic, weak) id<PaymentResultCellDelegate> delegate;

+ (PaymentResultCell *)cellWithTableView:(UITableView *)tableView;

- (void)setCellWithCellInfo:(CGFloat)combinedAmount;

@end
