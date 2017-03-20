//
//  AnswerFirstCell.h
//  Naonao
//
//  Created by 刘敏 on 16/6/1.
//  Copyright © 2016年 深圳市轩腾华兴科技开发有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SquareModel.h"
#import "AnswerFirstModeFrame.h"

#define CELL_RATIO_ASPECT  114.0f

@protocol AnswerFirstCellDelegate <NSObject>

//添加答案
- (void)jumpToSearchView;

- (void)headTapped;

@end


@interface AnswerFirstCell : UITableViewCell

@property (nonatomic, weak) AnswerFirstModeFrame *anModeFrame;
@property (nonatomic, weak) UIButton *answerBtn;
@property (nonatomic, weak) id<AnswerFirstCellDelegate> delegate;

+ (AnswerFirstCell *)cellWithTableView:(UITableView *)tableView;


@end
