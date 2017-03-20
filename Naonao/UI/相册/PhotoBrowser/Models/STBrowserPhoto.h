//
//  STBrowserPhoto.h
//  Naonao
//
//  Created by 刘敏 on 16/6/26.
//  Copyright © 2016年 深圳市轩腾华兴科技开发有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "STPhotoAssets.h"


#define STPhotoImageDidStartLoad                    @"STPhotoImageDidStartLoad"
#define STPhotoImageDidFinishLoad                   @"STPhotoImageDidFinishLoad"
#define STPhotoImageDidFailLoadWithError            @"STPhotoImageDidFailLoadWithError"

@interface STBrowserPhoto : NSObject

@property (nonatomic, strong) UIView *photoLoadingView;
@property (nonatomic, strong) UIButton *loadOriginButton;

@property (nonatomic, strong) id photoObj;              //自动适配以下几种数据
@property (strong, nonatomic) UIImageView *toView;      //传入对应的UIImageView,记录坐标
@property (nonatomic, strong) STPhotoAssets *asset;     //保存相册模型

@property (nonatomic, strong) NSURL *photoURL;          //URL地址
@property (nonatomic, copy) NSString *photoPath;        //本地路径

@property (nonatomic, strong) UIImage *photoImage;      //原图或全屏图，也就是要显示的图
@property (nonatomic, strong) UIImage *thumbImage;      //缩略图

@property (nonatomic, assign) BOOL isSelected;          //是否被选中
@property (nonatomic, assign) BOOL isLoading;

/**
 *  传入一个图片对象，可以是URL/UIImage/NSString，返回一个实例
 */
+ (instancetype)photoAnyImageObjWith:(id)imageObj;

- (instancetype)initWithAnyObj:(id)imageObj;

- (void)loadImageFromFileAsync:(NSString *)path;
- (void)loadImageFromURLAsync:(NSURL *)url;
- (void)notifyImageDidStartLoad;
- (void)notifyImageDidFinishLoad;
- (void)notifyImageDidFailLoadWithError:(NSError *)erro;

@end

