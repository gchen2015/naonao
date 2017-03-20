//
//  RecommandCell.m
//  Naonao
//
//  Created by 刘敏 on 16/5/4.
//  Copyright © 2016年 深圳市轩腾华兴科技开发有限公司. All rights reserved.
//

#import "RecommandCell.h"
#import "STSameModeView.h"
#import "UILabel+Extension.h"

@interface RecommandCell ()

@property (nonatomic, weak) UILabel *lA;
@property (nonatomic, weak) UIImageView *lineA;

@property (nonatomic, weak) UIScrollView *scrollView;

@end


@implementation RecommandCell

+ (RecommandCell *)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"RecommandCell";
    
    RecommandCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[RecommandCell alloc ] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
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

- (void)setUpChildView
{
    /********************************  搭配推荐  *********************************/
    UILabel *lA = [[UILabel alloc] initWithTitle:@"搭配推荐" textColor:LIGHT_BLACK_COLOR];
    _lA = lA;
    [_lA setFrame:CGRectMake(SCREEN_WIDTH/2 - 30, 10, 60, 18)];
    [_lA setFont:[UIFont systemFontOfSize:14.0]];
    [_lA setTextAlignment:NSTextAlignmentCenter];
    [self.contentView addSubview:_lA];
    
    
    UIImageView *lineA = [[UIImageView alloc] init];
    _lineA = lineA;
    [_lineA setFrame:CGRectMake((SCREEN_WIDTH -230)/2, 19, 230, 0.5)];
    [_lineA setImage:[UIImage imageNamed:@"line_bg3.png"]];
    [self.contentView addSubview:_lineA];
    
    
    
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    _scrollView = scrollView;
    [_scrollView setFrame:CGRectMake(0, 39, SCREEN_WIDTH, 200)];
    _scrollView.backgroundColor = [UIColor clearColor];
    _scrollView.showsHorizontalScrollIndicator = YES;
    _scrollView.showsVerticalScrollIndicator = NO;
    [self.contentView addSubview:_scrollView];

}


- (void)setCellWithCellInfo:(NSArray *)recommandArray
{
    int i = 0;
    
    //间距为8，图片130*130
    
    //设置滚动区域
    [_scrollView setContentSize:CGSizeMake(8+145*recommandArray.count, CGRectGetHeight(_scrollView.frame))];
    
    __typeof (&*self) __weak weakSelf = self;
    
    for (SameModel *sMode in recommandArray) {
        STSameModeView *sV = [[STSameModeView alloc] initWithFrame:CGRectMake(8+145*i, 2, 130, 130)];
        [sV setInfo:sMode];
        
        [sV sameModeViewClick:^(SameModel *result) {
            [weakSelf clickSameProduct:result];
        }];
        
        [_scrollView addSubview:sV];
        i++;
    }
}

- (void)clickSameProduct:(SameModel *)model
{
    if (_delegate && [_delegate respondsToSelector:@selector(recommandCell:clickWithInfo:)]) {
        [_delegate recommandCell:self clickWithInfo:model];
    }
}


@end
