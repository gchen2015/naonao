//
//  InstaFilters.h
//  STFilterTools
//
//  Created by Richard Liu on 15/5/27.
//  Copyright (c) 2015年 深圳市轩腾华兴科技开发有限公司. All rights reserved.


typedef enum { 
    IF_NORMAL_FILTER,           //原图
    IF_AMARO_FILTER,            //雪梨
    IF_RISE_FILTER,             //香蕉
    IF_HUDSON_FILTER,           //柠檬
    IF_XPROII_FILTER,           //葡萄
    IF_SIERRA_FILTER,           //杨桃
    IF_LOMOFI_FILTER,           //桑葚
    IF_WALDEN_FILTER,           //椰果
    IF_HEFE_FILTER,             //菠萝
    IF_VALENCIA_FILTER,         //柚子
    IF_NASHVILLE_FILTER,        //蓝莓
    IF_LORDKELVIN_FILTER,       //芒果
    /*
    IF_EARLYBIRD_FILTER,        //苹果
    IF_SUTRO_FILTER,            //黑莓
    IF_TOASTER_FILTER,          //橙子
    IF_BRANNAN_FILTER,          //山竹
    IF_INKWELL_FILTER,          //黑布林
    IF_1977_FILTER,             //枇杷
     */
} IFFilterType;



#import "UIImage+IF.h"
#import "IFImageFilter.h"
#import "IFSutroFilter.h"
#import "IFRotationFilter.h"
#import "IFAmaroFilter.h"
#import "IFNormalFilter.h"
#import "IFRiseFilter.h"
#import "IFHudsonFilter.h"
#import "IFXproIIFilter.h"
#import "IFSierraFilter.h"
#import "IFLomofiFilter.h"
#import "IFEarlybirdFilter.h"
#import "IFToasterFilter.h"
#import "IFBrannanFilter.h"
#import "IFInkwellFilter.h"
#import "IFWaldenFilter.h"
#import "IFHefeFilter.h"
#import "IFValenciaFilter.h"
#import "IFNashvilleFilter.h"
#import "IF1977Filter.h"
#import "IFLordKelvinFilter.h"
