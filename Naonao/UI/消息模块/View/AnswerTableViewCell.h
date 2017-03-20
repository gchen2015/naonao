//
//  AnswerTableViewCell.h
//  Naonao
//
//  Created by 刘敏 on 16/8/21.
//  Copyright © 2016年 深圳市轩腾华兴科技开发有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AnswerMessageModeFrame.h"


@protocol AnswerTableViewCellDelegate <NSObject>

- (void)nickNameTapped:(NSNumber *)userID;

@end

@interface AnswerTableViewCell : UITableViewCell

@property (nonatomic, weak) id<AnswerTableViewCellDelegate> delegate;
@property (nonatomic, weak) AnswerMessageModeFrame *modeFrame;

+ (AnswerTableViewCell *)cellWithTableView:(UITableView *)tableView;

@end
