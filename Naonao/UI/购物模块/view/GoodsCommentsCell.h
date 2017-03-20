//
//  GoodsCommentsCell.h
//  Naonao
//
//  Created by 刘敏 on 16/4/25.
//  Copyright © 2016年 深圳市轩腾华兴科技开发有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GoodsInfo.h"
#import "CommentsModelFrame.h"

@protocol GoodsCommentsCellDelegate <NSObject>

//进入评论列表
- (void)goodsCommentsCellJumpToCommentsList;

@end

@interface GoodsCommentsCell : UITableViewCell

@property (nonatomic, weak) id<GoodsCommentsCellDelegate> delegate;

+ (GoodsCommentsCell *)cellWithTableView:(UITableView *)tableView;

- (CGFloat)setCellWithCellInfo:(CommentInfo *)cInfo commentNumber:(NSNumber *)commentsNum;

@end




@class CommentsProductCell;

@protocol CommentsProductCellDelegate <NSObject>

//进入个人中心
- (void)commentsProductCell:(CommentsProductCell *)cell tappedWithUserInfo:(CommentInfo *)tData;

@end

@interface CommentsProductCell : UITableViewCell

@property (nonatomic, weak) id<CommentsProductCellDelegate> delegate;

@property (nonatomic, strong) CommentsProductFrame *comFrame;

+ (CommentsProductCell *)cellWithTableView:(UITableView *)tableView;

@end