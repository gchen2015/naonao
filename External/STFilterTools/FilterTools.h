//
//  FilterTools.h
//  STFilterTools
//
//  Created by Richard Liu on 15/5/27.
//  Copyright (c) 2015年 深圳市轩腾华兴科技开发有限公司. All rights reserved.

#import <Foundation/Foundation.h>
#import "InstaFilters.h"
#import "GPUImagePicture.h"

@interface FilterTools : GPUImageOutput

@property (nonatomic, strong) IFImageFilter *filter;

@property (nonatomic, strong) GPUImagePicture *sourcePicture1;
@property (nonatomic, strong) GPUImagePicture *sourcePicture2;
@property (nonatomic, strong) GPUImagePicture *sourcePicture3;
@property (nonatomic, strong) GPUImagePicture *sourcePicture4;
@property (nonatomic, strong) GPUImagePicture *sourcePicture5;

@property (nonatomic, strong) GPUImagePicture *stillImageSource;

@property (nonatomic, strong) IFRotationFilter *rotationFilter;

@property (nonatomic, unsafe_unretained) IFFilterType currentFilterType;

@property (nonatomic, strong) IFImageFilter *internalFilter;

@property (nonatomic, strong) GPUImagePicture *internalSourcePicture1;
@property (nonatomic, strong) GPUImagePicture *internalSourcePicture2;
@property (nonatomic, strong) GPUImagePicture *internalSourcePicture3;
@property (nonatomic, strong) GPUImagePicture *internalSourcePicture4;
@property (nonatomic, strong) GPUImagePicture *internalSourcePicture5;

- (UIImage *)switchFilter:(IFFilterType)type rawImage:(UIImage *)rawImage;

@end
