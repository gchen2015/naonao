//
//  BannerCell.m
//  Naonao
//
//  Created by 刘敏 on 16/7/19.
//  Copyright © 2016年 深圳市轩腾华兴科技开发有限公司. All rights reserved.
//

#import "BannerCell.h"
#import "Masonry.h"


@interface BannerCell ()<PageScrollViewDelegate>



@end

@implementation BannerCell


+ (BannerCell *)cellWithTableView:(UITableView *)tableView{
    static NSString *ID = @"BannerCell";
    
    BannerCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[BannerCell alloc ] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
    
    }
    return self;
}

- (void)setCellWithCellInfo:(NSArray *)array
{
    PageScrollView *pageView = [PageScrollView pageScollView:array placeHolder:[UIImage imageNamed:@"default_image.png"]];
    _pageView = pageView;
    _pageView.delegate = self;
    [self addSubview:_pageView];
    
    [pageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(SCREEN_WIDTH * Aspect_Ratio);
        make.leading.top.trailing.equalTo(self);
    }];
}


#pragma mark  PageScrollViewDelegate
- (void)pageScollView:(PageScrollView *)pageScrollView imageViewClicked:(NSUInteger)mRow
{
    if (_delegate && [_delegate respondsToSelector:@selector(bannerCell:imageViewClicked:)]) {
        [_delegate bannerCell:self imageViewClicked:mRow];
    }
}


@end
