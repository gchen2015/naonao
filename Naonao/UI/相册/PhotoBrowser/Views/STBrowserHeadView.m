//
//  STBrowserHeadView.m
//  Naonao
//
//  Created by 刘敏 on 16/6/26.
//  Copyright © 2016年 深圳市轩腾华兴科技开发有限公司. All rights reserved.
//

#import "STBrowserHeadView.h"

@interface STBrowserHeadView ()
@property (nonatomic, weak) UILabel *pageLabel;

@end

@implementation STBrowserHeadView

- (instancetype)initWithFrame:(CGRect)frame setShowType:(STShowImageType)showType
{
    if (self = [super initWithFrame:frame]) {
        [self initView:showType];
    }
    
    return self;
}

- (void)initView:(STShowImageType)showType {
    self.backgroundColor = [UIColor colorWithWhite:0.1 alpha:0.8];
    
    //返回按钮
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _backBtn = backBtn;
    [_backBtn setFrame:CGRectMake(-10.0f, 0.0f, 64, 64)];
    [_backBtn setImage:[UIImage imageNamed:@"nav_back_whitle.png"] forState:UIControlStateNormal];
    [self addSubview:_backBtn];
    
    //照片选择器
    if(showType == STShowImageTypeImagePicker){
        UIButton *selectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _selectBtn = selectBtn;
        
        [_selectBtn setFrame:CGRectMake(SCREEN_WIDTH - 40 - 10, 12, 40, 40)];
        [_selectBtn setImage:[UIImage imageNamed:@"icon_image_no_big.png"] forState:UIControlStateNormal];
        [_selectBtn setImage:[UIImage imageNamed:@"icon_image_yes_big.png"] forState:UIControlStateSelected];
        
        [self addSubview:_selectBtn];
    }
    
    //照片浏览器
    if(showType == STShowImageTypeImageBroswer){
        
        UILabel *pageLabel = [[UILabel alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - 160)/2, 12, 160, 44)];
        _pageLabel = pageLabel;
        _pageLabel.font = [UIFont boldSystemFontOfSize:19];
        _pageLabel.textAlignment = NSTextAlignmentCenter;
        _pageLabel.userInteractionEnabled = NO;
        _pageLabel.translatesAutoresizingMaskIntoConstraints = NO;
        _pageLabel.backgroundColor = [UIColor clearColor];
        _pageLabel.textColor = [UIColor whiteColor];
        [self addSubview:_pageLabel];
        
        //删除按钮
        UIButton *delectBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 40 - 10, 12, 40, 40)];
        _delectBtn = delectBtn;
        [_delectBtn setImage:[UIImage imageNamed:@"square_trash.png"] forState:UIControlStateNormal];
        [self addSubview:_delectBtn];

    }
    
    if (showType == STShowImageTypeImageURL) {
        UILabel *pageLabel = [[UILabel alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - 160)/2, 12, 160, 44)];
        _pageLabel = pageLabel;
        _pageLabel.font = [UIFont boldSystemFontOfSize:19];
        _pageLabel.textAlignment = NSTextAlignmentCenter;
        _pageLabel.userInteractionEnabled = NO;
        _pageLabel.translatesAutoresizingMaskIntoConstraints = NO;
        _pageLabel.backgroundColor = [UIColor clearColor];
        _pageLabel.textColor = [UIColor whiteColor];
        [self addSubview:_pageLabel];
    }
}

- (void)setTitle:(NSString *)title {
    _title = title;
    [_pageLabel setText:title];
}


@end
