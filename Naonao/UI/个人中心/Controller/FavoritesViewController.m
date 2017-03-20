//
//  FavoritesViewController.m
//  Naonao
//
//  Created by 刘敏 on 16/7/29.
//  Copyright © 2016年 深圳市轩腾华兴科技开发有限公司. All rights reserved.
//

#import "FavoritesViewController.h"
#import "FavGoodsViewController.h"
#import "FavAnswerViewController.h"
#import "FavArticleViewController.h"
#import "SegmentTapView.h"
#import "FlipTableView.h"


@interface FavoritesViewController ()<SegmentTapViewDelegate, FlipTableViewDelegate>

@property (nonatomic, strong) NSMutableArray *allVC;
@property (nonatomic, strong) SegmentTapView *segment;
@property (nonatomic, strong) FlipTableView *flipView;

@end

@implementation FavoritesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self setNavBarTitle:@"收藏夹"];
    
    [self initSegment];
    [self initFlipTableView];
}

- (void)initSegment{
    self.segment = [[SegmentTapView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.navbar.frame), SCREEN_WIDTH, 40) withDataArray:[NSArray arrayWithObjects:@"商品", @"问题", @"专题", nil] withFont:15];
    self.segment.delegate = self;
    [self.view addSubview:self.segment];
}

- (void)initFlipTableView{
    if (!self.allVC) {
        self.allVC = [[NSMutableArray alloc] init];
    }
    
    UICollectionViewLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    FavGoodsViewController *gVC = [[FavGoodsViewController alloc] initWithCollectionViewLayout:layout];
    gVC.rootVC = self;
    [self.allVC addObject:gVC];
    
    FavAnswerViewController *aVC = [[FavAnswerViewController alloc] initWithStyle:UITableViewStyleGrouped];
    aVC.rootVC = self;
    [self.allVC addObject:aVC];
    
    
    FavArticleViewController *arVC = [[FavArticleViewController alloc] initWithStyle:UITableViewStyleGrouped];
    arVC.rootVC = self;
    [self.allVC addObject:arVC];
    
    self.flipView = [[FlipTableView alloc] initWithFrame:CGRectMake(0, 104, SCREEN_WIDTH, SCREEN_HEIGHT - 104) withArray:self.allVC];
    self.flipView.delegate = self;
    [self.view addSubview:self.flipView];
    
}

#pragma mark - DBPagerTabView Delegate
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

@end
