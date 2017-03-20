//
//  STShapeViewController.m
//  Naonao
//
//  Created by 刘敏 on 16/6/13.
//  Copyright © 2016年 深圳市轩腾华兴科技开发有限公司. All rights reserved.
//

#import "STShapeViewController.h"
#import "STBodyViewController.h"
#import "LewPopupViewController.h"
#import "DefectView.h"
#import "DemandLogic.h"
#import "UserLogic.h"



@interface STShapeViewController ()

@property (nonatomic, strong) NSArray *shapNameArray;

@end

@implementation STShapeViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setNavBarTitle:@"选取体型"];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    _shapNameArray = [DemandLogic sharedInstance].demandMenu.bodyParamsArray;
    
    //分页
    _mScrollView.showsHorizontalScrollIndicator = NO;
    _mScrollView.showsVerticalScrollIndicator = YES;
    _mScrollView.bounces = YES;
    [self resetScrollView:_mScrollView tabBar:NO];
    
    [self initScrollView];
}


- (void)initScrollView
{
    
    [_mScrollView setContentSize:CGSizeMake(SCREEN_WIDTH, 398*_shapNameArray.count)];
    
    int i = 0;
    for (bodyParamsModel *bModel in _shapNameArray) {
        UIView *cardView = [[[NSBundle mainBundle] loadNibNamed:@"CardView" owner:nil options:nil] firstObject];
        [cardView setFrame:CGRectMake((SCREEN_WIDTH-288)/2, 398*i, 288, 398)];
        
        UIImageView *imageV = (UIImageView *)[cardView viewWithTag:100];
        //填充方式
        [imageV setContentMode:UIViewContentModeScaleAspectFit];
        imageV.layer.masksToBounds = YES;
        [imageV setImage:[UIImage imageNamed:bModel.image]];
        
        
        UIButton * shapeButton = (UIButton *)[cardView viewWithTag:101];
        [shapeButton setTitle:bModel.name forState:UIControlStateNormal];
        //圆角
        shapeButton.layer.cornerRadius = 16;
        shapeButton.layer.borderColor = BLACK_COLOR.CGColor;
        shapeButton.layer.borderWidth = 1;
        shapeButton.layer.masksToBounds = YES;
        [shapeButton setTitleColor:BLACK_COLOR forState:UIControlStateNormal];
        [shapeButton addTarget:self action:@selector(shapeButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
        
        
        UILabel *shapeL =  (UILabel *)[cardView viewWithTag:102];
        [shapeL setText:[NSString stringWithFormat:@"(%@)", bModel.desc]];
        [shapeL setTextColor:LIGHT_BLACK_COLOR];
        [_mScrollView addSubview:cardView];
        
        i++;
    }

}

- (void)shapeButtonTapped:(UIButton *)sender
{
    //记录体型
    [UserLogic sharedInstance].uBody.bodyStyle = sender.titleLabel.text;
    CLog(@"%@", [UserLogic sharedInstance].uBody);

    //弹出设置
    DefectView *view = [DefectView defaultPopupView];
    view.parentVC = self;
    
    __weak typeof(self) weakSelf = self;
    [self lew_presentPopupView:view animation:[LewPopupViewAnimationFade new] dismissed:^{
        CLog(@"动画结束");
        if (weakSelf.isDefect) {
            [weakSelf saveBodyCharacter];
        }
    }];

}

//保存身材缺陷数据
- (void)saveBodyCharacter{
    
    __weak typeof(self) weakSelf = self;
    [[UserLogic sharedInstance] userBodyCharacterCallback:^(LogicResult *result) {
        if(result.statusCode == KLogicStatusSuccess)
        {
            //成功
            STBodyViewController *sVC = CREATCONTROLLER(STBodyViewController);
            [weakSelf.navigationController pushViewController:sVC animated:YES];
        }
        else
            [theAppDelegate.window makeToast:result.stateDes];
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
