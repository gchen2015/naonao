//
//  STPopViewController.m
//  Naonao
//
//  Created by 刘敏 on 16/3/18.
//  Copyright © 2016年 深圳市轩腾华兴科技开发有限公司. All rights reserved.
//

#import "STPopViewController.h"
#import "ShopCartViewController.h"
#import "STNavigationController.h"

@interface STPopViewController ()

// maskView
@property(nonatomic, strong) UIView * maskView;

@end

@implementation STPopViewController

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"OPEN_SKU" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"CLOSE_SKU" object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //注册消息
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showVC) name:@"OPEN_SKU" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(closeVC) name:@"CLOSE_SKU" object:nil];
}

// 是否可右滑返回
- (void)navigationCanDragBack:(BOOL)canDragBack
{
    if (self.navigationController)
    {
        [((STNavigationController *)(self.navigationController)) navigationCanDragBack:canDragBack];
    }
}

- (void)createPopVCWithRootVC:(UIViewController *)rootVC andPopView:(GoodsCategoryView *)popView
{
    _rootVC = rootVC;
    _popView = popView;
    
    [self createUI];
}

- (void)createUI
{
    self.view.backgroundColor = [UIColor blackColor];
    
    _rootVC.view.frame = self.view.bounds;
    _rootVC.view.backgroundColor = [UIColor whiteColor];
    
    _rootView = _rootVC.view;
    [self addChildViewController:_rootVC];
    [self.view addSubview:_rootView];
    
    //rootVC上的maskView
    _maskView = ({
        UIView * maskView = [[UIView alloc]initWithFrame:self.view.bounds];
        maskView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.7];
        maskView.alpha = 0;
        
        maskView;
    });
    
    [_rootView addSubview:_maskView];
}

// 显示SKU
- (void)showVC
{
    //关闭右滑返回
    [self navigationCanDragBack:NO];
    
    [[UIApplication sharedApplication].windows[0] addSubview:_popView];
    
    CGRect frame = _popView.frame;
    frame.origin.y = self.view.bounds.size.height - _popView.frame.size.height;
    
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        
        [_rootView.layer setTransform:[self firstTransform]];
        
    } completion:^(BOOL finished) {
        
        [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            
            [_rootView.layer setTransform:[self secondTransform]];
            //显示maskView
            [_maskView setAlpha:0.5f];
            //popView上升
            _popView.frame = frame;
            
        } completion:^(BOOL finished) {
            
        }];
        
    }];
}

// 关闭SKU
- (void)closeVC {
    //开启右滑返回
    [self navigationCanDragBack:YES];
    
    CGRect frame = _popView.frame;
    frame.origin.y += _popView.frame.size.height;
    
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        
        //maskView隐藏
        [_maskView setAlpha:0.f];
        //popView下降
        _popView.frame = frame;
        
        //同时进行 感觉更丝滑
        [_rootView.layer setTransform:[self firstTransform]];
        
    } completion:^(BOOL finished) {
        
        [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            //变为初始值
            [_rootView.layer setTransform:CATransform3DIdentity];
            
        } completion:^(BOOL finished) {
            
            //移除
            [_popView removeFromSuperview];
        }];
        
    }];
}

- (CATransform3D)firstTransform {
    CATransform3D t1 = CATransform3DIdentity;
    t1.m34 = 1.0/-900;
    //带点缩小的效果
    t1 = CATransform3DScale(t1, 0.95, 0.95, 1);
    //绕x轴旋转
    t1 = CATransform3DRotate(t1, 15.0 * M_PI/180.0, 1, 0, 0);
    return t1;
    
}

- (CATransform3D)secondTransform {
    CATransform3D t2 = CATransform3DIdentity;
    t2.m34 = [self firstTransform].m34;
    //向上移
    t2 = CATransform3DTranslate(t2, 0, self.view.frame.size.height * (-0.08), 0);
    //第二次缩小
    t2 = CATransform3DScale(t2, 0.8, 0.8, 1);
    return t2;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
