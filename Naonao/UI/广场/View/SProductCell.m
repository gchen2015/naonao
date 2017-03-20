//
//  SProductCell.m
//  Naonao
//
//  Created by Richard Liu on 16/2/1.
//  Copyright © 2016年 深圳市轩腾华兴科技开发有限公司. All rights reserved.
//

#import "SProductCell.h"

@implementation SProductCell


+ (SProductCell *)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"SProductCell";
    
    SProductCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    //删除重用
    NSArray *subviews = [[NSArray alloc] initWithArray:cell.contentView.subviews];
    for (UIView *subview in subviews) {
        [subview removeFromSuperview];
    }
    
    
    cell = [[SProductCell alloc ] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    
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
    [self.contentView addSubview:self.centerView];
    
    //设置底部
    PGoodsView *goodsView = [[PGoodsView alloc] init];
    self.goodsView = goodsView;
    [self.contentView addSubview:self.goodsView];
}


#pragma mark - 把模型中得frame赋给view
- (void)setProFrame:(ProductModeFrame *)proFrame{
    
    _proFrame = proFrame;
    
    self.aboveView.proFrame = _proFrame;
    self.aboveView.frame = _proFrame.aboveFrame;
    
    self.centerView.proFrame = _proFrame;
    self.centerView.frame = _proFrame.centerFrame;
    
    self.goodsView.proFrame = _proFrame;
    self.goodsView.frame = _proFrame.bottomFrame;
}



@end
