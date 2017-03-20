//
//  RobotCell.m
//  Naonao
//
//  Created by 刘敏 on 16/6/1.
//  Copyright © 2016年 深圳市轩腾华兴科技开发有限公司. All rights reserved.
//

#import "RobotCell.h"
#import "RobotCard.h"


@interface RobotCell ()

@property (nonatomic, weak) UIScrollView *scrollView;
@property (nonatomic, weak) NSArray *goodsArray;
@end



@implementation RobotCell

+ (RobotCell *)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"RobotCell";
    
    RobotCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    cell = [[RobotCell alloc ] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setUpChildView];
        [self setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
    }
    
    return self;
}

- (void)setUpChildView{
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 270)];
    _scrollView = scrollView;
    _scrollView.backgroundColor = [UIColor clearColor];
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    [self.contentView addSubview:_scrollView];
}

- (void)setCellWithCellInfo:(NSArray *)array {
    
    _goodsArray = array;
    int i = 0;
    for (RecommandDAO *rDAO in array) {
        
        RobotCard *card = [[[NSBundle mainBundle] loadNibNamed:@"RobotCard" owner:nil options:nil] firstObject];
        [card setFrame:CGRectMake(12 + 198*i, 0, 186, 270)];
        [card setCradInfo:rDAO];
        card.tag = 1000+i;
        [_scrollView addSubview:card];
        
        //卡片点击
        _scrollView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(robotCardTapped:)];
        [card addGestureRecognizer:tap];
        
        i++;
    }
    
    CGFloat mW = 198*array.count+12;
    [_scrollView setContentSize:CGSizeMake(mW, 270)];
    [_scrollView setContentOffset:CGPointMake((mW - SCREEN_WIDTH)/2, 0) animated:NO];
}

- (void)robotCardTapped:(UITapGestureRecognizer *)recognizer
{
    //判断是否登录
    if (![UserLogic sharedInstance].user.basic.userId) {
        [theAppDelegate popLoginView];
        return;
    }

    RecommandDAO *rDAO = _goodsArray[recognizer.view.tag - 1000];
    
    if (_delegate && [_delegate respondsToSelector:@selector(robotCell:buttonWithData:)]) {
        [_delegate robotCell:self buttonWithData:rDAO];
    }

}


@end
