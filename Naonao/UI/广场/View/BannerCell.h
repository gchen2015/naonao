//
//  BannerCell.h
//  Naonao
//
//  Created by 刘敏 on 16/7/19.
//  Copyright © 2016年 深圳市轩腾华兴科技开发有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PageScrollView.h"

static const CGFloat Aspect_Ratio           =    184/375.0;                    //长宽比

@class BannerCell;

@protocol BannerCellDelegate <NSObject>
- (void)bannerCell:(BannerCell *)myCell imageViewClicked:(NSUInteger)mRow;
@end


@interface BannerCell : UITableViewCell
@property (nonatomic, weak) PageScrollView *pageView;
@property (nonatomic, weak) id<BannerCellDelegate> delegate;

+ (BannerCell *)cellWithTableView:(UITableView *)tableView;
- (void)setCellWithCellInfo:(NSArray *)array;

@end

