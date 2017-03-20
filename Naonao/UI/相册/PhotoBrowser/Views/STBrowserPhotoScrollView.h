//
//  STBrowserPhotoScrollView.h
//  Naonao
//
//  Created by 刘敏 on 16/6/26.
//  Copyright © 2016年 深圳市轩腾华兴科技开发有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "STPhotoImageView.h"
#import "STBrowserPhotoView.h"
#import "STBrowserPhoto.h"


typedef void(^scrollViewCallBackBlock)(id obj);

@class STBrowserPhotoScrollView;
@protocol STBrowserPhotoScrollViewDelegate <NSObject>

@optional
//单击调用
- (void)pickerPhotoScrollViewDidSingleClick:(STBrowserPhotoScrollView *)photoScrollView;
- (void)pickerPhotoScrollViewDidLongPressed:(STBrowserPhotoScrollView *)photoScrollView;

@end



@interface STBrowserPhotoScrollView : UIScrollView<UIScrollViewDelegate, STPhotoImageViewDelegate, STBrowserPhotoViewDelegate>

@property (nonatomic, strong) STBrowserPhoto *photo;
@property (nonatomic, strong) STPhotoImageView *photoImageView;
@property (nonatomic, weak) id <STBrowserPhotoScrollViewDelegate> photoScrollViewDelegate;

@property (nonatomic, assign) STShowImageType showType;
// 单击销毁的block
@property (nonatomic, copy) scrollViewCallBackBlock callback;


- (void)setMaxMinZoomScalesForCurrentBounds;

@end
