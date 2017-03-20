//
//  STContentCell.h
//  Naonao
//
//  Created by 刘敏 on 16/4/14.
//  Copyright © 2016年 深圳市轩腾华兴科技开发有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol STContentCellDelegate <NSObject>

- (void)updateUI:(BOOL)isLeft;

@end

@interface STContentCell : UITableViewCell

@property (nonatomic, weak) id<STContentCellDelegate> delegate;

+ (STContentCell *)cellWithTableView:(UITableView *)tableView;

- (CGFloat)setCellWithCellInfo:(BOOL)isLeft;

@end


@interface STInterBtn : UIButton

- (instancetype)initWithFrame:(CGRect)frame
                     setTitle:(NSString *)tit
                  normalImage:(NSString *)imageN
                selectedImage:(NSString *)imageS;

@end

