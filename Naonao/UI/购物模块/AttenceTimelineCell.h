//
//  AttenceTimelineCell.h
//  Naonao
//
//  Created by 刘敏 on 16/4/11.
//  Copyright © 2016年 深圳市轩腾华兴科技开发有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AddressInfo.h"

@interface AttenceTimelineCell : UITableViewCell

@property (nonatomic, assign) CGFloat mH;

+ (AttenceTimelineCell *)cellWithTableView:(UITableView *)tableView;

- (void)setCellWithCellInfo:(AcceptStation *)aInfo row:(NSInteger)mRow;

@end
