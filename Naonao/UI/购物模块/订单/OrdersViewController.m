//
//  OrdersViewController.m
//  Naonao
//
//  Created by Richard Liu on 15/11/23.
//  Copyright © 2015年 深圳市轩腾华兴科技开发有限公司. All rights reserved.
//

#import "OrdersViewController.h"
#import "SegmentTapView.h"
#import "FlipTableView.h"
#import "STAllViewController.h"
#import "STGenerationController.h"
#import "STReceiveController.h"
#import "STEvaluationController.h"
#import "OrderDetailsViewController.h"

@interface OrdersViewController ()<SegmentTapViewDelegate, FlipTableViewDelegate>

@property (nonatomic, strong) SegmentTapView *segment;
@property (nonatomic, strong) FlipTableView *flipView;
@property (strong, nonatomic) NSMutableArray *controllsArray;

@end


@implementation OrdersViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setNavBarTitle:@"我的订单"];

    [self initSegment];
    [self initFlipTableView];
}


- (void)initSegment{
    self.segment = [[SegmentTapView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.navbar.frame), SCREEN_WIDTH, 40) withDataArray:[NSArray arrayWithObjects:@"全部", @"待付款", @"待收货", @"待评价", nil] withFont:15];
    self.segment.delegate = self;
    [self.view addSubview:self.segment];
}


- (void)initFlipTableView{
    
    if (!self.controllsArray) {
        self.controllsArray = [[NSMutableArray alloc] init];
    }
    
    STAllViewController *allVC = [[UIStoryboard storyboardWithName:@"Order" bundle:nil] instantiateViewControllerWithIdentifier:@"STAll"];
    STGenerationController *gVC = [[UIStoryboard storyboardWithName:@"Order" bundle:nil] instantiateViewControllerWithIdentifier:@"STGeneration"];
    STReceiveController *rVC = [[UIStoryboard storyboardWithName:@"Order" bundle:nil] instantiateViewControllerWithIdentifier:@"STReceive"];
    STEvaluationController *eVC = [[UIStoryboard storyboardWithName:@"Order" bundle:nil] instantiateViewControllerWithIdentifier:@"STEvaluation"];
    
    [self.controllsArray addObject:allVC];
    allVC.rootVC = self;
    [self.controllsArray addObject:gVC];
    gVC.rootVC = self;
    [self.controllsArray addObject:rVC];
    rVC.rootVC = self;
    [self.controllsArray addObject:eVC];
    eVC.rootVC = self;

    self.flipView = [[FlipTableView alloc] initWithFrame:CGRectMake(0, 104, SCREEN_WIDTH, SCREEN_HEIGHT - 104) withArray:_controllsArray];
    self.flipView.delegate = self;
    [self.view addSubview:self.flipView];
}

#pragma mark -------- select Index
- (void)selectedIndex:(NSInteger)index
{
    CLog(@"%ld",index);
    [self.flipView selectIndex:index];
}


- (void)scrollChangeToIndex:(NSInteger)index
{
    CLog(@"%ld",index);
    [self.segment selectIndex:index];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
