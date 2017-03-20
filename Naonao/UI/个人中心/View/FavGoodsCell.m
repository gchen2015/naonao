//
//  FavGoodsCell.m
//  Naonao
//
//  Created by Richard Liu on 16/1/5.
//  Copyright © 2016年 深圳市轩腾华兴科技开发有限公司. All rights reserved.
//

#import "FavGoodsCell.h"
#import "CircleCollectionCell.h"

@interface FavGoodsCell ()<UICollectionViewDataSource,UICollectionViewDelegate>

@property (nonatomic, weak) UICollectionView *circleCollectionView;
@property (nonatomic, strong) NSArray *tableArray;

@end

@implementation FavGoodsCell

+ (FavGoodsCell *)cellWithTableView:(UITableView *)tableView{
    static NSString *ID = @"FavGoodsCell";
    FavGoodsCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    //删除重用
    NSArray *subviews = [[NSArray alloc] initWithArray:cell.contentView.subviews];
    for (UIView *subview in subviews) {
        [subview removeFromSuperview];
    }
    
    cell = [[FavGoodsCell alloc ] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;

}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
    }
    
    return self;
}

- (void)setUpChildView{
    
    CGFloat m_H = K_S_W + 50;
    NSUInteger mRow = _tableArray.count/2 +  _tableArray.count%2;
    
    UICollectionViewLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    UICollectionView *collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, m_H*mRow+ 15) collectionViewLayout:layout];
    
    self.circleCollectionView = collectionView;
    self.circleCollectionView.delegate = self;
    self.circleCollectionView.dataSource = self;
    self.circleCollectionView.scrollEnabled = NO;
    self.circleCollectionView.backgroundColor = [UIColor whiteColor];
    
    //注册CollectionCell
    [self.circleCollectionView registerClass:[CircleCollectionCell class] forCellWithReuseIdentifier:@"CircleCollectionCell"];
    
    [self.contentView addSubview:self.circleCollectionView];
}

- (void)setCellWithCellInfo:(NSArray *)mArray
{
    _tableArray = mArray;
    [self setUpChildView];
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
    
    if (_delegate && [_delegate respondsToSelector:@selector(goodsCell:didSelectRowWithData:)]) {
        [_delegate goodsCell:self didSelectRowWithData:cInfo];
    }
}

@end
