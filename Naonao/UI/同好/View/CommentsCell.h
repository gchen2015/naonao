//
//  CommentsCell.h
//  Naonao
//
//  Created by 刘敏 on 16/4/6.
//  Copyright © 2016年 深圳市轩腾华兴科技开发有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DynamicInfo.h"
#import "CommentsModelFrame.h"


@class CommentsCell;
@protocol CommentsCellDelegate <NSObject>

@required
//头像点击事件
- (void)commentsCell:(CommentsCell *)commentsCell useId:(NSNumber *)useId;

//发表评论
- (void)commentsCell:(CommentsCell *)commentsCell
    commentsWithInfo:(NSDictionary *)components
        indexWithRow:(NSUInteger)row;

@end

@interface CommentsCell : UITableViewCell

@property (nonatomic, weak) id<CommentsCellDelegate> delegate;

@property (nonatomic, strong) CommentsModelFrame *comModelFrame;
@property (nonatomic, assign) NSUInteger lineNO;

+ (CommentsCell *)cellWithTableView:(UITableView *)tableView;


@end
