//
//  UIImage+WebP.h
//  SDWebImage
//
//  Created by Richard Liu on 15/5/11.
//  Copyright (c) 2015年 深圳食探网络科技有限公司. All rights reserved.
//


#import <UIKit/UIKit.h>
#import <Webp/decode.h>
#import <WebP/encode.h>

@interface UIImage (WebP)

+ (UIImage *)sd_imageWithWebPData:(NSData *)data;

+ (UIImage*)imageWithWebPData:(NSData*)imgData;

+ (UIImage*)imageWithWebP:(NSString*)filePath;

+ (NSData*)imageToWebP:(UIImage*)image quality:(CGFloat)quality;

+ (void)imageToWebP:(UIImage*)image
            quality:(CGFloat)quality
              alpha:(CGFloat)alpha
             preset:(WebPPreset)preset
    completionBlock:(void (^)(NSData* result))completionBlock
       failureBlock:(void (^)(NSError* error))failureBlock;

+ (void)imageToWebP:(UIImage*)image
            quality:(CGFloat)quality
              alpha:(CGFloat)alpha
             preset:(WebPPreset)preset
        configBlock:(void (^)(WebPConfig* config))configBlock
    completionBlock:(void (^)(NSData* result))completionBlock
       failureBlock:(void (^)(NSError* error))failureBlock;

+ (void)imageWithWebP:(NSString*)filePath
      completionBlock:(void (^)(UIImage* result))completionBlock
         failureBlock:(void (^)(NSError* error))failureBlock;

- (UIImage*)imageByApplyingAlpha:(CGFloat)alpha;

@end
