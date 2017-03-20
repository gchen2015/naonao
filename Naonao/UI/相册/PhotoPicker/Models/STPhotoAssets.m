//
//  STPhotoAssets.m
//  Naonao
//
//  Created by 刘敏 on 16/6/26.
//  Copyright © 2016年 深圳市轩腾华兴科技开发有限公司. All rights reserved.
//

#import "STPhotoAssets.h"
#import "UIImage+UIImageScale.h"



@implementation STPhotoAssets

// 缩略图
- (UIImage *)thumbImage{
    //在ios9上，用thumbnail方法取得的缩略图显示出来不清晰，所以用aspectRatioThumbnail
    if (IOS9_OR_LATER) {
        return [UIImage imageWithCGImage:[self.asset aspectRatioThumbnail]];
    }
    else {
        return [UIImage imageWithCGImage:[self.asset thumbnail]];
    }
}

// 压缩原图
- (UIImage *)compressionImage{
    UIImage *fullScreenImage = [UIImage imageWithCGImage:[[self.asset defaultRepresentation] fullScreenImage]];
    CLog(@"原图 高 ===  %.2f, 原图 高 ===  %.2f", fullScreenImage.size.height, fullScreenImage.size.width);
    NSData *data = UIImageJPEGRepresentation(fullScreenImage, 0.45);
    CLog(@"原文件大小：：：：：：%.2f KB", [data length]/1024.0);
    
    UIImage *image = [UIImage imageWithData:data];
    
//    
//    //先压缩到1280*1280像素以内
//    UIImage *image = [fullScreenImage scaleToSize:CGSizeMake(1136, 1136)];
//    NSData *data1 = UIImageJPEGRepresentation(image, 1.0);
//    CLog(@"裁剪文件大小：：：：：：%.2f KB", [data1 length]/1024.0);
//    CLog(@"高 ===  %.2f,  高 ===  %.2f", image.size.height, image.size.width);


//    [UIImage imageWithData:data2];
    fullScreenImage = nil;
    data = nil;
//    data1 = nil;
    
    return image;
}

// 原图
- (UIImage *)originImage{
    UIImage *image = [UIImage imageWithCGImage:[[self.asset defaultRepresentation] fullScreenImage]];
    return image;
}


- (UIImage *)fullResolutionImage{
    ALAssetRepresentation *rep = [self.asset defaultRepresentation];
    CGImageRef iref = [rep fullResolutionImage];
    
    return [UIImage imageWithCGImage:iref scale:[rep scale] orientation:(UIImageOrientation)[rep orientation]];
}

// 获取是否是视频类型
- (BOOL)isVideoType{
    NSString *type = [self.asset valueForProperty:ALAssetPropertyType];
    //媒体类型是视频
    return [type isEqualToString:ALAssetTypeVideo];
}

// 获取相册的URL
- (NSURL *)assetURL{
    return [[self.asset defaultRepresentation] url];
}


@end
