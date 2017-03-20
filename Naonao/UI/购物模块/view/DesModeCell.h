//
//  DesModeCell.h
//  Naonao
//
//  Created by 刘敏 on 16/3/18.
//  Copyright © 2016年 深圳市轩腾华兴科技开发有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DesModeFrame.h"
#import "DesModeView.h"

@interface DesModeCell : UITableViewCell

@property (nonatomic, strong) DesModeFrame *desFrame;
@property (nonatomic, weak) DesModeView *desView;

+ (DesModeCell *)cellWithTableView:(UITableView *)tableView;

@end
