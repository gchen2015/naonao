//
//  EffectsViewController.m
//  Artery
//
//  Created by 刘敏 on 14-10-5.
//  Copyright (c) 2014年 深圳市轩腾华兴科技开发有限公司. All rights reserved.
//

#import "EffectsViewController.h"
#import "FilterCell.h"
#import "FilterCellModel.h"
#import "FilterTools.h"
#import "ALAssetsLibrary+CustomPhotoAlbum.h"
#import "PublishPicturesViewController.h"
#import "SquareLogic.h"
#import "STPhotoAssets.h"

@interface EffectsViewController ()<UIScrollViewDelegate>

@property (nonatomic, weak) UIButton *effButton;

@property (strong, nonatomic) NSArray *fitArray;        //滤镜数组
@property (nonatomic, unsafe_unretained) IFFilterType currentType;

@property (strong, nonatomic) UIImage *filterImage;     //滤镜图片
@property (strong, nonatomic) UIScrollView *fitScrollView;


@end

@implementation EffectsViewController



- (void)viewWillAppear:(BOOL)animated
{
    //显示navigationController
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"滤镜"];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"滤镜"];
}


- (void)loadFiltPlist
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"FilterList" ofType:@"plist"];
    self.fitArray = [[NSArray alloc] initWithContentsOfFile:path];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setNavBarTitle:@"选择滤镜"];

    [self loadFiltPlist];

    _filterImage = _cacheImage;
    
    UIButton *effButton = [[UIButton alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.navbar.frame), SCREEN_WIDTH, SCREEN_WIDTH)];
    _effButton = effButton;
    [self.view addSubview:_effButton];
    [_effButton setBackgroundImage:_filterImage forState:UIControlStateNormal];
    [_effButton setBackgroundImage:_cacheImage forState:UIControlStateHighlighted];
    
    //设置导航栏右侧按钮
    [self setNavBarRightBtn:[STNavBarView createNormalNaviBarBtnByTitle:@"确定" target:self action:@selector(doneButtonTapped:)]];
    
//    //设置导航栏右侧按钮
//    [self setNavBarRightBtn:[STNavBarView createNormalNaviBarBtnByTitle:@"下一步" target:self action:@selector(nextButtonTapped:)]];
    
    // 滤镜菜单
    _fitScrollView = [[UIScrollView alloc] initWithFrame:CGRectZero];


    [_fitScrollView setFrame:CGRectMake(0, SCREEN_HEIGHT - 150, SCREEN_WIDTH, 130)];

    _fitScrollView.contentSize = CGSizeMake(12+[_fitArray count]*91+6, 130);
    _fitScrollView.showsHorizontalScrollIndicator = NO;
    _fitScrollView.showsVerticalScrollIndicator = NO;
    _fitScrollView.scrollsToTop = NO;
    _fitScrollView.delegate = self;
    
    [self.view addSubview:_fitScrollView];
    
    
    [self setupFilterButtons];
}


// 绘制按钮
- (void)setupFilterButtons
{
    NSDictionary *item = nil;
    
    for (int i=0; i<[_fitArray count]; i++) {
        item = [_fitArray objectAtIndex:i];
        
        UIButton* fButton = [[UIButton alloc] initWithFrame:CGRectMake(12+i*91, 16, 73, 73)];

        [fButton setBackgroundImage:[UIImage imageNamed:[item objectForKey:@"image"]] forState:UIControlStateNormal];
        [fButton setImage:[UIImage imageNamed:@"filter_sel.png"] forState:UIControlStateSelected];
        
        [fButton addTarget:self action:@selector(filterButtonTapped:) forControlEvents:UIControlEventTouchUpInside];

        fButton.tag = i+5000;
		[_fitScrollView addSubview:fButton];
        
        
        if (i == 0) {
            fButton.selected = YES;
        }
        
        
        UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(12+i*91, 94, 73, 21)];
        nameLabel.font = [UIFont systemFontOfSize:15];
        nameLabel.textAlignment = NSTextAlignmentCenter;
        nameLabel.adjustsFontSizeToFitWidth = YES;
        nameLabel.textColor = [UIColor blackColor];
        nameLabel.shadowColor = [UIColor grayColor];
        nameLabel.shadowOffset = CGSizeMake(0, -0.2);
        nameLabel.backgroundColor = [UIColor clearColor];
        nameLabel.text = [item objectForKey:@"name"];
        
        [_fitScrollView addSubview:nameLabel];
        
    }
}


- (void)filterButtonTapped:(UIButton *)sender
{
    NSInteger row = sender.tag - 5000;
    sender.selected = !sender.selected;
    
    for (int i=0; i<[_fitArray count]; i++)
    {
        UIButton* fButton = (UIButton *)[self.fitScrollView viewWithTag:i+5000];
        if (fButton) {
            if (i != row) {
                fButton.selected = NO;
            }
        }
    }
    
    
    
    self.currentType = (IFFilterType)row;
    FilterTools *filterTools = [[FilterTools alloc] init];

    _filterImage = [Units image:[filterTools switchFilter:self.currentType rawImage:self.cacheImage] rotation:UIImageOrientationUp];

    [_effButton setBackgroundImage:_filterImage forState:UIControlStateNormal];
    
    
//    ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];;
//    
//    //保存拍摄的图片到相册
//    [library saveImage:_filterImage toAlbum:@"挠挠" completion:^(NSURL *assetURL, NSError *error) {
//        CLog(@"你好，阳光！");
//
//    } failure:^(NSError *error) {
//        if (error != nil) {
//            CLog(@"Big error: %@", [error description]);
//        }
//    }];
}


//
//- (void)nextButtonTapped:(id)sender
//{
//    
//    PublishPicturesViewController *pVC = [[PublishPicturesViewController alloc] init];
//    pVC.image = _filterImage;
//    [self.navigationController pushViewController:pVC animated:YES];
//}


- (void)doneButtonTapped:(id)sender
{
    NSData *data2 = UIImageJPEGRepresentation(_filterImage, 0.45);
    UIImage *image = [UIImage imageWithData:data2];
    
    NSArray *array = [NSArray arrayWithObject:image];
    //填充数据
    [[SquareLogic sharedInstance] addselectImages:array];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"AddPicCompletionNotification" object:nil];
    
    [self.navigationController popToRootViewControllerAnimated:YES];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
