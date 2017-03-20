//
//  CommentsHeadCell.h
//  Naonao
//
//  Created by 刘敏 on 16/4/6.
//  Copyright © 2016年 深圳市轩腾华兴科技开发有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DynamicInfo.h"

@protocol CommentsHeadCellDelegate <NSObject>

//点击商品
- (void)commentsHeadCellClickGoods;

@end


@interface CommentsHeadCell : UITableViewCell

@property (nonatomic, weak) id<CommentsHeadCellDelegate> delegate;

+ (CommentsHeadCell *)cellWithTableView:(UITableView *)tableView;

- (CGFloat)setCellWithCellInfo:(DynamicInfo *)pInfo;

@end
