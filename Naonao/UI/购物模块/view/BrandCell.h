//
//  BrandCell.h
//  Naonao
//
//  Created by 刘敏 on 16/3/17.
//  Copyright © 2016年 深圳市轩腾华兴科技开发有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GoodsInfo.h"

@protocol BrandCellDelegate <NSObject>

- (void)brandCellJumpToBrandDetails;

@end



@interface BrandCell : UITableViewCell

@property (nonatomic, weak) id<BrandCellDelegate> delegate;

+ (BrandCell *)cellWithTableView:(UITableView *)tableView;

- (void)setCellWithCellInfo:(BrandInfo *)bInfo;

@end
