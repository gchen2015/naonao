//
//  ALAssetsLibrary+CustomPhotoAlbum.h
//  Shitan
//
//  Created by 刘敏 on 14-10-28.
//  Copyright (c) 2014年 深圳市轩腾华兴科技开发有限公司. All rights reserved.
//  图片合成


#import <Foundation/Foundation.h>
#import <AssetsLibrary/AssetsLibrary.h>

//typedef void(^SaveImageCompletion)(NSError* error);

@interface ALAssetsLibrary (CustomPhotoAlbum)

/*! Write the image data to the assets library (camera roll).
 *
 * \param image The target image to be saved
 * \param albumName Custom album name
 * \param completion Block to be executed when succeed to write the image data to the assets library (camera roll)
 * \param failure Block to be executed when failed to add the asset to the custom photo album
 */
- (void)saveImage:(UIImage *)image
          toAlbum:(NSString *)albumName
       completion:(ALAssetsLibraryWriteImageCompletionBlock)completion
          failure:(ALAssetsLibraryAccessFailureBlock)failure;

/*! write the video to the assets library (camera roll).
 *
 * \param videoUrl The target video to be saved
 * \param albumName Custom album name
 * \param completion Block to be executed when succeed to write the image data to the assets library (camera roll)
 * \param failure block to be executed when failed to add the asset to the custom photo album
 */
- (void)saveVideo:(NSURL *)videoUrl
          toAlbum:(NSString *)albumName
       completion:(ALAssetsLibraryWriteImageCompletionBlock)completion
          failure:(ALAssetsLibraryAccessFailureBlock)failure;

/*! Write the image data with meta data to the assets library (camera roll).
 *
 * \param imageData The image data to be saved
 * \param albumName Custom album name
 * \param metadata Meta data for image
 * \param completion Block to be executed when succeed to write the image data
 * \param failure block to be executed when failed to add the asset to the custom photo album
 */
- (void)saveImageData:(NSData *)imageData
              toAlbum:(NSString *)albumName
             metadata:(NSDictionary *)metadata
           completion:(ALAssetsLibraryWriteImageCompletionBlock)completion
              failure:(ALAssetsLibraryAccessFailureBlock)failure;

/*! Write the asset to the assets library (camera roll).
 *
 * \param assetURL The asset URL
 * \param albumName Custom album name
 * \param failure Block to be executed when failed to add the asset to the custom photo album
 */
- (void)addAssetURL:(NSURL *)assetURL
            toAlbum:(NSString *)albumName
         completion:(ALAssetsLibraryWriteImageCompletionBlock)completion
            failure:(ALAssetsLibraryAccessFailureBlock)failure;

/*! Loads assets from the assets group (album)
 *
 * \param albumName Custom album name
 * \param completion Block to be executed when succeed or failed to load images from target album
 */
- (void)loadImagesFromAlbum:(NSString *)albumName
                 completion:(void (^)(NSMutableArray *images, NSError *error))completion;

@end


