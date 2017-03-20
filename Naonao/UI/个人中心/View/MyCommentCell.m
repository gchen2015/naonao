//
//  MyCommentCell.m
//  Naonao
//
//  Created by 刘敏 on 16/8/6.
//  Copyright © 2016年 深圳市轩腾华兴科技开发有限公司. All rights reserved.
//

#import "MyCommentCell.h"

@interface MyCommentCell ()

@end

@implementation MyCommentCell

+ (MyCommentCell *)cellWithTableView:(UITableView *)tableView{
    static NSString *ID = @"MyCommentCell";
    
    MyCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[MyCommentCell alloc ] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setUpChildView];
    }
    
    return self;
}

- (void)setUpChildView{
    
}

@end
