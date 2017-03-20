//
//  FocusCell.h
//  Naonao
//
//  Created by 刘敏 on 16/7/21.
//  Copyright © 2016年 深圳市轩腾华兴科技开发有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"

@class FocusCell;
@protocol FocusCellDelegate <NSObject>

- (void)focusCell:(FocusCell *)mCell headBtnTapped:(NSNumber *)userId;

@end



@interface FocusCell : UITableViewCell

@property (nonatomic, weak) id<FocusCellDelegate> delegate;
@property (nonatomic, assign) NSUInteger mIndex;                    //1为关注， 2为粉丝

+ (FocusCell *)cellWithTableView:(UITableView *)tableView;

- (void)setCellWithCellInfo:(UserFollow *)fInfo;

@end
