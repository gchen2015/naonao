//
//  STTabBarController.m
//  Naonao
//
//  Created by Richard Liu on 15/11/20.
//  Copyright © 2015年 深圳市轩腾华兴科技开发有限公司. All rights reserved.
//

#import "STTabBarController.h"
#import "STNavigationController.h"
#import "NaonaoViewController.h"
#import "InformationViewController.h"
#import "GBrandViewController.h"
#import "GRudderViewController.h"
#import "MineViewController.h"
#import "LoginViewController.h"
#import "STMessageViewController.h"
#import "SquareViewController.h"
#import "DemandViewController.h"
#import "FigureGuideViewController.h"
#import "STTabBar.h"



@interface STTabBarController ()


@end


@implementation STTabBarController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //初始化
    [self initializeTabBarController];
    
    //设置文字颜色
    self.tabBar.tintColor = PINK_COLOR;

    //常规状态
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                       [UIColor colorWithHex:0xAAAAAA], NSForegroundColorAttributeName,
                                                       nil] forState:UIControlStateNormal];
    //选中状态
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                       PINK_COLOR, NSForegroundColorAttributeName,
                                                       nil] forState:UIControlStateSelected];
    
    
    
    //关闭磨砂效果
    self.tabBar.translucent = NO;
}

/*添加子控制器 */
- (void)initializeTabBarController{
    //播报
    NaonaoViewController *home = [[NaonaoViewController alloc] init];
    home.contentViewControllerArray = @[[InformationViewController class], [GBrandViewController class], [GRudderViewController class]];
    [self addChildViewController:home title:@"播报" image:@"tab_icon1_normal.png" selectedImage:@"tab_icon1_selcet.png"];
    
    //广场
    SquareViewController *rVC = [[SquareViewController alloc] init];
    [self addChildViewController:rVC title:@"问答" image:@"tab_icon2_normal.png" selectedImage:@"tab_icon2_selcet.png"];
    
    //消息
    STMessageViewController *sVC = [[STMessageViewController alloc] init];
    [self addChildViewController:sVC title:@"消息" image:@"tab_icon4_normal.png" selectedImage:@"tab_icon4_selcet.png"];
    
    //我的
    MineViewController *userVC = [[MineViewController alloc] init];
    [self addChildViewController:userVC title:@"我的" image:@"tab_icon5_normal.png" selectedImage:@"tab_icon5_selcet.png"];
}


#pragma mark 添加子控制器的方法
- (void)addChildViewController:(UIViewController *)childVc
                         title:(NSString*)title
                         image:(NSString*)image
                 selectedImage:(NSString*)selectedImage {
    
    // 始终绘制图片原始状态，不使用Tint Color,系统默认使用了Tint Color（灰色）
    [childVc.tabBarItem setImage:[[UIImage imageNamed:image] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [childVc.tabBarItem setSelectedImage:[UIImage imageNamed:selectedImage]];
    childVc.tabBarItem.title = title;
    
    STNavigationController *nav = [[STNavigationController alloc] initWithRootViewController:childVc];
    [self addChildViewController:nav];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
