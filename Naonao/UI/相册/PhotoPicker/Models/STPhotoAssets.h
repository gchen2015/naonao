//
//  STPhotoAssets.h
//  Naonao
//
//  Created by 刘敏 on 16/6/26.
//  Copyright © 2016年 深圳市轩腾华兴科技开发有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AssetsLibrary/AssetsLibrary.h>


@interface STPhotoAssets : NSObject

@property (strong,nonatomic) ALAsset *asset;

// 获取是否是视频类型, Default = false
@property (assign,nonatomic) BOOL isVideoType;


// 缩略图
- (UIImage *)thumbImage;

// 压缩原图
- (UIImage *)compressionImage;

// 原图
- (UIImage *)originImage;

- (UIImage *)fullResolutionImage;

// 获取相册的URL
- (NSURL *)assetURL;

@end
