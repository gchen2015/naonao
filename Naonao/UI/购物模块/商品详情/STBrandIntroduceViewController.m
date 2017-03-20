//
//  STBrandIntroduceViewController.m
//  Naonao
//
//  Created by 刘敏 on 16/5/4.
//  Copyright © 2016年 深圳市轩腾华兴科技开发有限公司. All rights reserved.
//

#import "STBrandIntroduceViewController.h"
#import "SHLUILabel.h"

@interface STBrandIntroduceViewController ()

@property (nonatomic, weak) UIScrollView *scrollView;

@end

@implementation STBrandIntroduceViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:NO];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setNavBarTitle:_bInfo.en_name];
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:MAINSCREEN];
    _scrollView = scrollView;
    [_scrollView setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:_scrollView];
    
    [self resetScrollView:_scrollView tabBar:NO];
    
    [self drawUI];
}

- (void)drawUI
{
    SHLUILabel* desLabel = [[SHLUILabel alloc] init];
    [desLabel setTextColor:[UIColor grayColor]];
    [desLabel setFont:[UIFont systemFontOfSize:14.0]];
    [desLabel setTextColor:BLACK_COLOR];
    desLabel.lineBreakMode = NSLineBreakByWordWrapping;
    [_scrollView addSubview:desLabel];
    
    [desLabel setText:_bInfo.story];
    
    //根据字符串长度和Label显示的宽度计算出contentLab的高
    int labelHeight = [desLabel getAttributedStringHeightWidthValue:SCREEN_WIDTH-28];
    [desLabel setFrame:CGRectMake(14, 20, SCREEN_WIDTH-28, labelHeight)];
    
    if (labelHeight < SCREEN_HEIGHT) {
        [_scrollView setContentSize:CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT+50)];
    }
    else{
        [_scrollView setContentSize:CGSizeMake(SCREEN_WIDTH, labelHeight+50)];
    }
}


@end
