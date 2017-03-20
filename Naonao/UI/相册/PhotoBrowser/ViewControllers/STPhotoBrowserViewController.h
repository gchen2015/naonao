//
//  STPhotoBrowserViewController.h
//  Naonao
//
//  Created by 刘敏 on 16/6/26.
//  Copyright © 2016年 深圳市轩腾华兴科技开发有限公司. All rights reserved.
//

#import "STChildViewController.h"
#import "STBrowserPhotoScrollView.h"
#import "STBrowserPhoto.h"
#import "STToolbar.h"

@class STPhotoBrowserViewController;

@protocol STPhotoBrowserViewControllerDataSource <NSObject>

@optional
// 有多少组
- (NSInteger)numberOfSectionInPhotosInPickerBrowser:(STPhotoBrowserViewController *) pickerBrowser;

@required
// 每个组多少个图片
- (NSInteger)photoBrowser:(STPhotoBrowserViewController *)photoBrowser numberOfItemsInSection:(NSUInteger)section;

// 每个对应的IndexPath展示什么内容
- (STBrowserPhoto *)photoBrowser:(STPhotoBrowserViewController *)pickerBrowser photoAtIndexPath:(NSIndexPath *)indexPath;

@end


@protocol STPhotoBrowserViewControllerDelegate <NSObject>

@optional
// 发送按钮和返回按钮按下时调用，向上一级控制器传递selectedAssets
- (void)photoBrowserWillExit:(STPhotoBrowserViewController *)pickerBrowser;

// 滑动的页数
- (void)photoBrowser:(STPhotoBrowserViewController *)photoBrowser willCurrentPage:(NSUInteger)page;

// 滑动结束的页数
- (void)photoBrowser:(STPhotoBrowserViewController *)photoBrowser didCurrentPage:(NSUInteger)page;

// 删除当前页面的图片
- (void)photoBrowserDeleteCurrentPage:(STPhotoBrowserViewController *)photoBrowser;

@end


@interface STPhotoBrowserViewController : STChildViewController

// 数据源/代理
@property (nonatomic , weak) id<STPhotoBrowserViewControllerDataSource> dataSource;
@property (nonatomic , weak) id<STPhotoBrowserViewControllerDelegate> delegate;

// 展示的图片数组
@property (nonatomic, copy) NSArray *photos;

@property (nonatomic, strong) NSMutableArray *selectedAssets;       //存储选中的图片
@property (nonatomic, strong) NSMutableArray *selectsIndexPath;     //存储选中的图片索引值

// 当前提供的组
@property (strong,nonatomic) NSIndexPath *currentIndexPath;

@property (nonatomic, assign) STShowImageType showType;
@property (nonatomic, assign) NSInteger maxCount;

// 刷新数据
- (void)reloadData;

@end
