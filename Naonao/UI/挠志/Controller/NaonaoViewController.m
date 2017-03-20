//
//  NaonaoViewController.m
//  Naonao
//
//  Created by 刘敏 on 16/7/26.
//  Copyright © 2016年 深圳市轩腾华兴科技开发有限公司. All rights reserved.
//

#import "NaonaoViewController.h"
#import "TitleScrollView.h"
#import "MagazineLogic.h"
#import "MagazineInfo.h"
#import "PageScrollView.h"
#import "GBaseViewController.h"
#import "DPWebViewController.h"
#import "DelegateContainer.h"
#import "BrandProViewController.h"
#import "MJRefresh.h"


static const CGFloat Aspect_Ratio    =    0.49;     //长宽比
static const CGFloat TIT_H           =    44.0;


@interface NaonaoViewController ()<UIDynamicAnimatorDelegate, PageScrollViewDelegate, TitleScrollViewDelegate, UIScrollViewDelegate>

//头部包含广告和分组菜单
@property (nonatomic, weak) UIView * headView;

// 头部视图的高度 （包含轮播 + toolview  toolview默认是44的高度）
@property (nonatomic, assign) CGFloat bannerViewHeight;
@property (nonatomic, strong) NSArray *bannerArray;             // 广告条数组

@property (nonatomic, weak) UIView *statuView;
@property (nonatomic, weak) TitleScrollView *titleView;

@property (nonatomic, weak) UIScrollView *mainScrollView;
@property (nonatomic, assign) CGFloat contentoffSetY;

//当前显示在屏幕当中的控制器
@property (nonatomic, strong) NSMutableArray * customDelegateArray;
@property (nonatomic, weak) GBaseViewController * currentShowContentController;

@end


@implementation NaonaoViewController

//懒加载
- (NSMutableArray *)customDelegateArray{
    if (_customDelegateArray == nil) {
        _customDelegateArray = [NSMutableArray array];
    }
    return _customDelegateArray;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //注册通知
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updateBanner)
                                                 name:@"Network_Connection_Normal"
                                               object:nil];

    _bannerViewHeight = Aspect_Ratio*SCREEN_WIDTH + TIT_H;
    _contentoffSetY = - self.bannerViewHeight;
    
    [self initContentViewController];
    
    _bannerArray = [[MagazineLogic sharedInstance] readHomeBanner];
    if (_bannerArray) {
        [self initBannerView];
    }
    
    
    [self getBannerList];
    [self initNaViBar];
    
    theAppDelegate.tabBarController.selectedIndex = 1;
}   

- (void)updateBanner {
    if (!_bannerArray) {
        [self getBannerList];
    }
}

- (void)initBannerView{
    _headView = [self.view viewWithTag:3000];
    
    if (!_headView) {
        UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, _bannerViewHeight)];
        _headView = headView;
        _headView.tag = 3000;
        [self.view addSubview:_headView];
    }
    else
        return;

    
    PageScrollView *pageView = [PageScrollView pageScollView:_bannerArray placeHolder:[UIImage imageNamed:@"default_image.png"]];
    pageView.delegate = self;
    [pageView setFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH * Aspect_Ratio)];
    [_headView addSubview:pageView];
    
    /** 滚动标题每个item的宽度  */
    NSArray *categoryTitles = [NSArray arrayWithObjects:@"资讯", @"品牌", @"舵主", nil];
    TitleScrollView *titleView = [[TitleScrollView alloc] initWithTitleArray:categoryTitles itemWidth:SCREEN_WIDTH/3.0];
    _titleView = titleView;
    [_titleView setFrame:CGRectMake(0, CGRectGetHeight(pageView.frame), SCREEN_WIDTH, TIT_H)];
    _titleView.delegate = self;
    [_headView addSubview:_titleView];

    [self.view bringSubviewToFront:_statuView];
}


- (void)getBannerList {
    __typeof (&*self) __weak weakSelf = self;
    
    [[MagazineLogic sharedInstance] getBannerList:nil withCallback:^(LogicResult *result) {
        if(result.statusCode == KLogicStatusSuccess)
        {
            _bannerArray = (NSArray *)result.mObject;
            [self initBannerView];
        }
        else
        {
            [weakSelf.view makeToast:result.stateDes];
        }
    }];
}

- (void)initNaViBar{
    UIView *statuView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 20)];
    _statuView = statuView;
    _statuView.backgroundColor = [UIColor whiteColor];
    _statuView.alpha = 0;
    [self.view addSubview:_statuView];
}

- (void)initContentViewController{
    UIScrollView * mainScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - Bottom_H)];
    _mainScrollView = mainScrollView;
    _mainScrollView.contentSize = CGSizeMake(SCREEN_WIDTH * self.contentViewControllerArray.count, SCREEN_HEIGHT - Bottom_H - 20);
    _mainScrollView.pagingEnabled = YES;
    _mainScrollView.delegate = self;
    _mainScrollView.bounces = NO;
    _mainScrollView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:_mainScrollView];
    
    // 这里可以优化成按需加载(也就是显示当当前页面了再显示)
    for (int index = 0; index < self.contentViewControllerArray.count; index++) {
        Class contentVC = self.contentViewControllerArray[index];
        GBaseViewController *tempVC = [[contentVC alloc] init];
        
        tempVC.tableViewEdinsets = UIEdgeInsetsMake(self.bannerViewHeight, 0, 0, 0);
        [self addChildViewController:tempVC];
        
        [_mainScrollView addSubview:tempVC.view];
        tempVC.view.frame = CGRectMake(SCREEN_WIDTH * index, 0, SCREEN_WIDTH, SCREEN_HEIGHT - Bottom_H);
        
        [tempVC.tableView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:(__bridge void * _Nullable)(tempVC)];
        
        // 让代理能够多对一
        DelegateContainer * container = [DelegateContainer containerDelegateWithFirst:self second:tempVC];
        [self.customDelegateArray addObject:container];
        tempVC.tableView.delegate = (id)container;
        
        if (index == 0) {
            self.currentShowContentController = tempVC;
        }
    }
}


- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary<NSString *,id> *)change
                       context:(void *)context
{
    if (context) {
        GBaseViewController * vc = (__bridge GBaseViewController *)context;
        
        CGFloat delta = self.bannerViewHeight + vc.tableView.contentOffset.y;
        if (delta < self.bannerViewHeight - TIT_H - 20) {
            self.headView.frame = CGRectMake(0, - delta, SCREEN_WIDTH, self.bannerViewHeight);
            self.contentoffSetY = vc.tableView.contentOffset.y;
            CGFloat scale = delta / (self.bannerViewHeight - TIT_H - 20);
            self.statuView.alpha = scale;
        }
        else{
            self.statuView.alpha = 1;
            self.headView.frame = CGRectMake(0, -(self.bannerViewHeight - TIT_H - 20), SCREEN_WIDTH, self.bannerViewHeight);
            self.contentoffSetY = - TIT_H - 20;
        }
    }
}

#pragma mark - tableView的代理
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (![scrollView isKindOfClass:[UITableView class]]) {
        for (GBaseViewController * tempVC in self.childViewControllers) {
            if (![tempVC isEqual:self.currentShowContentController]) {
                tempVC.tableView.contentOffset = CGPointMake(0, self.contentoffSetY);
            }
        }
    }
    else{

    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if (![scrollView isKindOfClass:[UITableView class]]) {
        int currentIndex = scrollView.contentOffset.x / SCREEN_WIDTH;
        self.currentShowContentController = self.childViewControllers[currentIndex];
        [self.titleView titleScrollViewScrollTo:currentIndex];
    }
}

#pragma mark  PageScrollViewDelegate
- (void)pageScollView:(PageScrollView *)pageScrollView imageViewClicked:(NSUInteger)mRow
{
    STBanInfo *sInfo = _bannerArray[mRow];
    if ([sInfo.type integerValue] == 1) {
        //进入web 页面
        
        DPWebViewController *dVC = [[DPWebViewController alloc] init];
        dVC.urlSting = sInfo.content;
        dVC.titName = sInfo.title;
        dVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:dVC animated:YES];
    }
    else if ([sInfo.type integerValue] == 2) {
        //进入品牌页面
        
        BrandProViewController *bVC = [[BrandProViewController alloc] init];
        bVC.brandID = [NSNumber numberWithInteger:[sInfo.content integerValue]];
        bVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:bVC animated:YES];
    }
}

#pragma titleScrollView delegate
- (void)didTitleScrollViewCliked:(TitleScrollView *)titleScrollView atIndex:(NSInteger)index {
    self.currentShowContentController = self.childViewControllers[index];
    for (GBaseViewController * tempVC in self.childViewControllers) {
        tempVC.tableView.contentOffset =  CGPointMake(0, self.contentoffSetY);
    }
    
    CGRect needShowRect = CGRectMake(index * SCREEN_WIDTH, 0, SCREEN_WIDTH, SCREEN_HEIGHT - Bottom_H);
    [self.mainScrollView scrollRectToVisible:needShowRect animated:YES];
}

#pragma  mark - 移除监听
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"Network_Connection_Normal" object:nil];

    for (GBaseViewController * contentVC in self.childViewControllers) {
        [contentVC.tableView removeObserver:self forKeyPath:@"contentOffset" context:(__bridge void * _Nullable)(contentVC.tableView)];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
