//
//  AnswerGoodsCell.m
//  Naonao
//
//  Created by 刘敏 on 16/6/3.
//  Copyright © 2016年 深圳市轩腾华兴科技开发有限公司. All rights reserved.
//

#import "AnswerGoodsCell.h"

@implementation AnswerGoodsCell

+ (AnswerGoodsCell *)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"AnswerGoodsCell";
    
    AnswerGoodsCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    //删除重用
    NSArray *subviews = [[NSArray alloc] initWithArray:cell.contentView.subviews];
    for (UIView *subview in subviews) {
        [subview removeFromSuperview];
    }
    
    
    cell = [[AnswerGoodsCell alloc ] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setUpChildView];
    }
    
    return self;
}


- (void)setUpChildView {
    
    //设置顶部
    PAboveView *aboveView = [[PAboveView alloc] init];
    self.aboveView = aboveView;
    [self.contentView addSubview:self.aboveView];
    
    //中间
    PCenterView *centerView = [[PCenterView alloc] init];
    self.centerView = centerView;
    self.centerView.userInteractionEnabled = YES;
    [self.contentView addSubview:self.centerView];
    
    //设置底部
    PGoodsView *goodsView = [[PGoodsView alloc] init];
    self.goodsView = goodsView;
    [self.contentView addSubview:self.goodsView];
    
    
    AnswerCommentsView *commentView = [[AnswerCommentsView alloc] init];
    self.commentView = commentView;
    self.commentView.userInteractionEnabled = YES;
    [self.contentView addSubview:self.commentView];
    
    AnswerToolbarView *toolbar = [[AnswerToolbarView alloc] init];
    self.toolbar = toolbar;
    self.toolbar.userInteractionEnabled = YES;
    [self.contentView addSubview:self.toolbar];

}


#pragma mark - 把模型中得frame赋给view
- (void)setAnFrame:(AnswerModeFrame *)anFrame
{
    _anFrame = anFrame;
    
    self.aboveView.anFrame = _anFrame;
    self.aboveView.frame = _anFrame.aboveFrame;
    
    self.centerView.anFrame = _anFrame;
    self.centerView.frame = _anFrame.centerFrame;
    
    self.goodsView.anFrame = _anFrame;
    self.goodsView.frame = _anFrame.bottomFrame;
    
    self.commentView.anFrame = _anFrame;
    self.commentView.frame = _anFrame.comFrame;
    
    self.toolbar.anFrame = _anFrame;
    self.toolbar.frame = _anFrame.toolsFrame;
}

@end
