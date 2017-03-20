//
//  MyAppointmentViewController.m
//  Naonao
//
//  Created by 刘敏 on 2016/9/12.
//  Copyright © 2016年 深圳市轩腾华兴科技开发有限公司. All rights reserved.
//

#import "MyAppointmentViewController.h"
#import "FittingViewController.h"
#import "PickupViewController.h"
#import "SegmentTapView.h"
#import "FlipTableView.h"


@interface MyAppointmentViewController ()<SegmentTapViewDelegate, FlipTableViewDelegate>

@property (nonatomic, strong) NSMutableArray *allVC;
@property (nonatomic, strong) SegmentTapView *segment;
@property (nonatomic, strong) FlipTableView *flipView;

@end


@implementation MyAppointmentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setNavBarTitle:@"我的预约"];
    [self.view setBackgroundColor:BACKGROUND_GARY_COLOR];
    [self initSegment];
    [self initFlipTableView];
    
    if (_isReturn) {
        [self setNavBarLeftBtn:[STNavBarView createImgNaviBarBtnByImgNormal:@"nav_back.png"
                                                               imgHighlight:@"nav_back_highlighted.png"
                                                                     target:self
                                                                     action:@selector(back:)]];
    }
    
    if (_isSecond) {
        //延迟执行
        double delayInSeconds = 0.6;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [self selectedAppointmentIndex:1];
        });
    }
}

- (void)back:(id)sender{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)initSegment{
    self.segment = [[SegmentTapView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.navbar.frame), SCREEN_WIDTH, 40) withDataArray:[NSArray arrayWithObjects:@"上门试衣", @"上门取货", nil] withFont:15];
    self.segment.delegate = self;
    [self.view addSubview:self.segment];
}


- (void)initFlipTableView{
    if (!self.allVC) {
        self.allVC = [[NSMutableArray alloc] init];
    }
    
    FittingViewController *arVC = [[FittingViewController alloc] initWithStyle:UITableViewStyleGrouped];
    arVC.rootVC = self;
    [self.allVC addObject:arVC];
    
    PickupViewController *pVC = [[PickupViewController alloc] initWithStyle:UITableViewStyleGrouped];
    pVC.rootVC = self;
    [self.allVC addObject:pVC];
    
    self.flipView = [[FlipTableView alloc] initWithFrame:CGRectMake(0, 104, SCREEN_WIDTH, SCREEN_HEIGHT - 104) withArray:self.allVC];
    self.flipView.delegate = self;
    [self.view addSubview:self.flipView];
}

#pragma mark - DBPagerTabView Delegate
#pragma mark -------- select Index
- (void)selectedIndex:(NSInteger)index
{
    [self.flipView selectIndex:index];
}

- (void)scrollChangeToIndex:(NSInteger)index
{
    //TODO：index从1开始
    [self.segment selectIndex:index];
}

// 手动选中
- (void)selectedAppointmentIndex:(NSInteger)index
{
    [self.flipView selectIndex:index];
    [self.segment selectIndex:index+1];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
