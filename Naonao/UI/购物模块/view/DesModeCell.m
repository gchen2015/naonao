//
//  DesModeCell.m
//  Naonao
//
//  Created by 刘敏 on 16/3/18.
//  Copyright © 2016年 深圳市轩腾华兴科技开发有限公司. All rights reserved.
//

#import "DesModeCell.h"

@implementation DesModeCell

+ (DesModeCell *)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"DesModeCell";
    
    DesModeCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    //删除重用
    NSArray *subviews = [[NSArray alloc] initWithArray:cell.contentView.subviews];
    for (UIView *subview in subviews) {
        [subview removeFromSuperview];
    }
    
    cell = [[DesModeCell alloc ] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.userInteractionEnabled = YES;
        self.contentView.userInteractionEnabled = YES;
        [self setUpChildView];
    }
    
    return self;
}

- (void)setUpChildView {
    //设置顶部
    DesModeView *desView = [[DesModeView alloc] init];
    self.desView = desView;
    [self.contentView addSubview:self.desView];
}

#pragma mark - 把模型中得frame赋给view
- (void)setDesFrame:(DesModeFrame *)desFrame{
    
    _desFrame = desFrame;
    self.desView.desFrame = _desFrame;
    self.desView.frame = _desFrame.modeFrame;
}


@end
