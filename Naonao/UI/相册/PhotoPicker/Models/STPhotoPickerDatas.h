//
//  STPhotoPickerDatas.h
//  Naonao
//
//  Created by 刘敏 on 16/6/26.
//  Copyright © 2016年 深圳市轩腾华兴科技开发有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@class STPhotoPickerGroup;
// 回调
typedef void(^groupCallBackBlock)(id obj);


@interface STPhotoPickerDatas : NSObject

// 获取所有组
+ (instancetype)defaultPicker;

// 获取所有组对应的图片
- (void)getAllGroupWithPhotos:(groupCallBackBlock)callBack;

// 获取所有组对应的Videos
- (void)getAllGroupWithVideos:(groupCallBackBlock)callBack;

// 传入一个组获取组里面的Asset
- (void)getGroupPhotosWithGroup:(STPhotoPickerGroup *)pickerGroup finished:(groupCallBackBlock)callBack;

// 传入一个AssetsURL来获取UIImage
- (void)getAssetsPhotoWithURLs:(NSURL *)url callBack:(groupCallBackBlock )callBack;


@end
