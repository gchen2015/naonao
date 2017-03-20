//
//  BrandGoodsCell.m
//  Naonao
//
//  Created by 刘敏 on 2016/10/9.
//  Copyright © 2016年 深圳市轩腾华兴科技开发有限公司. All rights reserved.
//

#import "BrandGoodsCell.h"
#import "CircleCollectionCell.h"
#import "BrandProViewController.h"
#import "STGoodsMainViewController.h"

#define K_S_W   (SCREEN_WIDTH-15*3)/2.0f     //单个高度


@interface BrandGoodsCell ()<UICollectionViewDataSource,UICollectionViewDelegate>

@property (nonatomic, weak) UICollectionView *circleCollectionView;
@property (nonatomic, strong) NSArray *proArray;

@end

@implementation BrandGoodsCell

+ (BrandGoodsCell *)cellWithTableView:(UITableView *)tableView{
    static NSString *ID = @"BrandGoodsCell";
    
    BrandGoodsCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    cell = [[BrandGoodsCell alloc ] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
    }
    
    return self;
}

- (void)setCellWithCellInfo:(STBrand *)topic{
    _proArray = topic.content.proArray;
    
    UILabel *nameL = [[UILabel alloc] initWithFrame:CGRectMake(14, 20, 100, 16)];
    [nameL setText:@"所有商品"];
    [nameL setFont:[UIFont systemFontOfSize:15.0]];
    [nameL setTextColor:GARY_COLOR];
    [self.contentView addSubview:nameL];
    
    
    long x_f = _proArray.count/2;
    int y_f = _proArray.count%2;
    
    UICollectionViewLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(nameL.frame)+8, SCREEN_WIDTH, (x_f+y_f)*(K_S_W+50)) collectionViewLayout:layout];
    
    self.circleCollectionView = collectionView;
    self.circleCollectionView.delegate = self;
    self.circleCollectionView.dataSource = self;
    self.circleCollectionView.scrollEnabled = NO;
    self.circleCollectionView.backgroundColor = [UIColor whiteColor];
    
    //注册CollectionCell
    [self.circleCollectionView registerClass:[CircleCollectionCell class] forCellWithReuseIdentifier:@"CircleCollectionCell"];
    
    [self.contentView addSubview:self.circleCollectionView];
}

#pragma mark <UICollectionViewDataSource>
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _proArray.count;
}

//定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat m_unit = K_S_W;
    CGFloat m_Width = m_unit;

    return CGSizeMake(m_unit, m_Width+35);
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
    STBrand_Product *cInfo = [_proArray objectAtIndex:indexPath.row];
    [cell initWithCellBrandsInfo:cInfo];

    return cell;
}


#pragma mark <UICollectionViewDelegate>
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    //判断是否登录
    if (![UserLogic sharedInstance].user.basic.userId) {
        [theAppDelegate popLoginView];
        return;
    }
    
    STBrand_Product *cInfo = [_proArray objectAtIndex:indexPath.row];

    //进入商品详情页
    MagazineContentInfo *mcInfo = [[MagazineContentInfo alloc] init];
    mcInfo.productId = cInfo.mId;
    mcInfo.coverUrl = cInfo.imgUrl;

    STGoodsMainViewController *goodsVC = [[STGoodsMainViewController alloc] init];
    goodsVC.mInfo = mcInfo;
    [_rootVC.navigationController pushViewController:goodsVC animated:YES];
}



- (CGFloat)height {
    [self layoutIfNeeded];
    return CGRectGetMaxY(self.circleCollectionView.frame) + 20;
}


@end
