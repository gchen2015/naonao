//
//  NSString+ImageURL.m
//  Naonao
//
//  Created by 刘敏 on 16/6/29.
//  Copyright © 2016年 深圳市轩腾华兴科技开发有限公司. All rights reserved.
//

#import "NSString+ImageURL.h"

#define Qiniuyun_Prefix    @"http://7xo44t.com1.z0.glb.clouddn.com/"          //七牛云前缀
#define QiniuApp_Prefix    @"http://7xrvqr.com1.z0.glb.clouddn.com/"          //七牛云前缀


@implementation NSString (ImageURL)

// 原图格式转换，转换成web
- (NSString *)originalImageTurnWebp {
    //是七牛云上的图片可以做处理
    if ([self hasPrefix:Qiniuyun_Prefix] || [self hasPrefix:QiniuApp_Prefix]) {
        return [NSString stringWithFormat:@"%@?%@", self,  kQNY_OriginImage_WEB];
    }
    else
        return self;

}


// 原图格式转换，转换成web并且压缩，压缩率80%
- (NSString *)compressionOriginalImageTurnWebp {
    //是七牛云上的图片可以做处理
    if ([self hasPrefix:Qiniuyun_Prefix] || [self hasPrefix:QiniuApp_Prefix]) {
        return [NSString stringWithFormat:@"%@?%@", self,  kQNY_Compression_WEB];
    }
    else
        return self;
    
}

//头像压缩
- (NSString *)smallHead {
    //是七牛云上的图片可以做处理
    if ([self hasPrefix:Qiniuyun_Prefix] || [self hasPrefix:QiniuApp_Prefix]) {
        return [NSString stringWithFormat:@"%@?%@", self,  kQNY_Small_Head];
    }
    else
        return self;
    
}

// 转成宽度为300的图片，适用于商品小图（购物车、订单）、较大的头像
- (NSString *)middleImage {
    //是七牛云上的图片可以做处理
    if ([self hasPrefix:Qiniuyun_Prefix] || [self hasPrefix:QiniuApp_Prefix]) {
        return [NSString stringWithFormat:@"%@?%@", self,  kQNY_Middle_Image];
    }
    else
        return self;
}


@end
