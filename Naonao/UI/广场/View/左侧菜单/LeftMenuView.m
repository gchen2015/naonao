//
//  LeftMenuView.m
//  Naonao
//
//  Created by 刘敏 on 16/7/25.
//  Copyright © 2016年 深圳市轩腾华兴科技开发有限公司. All rights reserved.
//

#import "LeftMenuView.h"
#import "DemandLogic.h"
#import "TipMenuView.h"
#import "SquareLogic.h"

#define width_ratio    0.72

@interface LeftMenuView ()

@property (nonatomic, weak) UIView *innerView;
@property (nonatomic, weak) UIScrollView *scrollView;

@end

@implementation LeftMenuView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        // Initialization code
        [self setBackgroundColor:[UIColor colorWithWhite:0.0 alpha:0.5]];
        UIView *innerView = [[UIView alloc] initWithFrame:CGRectMake(-SCREEN_WIDTH*width_ratio, 0, SCREEN_WIDTH*width_ratio, SCREEN_HEIGHT)];
        _innerView = innerView;
        [_innerView setBackgroundColor:[UIColor whiteColor]];
        [self addSubview:_innerView];
        
        
        //触摸区域
        UIView *tapView = [[UIView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH*width_ratio, 0, SCREEN_WIDTH-SCREEN_WIDTH*width_ratio, SCREEN_HEIGHT)];
        tapView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideView)];
        [tapView addGestureRecognizer:tap];
        [self addSubview:tapView];
        
        
        [self showView];

        [self drawScrollView];
        [self initBottomView];
    }
    return self;
}

// 添加底部购买按钮和加入购物车按钮的view
- (void)initBottomView {
    UIView* view = [[UIView alloc] init];
    view.frame = CGRectMake(0, SCREEN_HEIGHT - Bottom_H, CGRectGetWidth(_innerView.frame), Bottom_H);
    view.backgroundColor = [UIColor whiteColor];

    //重置
    UIButton* resetBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(_innerView.frame)/2, Bottom_H)];
    [resetBtn setTitle:@"重置" forState:UIControlStateNormal];
    [resetBtn.titleLabel setFont:[UIFont systemFontOfSize:17.0]];
    [resetBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [resetBtn setBackgroundImage:[UIImage imageNamed:@"btn_whitle_1.png"] forState:UIControlStateNormal];
    [resetBtn setBackgroundImage:[UIImage imageNamed:@"btn_grey.png"] forState:UIControlStateHighlighted];
    [resetBtn setBackgroundImage:[UIImage imageNamed:@"btn_grey.png"] forState:UIControlStateSelected];
    [resetBtn addTarget:self action:@selector(resetBtnTapped:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:resetBtn];
    
    //完成
    UIButton* doneBtn = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetWidth(_innerView.frame)/2, 0, CGRectGetWidth(_innerView.frame)/2, Bottom_H)];
    [doneBtn setTitle:@"完成" forState:UIControlStateNormal];
    [doneBtn.titleLabel setFont:[UIFont systemFontOfSize:17.0]];
    [doneBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [doneBtn setBackgroundImage:[UIImage imageNamed:@"ST_btn_11.png"] forState:UIControlStateNormal];
    [doneBtn setBackgroundImage:[UIImage imageNamed:@"ST_btn_4.png"] forState:UIControlStateHighlighted];
    [doneBtn setBackgroundImage:[UIImage imageNamed:@"ST_btn_4.png"] forState:UIControlStateSelected];
    [doneBtn addTarget:self action:@selector(doneBtnTapped:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:doneBtn];
    
    [_innerView addSubview:view];
    
    UILabel *lineV = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(_innerView.frame), 0.5)];
    [lineV setBackgroundColor:LIGHT_BLACK_COLOR];
    [view addSubview:lineV];
}

- (void)drawScrollView
{
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 20, CGRectGetWidth(_innerView.frame), SCREEN_HEIGHT - Bottom_H - 20)];
    _scrollView = scrollView;
    //分页
    _scrollView.pagingEnabled = YES;
    _scrollView.showsVerticalScrollIndicator = YES;
    _scrollView.bounces = YES;                      //反弹属性
    [_scrollView setBackgroundColor:[UIColor whiteColor]];
    [_innerView addSubview:_scrollView];
    
    
    CGFloat mH = 0;
    //标签
    for (int i = 0; i< 3; i++) {
        TipMenuView *skV = [[TipMenuView alloc] initWithFrame:CGRectMake(0, mH, CGRectGetWidth(_scrollView.frame), 0)];
        CGRect mG = skV.frame;
        skV.tag = 100+i;
        
        if (i == 0) {
            //品类
            mG.size.height = [skV setMenuWithskuMenuData:[DemandLogic sharedInstance].categoryArray titleN:@"品类" tag:i];
        }
        
        if (i == 1) {
            //场景
            mG.size.height = [skV setMenuWithskuMenuData:[DemandLogic sharedInstance].sceneArray titleN:@"场景" tag:i];
        }
        
        if (i == 2) {
            //风格
            mG.size.height = [skV setMenuWithskuMenuData:[DemandLogic sharedInstance].styleArray titleN:@"风格" tag:i];
        }

        [skV setFrame:mG];
        [_scrollView addSubview:skV];
        
        mH += mG.size.height;
    }

    [_scrollView setContentSize:CGSizeMake(0, mH)];
}


- (void)showView {
    //移动动画
    [UIView beginAnimations:@"showView" context:nil];
    [UIView setAnimationDuration:0.4];
    [UIView setAnimationDelegate:self];
    //改变它的frame的x,y的值
    _innerView.frame = CGRectMake(0, 0, SCREEN_WIDTH*width_ratio, SCREEN_HEIGHT);
    
    [UIView commitAnimations];
}

- (void)hideView {
    //移动动画
    [UIView beginAnimations:@"hideView" context:nil];
    [UIView setAnimationDuration:0.4];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(innerViewClose)];
    //改变它的frame的x,y的值
    _innerView.frame = CGRectMake(-SCREEN_WIDTH*width_ratio, 0, SCREEN_WIDTH*width_ratio, SCREEN_HEIGHT);
    
    [UIView commitAnimations];
}


- (void)innerViewClose {
    if (_delegate && [_delegate respondsToSelector:@selector(setHideMenuView)]){
        [_delegate setHideMenuView];
    }
}

//重置
- (void)resetBtnTapped:(id)sender {
    
    for (int i = 0; i< 3; i++) {
        TipMenuView *skV = (TipMenuView*) [_scrollView viewWithTag:(100+i)];
        [skV reductionMenuView];
    }
    
    //还原数据
    FilterData *fData = [SquareLogic sharedInstance].fData;
    fData.category = nil;
    fData.scene = nil;
    fData.style = nil;

    [[NSNotificationCenter defaultCenter] postNotificationName:@"UPDATE_FILTER_CONDITIONS" object:nil];

}

//完成
- (void)doneBtnTapped:(id)sender {
    [self hideView];
}

@end
