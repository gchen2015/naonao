//
//  FigureGuideViewController.m
//  Naonao
//
//  Created by 刘敏 on 16/6/13.
//  Copyright © 2016年 深圳市轩腾华兴科技开发有限公司. All rights reserved.
//

#import "FigureGuideViewController.h"
#import "STShapeViewController.h"
#import "UserLogic.h"

@implementation FigureGuideViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setNavBarTitle:@"我的身材信息"];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    if (_isPOP) {
        [self setNavBarLeftBtn:[STNavBarView createImgNaviBarBtnByImgNormal:@"icon_close.png"
                                                               imgHighlight:@"icon_close_highlighted.png"
                                                                     target:self
                                                                     action:@selector(close:)]];
        
        [UserLogic sharedInstance].isPOP = YES;
    }
    else
        [UserLogic sharedInstance].isPOP = NO;
        
    [_labelA setTextColor:BLACK_COLOR];
    [_labelB setTextColor:BLACK_COLOR];
    [_labelData setTextColor:BLACK_COLOR];
    [_labelC setTextColor:BLACK_COLOR];
    
    
    
    //继续按钮
    UIButton *nextBtn = [[UIButton alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-116)/2, SCREEN_HEIGHT - 50, 116, 36)];
    [nextBtn setTitle:@"马上开始" forState:UIControlStateNormal];
    [nextBtn setTitleColor:PINK_COLOR forState:UIControlStateNormal];
    [nextBtn.titleLabel setFont:[UIFont systemFontOfSize:18.0]];
    [nextBtn addTarget:self action:@selector(nextBtnTapped:) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIImageView *arrowV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_triangle.png"]];
    [arrowV setFrame:CGRectMake(0, 0, 14, 15)];
    CGPoint mCenter = nextBtn.center;
    mCenter.x = nextBtn.center.x + 45;
    arrowV.center = mCenter;
    arrowV.center = mCenter;
    
    [self.view addSubview:arrowV];
    [self.view addSubview:nextBtn];
}


- (void)close:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:NULL];
    [UserLogic sharedInstance].isPOP = NO;
}


- (IBAction)nextBtnTapped:(id)sender{
    STShapeViewController *sVC = CREATCONTROLLER(STShapeViewController);
    [self.navigationController pushViewController:sVC animated:YES];
}

@end
