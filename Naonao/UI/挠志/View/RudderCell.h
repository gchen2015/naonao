//
//  RudderCell.h
//  Naonao
//
//  Created by 刘敏 on 16/7/26.
//  Copyright © 2016年 深圳市轩腾华兴科技开发有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RudderModeFrame.h"


@interface RudderCell : UITableViewCell

@property (nonatomic, weak) RudderModeFrame *modeFrame;

+ (RudderCell *)cellWithTableView:(UITableView *)tableView;


@end
