//
//  FilterTools.m
//  STFilterTools
//
//  Created by Richard Liu on 15/5/27.
//  Copyright (c) 2015年 深圳市轩腾华兴科技开发有限公司. All rights reserved.


#import "FilterTools.h"


// 图片路径
//#define bundleImage(file) [@"FilterTools.bundle" stringByAppendingPathComponent:file]

@implementation FilterTools


@synthesize stillImageSource;
@synthesize rotationFilter;

@synthesize filter;
@synthesize sourcePicture1;
@synthesize sourcePicture2;
@synthesize sourcePicture3;
@synthesize sourcePicture4;
@synthesize sourcePicture5;

@synthesize currentFilterType;

@synthesize internalFilter;
@synthesize internalSourcePicture1;
@synthesize internalSourcePicture2;
@synthesize internalSourcePicture3;
@synthesize internalSourcePicture4;
@synthesize internalSourcePicture5;

-(id)init{
    self = [super init];
    if (self) {
        self.rotationFilter = [[IFRotationFilter alloc] initWithRotation:kGPUImageRotateRight];
        [self addTarget:rotationFilter];
        
        self.filter = [[IFNormalFilter alloc] init];
        self.internalFilter = self.filter;
        
        [rotationFilter addTarget:filter];
        
    }
    return self;
    
}

//图片处理
- (UIImage *)switchFilter:(IFFilterType)type rawImage:(UIImage *)rawImage{
    
    if ((rawImage != nil) && (self.stillImageSource == nil)) {
        
        // This is the state when we just switched from live view to album photo view
        [self.rotationFilter removeTarget:self.filter];
        self.stillImageSource = [[GPUImagePicture alloc] initWithImage:rawImage];
        [self.stillImageSource addTarget:self.filter];
    } else {
        
        if (currentFilterType == type) {
            return rawImage;
        }
    }
    
    return [self forceSwitchToNewFilter:type];
}

- (UIImage *)forceSwitchToNewFilter:(IFFilterType)type {
    
    currentFilterType = type;
    
    switch (type) {
        case IF_AMARO_FILTER: {
            self.internalFilter = [[IFAmaroFilter alloc] init];
            self.internalSourcePicture1 = [[GPUImagePicture alloc] initWithImage:[UIImage imageNamed:@"blackboard1024.png"]];
            self.internalSourcePicture2 = [[GPUImagePicture alloc] initWithImage:[UIImage imageNamed:@"overlayMap.png"]];
            self.internalSourcePicture3 = [[GPUImagePicture alloc] initWithImage:[UIImage imageNamed:@"amaroMap.png"]];
            break;
        }
            
        case IF_NORMAL_FILTER: {
            self.internalFilter = [[IFNormalFilter alloc] init];
            break;
        }
            
        case IF_RISE_FILTER: {
            self.internalFilter = [[IFRiseFilter alloc] init];
            self.internalSourcePicture1 = [[GPUImagePicture alloc] initWithImage:[UIImage imageNamed:@"blackboard1024.png"]];
            self.internalSourcePicture2 = [[GPUImagePicture alloc] initWithImage:[UIImage imageNamed:@"overlayMap.png"]];
            self.internalSourcePicture3 = [[GPUImagePicture alloc] initWithImage:[UIImage imageNamed:@"riseMap.png"]];
            
            break;
        }
            
        case IF_HUDSON_FILTER: {
            self.internalFilter = [[IFHudsonFilter alloc] init];
            self.internalSourcePicture1 = [[GPUImagePicture alloc] initWithImage:[UIImage imageNamed:@"hudsonBackground.png"]];
            self.internalSourcePicture2 = [[GPUImagePicture alloc] initWithImage:[UIImage imageNamed:@"overlayMap.png"]];
            self.internalSourcePicture3 = [[GPUImagePicture alloc] initWithImage:[UIImage imageNamed:@"hudsonMap.png"]];
            
            break;
        }
            
        case IF_XPROII_FILTER: {
            self.internalFilter = [[IFXproIIFilter alloc] init];
            self.internalSourcePicture1 = [[GPUImagePicture alloc] initWithImage:[UIImage imageNamed:@"xproMap.png"]];
            self.internalSourcePicture2 = [[GPUImagePicture alloc] initWithImage:[UIImage imageNamed:@"vignetteMap.png"]];
            
            break;
        }
            
        case IF_SIERRA_FILTER: {
            self.internalFilter = [[IFSierraFilter alloc] init];
            self.internalSourcePicture1 = [[GPUImagePicture alloc] initWithImage:[UIImage imageNamed:@"sierraVignette.png"]];
            self.internalSourcePicture2 = [[GPUImagePicture alloc] initWithImage:[UIImage imageNamed:@"overlayMap.png"]];
            self.internalSourcePicture3 = [[GPUImagePicture alloc] initWithImage:[UIImage imageNamed:@"sierraMap.png"]];
            
            
            break;
        }
            
        case IF_LOMOFI_FILTER: {
            self.internalFilter = [[IFLomofiFilter alloc] init];
            self.internalSourcePicture1 = [[GPUImagePicture alloc] initWithImage:[UIImage imageNamed:@"lomoMap.png"]];
            self.internalSourcePicture2 = [[GPUImagePicture alloc] initWithImage:[UIImage imageNamed:@"vignetteMap.png"]];
            
            break;
        }
            
        case IF_WALDEN_FILTER: {
            self.internalFilter = [[IFWaldenFilter alloc] init];
            self.internalSourcePicture1 = [[GPUImagePicture alloc] initWithImage:[UIImage imageNamed:@"waldenMap.png"]];
            self.internalSourcePicture2 = [[GPUImagePicture alloc] initWithImage:[UIImage imageNamed:@"vignetteMap.png"]];
            
            break;
        }
            
        case IF_HEFE_FILTER: {
            self.internalFilter = [[IFHefeFilter alloc] init];
            self.internalSourcePicture1 = [[GPUImagePicture alloc] initWithImage:[UIImage imageNamed:@"edgeBurn.png"]];
            self.internalSourcePicture2 = [[GPUImagePicture alloc] initWithImage:[UIImage imageNamed:@"hefeMap.png"]];
            self.internalSourcePicture3 = [[GPUImagePicture alloc] initWithImage:[UIImage imageNamed:@"hefeGradientMap.png"]];
            self.internalSourcePicture4 = [[GPUImagePicture alloc] initWithImage:[UIImage imageNamed:@"hefeSoftLight.png"]];
            self.internalSourcePicture5 = [[GPUImagePicture alloc] initWithImage:[UIImage imageNamed:@"hefeMetal.png"]];
            
            
            break;
        }
            
        case IF_VALENCIA_FILTER: {
            self.internalFilter = [[IFValenciaFilter alloc] init];
            self.internalSourcePicture1 = [[GPUImagePicture alloc] initWithImage:[UIImage imageNamed:@"valenciaMap.png"]];
            self.internalSourcePicture2 = [[GPUImagePicture alloc] initWithImage:[UIImage imageNamed:@"valenciaGradientMap.png"]];
            
            break;
        }
            
        case IF_NASHVILLE_FILTER: {
            self.internalFilter = [[IFNashvilleFilter alloc] init];
            self.internalSourcePicture1 = [[GPUImagePicture alloc] initWithImage:[UIImage imageNamed:@"nashvilleMap.png"]];
            
            break;
        }
            
        case IF_LORDKELVIN_FILTER: {
            self.internalFilter = [[IFLordKelvinFilter alloc] init];
            self.internalSourcePicture1 = [[GPUImagePicture alloc] initWithImage:[UIImage imageNamed:@"kelvinMap.png"]];
            
            break;
        }
            
        default:
            break;
    }
    
    
    return [self switchToNewFilter];
}


- (UIImage *)switchToNewFilter {
    
    if (self.stillImageSource == nil) {
        [self.rotationFilter removeTarget:self.filter];
        self.filter = self.internalFilter;
        [self.rotationFilter addTarget:self.filter];
    } else {
        [self.stillImageSource removeTarget:self.filter];
        self.filter = self.internalFilter;
        [self.stillImageSource addTarget:self.filter];
    }
    
    switch (currentFilterType) {
        case IF_AMARO_FILTER: {
            self.sourcePicture1 = self.internalSourcePicture1;
            self.sourcePicture2 = self.internalSourcePicture2;
            self.sourcePicture3 = self.internalSourcePicture3;
            
            [self.sourcePicture1 addTarget:self.filter];
            [self.sourcePicture2 addTarget:self.filter];
            [self.sourcePicture3 addTarget:self.filter];
            
            break;
        }
            
        case IF_RISE_FILTER: {
            self.sourcePicture1 = self.internalSourcePicture1;
            self.sourcePicture2 = self.internalSourcePicture2;
            self.sourcePicture3 = self.internalSourcePicture3;
            
            [self.sourcePicture1 addTarget:self.filter];
            [self.sourcePicture2 addTarget:self.filter];
            [self.sourcePicture3 addTarget:self.filter];
            
            break;
        }
            
        case IF_HUDSON_FILTER: {
            self.sourcePicture1 = self.internalSourcePicture1;
            self.sourcePicture2 = self.internalSourcePicture2;
            self.sourcePicture3 = self.internalSourcePicture3;
            
            [self.sourcePicture1 addTarget:self.filter];
            [self.sourcePicture2 addTarget:self.filter];
            [self.sourcePicture3 addTarget:self.filter];
            
            break;
        }
            
        case IF_XPROII_FILTER: {
            self.sourcePicture1 = self.internalSourcePicture1;
            self.sourcePicture2 = self.internalSourcePicture2;
            
            [self.sourcePicture1 addTarget:self.filter];
            [self.sourcePicture2 addTarget:self.filter];
            
            break;
        }
            
        case IF_SIERRA_FILTER: {
            self.sourcePicture1 = self.internalSourcePicture1;
            self.sourcePicture2 = self.internalSourcePicture2;
            self.sourcePicture3 = self.internalSourcePicture3;
            
            [self.sourcePicture1 addTarget:self.filter];
            [self.sourcePicture2 addTarget:self.filter];
            [self.sourcePicture3 addTarget:self.filter];
            
            break;
        }
            
        case IF_LOMOFI_FILTER: {
            self.sourcePicture1 = self.internalSourcePicture1;
            self.sourcePicture2 = self.internalSourcePicture2;
            
            [self.sourcePicture1 addTarget:self.filter];
            [self.sourcePicture2 addTarget:self.filter];
            
            break;
        }

            
        case IF_WALDEN_FILTER: {
            self.sourcePicture1 = self.internalSourcePicture1;
            self.sourcePicture2 = self.internalSourcePicture2;
            
            [self.sourcePicture1 addTarget:self.filter];
            [self.sourcePicture2 addTarget:self.filter];
            
            break;
        }
            
        case IF_HEFE_FILTER: {
            self.sourcePicture1 = self.internalSourcePicture1;
            self.sourcePicture2 = self.internalSourcePicture2;
            self.sourcePicture3 = self.internalSourcePicture3;
            self.sourcePicture4 = self.internalSourcePicture4;
            self.sourcePicture5 = self.internalSourcePicture5;
            
            [self.sourcePicture1 addTarget:self.filter];
            [self.sourcePicture2 addTarget:self.filter];
            [self.sourcePicture3 addTarget:self.filter];
            [self.sourcePicture4 addTarget:self.filter];
            [self.sourcePicture5 addTarget:self.filter];
            
            break;
        }
            
        case IF_VALENCIA_FILTER: {
            self.sourcePicture1 = self.internalSourcePicture1;
            self.sourcePicture2 = self.internalSourcePicture2;
            
            [self.sourcePicture1 addTarget:self.filter];
            [self.sourcePicture2 addTarget:self.filter];
            
            break;
        }
            
        case IF_NASHVILLE_FILTER: {
            self.sourcePicture1 = self.internalSourcePicture1;
            
            [self.sourcePicture1 addTarget:self.filter];
            
            break;
        }
            
        case IF_LORDKELVIN_FILTER: {
            self.sourcePicture1 = self.internalSourcePicture1;
            
            [self.sourcePicture1 addTarget:self.filter];
            
            break;
        }
            
        case IF_NORMAL_FILTER: {
            break;
        }
            
        default: {
            break;
        }
    }
    
    [self.stillImageSource processImage];
    return [self.filter imageFromCurrentlyProcessedOutput];
}


@end
