//
//  PCenterView.m
//  Naonao
//
//  Created by Richard Liu on 16/2/1.
//  Copyright © 2016年 深圳市轩腾华兴科技开发有限公司. All rights reserved.
//

#import "PCenterView.h"
#import "SHLUILabel.h"
#import <SDWebImage/UIImageView+WebCache.h>



#define K_S_W (SCREEN_WIDTH - 28 - 4*2)/3.0f

@interface PCenterView ()<UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, weak) UICollectionView *cv;
@property (nonatomic, weak) SHLUILabel *flagL;

@end


@implementation PCenterView

- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        [self setUpChildView];
    }
    return self;
}

- (void)setUpChildView
{
    SHLUILabel *flagL = [[SHLUILabel alloc] init];
    _flagL = flagL;
    [_flagL setTextColor:BLACK_COLOR];
    [_flagL setFont:[UIFont systemFontOfSize:14.0]];
    _flagL.lineBreakMode = NSLineBreakByWordWrapping;
    _flagL.numberOfLines = 0;
    [self addSubview:_flagL];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    UICollectionView *cv = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    _cv = cv;
    [_cv registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    [_cv setUserInteractionEnabled:YES];
    [_cv setDataSource:self];
    [_cv setDelegate:self];
    [_cv setBackgroundColor:[UIColor clearColor]];
    
    [self addSubview:_cv];
}

- (void)setProFrame:(ProductModeFrame *)proFrame
{
    _proFrame = proFrame;
    _flagL.frame = _proFrame.flagLFrame;

    [self setChildViewData];
}

- (void)setAnFrame:(AnswerModeFrame *)anFrame
{
    _anFrame = anFrame;
    _flagL.frame = _anFrame.flagLFrame;
    _cv.frame = _anFrame.picFrame;
    
    [_cv setBackgroundColor:[UIColor clearColor]];
    [self setAnChildViewData];
}

- (void)setChildViewData
{
    if (_proFrame.pData.wrap_words.length > 0) {
        [_flagL setText:_proFrame.pData.wrap_words];
    }
}

- (void)setAnChildViewData
{
    if (_anFrame.aMode.content) {
        [_flagL setText:_anFrame.aMode.content];
    }
}


#pragma mark collectionView
#pragma mark - collectionView data source
//定义展示的UICollectionViewCell的个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _anFrame.aMode.links.count;
}

//定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat m_unit = K_S_W;
    
    if (_anFrame.aMode.links.count == 1) {
        m_unit = K_S_W * 2;
    }
    else
        m_unit = K_S_W;

    
    return CGSizeMake(m_unit, m_unit);
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
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    UIImageView *mv = [[UIImageView alloc] init];
    
    if (_anFrame.aMode.links.count == 1){
        [mv setFrame:CGRectMake(0, 0, K_S_W*2, K_S_W*2)];
    }
    else
        [mv setFrame:CGRectMake(0, 0, K_S_W, K_S_W)];

    //填充方式
    [mv setContentMode:UIViewContentModeScaleAspectFill];
    mv.layer.masksToBounds = YES;
    
    
    if([[_anFrame.aMode.links objectAtIndex:indexPath.row] isKindOfClass:[NSString class]]){
        [mv sd_setImageWithURL:[NSURL URLWithString:[[_anFrame.aMode.links objectAtIndex:indexPath.row] middleImage]] placeholderImage:[UIImage imageNamed:@"default_image.png"]];
    }
    else if ([[_anFrame.aMode.links objectAtIndex:indexPath.row] isKindOfClass:[UIImage class]]){
        //模拟数据
        [mv setImage:[_anFrame.aMode.links objectAtIndex:indexPath.row]];
    }

    [cell.contentView addSubview:mv];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (_delegate && [_delegate respondsToSelector:@selector(pCenterView:didSelectItemAtIndexPath:imageArray:)]) {
        [_delegate pCenterView:self didSelectItemAtIndexPath:indexPath imageArray:_anFrame.aMode.links];
    }
}


@end
