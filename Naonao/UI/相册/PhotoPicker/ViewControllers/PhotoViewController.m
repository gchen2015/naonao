//
//  PhotoViewController.m
//  Artery
//
//  Created by RichardLiu on 15/4/10.
//  Copyright (c) 2015年 刘 敏. All rights reserved.
//

#import "PhotoViewController.h"
#import "STImageEditorViewController.h"
#import "STPhotoBrowserViewController.h"
#import "DMCameraViewController.h"
#import "STPhotoPickerImageView.h"
#import "STPhotoPickerDatas.h"
#import "STPhotoPickerGroup.h"
#import "SquareLogic.h"


#define K_S_W   (SCREEN_WIDTH-4*5)/4.0f


@interface PhotoViewController ()<UICollectionViewDataSource, UICollectionViewDelegate, STToolbarDelegate, STPhotoPickerImageViewDelegate, STPhotoBrowserViewControllerDelegate, STPhotoBrowserViewControllerDataSource>

@property (nonatomic, strong) UICollectionView *cv;
@property (nonatomic, strong) NSArray *imageArray;

@property (nonatomic, strong) NSMutableArray *selectAssets;         //存储选中的图片
@property (nonatomic, strong) NSMutableArray *selectsIndexPath;     //存储选中的图片索引值

@property (nonatomic , weak) STToolbar *toolBar;

@property (nonatomic, assign) BOOL isPreview;

@end


@implementation PhotoViewController
#pragma mark 懒加载
- (NSMutableArray *)selectAssets{
    if (!_selectAssets) {
        _selectAssets = [NSMutableArray array];
    }
    
    return _selectAssets;
}

- (NSMutableArray *)selectsIndexPath{
    if (!_selectsIndexPath) {
        _selectsIndexPath = [NSMutableArray array];
    }
    
    if (_selectsIndexPath) {
        NSSet *set = [NSSet setWithArray:_selectsIndexPath];
        _selectsIndexPath = [NSMutableArray arrayWithArray:[set allObjects]];
    }
    
    return _selectsIndexPath;
}

- (void)setMaxCount:(NSInteger)maxCount{
    _maxCount = maxCount;
}

- (void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBarHidden = YES;
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"相册"];
}


- (void)viewWillDisappear:(BOOL)animated
{
    [MobClick endLogPageView:@"相册"];
    [super viewWillDisappear:animated];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setNavBarTitle:_pickerGroup.groupName];
    
    [self setNavBarRightBtn:[STNavBarView createNormalNaviBarBtnByTitle:@"取消" target:self action:@selector(cancelTapped:)]];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    [layout setScrollDirection:UICollectionViewScrollDirectionVertical]; //控制滑动分页用

    _cv = [[UICollectionView alloc] initWithFrame:MAINSCREEN collectionViewLayout:layout];
    [_cv registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    [_cv setUserInteractionEnabled:YES];
    [_cv setDataSource:self];
    [_cv setDelegate:self];
    [_cv setBackgroundColor:[UIColor clearColor]];
    [_cv setContentInset:UIEdgeInsetsMake(0, 0, 44, 0)];

    [self.view addSubview:_cv];
    
    [self resetScrollView:_cv tabBar:NO];
    
    // 初始化底部ToorBar
    [self setupToorBar];
    
    [self initTableData:_pickerGroup];
}

- (void)initTableData:(STPhotoPickerGroup *)pickerGroup
{
    __block NSMutableArray *assetsM = [NSMutableArray array];
    __weak typeof(self) weakSelf = self;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [[STPhotoPickerDatas defaultPicker] getGroupPhotosWithGroup:pickerGroup finished:^(NSArray *assets) {

            [assets enumerateObjectsUsingBlock:^(ALAsset *asset, NSUInteger idx, BOOL *stop) {
                STPhotoAssets *lgAsset = [[STPhotoAssets alloc] init];
                lgAsset.asset = asset;
                [assetsM addObject:lgAsset];
            }];
            
            //倒序
            weakSelf.imageArray = [[assetsM reverseObjectEnumerator] allObjects];
            [weakSelf.cv reloadData];
        }];
    });
}

- (void)cancelTapped:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark collectionView
#pragma mark - collectionView data source
//定义展示的UICollectionViewCell的个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [_imageArray count];
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

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];

    STPhotoPickerImageView *iv = [[STPhotoPickerImageView alloc] initWithFrame:CGRectMake(0, 0, K_S_W, K_S_W)];
    //有动画
    iv.isClickHaveAnimation = NO;
    iv.maskViewFlag = ([self.selectsIndexPath containsObject:@(indexPath.row)]);
    
    STPhotoAssets *lgAsset = [_imageArray objectAtIndex:indexPath.row];
    iv.image = lgAsset.thumbImage;
    iv.indexPath = indexPath;
    iv.delegate = self;
    [cell.contentView addSubview:iv];

    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    //进入整个相册预览
    NSIndexPath *mPath = [NSIndexPath indexPathForRow:indexPath.row inSection:0];
    [self setupPhotoBrowserInCasePreview:NO CurrentIndexPath:mPath];
}

- (BOOL)validatePhotoCount:(NSInteger)maxCount{
    if (self.selectAssets.count >= maxCount || maxCount < 0) {
        NSString *format = [NSString stringWithFormat:@"最多只能选择%zd张图片",maxCount];
        if (maxCount <= 0) {
            format = [NSString stringWithFormat:@"您已经选满了图片了."];
        }
        AlertWithTitleAndMessage(nil, format);
    
        return NO;
    }
    
    return YES;
}


#pragma mark STPhotoPickerImageViewDelegate
- (void)pickImageView:(STPhotoPickerImageView *)pickImageView selectTapped:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [_cv cellForItemAtIndexPath:indexPath];
    STPhotoPickerImageView *pickerImageView = [cell.contentView.subviews lastObject];

    STPhotoAssets *lgAsset = [_imageArray objectAtIndex:indexPath.row];
    
    // 如果没有就添加到数组里面，存在就移除
    if (pickerImageView.isMaskViewFlag)
    {
        [self.selectsIndexPath removeObject:@(indexPath.row)];
        //原图
        [self.selectAssets removeObject:lgAsset];
    }
    else
    {
        // 判断图片数超过最大数或者小于0
        NSInteger maxCount = (self.maxCount == 0) ? KPhotoShowMaxCount :  self.maxCount;
        if (![self validatePhotoCount:maxCount]){
            return ;
        }

        [self.selectsIndexPath addObject:@(indexPath.row)];
        [self.selectAssets addObject:lgAsset];
    }

    pickerImageView.isClickHaveAnimation = YES;
    pickerImageView.maskViewFlag = ([pickerImageView isKindOfClass:[STPhotoPickerImageView class]]) && !pickerImageView.isMaskViewFlag;

    [_toolBar setCount:self.selectAssets.count];
}


#pragma mark -初始化底部ToorBar
- (void)setupToorBar {
    STToolbar *toorBar = [[STToolbar alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 44, SCREEN_WIDTH, 44) isBlack:NO];
    [self.view addSubview:toorBar];
    toorBar.mDelegate = self;
    self.toolBar = toorBar;
}


#pragma mark  STToolbarDelegate
- (void)toolbarBackMainview {
    
    NSMutableArray *temA = [NSMutableArray arrayWithCapacity:self.selectAssets.count];
    
    for (STPhotoAssets *lgAsset in self.selectAssets) {
        [temA addObject:lgAsset.compressionImage];
    }
    
    //填充数据
    [[SquareLogic sharedInstance] addselectImages:temA];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"AddPicCompletionNotification" object:nil];
    
    [self.navigationController popToRootViewControllerAnimated:YES];
}


- (void)previewSelectImages
{
    [self setupPhotoBrowserInCasePreview:YES CurrentIndexPath:0];
}


// 跳转照片浏览器
- (void)setupPhotoBrowserInCasePreview:(BOOL)preview CurrentIndexPath:(NSIndexPath *)indexPath{
    
    self.isPreview = preview;
     
    // 图片游览器（选择照片模式）
    STPhotoBrowserViewController *pickerBrowser = [[STPhotoBrowserViewController alloc] init];
    pickerBrowser.showType = STShowImageTypeImagePicker;
    
    // 数据源/delegate
    pickerBrowser.delegate = self;
    pickerBrowser.dataSource = self;
    pickerBrowser.maxCount = self.maxCount;
    pickerBrowser.selectedAssets = [self.selectAssets mutableCopy];
    pickerBrowser.selectsIndexPath = [self.selectsIndexPath mutableCopy];
    // 是否可以删除照片
    pickerBrowser.editing = NO;
    // 当前选中的值
    pickerBrowser.currentIndexPath = indexPath;
    
    [self.navigationController pushViewController:pickerBrowser animated:YES];
}


#pragma mark - STPhotoBrowserViewControllerDataSource
- (NSInteger)numberOfSectionInPhotosInPickerBrowser:(STPhotoBrowserViewController *)pickerBrowser{
    return 1;
}

//数据源
- (NSInteger)photoBrowser:(STPhotoBrowserViewController *)photoBrowser numberOfItemsInSection:(NSUInteger)section{
    if (self.isPreview) {
        return self.selectAssets.count;
    }
    else {
        return self.imageArray.count;
    }
}

- (STBrowserPhoto *)photoBrowser:(STPhotoBrowserViewController *)pickerBrowser photoAtIndexPath:(NSIndexPath *)indexPath
{
    STPhotoAssets *imageObj = [[STPhotoAssets alloc] init];
    if (self.isPreview && self.selectAssets.count) {
        imageObj = [self.selectAssets objectAtIndex:indexPath.row];
    } else if (!self.isPreview && self.imageArray.count){
        imageObj = [self.imageArray objectAtIndex:indexPath.row];
    }
    
    // 包装下imageObj 成 STBrowserPhoto 传给数据源
    STBrowserPhoto *photo = [STBrowserPhoto photoAnyImageObjWith:imageObj];
    
    return photo;
}


#pragma mark - STPhotoBrowserViewControllerDelegate
- (void)photoBrowserWillExit:(STPhotoBrowserViewController *)pickerBrowser
{
    self.selectAssets = [NSMutableArray arrayWithArray:pickerBrowser.selectedAssets];
    self.selectsIndexPath = [NSMutableArray arrayWithArray:pickerBrowser.selectsIndexPath];
    [_cv reloadData];
    
    [_toolBar setCount:self.selectAssets.count];
}

- (void)photoBrowserSendBtnTouched:(STPhotoBrowserViewController *)pickerBrowser isOriginal:(BOOL)isOriginal
{
//    self.isOriginal = isOriginal;
//    self.selectAssets = pickerBrowser.selectedAssets;
//    [self sendBtnTouched];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
