//
//  FavGoodsViewController.m
//  Naonao
//
//  Created by 刘敏 on 16/7/29.
//  Copyright © 2016年 深圳市轩腾华兴科技开发有限公司. All rights reserved.
//

#import "FavGoodsViewController.h"
#import "MagazineLogic.h"
#import "UserLogic.h"
#import "CircleCollectionCell.h"
#import "MJRefresh.h"
#import "STGoodsMainViewController.h"
#import "FavoritesViewController.h"

#define K_S_W   (SCREEN_WIDTH-15*3)/2.0f     //单个高度

@interface FavGoodsViewController ()

@property (nonatomic, strong) NSMutableArray *goodsArray;          //商品数据

@end

static NSString * const reuseIdentifier = @"Cell";

@implementation FavGoodsViewController

#pragma mark - 懒加载
- (NSMutableArray *)goodsArray
{
    if (!_goodsArray) {
        self.goodsArray = [NSMutableArray array];
    }
    return _goodsArray;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.collectionView setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
    //注册CollectionCell
    [self.collectionView registerClass:[CircleCollectionCell class] forCellWithReuseIdentifier:@"CircleCollectionCell"];
    
    [self getFavGoodsList];
    
    [self setupRefresh];
}

// 刷新控件
- (void)setupRefresh
{
    self.collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
}

#pragma mark - 下拉刷新更新数据
- (void)loadNewData{
    [self.collectionView.mj_header endRefreshing];
    [self getFavGoodsList];
}


- (void)setRootVC:(FavoritesViewController *)rootVC
{
    _rootVC = rootVC;
}

//喜欢的商品列表
- (void)getFavGoodsList {
    User *user = [UserLogic sharedInstance].getUser;
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithCapacity:0];
    [dic setObject:user.basic.userId forKey:@"uid"];
    
    __typeof (&*self) __weak weakSelf = self;
    [[MagazineLogic sharedInstance] favoriteGoodsList:dic withCallback:^(LogicResult *result) {
        if(result.statusCode == KLogicStatusSuccess)
        {
            //先清空数据
            [weakSelf.goodsArray removeAllObjects];
            
            [weakSelf.goodsArray addObjectsFromArray:(NSArray *)result.mObject];
            [weakSelf.collectionView reloadData];
        }
        else
        {
            [weakSelf.view makeToast:result.stateDes];
        }
        
        [self.collectionView.mj_header endRefreshing];
    }];
}

#pragma mark <UICollectionViewDataSource>
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _goodsArray.count;
}

//定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat m_unit = K_S_W;
    CGFloat m_Width = m_unit+35;
    
    return CGSizeMake(m_unit, m_Width);
}

//设定全局的行间距，如果想要设定指定区内Cell的最小行距，可以使用下面方法
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 15.0f;
}

//设定全局的Cell间距，如果想要设定指定区内Cell的最小间距，可以使用下面方法：
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 15.0f;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(15, 15, 15, 15);
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *favoriteCellIdentifier = @"CircleCollectionCell";
    CircleCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:favoriteCellIdentifier forIndexPath:indexPath];
    FavGoodsModel *cInfo = [_goodsArray objectAtIndex:indexPath.row];
    [cell initWithParsData:cInfo];
    
    return cell;

}

#pragma mark <UICollectionViewDelegate>
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    FavGoodsModel *cInfo = [_goodsArray objectAtIndex:indexPath.row];
    
    //进入商品详情页
    MagazineContentInfo *mcInfo = [[MagazineContentInfo alloc] init];
    mcInfo.productId = cInfo.productId;
    mcInfo.coverUrl = cInfo.imgUrl;
        
        
    STGoodsMainViewController *goodsVC = [[STGoodsMainViewController alloc] init];
    goodsVC.mInfo = mcInfo;
    [_rootVC.navigationController pushViewController:goodsVC animated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
