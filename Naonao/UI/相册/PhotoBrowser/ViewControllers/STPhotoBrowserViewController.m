//
//  STPhotoBrowserViewController.m
//  Naonao
//
//  Created by 刘敏 on 16/6/26.
//  Copyright © 2016年 深圳市轩腾华兴科技开发有限公司. All rights reserved.
//

#import "STPhotoBrowserViewController.h"
#import "STPhotoRect.h"
#import "STBrowserHeadView.h"
#import "STPhotoAssets.h"
#import "SquareLogic.h"

// ScrollView 滑动的间距
static CGFloat const STPickerColletionViewPadding = 20;

typedef NS_ENUM(NSInteger, DraggingDirect) {
    MIDDLE ,  //没有滑动
    LEFT ,
    RIGHT
};


@interface STPhotoBrowserViewController ()<UIScrollViewDelegate, STBrowserPhotoScrollViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate, STToolbarDelegate>

// 控件
@property (nonatomic, weak) UIButton *backBtn;
@property (nonatomic, weak) UICollectionView *collectionView;
@property (nonatomic, weak) STBrowserHeadView *headView;
@property (nonatomic, weak) STBrowserPhotoScrollView *cellScrollView;

@property (nonatomic, strong) STToolbar *mtoolbar;
@property (nonatomic, strong) UIImage *displayImage;

@property (nonatomic, assign) CGFloat beginDraggingContentOffsetX;
@property (nonatomic, assign) DraggingDirect draggingDirect;
@property (nonatomic, assign) NSInteger currentPage;

@property (nonatomic, assign) BOOL isNowRotation;
@property (nonatomic, assign) BOOL scrollToEndFlag;

@end

@implementation STPhotoBrowserViewController

#pragma mark - dealloc
- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    self.delegate = nil;
    self.dataSource = nil;
}

- (void)setShowType:(STShowImageType)showType {
    _showType = showType;
}



#pragma mark - getter
#pragma mark photos
- (NSArray *)photos{
    if (!_photos) {
        _photos = [self getPhotos];
    }
    return _photos;
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


#pragma mark setupCollectionView
- (void)setupCollectionView{
    if (!_collectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.minimumLineSpacing = STPickerColletionViewPadding;
        flowLayout.minimumInteritemSpacing = 0;
        flowLayout.itemSize = self.view.size;
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        
        CGRect frame = self.view.bounds;
        UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width + STPickerColletionViewPadding,self.view.height) collectionViewLayout:flowLayout];
        
        collectionView.showsHorizontalScrollIndicator = YES;
        collectionView.showsVerticalScrollIndicator = NO;
        collectionView.pagingEnabled = YES;
        collectionView.backgroundColor = [UIColor blackColor];
        collectionView.bounces = YES;
        collectionView.delegate = self;
        collectionView.dataSource = self;
        [collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"collectionViewCell"];
        
        [self.view addSubview:collectionView];
        self.collectionView = collectionView;
    }
}

#pragma mark getPhotos
- (NSArray *)getPhotos{
    NSMutableArray *photos = [NSMutableArray arrayWithArray:_photos];
    if ([self isDataSourceElsePhotos]) {
        NSInteger section = self.currentIndexPath.section;
        NSInteger rows = [self.dataSource photoBrowser:self numberOfItemsInSection:section];
        photos = [NSMutableArray arrayWithCapacity:rows];
        for (NSInteger i = 0; i < rows; i++) {
            [photos addObject:[self.dataSource photoBrowser:self photoAtIndexPath:[NSIndexPath indexPathForItem:i inSection:section]]];
        }
    }
    return photos;
}

#pragma mark - Life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navbar setHidden:YES];
    
    [self setupCollectionView];
    [self setupTopView];
    
    if (_showType == STShowImageTypeImagePicker) {
        [self setupToorBar];
    }
}


#pragma mark 初始化底部ToorBar
- (void)setupToorBar {
    STToolbar *toorBar = [[STToolbar alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 44, SCREEN_WIDTH, 44) isBlack:YES];
    [self.view addSubview:toorBar];
    toorBar.mDelegate = self;
    self.mtoolbar = toorBar;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    [self reloadData];
    
    [self updateToolbar];
    if (_showType == STShowImageTypeImagePicker) {
        [self updateSelectBtn];
    }
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if (self.photos.count == 0) {
        NSAssert(self.dataSource, @"你没成为数据源代理");
    }
    [self navigationCanDragBack:NO];
    [self prepareLeftAndRighImage];
}


- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    [self.navigationController.navigationBar setBarTintColor:[UIColor whiteColor]];
    self.scrollToEndFlag = 0;
    
    [self navigationCanDragBack:YES];
}

#pragma mark - STBrowserHeadView 相关
- (void)setupTopView {
    if (!_headView) {
        STBrowserHeadView *headView = [[STBrowserHeadView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 64) setShowType:_showType];
        _headView = headView;
        [_headView.backBtn addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_headView];
    }
    
    if (_showType == STShowImageTypeImagePicker) {
        [_headView.selectBtn addTarget:self action:@selector(selectedButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
        [self updateSelectBtn];
    }
    else if (_showType == STShowImageTypeImageBroswer){
        [_headView.delectBtn addTarget:self action:@selector(delectBtnTapped:) forControlEvents:UIControlEventTouchUpInside];
    }
}

#pragma mark - STBrowserHeadView 按钮响应事件
- (void)back:(id)sender {
    // 执行代理，向上一级控制器传递selectedAssets
    if ([self.delegate respondsToSelector:@selector(photoBrowserWillExit:)]) {
        [self.delegate photoBrowserWillExit:self];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)selectedButtonTapped:(id)sender {
    STPhotoAssets *selectAsset = ((STBrowserPhoto *)self.photos[self.currentPage]).asset;
    
    // 0. 九张图片数量限制
    NSUInteger maxCount = (self.maxCount < 0) ? KPhotoShowMaxCount : self.maxCount;
    
    if (self.selectedAssets.count >= maxCount && !_headView.selectBtn.selected) {
        NSString *format = [NSString stringWithFormat:@"最多只能选择%zd张图片", maxCount];
        AlertWithTitleAndMessage(nil, format);
        
        return ;
    }
    
    //1. 刷新选择按钮的图片
    _headView.selectBtn.selected = !_headView.selectBtn.selected;
    
    // 2. selectedAssets增加或删除
    if (_headView.selectBtn.selected) {
        [self.selectedAssets addObject:selectAsset];
        [self.selectsIndexPath addObject:@(self.currentPage)];
    }
    else {
        [self.selectedAssets removeObject:selectAsset];
        [self.selectsIndexPath removeObject:@(self.currentPage)];
    }
    
    // 3. 刷新底部toolbar
    [self updateToolbar];
}

// 设置标题(图片浏览模式下)
- (void)setPageLabelPage:(NSInteger)page{
    _headView.title = [NSString stringWithFormat:@"%ld/%ld",(unsigned long)(page + 1), (unsigned long)self.photos.count];
}

// 删除当前图片
- (void)delectBtnTapped:(id)sender {
    AlertWithTitleAndMessageAndUnits(@"移除提示", @"放弃上传这张图片？", self, @"确认", nil);
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        [[SquareLogic sharedInstance].selectImages removeObjectAtIndex:self.currentPage];
        
        //延迟
        double delayInSeconds = 0.3;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            if(_delegate && [_delegate respondsToSelector:@selector(photoBrowserDeleteCurrentPage:)]) {
                [_delegate photoBrowserDeleteCurrentPage:self];
            }
        });
        
        if ([SquareLogic sharedInstance].selectImages.count == 0) {
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
    }
}



#pragma mark - STToolbar 相关
- (void)updateToolbar {
    [_mtoolbar setCount:self.selectedAssets.count];
}


#pragma mark - reloadData
- (void)reloadData{
    if (self.currentPage <= 0){
        self.currentPage = self.currentIndexPath.item;
    }
    else{
        --self.currentPage;
    }
    
    if (self.currentPage >= self.photos.count) {
        self.currentPage = self.photos.count - 1;
    }
    
    if (_showType == STShowImageTypeImageBroswer || _showType == STShowImageTypeImageURL) {
        [self setPageLabelPage:self.currentPage];
    }
    
    if (self.currentPage >= 0) {
        CGPoint point = CGPointMake(self.currentPage * self.collectionView.width, 0);
        CLog(@"%ld,%f,%f",(long)self.currentPage , self.collectionView.width,point.x);
        self.collectionView.contentOffset = point;
        self.beginDraggingContentOffsetX = self.collectionView.contentOffset.x;
    }
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if ([self isDataSourceElsePhotos]) {
        return [self.dataSource photoBrowser:self numberOfItemsInSection:self.currentIndexPath.section];
    }
    
    return self.photos.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"collectionViewCell" forIndexPath:indexPath];
    if (collectionView.isDragging) {
        cell.hidden = NO;
    }
    
    if (self.photos.count) {
        STBrowserPhoto *photo = nil;
        photo = self.photos[indexPath.item];
        
        if([[cell.contentView.subviews lastObject] isKindOfClass:[UIView class]]){
            [[cell.contentView.subviews lastObject] removeFromSuperview];
        }
        
        CGRect tempF = [UIScreen mainScreen].bounds;
        UIView *scrollBoxView = [[UIView alloc] init];
        scrollBoxView.frame = tempF;
        scrollBoxView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        [cell.contentView addSubview:scrollBoxView];
        
        STBrowserPhotoScrollView *scrollView =  [[STBrowserPhotoScrollView alloc] init];
        [scrollBoxView addSubview:scrollView];
        scrollView.showType = self.showType;
        // 为了监听单击photoView事件
        scrollView.frame = tempF;
        scrollView.tag = 101;
        scrollView.photoScrollViewDelegate = self;
        scrollView.photo = photo;
        scrollView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        _cellScrollView = scrollView;
    }
    
    return cell;
}

- (NSUInteger)getRealPhotosCount {
    
    if ([self isDataSourceElsePhotos]) {
        return [self.dataSource photoBrowser:self numberOfItemsInSection:self.currentIndexPath.section];
    }
    return self.photos.count;
}



#pragma mark -UIScrollViewDelegate
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    return CGSizeMake(STPickerColletionViewPadding, self.view.frame.size.height);
}

#pragma mark 滚动过程中重复调用
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    if (self.isNowRotation) {
        self.isNowRotation = NO;
        return;
    }
    
    if (_showType == STShowImageTypeImageBroswer || _showType == STShowImageTypeImageURL) {
        NSInteger currentPage = (NSInteger)((scrollView.contentOffset.x / scrollView.frame.size.width) + 0.5);
        [self setPageLabelPage:currentPage];
    }
    
    CGRect tempF = self.collectionView.frame;
    
    if (tempF.size.width < [UIScreen mainScreen].bounds.size.width){
        tempF.size.width = [UIScreen mainScreen].bounds.size.width;
    }
    
    self.collectionView.frame = tempF;
    self.draggingDirect = [self getDraggingDirect];
}

#pragma mark 将要减速
- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView{
    
}

#pragma mark 减速完成
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    if ([self.delegate respondsToSelector:@selector(photoBrowser:didCurrentPage:)]) {
        [self.delegate photoBrowser:self didCurrentPage:self.currentPage];
    }
    
    self.beginDraggingContentOffsetX = self.collectionView.contentOffset.x;
    
    if (_showType == STShowImageTypeImagePicker) {
        [self updateSelectBtn];
    }
    
    [self updateToolbar];
}

#pragma mark 将要结束拖拽
- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    //如果滑动松开手后回滚动到下一个页面
    if (targetContentOffset->x != _beginDraggingContentOffsetX) {
        DraggingDirect direct = [self getDraggingDirect];
        //获得currentPage
        if (direct == LEFT) {
            self.currentPage = (NSInteger)(scrollView.contentOffset.x / (scrollView.frame.size.width) + 0.9);
            if (self.currentPage > self.photos.count - 1) {
                self.currentPage --;
            }
        }
        else if (direct == RIGHT) {
            self.currentPage = (NSInteger)(scrollView.contentOffset.x / (scrollView.frame.size.width));
        }
        
        //获得image
        dispatch_queue_t queue = dispatch_queue_create("BeginDecelerating", DISPATCH_QUEUE_SERIAL);
        dispatch_async(queue, ^{
            //获取下一张image
            [self loadNextImageWithDirect:direct];
        });
    }
}

- (void)updateSelectBtn {
    _headView.selectBtn.selected = NO;
    STPhotoAssets *photoAsset = ((STBrowserPhoto *)self.photos[self.currentPage]).asset;
    
    for (STPhotoAssets *asset in self.selectedAssets) {
        if ([[asset assetURL] isEqual:[photoAsset assetURL]]) {
            _headView.selectBtn.selected = YES;
            break;
        }
    }
}

- (BOOL)isDataSourceElsePhotos{
    return self.dataSource != nil;
}

#pragma mark -PickerPhotoScrollViewDelegate
- (void)pickerPhotoScrollViewDidSingleClick:(STBrowserPhotoScrollView *)photoScrollView{
    static CGFloat alphaValue = 1;
    alphaValue = alphaValue? 0 : 1;
    [UIView animateWithDuration:0.3 animations:^(void) {
        [_headView setAlpha:alphaValue];
        [_mtoolbar setAlpha:alphaValue];
    } completion:nil];
}

- (void) pickerPhotoScrollViewDidLongPressed:(STBrowserPhotoScrollView *)photoScrollView{
    [self longPressAction];
}



- (DraggingDirect)getDraggingDirect {
    DraggingDirect direct;
    if (self.beginDraggingContentOffsetX == self.collectionView.contentOffset.x) {
        direct = MIDDLE;
    }
    else if (self.beginDraggingContentOffsetX > self.collectionView.contentOffset.x) {
        direct = RIGHT;
    }
    else {
        direct = LEFT;
    }
    
    return direct;
}

#pragma mark - 照片预加载相关, 在viewDidAppear中调用, 准备当前页面两边的imange
- (void)prepareLeftAndRighImage {
    if (self.photos.count > 1) {
        if (self.currentPage == 0) {
            //从第一张进入
            if (!((STBrowserPhoto *)self.photos[1]).photoImage) {
                STPhotoAssets *asset = ((STBrowserPhoto *)self.photos[1]).asset;
                ((STBrowserPhoto *)self.photos[1]).photoImage = [asset originImage];
            }
        }
        else if (self.currentPage == self.photos.count - 1) {
            //从第最后一张进入
            if (!((STBrowserPhoto *)self.photos[self.currentPage - 1]).photoImage) {
                STPhotoAssets *asset = ((STBrowserPhoto *)self.photos[self.currentPage - 1]).asset;
                ((STBrowserPhoto *)self.photos[self.currentPage - 1]).photoImage = [asset originImage];
            }
        }
        else {
            if (!((STBrowserPhoto *)self.photos[self.currentPage + 1]).photoImage) {
                STPhotoAssets *asset = ((STBrowserPhoto *)self.photos[self.currentPage + 1]).asset;
                ((STBrowserPhoto *)self.photos[self.currentPage + 1]).photoImage = [asset originImage];
            }
            if (!((STBrowserPhoto *)self.photos[self.currentPage - 1]).photoImage) {
                STPhotoAssets *asset1 = ((STBrowserPhoto *)self.photos[self.currentPage - 1]).asset;
                ((STBrowserPhoto *)self.photos[self.currentPage - 1]).photoImage = [asset1 originImage];
            }
        }
    }
    if (self.photos.count == 2) {
        //两张图片时，在这里做预处理
        self.scrollToEndFlag = 1;
    }
}


// 根据上一次的滑动方向，加载下一张图
- (void)loadNextImageWithDirect:(DraggingDirect)direct {
    if (direct == LEFT && self.currentPage < self.photos.count - 1){
        if (!((STBrowserPhoto *)self.photos[self.currentPage + 1]).photoImage) {
            STPhotoAssets *asset = ((STBrowserPhoto *)self.photos[self.currentPage + 1]).asset;
            ((STBrowserPhoto *)self.photos[self.currentPage + 1]).photoImage = [asset originImage];
        }
    } else if(direct == RIGHT && self.currentPage > 0){
        if (!((STBrowserPhoto *)self.photos[self.currentPage - 1]).photoImage) {
            STPhotoAssets *asset = ((STBrowserPhoto *)self.photos[self.currentPage - 1]).asset;
            ((STBrowserPhoto *)self.photos[self.currentPage - 1]).photoImage = [asset originImage];
        }
    } else ;
}

#pragma mark - 长按动作
- (void)longPressAction {
    CLog(@"long pressed");
}

- (STBrowserPhoto *)currentPhoto{
    return _cellScrollView.photo;
}

- (void)forwardImageChatMessage{
    
}

- (void)hiddenSavingStatusView{
    for (UIView *view in [self.view subviews]) {
        if (view.tag == 100) {
            [view removeFromSuperview];
        }
    }
}


#pragma mark - STToolbarDelegate
- (void)toolbarBackMainview {
    NSMutableArray *temA = [NSMutableArray arrayWithCapacity:self.selectedAssets.count];
    
    for (STPhotoAssets *lgAsset in self.selectedAssets) {
        [temA addObject:lgAsset.compressionImage];
    }
    
    //填充数据
    [[SquareLogic sharedInstance] addselectImages:temA];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"AddPicCompletionNotification" object:nil];
    
    [self.navigationController popToRootViewControllerAnimated:YES];
}

@end
