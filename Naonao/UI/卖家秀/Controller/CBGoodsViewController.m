//
//  CBGoodsViewController.m
//  Naonao
//
//  Created by 刘敏 on 16/5/4.
//  Copyright © 2016年 深圳市轩腾华兴科技开发有限公司. All rights reserved.
//

#import "CBGoodsViewController.h"
#import "MagazineLogic.h"
#import "CircleCollectionCell.h"
#import "PhotoViewController.h"
#import "STNavigationController.h"
#import "UserLogic.h"
#import "CommunityLogic.h"


#define K_S_W   (SCREEN_WIDTH-4*4)/3.0f     //单个高度

@interface CBGoodsViewController ()<UICollectionViewDataSource,UICollectionViewDelegate>

@property (nonatomic, weak) UICollectionView *circleCollectionView;
@property (nonatomic, strong) NSMutableArray *tableArray;

@end



@implementation CBGoodsViewController


#pragma mark - 懒加载
- (NSMutableArray *)tableArray
{
    if (!_tableArray) {
        self.tableArray = [NSMutableArray array];
    }
    return _tableArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setNavBarTitle:@"我的衣橱"];
    
    [self setNavBarLeftBtn:[STNavBarView createImgNaviBarBtnByImgNormal:@"icon_close.png"
                                                           imgHighlight:@"icon_close_highlighted.png"
                                                                 target:self
                                                                 action:@selector(back:)]];
    
    UICollectionViewLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:MAINSCREEN collectionViewLayout:layout];
    
    self.circleCollectionView = collectionView;
    self.circleCollectionView.delegate = self;
    self.circleCollectionView.dataSource = self;
    self.circleCollectionView.scrollEnabled = NO;
    self.circleCollectionView.backgroundColor = BACKGROUND_GARY_COLOR;
    
    //注册CollectionCell
    [self.circleCollectionView registerClass:[CircleCollectionCell class] forCellWithReuseIdentifier:@"CircleCollectionCell"];
    
    [self.view addSubview:self.circleCollectionView];
    [self resetScrollView:self.circleCollectionView tabBar:NO];
    

    [self getWardrobeList];
    
    User *user = [[UserLogic sharedInstance] getUser];
    if ([user.basic.contract boolValue]) {
        //舵主
        [self getTryProducts];
    }
}

- (void)back:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:NULL];
}


//增加提示语句
- (void)addPromptView
{
    UIImageView *tipV = (UIImageView *)[self.view viewWithTag:0x128];
    if (!tipV) {
        tipV = [[UIImageView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - 76)/2, 140, 62, 76)];
        [tipV setImage:[UIImage imageNamed:@"bird_no_response.png"]];
        tipV.tag = 0x128;
        tipV.tag = 0x128;
    }
    
    [self.view addSubview:tipV];
    
    
    UILabel *mL = (UILabel *)[self.view viewWithTag:0x256];
    if (!mL)
    {
        mL = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(tipV.frame)+30, SCREEN_WIDTH, 30)];
        [mL setText:@"您的衣橱空空如也，去别处看看吧"];
        
        [mL setTextAlignment:NSTextAlignmentCenter];
        [mL setFont:[UIFont boldSystemFontOfSize:15.0]];
        [mL setTextColor:LIGHT_BLACK_COLOR];
        mL.tag = 0x256;
    }
    [self.view addSubview:mL];
}


//删除提示语句
- (void)removePromptView
{
    UIImageView *tipV = (UIImageView *)[self.view viewWithTag:0x128];
    if (tipV) {
        [tipV removeFromSuperview];
    }
    
    UILabel *mL = (UILabel *)[self.view viewWithTag:0x256];
    if (mL) {
        [mL removeFromSuperview];
    }
}

//获取舵主的可试穿衣服记录
- (void)getTryProducts
{
    if (![UserLogic sharedInstance].user.basic.userId) {
        [theAppDelegate popLoginView];
        return;
    }
    
    
//    NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithCapacity:0];
//    [dic setObject:[UserLogic sharedInstance].user.basic.userId forKey:@"uid"];
//    
//    __typeof (&*self) __weak weakSelf = self;
//    
//    [[MagazineLogic sharedInstance] getTryProducts:dic withCallback:^(LogicResult *result) {
//        
//        [weakSelf removePromptView];
//        
//        if(result.statusCode == KLogicStatusSuccess)
//        {
//            [weakSelf.tableArray addObjectsFromArray:(NSArray *)result.mObject];
//            [weakSelf.circleCollectionView reloadData];
//            
//            
//            if (weakSelf.tableArray.count <1) {
//                [weakSelf addPromptView];
//            }
//        }
//        else
//        {
//            [weakSelf.view makeToast:result.stateDes];
//        }
//    }];
}


//获取我的衣橱
- (void)getWardrobeList
{
//    if (![UserLogic sharedInstance].user.basic.userId) {
//        [theAppDelegate popLoginView];
//        return;
//    }
//    
//    NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithCapacity:0];
//    [dic setObject:[UserLogic sharedInstance].user.basic.userId forKey:@"uid"];
//    
//    __typeof (&*self) __weak weakSelf = self;
//    [[MagazineLogic sharedInstance] getWardrobeList:dic withCallback:^(LogicResult *result) {
//        
//        [weakSelf removePromptView];
//        
//        if(result.statusCode == KLogicStatusSuccess)
//        {
//            [weakSelf.tableArray addObjectsFromArray:(NSArray *)result.mObject];
//            [weakSelf.circleCollectionView reloadData];
//            
//            if (weakSelf.tableArray.count <1) {
//                [weakSelf addPromptView];
//            }
//            
//        }
//        else
//        {
//            [weakSelf.view makeToast:result.stateDes];
//        }
//    }];
}


#pragma mark - collectionView data source
//定义展示的UICollectionViewCell的个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [_tableArray count];
}

//定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat m_unit = K_S_W;
    CGFloat m_Width = m_unit;
    
    return CGSizeMake(m_unit, m_Width);
}

//设定全局的行间距，如果想要设定指定区内Cell的最小行距，可以使用下面方法
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 4.0f;
}

//设定全局的Cell间距，如果想要设定指定区内Cell的最小间距，可以使用下面方法：
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 4.0f;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(4, 4, 4, 4);
}


//每个UICollectionView展示的内容
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *favoriteCellIdentifier = @"CircleCollectionCell";
    
    CircleCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:favoriteCellIdentifier forIndexPath:indexPath];
    FavGoodsModel *cInfo = [_tableArray objectAtIndex:indexPath.row];
    [cell initWithParsData:cInfo];
    
    return cell;
    
}

#pragma mark - collectionView delegete
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    FavGoodsModel *cInfo = [_tableArray objectAtIndex:indexPath.row];
    [[CommunityLogic sharedInstance] setProID:cInfo.productId];
    
    PhotoViewController * mVC = [[PhotoViewController alloc] init];
    [self.navigationController pushViewController:mVC animated:YES];
}



@end
