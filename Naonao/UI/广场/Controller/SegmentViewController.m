//
//  SegmentViewController.m
//  SegmentView
//
//  Created by tom.sun on 16/5/26.
//  Copyright © 2016年 tom.sun. All rights reserved.
//

#import "SegmentViewController.h"

#define HEADBTN_TAG                 10000
#define Default_BottomLineHeight    2
#define Default_ButtonHeight        40
#define Default_FontSize            15



@interface SegmentViewController ()<UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *headerView;
@property (nonatomic, strong) UIScrollView *mainScrollView;
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, assign) NSInteger selectIndex;

@end

@implementation SegmentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initSegment
{
    [self addButtonInScrollHeader:_titleArray];
    [self addContentViewScrollView:_subViewControllers];
}

/*!
 *  @brief  根据传入的title数组新建button显示在顶部scrollView上
 *
 *  @param titleArray  title数组
 */
- (void)addButtonInScrollHeader:(NSArray *)titleArray
{
    self.headerView.frame = CGRectMake(0, 64, SCREEN_WIDTH, self.buttonHeight);
    if (_segmentHeaderType == 0) {
        self.headerView.contentSize = CGSizeMake(self.buttonWidth * titleArray.count, self.buttonHeight);
    }
    else {
        self.headerView.contentSize = CGSizeMake(SCREEN_WIDTH, self.buttonHeight);
    }
    [self.view addSubview:self.headerView];
    
    //边界线
    UILabel *line = [[UILabel alloc ] initWithFrame:CGRectMake(0 , CGRectGetMaxY(self.headerView.frame) - 0.3, SCREEN_WIDTH, 0.3)];
    line.backgroundColor = LIGHT_BLACK_COLOR;
    [self.view bringSubviewToFront:line];
    [self.view addSubview:line];
    
    self.headerView.userInteractionEnabled = YES;
    
    for (NSInteger index = 0; index < titleArray.count; index++) {
        UIButton *segmentBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        
        segmentBtn.frame = CGRectMake(self.buttonWidth * index, 0, self.buttonWidth, self.buttonHeight);
        [segmentBtn setTitle:titleArray[index] forState:UIControlStateNormal];
        segmentBtn.titleLabel.font = [UIFont systemFontOfSize:self.fontSize];
        segmentBtn.tag = index + HEADBTN_TAG;
        [segmentBtn setTitleColor:self.titleColor forState:UIControlStateNormal];
        [segmentBtn setTitleColor:self.titleSelectedColor forState:UIControlStateSelected];
        [segmentBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.headerView addSubview:segmentBtn];

        
        if (index == 0) {
            segmentBtn.selected = YES;
            self.selectIndex = segmentBtn.tag;
        }
    }
    
    _lineView = [[UIView alloc] initWithFrame:CGRectMake(0, self.buttonHeight - self.bottomLineHeight, self.buttonWidth, self.bottomLineHeight)];
    _lineView.backgroundColor = self.bottomLineColor;
    [self.headerView addSubview:_lineView];
}

/*!
 *  @brief  根据传入的viewController数组，将viewController的view添加到显示内容的scrollView
 *
 *  @param subViewControllers  viewController数组
 */
- (void)addContentViewScrollView:(NSArray *)subViewControllers
{
    _mainScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, self.buttonHeight+64, SCREEN_WIDTH, SCREEN_HEIGHT - self.buttonHeight-64)];
    _mainScrollView.contentSize = CGSizeMake(SCREEN_WIDTH * subViewControllers.count, SCREEN_HEIGHT - self.buttonHeight-64);
    
    [_mainScrollView setPagingEnabled:YES];
    if (_segmentControlType == 0) {
        _mainScrollView.scrollEnabled = YES;
    }
    else {
        _mainScrollView.scrollEnabled = NO;
    }
    [_mainScrollView setShowsVerticalScrollIndicator:NO];
    [_mainScrollView setShowsHorizontalScrollIndicator:NO];
    _mainScrollView.bounces = NO;
    _mainScrollView.delegate = self;
    
    [self.view addSubview:_mainScrollView];
    [subViewControllers enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop){
        UIViewController *viewController = (UIViewController *)_subViewControllers[idx];
        viewController.view.frame = CGRectMake(idx * SCREEN_WIDTH, 0, SCREEN_WIDTH, _mainScrollView.frame.size.height);
        [_mainScrollView addSubview:viewController.view];
        [self addChildViewController:viewController];
    }];
}

- (void)addParentController:(UIViewController *)viewController
{
    if ([viewController respondsToSelector:@selector(edgesForExtendedLayout)])
    {
        viewController.edgesForExtendedLayout = UIRectEdgeNone;
    }
    [viewController addChildViewController:self];
    [viewController.view addSubview:self.view];
}

- (void)btnClick:(UIButton *)button
{
    [_mainScrollView scrollRectToVisible:CGRectMake((button.tag - HEADBTN_TAG) *SCREEN_WIDTH, 0, SCREEN_WIDTH, _mainScrollView.frame.size.height) animated:YES];
    [self didSelectSegmentIndex:button.tag];
}

/*!
 *  @brief  设置顶部选中button下方线条位置
 *
 *  @param index 第几个
 */
- (void)didSelectSegmentIndex:(NSInteger)index
{
    UIButton *btn = (UIButton *)[self.view viewWithTag:self.selectIndex];
    btn.selected = NO;
    self.selectIndex = index;
    UIButton *currentSelectBtn = (UIButton *)[self.view viewWithTag:index];
    currentSelectBtn.selected = YES;
    CGRect rect = self.lineView.frame;
    rect.origin.x = (index - HEADBTN_TAG) * _buttonWidth;
    
    [UIView animateWithDuration:0.3 animations:^{
        self.lineView.frame = rect;
    }];
}

#pragma mark - ScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (scrollView == _mainScrollView) {
        float xx = scrollView.contentOffset.x * (_buttonWidth / SCREEN_WIDTH) - _buttonWidth;
        [_headerView scrollRectToVisible:CGRectMake(xx, 0, SCREEN_WIDTH, _headerView.frame.size.height) animated:YES];
        NSInteger currentIndex = scrollView.contentOffset.x / SCREEN_WIDTH;
        [self didSelectSegmentIndex:currentIndex + HEADBTN_TAG];
    }
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView;
{
    float xx = scrollView.contentOffset.x * (_buttonWidth / SCREEN_WIDTH) - _buttonWidth;
    [_headerView scrollRectToVisible:CGRectMake(xx, 0, SCREEN_WIDTH, _headerView.frame.size.height) animated:YES];
}

#pragma mark - setter/getter
- (UIScrollView *)headerView
{
    if (_headerView == nil) {
        _headerView = [[UIScrollView alloc] init];
        [_headerView setShowsVerticalScrollIndicator:NO];
        [_headerView setShowsHorizontalScrollIndicator:NO];
        _headerView.bounces = NO;
        _headerView.backgroundColor = self.headViewBackgroundColor;
        
        
    }
    return _headerView;
}

- (UIColor *)headViewBackgroundColor
{
    if (_headViewBackgroundColor == nil) {
        _headViewBackgroundColor = [UIColor whiteColor];
    }
    return _headViewBackgroundColor;
}

- (UIColor *)titleColor
{
    if (_titleColor == nil) {
        _titleColor = BLACK_COLOR;
    }
    return _titleColor;
}

- (UIColor *)titleSelectedColor
{
    if (_titleSelectedColor == nil) {
        _titleSelectedColor = BLACK_COLOR;
    }
    return _titleSelectedColor;
}

- (CGFloat)fontSize
{
    if (_fontSize == 0) {
        _fontSize = Default_FontSize;
    }
    return _fontSize;
}

- (CGFloat)buttonWidth
{
    if (_buttonWidth == 0) {
        _buttonWidth = SCREEN_WIDTH / 6;
    }
    return _buttonWidth;
}

- (CGFloat)buttonHeight
{
    if (_buttonHeight == 0) {
        _buttonHeight = Default_ButtonHeight;
    }
    return _buttonHeight;
}

- (CGFloat)bottomLineHeight
{
    if (_bottomLineHeight == 0) {
        _bottomLineHeight = Default_BottomLineHeight;
    }
    return _bottomLineHeight;
}

- (UIColor *)bottomLineColor
{
    if (_bottomLineColor == nil) {
        _bottomLineColor = PINK_COLOR;
    }
    return _bottomLineColor;
}


@end
