//
//  STBodyViewController.m
//  Naonao
//
//  Created by 刘敏 on 16/6/14.
//  Copyright © 2016年 深圳市轩腾华兴科技开发有限公司. All rights reserved.
//

#import "STBodyViewController.h"
#import "STBodyView.h"
#import "PersonalityViewController.h"
#import "UserLogic.h"


@interface STBodyViewController ()

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) UserBody *uBody;

@end

@implementation STBodyViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setNavBarTitle:@"我的身体数据"];
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    //分页
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = YES;
    _scrollView.bounces = YES;
    [self resetScrollView:_scrollView tabBar:NO];
    
    [self initScrollView];
}


- (void)initScrollView
{
    
    [_scrollView setContentSize:CGSizeMake(SCREEN_WIDTH, 1320)];
    
    for (int i = 0; i<7; i++) {
        STBodyView *sv = [[STBodyView alloc] initWithFrame:CGRectMake(0, 180*i, SCREEN_WIDTH, 180)];
        [sv setCellWithCellInfo:i];
        
        [_scrollView addSubview:sv];
    }
    
    
    //继续按钮
    UIButton *nextBtn = [[UIButton alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-116)/2, 1264, 116, 36)];
    [nextBtn setTitle:@"继续" forState:UIControlStateNormal];
    [nextBtn setTitleColor:PINK_COLOR forState:UIControlStateNormal];
    [nextBtn.titleLabel setFont:[UIFont systemFontOfSize:17.0]];
    [nextBtn addTarget:self action:@selector(nextBtnTapped:) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIImageView *arrowV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_triangle.png"]];
    [arrowV setFrame:CGRectMake(0, 0, 14, 15)];
    CGPoint mCenter = nextBtn.center;
    mCenter.x = nextBtn.center.x + 30;
    arrowV.center = mCenter;
    [_scrollView addSubview:arrowV];
    [_scrollView addSubview:nextBtn];
}

- (void)nextBtnTapped:(id)sender
{
    CLog(@"%@", [UserLogic sharedInstance].uBody);
    
    //保存身材数据
    [[UserLogic sharedInstance] userSaveBodyParamCallback:^(LogicResult *result) {
        if(result.statusCode == KLogicStatusSuccess)
        {
            //进入设置用户圈子
            PersonalityViewController *pVC = [[PersonalityViewController alloc] init];
            [self.navigationController pushViewController:pVC animated:YES];
        }
        else
            CLog(@"成功");
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
