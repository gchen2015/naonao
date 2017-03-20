//
//  MyCommentCell.h
//  Naonao
//
//  Created by 刘敏 on 16/8/6.
//  Copyright © 2016年 深圳市轩腾华兴科技开发有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyCommentModeFrame.h"

@interface MyCommentCell : UITableViewCell

@property (nonatomic, strong) MyCommentModeFrame *modeFrame;

+ (MyCommentCell *)cellWithTableView:(UITableView *)tableView;

@end
