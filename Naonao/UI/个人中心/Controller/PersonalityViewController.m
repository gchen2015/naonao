//
//  PersonalityViewController.m
//  Naonao
//
//  Created by Richard Liu on 15/12/16.
//  Copyright © 2015年 深圳市轩腾华兴科技开发有限公司. All rights reserved.
//

#import "PersonalityViewController.h"
#import <SDWebImage/UIButton+WebCache.h>
#import "ShapeInfoViewController.h"
#import "UserLogic.h"
#import "InterestModel.h"
#import "LMButton.h"
#import "ShoppingLogic.h"


#define BTN_SIDE_H     70.0f    //边长

@interface PersonalityViewController ()

@property (nonatomic, weak) UIScrollView *scrollView;

@property (nonatomic, strong) NSArray *mArray;
@property (nonatomic, strong) NSMutableArray *tArray;      //存储数据

@end

@implementation PersonalityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setNavBarRightBtn:[STNavBarView createNormalNaviBarBtnByTitle:@"保存" target:self action:@selector(doneBtnTapped:)]];
    [self setNavBarTitle:@"选择你感兴趣的圈子"];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    _tArray = [[NSMutableArray alloc] initWithCapacity:0];
    //获取兴趣圈子列表
    [self getInterestCircleList];
}

//获取兴趣圈子列表
- (void)getInterestCircleList
{
    __typeof (&*self) __weak weakSelf = self;
    [[UserLogic sharedInstance] getInterestCircleList:^(LogicResult *result) {
        
        if(result.statusCode == KLogicStatusSuccess)
        {
            _mArray = (NSArray *)result.mObject;
            [self drawScrollowUI];
        }
        else
        {
            [weakSelf.view makeToast:result.stateDes];
        }
    }];
}

- (void)drawScrollowUI
{
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 40, SCREEN_WIDTH, SCREEN_HEIGHT-40)];
    _scrollView = scrollView;
    [_scrollView setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:_scrollView];
    
    [self resetScrollView:_scrollView tabBar:NO];
     
    //间距X轴
    NSUInteger m_X_W = 25;
    NSUInteger mInterval_X = (SCREEN_WIDTH-10 - BTN_SIDE_H*3 - m_X_W*2)/2;
    
    CGFloat max_H = 0.0;
    
    //3行3列
    for (int i = 0; i < _mArray.count; i++) {
        NSUInteger mx = i/3;       //行
        NSUInteger my = i%3;       //列
        
        LMButton *btn = [[LMButton alloc] initWithFrame:CGRectMake(m_X_W + (mInterval_X + BTN_SIDE_H)*my, 15+120*mx, BTN_SIDE_H, BTN_SIDE_H)];
        InterestModel *pM = [_mArray objectAtIndex:i];
        [btn sd_setImageWithURL:[NSURL URLWithString:pM.icon] forState:UIControlStateNormal placeholderImage:nil];
        [btn setTag:1000+i];
        [btn addTarget:self action:@selector(btnTapped:) forControlEvents:UIControlEventTouchUpInside];
        [_scrollView addSubview:btn];
        
        UILabel *la = [[UILabel alloc] initWithFrame:CGRectMake(m_X_W + (mInterval_X + BTN_SIDE_H)*my, CGRectGetMaxY(btn.frame)+6, BTN_SIDE_H, 20)];
        [la setText:pM.name];
        [la setTextAlignment:NSTextAlignmentCenter];
        [la setFont:[UIFont systemFontOfSize:15.0]];
        [la setTextColor:BLACK_COLOR];
        [la setBackgroundColor:[UIColor clearColor]];
        [_scrollView addSubview:la];
        
        max_H = CGRectGetMaxY(la.frame) + 20 +10;
    }
    
    
    [_scrollView setContentSize:CGSizeMake(SCREEN_WIDTH, max_H)];
    
    [self.view bringSubviewToFront:self.navbar];
}

- (void)btnTapped:(LMButton *)sender
{
    sender.selected = !sender.selected;
    InterestModel *pM = [_mArray objectAtIndex:sender.tag-1000];
    
    if (sender.selected)
    {
        [_tArray addObject:pM.mId];
    }
    else
        [_tArray removeObject:pM.mId];
}

- (void)doneBtnTapped:(id)sender
{
    if(_tArray.count == 0)
    {
        [self.view makeToast:@"兴趣标签至少选择一个"];
        return;
    }
    
    [self saveInterestCircleData];
}

//保存已经选择的兴趣标签
- (void)saveInterestCircleData
{
    //数组排序
    NSArray *sortedArray = [_tArray sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2){
        if ([obj1 intValue] > [obj2 intValue]){
            return NSOrderedDescending;
        }
        if ([obj1 intValue] < [obj2 intValue]){
            return NSOrderedAscending;
        }
        return NSOrderedSame;
    }];
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithCapacity:1];
    [dic setObject:[sortedArray componentsJoinedByString:@"|"] forKey:@"flags"];

    __weak typeof(self) weakSelf = self;
    [[UserLogic sharedInstance] saveInterestCircleData:dic withCallback:^(LogicResult *result) {
        if(result.statusCode == KLogicStatusSuccess)
        {
            [[ShoppingLogic sharedInstance] sendCoupon:nil];
            
            //成功
            ShapeInfoViewController *sVC = [[ShapeInfoViewController alloc] init];
            [weakSelf.navigationController pushViewController:sVC animated:NO];

            // TODO：后续处理
        }
        else
            CLog(@"失败！");
    }];

}

@end
