//
//  PraiseTableViewCell.h
//  Naonao
//
//  Created by 刘敏 on 16/8/19.
//  Copyright © 2016年 深圳市轩腾华兴科技开发有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PraiseMessageModeFrame.h"


@protocol PraiseTableViewCellDelegate <NSObject>

- (void)nickNameTapped:(NSNumber *)userID;

@end

@interface PraiseTableViewCell : UITableViewCell

@property (nonatomic, weak) id<PraiseTableViewCellDelegate> delegate;
@property (nonatomic, weak) PraiseMessageModeFrame *modeFrame;

+ (PraiseTableViewCell *)cellWithTableView:(UITableView *)tableView;

@end
