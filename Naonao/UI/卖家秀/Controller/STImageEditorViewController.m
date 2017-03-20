//
//  STImageEditorViewController.m
//  Artery
//
//  Created by 刘敏 on 15/1/10.
//  Copyright (c) 2015年 深圳市轩腾华兴科技开发有限公司. All rights reserved.
//

#import "STImageEditorViewController.h"
#import "KICropImageView.h"
#import "EffectsViewController.h"
#import "ILTranslucentView.h"


@interface STImageEditorViewController ()

@property (nonatomic, weak) KICropImageView *cropImageView;
@property (nonatomic, assign) NSInteger index;

@end

@implementation STImageEditorViewController


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
    [MobClick beginLogPageView:@"图片编辑"];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"图片编辑"];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:NO];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view setBackgroundColor:[UIColor colorWithHex:0x2d2d2d]];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.extendedLayoutIncludesOpaqueBars = NO;
    self.modalPresentationCapturesStatusBarAppearance = NO;
    
    _index = 0;

    ILTranslucentView *navView = [[ILTranslucentView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 64)];
    navView.alpha = 0.8;
    navView.translucentStyle = UIBarStyleDefault;
    navView.translucentTintColor = [UIColor blackColor];
    [self.view addSubview:navView];
    
    //返回按钮
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(-10, 22, 64, 40);
    [backBtn setImage:[UIImage imageNamed:@"btn_back_c.png"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(cancelTapped:) forControlEvents:UIControlEventTouchUpInside];
    [navView addSubview:backBtn];
    
    //标题
    UILabel *labelTitle = [[UILabel alloc] initWithFrame:CGRectMake(80, 20, SCREEN_WIDTH-160, 44)];
    labelTitle.backgroundColor = [UIColor clearColor];
    labelTitle.textColor = [UIColor whiteColor];
    [labelTitle setText:@"图片编辑"];
    labelTitle.font = [UIFont systemFontOfSize:18.0];
    labelTitle.textAlignment = NSTextAlignmentCenter;
    [navView addSubview:labelTitle];
    
    //下一步
    UIButton *nextBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-64, 22, 64, 40)];
    [nextBtn setTitle:@"下一步" forState:UIControlStateNormal];
    [nextBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [nextBtn addTarget:self action:@selector(nextBtnTapped:) forControlEvents:UIControlEventTouchUpInside];
    nextBtn.titleLabel.font = [UIFont systemFontOfSize:16.0f];
    [navView addSubview:nextBtn];
    
    //图像裁剪
    KICropImageView *cropImageView = [[KICropImageView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(navView.frame), self.view.width, self.view.height-CGRectGetMaxY(navView.frame))];
    _cropImageView = cropImageView;
    [_cropImageView setImage:_cacheImage];
    [self.view addSubview:_cropImageView];
    
    //设置裁剪区域大小
    [_cropImageView setCropSize:CGSizeMake(self.view.width, self.view.width)];
    
    
    ILTranslucentView *bottomV = [[ILTranslucentView alloc] initWithFrame:CGRectMake(0, SCREEN_WIDTH + CGRectGetMaxY(navView.frame), SCREEN_WIDTH, self.view.height-CGRectGetMaxY(navView.frame)- SCREEN_WIDTH)];
    bottomV.alpha = 0.8;
    bottomV.translucentStyle = UIBarStyleDefault;
    bottomV.translucentTintColor = [UIColor blackColor];
    [self.view addSubview:bottomV];
    
    //添加裁剪方式按钮
    CGFloat mHeight = (64 + SCREEN_WIDTH) + (SCREEN_HEIGHT - (64 + SCREEN_WIDTH))/2 - 22.5;
    UIButton *tailorBtn = [[UIButton alloc] initWithFrame:CGRectMake(45, mHeight, 45, 45)];
  
    [tailorBtn setBackgroundImage:[UIImage imageNamed:@"rectangular_btn.png"] forState:UIControlStateNormal];
    [tailorBtn setBackgroundImage:[UIImage imageNamed:@"square_btn.png"] forState:UIControlStateSelected];
    [tailorBtn addTarget:self action:@selector(tailorBtnTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:tailorBtn];

    //旋转按钮
    UIButton *rotateBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rotateBtn setFrame:CGRectMake(SCREEN_WIDTH-90, tailorBtn.frame.origin.y, 45, 45)];
    [rotateBtn setTitleColor:PINK_COLOR forState:UIControlStateNormal];
    [rotateBtn setImage:[UIImage imageNamed:@"camera_icon_09"] forState:UIControlStateNormal];
    [rotateBtn addTarget:self action:@selector(rotateBtnTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:rotateBtn];

    //显示在最上层
    [self.view bringSubviewToFront:navView];
}


//返回
- (void)cancelTapped:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

//选取图片
- (void)nextBtnTapped:(id)sender
{
    NSData *data = UIImageJPEGRepresentation([_cropImageView cropImage], 1.0);

    //跳转到特效页面（滤镜）
    EffectsViewController * eVC = [[EffectsViewController alloc] init];
    eVC.cacheImage = [UIImage imageWithData:data];
    [self.navigationController pushViewController:eVC animated:YES];
}


//图片裁剪方式
- (void)tailorBtnTapped:(UIButton *)sender
{
    sender.selected = !sender.selected;
    
    if (sender.selected) {
        //长方形
        [_cropImageView photoFilling];
    }
    else
    {
        [_cropImageView.scrollView setZoomScale:1.0 animated:NO];
        //正常
        [_cropImageView updateZoomScale];
        
    }
}

//
- (void)rotateBtnTapped:(UIButton *)sender{
    
    self.index++;
    
    //UIImage *newImage = [[UIImage alloc] init];
    
    switch (self.index % 4) {
        case 1:
            self.cacheImage = [UIImage imageWithCGImage:self.cacheImage.CGImage scale:1 orientation:UIImageOrientationRight];
            break;
        case 2:
            self.cacheImage = [UIImage imageWithCGImage:self.cacheImage.CGImage scale:1 orientation:UIImageOrientationDown];
            break;
        case 3:
            self.cacheImage = [UIImage imageWithCGImage:self.cacheImage.CGImage scale:1 orientation:UIImageOrientationLeft];
            break;
        case 0:
            self.cacheImage = [UIImage imageWithCGImage:self.cacheImage.CGImage scale:1 orientation:UIImageOrientationUp];
            break;
            
        default:
            break;
    }
    
    [_cropImageView setImage:self.cacheImage];
}




@end
